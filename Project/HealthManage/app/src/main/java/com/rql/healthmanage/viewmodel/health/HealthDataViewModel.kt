package com.rql.healthmanage.viewmodel.health

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.gson.Gson
import com.rql.healthmanage.BuildConfig
import com.rql.healthmanage.common.MyApp
import com.rql.healthmanage.model.datasource.local.AppDatabase
import com.rql.healthmanage.model.datasource.local.PendingHealthEntity
import com.rql.healthmanage.model.datasource.remote.ArkRetrofitClient
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.AiAdviceRequestDto
import com.rql.healthmanage.model.entity.ArkResponsesRequestDto
import com.rql.healthmanage.model.entity.HealthDataItemDto
import com.rql.healthmanage.model.entity.HealthDataRequestDto
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull

class HealthDataViewModel : ViewModel() {
    private val gson = Gson()
    private val pendingDao = AppDatabase.get(MyApp.context).pendingHealthDao()
    private var currentUserId: Int? = null
    /** 忽略过期的并发 `loadAll()` 结果，避免先发出的请求晚返回把列表又置空并再次触发「首次录入」弹窗。 */
    private var loadAllGeneration = 0
    private val aiCache = LinkedHashMap<String, Pair<Long, String>>()
    private val aiCacheTtlMs = 60_000L
    private val aiTimeoutMs = 12_000L

    private val _records = MutableLiveData<List<HealthDataItemDto>>(emptyList())
    val records: LiveData<List<HealthDataItemDto>> = _records

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _syncStatus = MutableLiveData("已同步")
    val syncStatus: LiveData<String> = _syncStatus

    private val _requireInitialInput = MutableLiveData(false)
    val requireInitialInput: LiveData<Boolean> = _requireInitialInput

    private val _saveSucceeded = MutableLiveData(false)
    val saveSucceeded: LiveData<Boolean> = _saveSucceeded

    private val _aiReply = MutableLiveData<String?>()
    val aiReply: LiveData<String?> = _aiReply

    private val _healthDataListFetchCompleted = MutableLiveData(false)
    val healthDataListFetchCompleted: LiveData<Boolean> = _healthDataListFetchCompleted

    fun loadAll() {
        val generation = ++loadAllGeneration
        viewModelScope.launch {
            try {
                currentUserId = runCatching { RetrofitClient.api.getUserInfo().data?.id }.getOrNull()
                val merged = fetchAllHealthDataPages(generation)
                if (generation != loadAllGeneration) return@launch
                val records = merged.first
                val err = merged.second
                if (err != null && records.isEmpty()) {
                    _error.value = err
                    _requireInitialInput.value = false
                } else {
                    _records.value = records
                    _requireInitialInput.value = records.isEmpty()
                }
            } catch (e: Exception) {
                if (generation != loadAllGeneration) return@launch
                _error.value = e.message
                _requireInitialInput.value = false
            } finally {
                if (generation == loadAllGeneration) {
                    _healthDataListFetchCompleted.value = true
                }
            }
        }
    }

    /**
     * 分页拉取当前用户全部健康记录（单页仅 100 条会截断长期趋势/对比）。
     */
    private suspend fun fetchAllHealthDataPages(generation: Int): Pair<List<HealthDataItemDto>, String?> {
        val uid = currentUserId
        val pageSize = 200
        val out = mutableListOf<HealthDataItemDto>()
        var page = 1
        var apiMessage: String? = null
        while (page <= 50) {
            if (generation != loadAllGeneration) return out to null
            val res = RetrofitClient.api.healthDataList(null, page, pageSize)
            if (res.code != 200 || res.data == null) {
                apiMessage = res.message
                return if (out.isEmpty()) emptyList<HealthDataItemDto>() to apiMessage else out to null
            }
            val batch = res.data.records.filter { uid == null || it.userId == uid }
            out.addAll(batch)
            val total = res.data.total
            if (batch.size < pageSize || out.size.toLong() >= total) break
            page++
        }
        return out to null
    }

    fun delete(item: HealthDataItemDto) {
        viewModelScope.launch {
            try {
                RetrofitClient.api.deleteHealthData(item.id)
                loadAll()
            } catch (e: Exception) {
                _error.value = e.message
            }
        }
    }

    fun replaceGroup(oldItems: List<HealthDataItemDto>, newRequests: List<HealthDataRequestDto>) {
        viewModelScope.launch {
            try {
                oldItems.forEach { old ->
                    runCatching { RetrofitClient.api.deleteHealthData(old.id) }
                }
                var successCount = 0
                var failedCount = 0
                newRequests.forEach { request ->
                    val res = runCatching { RetrofitClient.api.addHealthData(request) }.getOrNull()
                    if (res?.code == 200) {
                        successCount += 1
                    } else {
                        failedCount += 1
                        cacheOffline(request.dataType, request, null)
                    }
                }
                if (successCount > 0) {
                    _syncStatus.value = "已更新并同步 $successCount/${newRequests.size} 条"
                    _saveSucceeded.value = true
                }
                if (failedCount > 0) {
                    _error.value = "有 $failedCount 条更新失败，已离线缓存"
                }
                loadAll()
            } catch (e: Exception) {
                _error.value = e.message ?: "更新失败"
            }
        }
    }

    fun addBatch(requests: List<HealthDataRequestDto>) {
        viewModelScope.launch {
            try {
                var successCount = 0
                var failedCount = 0
                val firstError = StringBuilder()
                requests.forEach { request ->
                    val res = RetrofitClient.api.addHealthData(request)
                    if (res.code == 200) {
                        successCount += 1
                    } else {
                        failedCount += 1
                        if (firstError.isEmpty()) firstError.append(res.message)
                        cacheOffline(request.dataType, request, null)
                    }
                }
                if (successCount > 0) {
                    _syncStatus.value = "已同步 $successCount/${requests.size} 条到后台管理系统"
                    _saveSucceeded.value = true
                    _requireInitialInput.value = false
                    loadAll()
                }
                if (failedCount > 0) {
                    _error.value = if (firstError.isNotEmpty()) {
                        "有 $failedCount 条保存失败，已离线缓存：$firstError"
                    } else {
                        "有 $failedCount 条保存失败，已离线缓存"
                    }
                }
            } catch (e: Exception) {
                requests.forEach { request ->
                    cacheOffline(request.dataType, request, null)
                }
                _error.value = e.message ?: "网络异常，已离线保存"
            }
        }
    }

    fun syncPending() {
        viewModelScope.launch {
            val rows = pendingDao.pending()
            if (rows.isEmpty()) {
                _syncStatus.value = "无待同步数据"
                return@launch
            }
            var success = 0
            rows.forEach { row ->
                val req = runCatching {
                    gson.fromJson(row.payloadJson, HealthDataRequestDto::class.java)
                }.getOrNull() ?: return@forEach
                val res = runCatching { RetrofitClient.api.addHealthData(req) }.getOrNull()
                if (res?.code == 200) {
                    pendingDao.markSynced(row.id)
                    success += 1
                }
            }
            _syncStatus.value = "已同步 $success/${rows.size} 条"
            loadAll()
        }
    }

    private suspend fun cacheOffline(dataType: Int, request: HealthDataRequestDto, message: String?) {
        pendingDao.insert(
            PendingHealthEntity(
                dataType = dataType,
                payloadJson = gson.toJson(request),
                createdAt = System.currentTimeMillis(),
                synced = false
            )
        )
        _syncStatus.value = "离线保存，待网络恢复后同步"
        if (!message.isNullOrBlank()) _error.value = message
    }

    fun clearSaveState() {
        _saveSucceeded.value = false
    }

    fun requestAiAdvice(request: AiAdviceRequestDto) {
        viewModelScope.launch {
            try {
                val prompt = buildFastAdviceKey(request)
                val now = System.currentTimeMillis()
                val cached = aiCache[prompt]
                if (cached != null && now - cached.first <= aiCacheTtlMs) {
                    _aiReply.value = cached.second
                    return@launch
                }
                val finalText = requestAccurateReplyFast(request) ?: "AI 服务繁忙，请稍后重试。"
                aiCache[prompt] = now to finalText
                if (aiCache.size > 30) aiCache.remove(aiCache.entries.first().key)
                _aiReply.value = finalText
            } catch (_: CancellationException) {
                // 页面销毁等场景取消，不提示错误。
            } catch (e: Exception) {
                _aiReply.value = e.message ?: "AI 服务调用失败"
            }
        }
    }

    private fun buildFastAdviceKey(request: AiAdviceRequestDto): String {
        return "${request.recordsSummary.orEmpty().take(180)}|${request.message.orEmpty().take(120)}"
    }

    private suspend fun requestAccurateReplyFast(request: AiAdviceRequestDto): String? {
        if (BuildConfig.ARK_API_KEY.isBlank() || BuildConfig.ARK_MODEL.isBlank()) return null
        val compactPrompt = buildString {
            append("你是健康管理助手，请直接回答用户问题，先结论后建议，控制在220字内，避免冗余。\n")
            append("【关键健康摘要】")
            append(request.recordsSummary.orEmpty().take(160))
            append("\n【用户问题】")
            append(request.message.orEmpty().take(180))
        }
        val res = withTimeoutOrNull(aiTimeoutMs) {
            ArkRetrofitClient.api.createResponse(
                ArkResponsesRequestDto(
                    model = BuildConfig.ARK_MODEL,
                    input = compactPrompt
                )
            )
        } ?: return null
        return res.output_text
            ?: res.output?.flatMap { it.content.orEmpty() }?.mapNotNull { it.text }?.joinToString("\n")
            ?: res.error?.message
    }

    fun clearAiReply() {
        _aiReply.value = null
    }

    fun clearError() {
        _error.value = null
    }

}
