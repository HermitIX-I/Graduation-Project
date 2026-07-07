package com.rql.healthmanage.viewmodel.sport

import androidx.lifecycle.LiveData
import androidx.lifecycle.MediatorLiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rql.healthmanage.BuildConfig
import com.rql.healthmanage.model.datasource.remote.ArkRetrofitClient
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.ArkResponsesRequestDto
import com.rql.healthmanage.model.entity.SportPlanCreateDto
import com.rql.healthmanage.model.entity.SportPlanDto
import com.rql.healthmanage.model.entity.SportRecordCreateDto
import com.rql.healthmanage.model.entity.SportRecordDto
import com.rql.healthmanage.model.sport.HighIntensityUi
import com.rql.healthmanage.model.sport.SportPlanPayload
import com.rql.healthmanage.model.sport.SportPlanFormState
import com.rql.healthmanage.model.sport.decodePayload
import com.rql.healthmanage.model.sport.displayTitle
import com.rql.healthmanage.model.sport.intensityLabel
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.concurrent.TimeUnit
import kotlin.math.min

/** 运动计划列表筛选：对接 sportPlansByStatus / sportPlansByUser */
enum class SportPlanListMode { ONGOING, COMPLETED, ALL }

class ExerciseViewModel : ViewModel() {
    private val dateFmt = SimpleDateFormat("yyyy-MM-dd", Locale.CHINA)
    private val localDateFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd")
    private val aiCache = LinkedHashMap<String, Pair<Long, String>>()
    private val aiCacheTtlMs = 60_000L

    private val _plans = MutableLiveData<List<SportPlanDto>>(emptyList())
    val plans: LiveData<List<SportPlanDto>> = _plans

    /** 始终为 status=0，用于打卡选择、提醒调度与进度统计 */
    private val _ongoingPlans = MutableLiveData<List<SportPlanDto>>(emptyList())
    val ongoingPlans: LiveData<List<SportPlanDto>> = _ongoingPlans

    private val _planListMode = MutableLiveData(SportPlanListMode.ONGOING)
    val planListMode: LiveData<SportPlanListMode> = _planListMode

    private val _records = MutableLiveData<List<SportRecordDto>>(emptyList())
    val records: LiveData<List<SportRecordDto>> = _records

    /** 打卡日历与记录列表：按计划、日期区间筛选后的记录 */
    private val _recordFilterPlanId = MutableLiveData<Int?>(null)
    private val _recordFilterDateStart = MutableLiveData<String?>(null)
    private val _recordFilterDateEnd = MutableLiveData<String?>(null)

    private val _calendarRecords = MediatorLiveData<List<SportRecordDto>>()

    init {
        val applyRecordFilters = {
            var list = _records.value.orEmpty()
            _recordFilterPlanId.value?.let { pid -> list = list.filter { it.planId == pid } }
            _recordFilterDateStart.value?.trim()?.takeIf { it.isNotEmpty() }?.let { s ->
                list = list.filter { it.recordDate >= s }
            }
            _recordFilterDateEnd.value?.trim()?.takeIf { it.isNotEmpty() }?.let { e ->
                list = list.filter { it.recordDate <= e }
            }
            _calendarRecords.value = list.sortedByDescending { it.recordDate }
        }
        _calendarRecords.addSource(_records) { applyRecordFilters() }
        _calendarRecords.addSource(_recordFilterPlanId) { applyRecordFilters() }
        _calendarRecords.addSource(_recordFilterDateStart) { applyRecordFilters() }
        _calendarRecords.addSource(_recordFilterDateEnd) { applyRecordFilters() }
    }

    val calendarRecords: LiveData<List<SportRecordDto>> get() = _calendarRecords

    fun setRecordFilterPlanId(planId: Int?) {
        _recordFilterPlanId.value = planId
    }

    fun setRecordFilterDateRange(start: String?, end: String?) {
        _recordFilterDateStart.value = start?.trim()?.takeIf { it.isNotEmpty() }
        _recordFilterDateEnd.value = end?.trim()?.takeIf { it.isNotEmpty() }
    }

    fun clearRecordFilters() {
        _recordFilterPlanId.value = null
        _recordFilterDateStart.value = null
        _recordFilterDateEnd.value = null
    }

    fun hasRecordFilters(): Boolean =
        _recordFilterPlanId.value != null ||
            !_recordFilterDateStart.value.isNullOrBlank() ||
            !_recordFilterDateEnd.value.isNullOrBlank()

    private val _recentWeightKg = MutableLiveData<Double?>(null)
    val recentWeightKg: LiveData<Double?> = _recentWeightKg

    private val _progressPercent = MutableLiveData(0)
    val progressPercent: LiveData<Int> = _progressPercent

    private val _progressHint = MutableLiveData("")
    val progressHint: LiveData<String> = _progressHint

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _loading = MutableLiveData(false)
    val loading: LiveData<Boolean> = _loading

    private val _planCreatedAi = MutableLiveData<String?>()
    val planCreatedAi: LiveData<String?> = _planCreatedAi

    private val _checkInAiSummary = MutableLiveData<String?>()
    val checkInAiSummary: LiveData<String?> = _checkInAiSummary
    private val _info = MutableLiveData<String?>()
    val info: LiveData<String?> = _info

    private val _highIntensityFollowUp = MutableLiveData<HighIntensityUi?>()
    val highIntensityFollowUp: LiveData<HighIntensityUi?> = _highIntensityFollowUp
    private val _missedCheckInReminder = MutableLiveData<Int?>()
    val missedCheckInReminder: LiveData<Int?> = _missedCheckInReminder
    private var lastReminderDays: Int? = null

    /** 兼容 Compose 等：取第一个进行中计划 */
    private val _plan = MutableLiveData<SportPlanDto?>(null)
    val plan: LiveData<SportPlanDto?> = _plan

    fun setPlanListMode(mode: SportPlanListMode) {
        if (_planListMode.value == mode) return
        _planListMode.value = mode
        refresh()
    }

    fun findPlanForEdit(planId: Int): SportPlanDto? =
        _ongoingPlans.value.orEmpty().firstOrNull { it.id == planId }
            ?: _plans.value.orEmpty().firstOrNull { it.id == planId }

    fun refresh() {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                refreshInternal()
            } catch (e: Exception) {
                _error.value = e.message
            } finally {
                _loading.value = false
            }
        }
    }

    private suspend fun refreshInternal() {
        val ongoingRes = RetrofitClient.api.sportPlansByStatus(0)
        val ongoing = if (ongoingRes.code == 200 && ongoingRes.data != null) {
            ongoingRes.data!!
        } else {
            if (ongoingRes.code != 200) _error.value = ongoingRes.message
            emptyList()
        }
        _ongoingPlans.value = ongoing
        _plan.value = ongoing.firstOrNull()

        val mode = _planListMode.value ?: SportPlanListMode.ONGOING
        val display = when (mode) {
            SportPlanListMode.ONGOING -> ongoing
            SportPlanListMode.COMPLETED -> {
                val r = RetrofitClient.api.sportPlansByStatus(1)
                if (r.code != 200) _error.value = r.message
                r.data.orEmpty()
            }
            SportPlanListMode.ALL -> {
                val r = RetrofitClient.api.sportPlansByUser()
                if (r.code != 200) _error.value = r.message
                r.data.orEmpty()
            }
        }
        _plans.value = display

        val recRes = RetrofitClient.api.sportRecordsByUser()
        val recs = if (recRes.code == 200 && recRes.data != null) recRes.data!! else emptyList()
        _records.value = recs
        val healthRes = RetrofitClient.api.healthDataList(1, 1, 30)
        _recentWeightKg.value = if (healthRes.code == 200 && healthRes.data != null) {
            healthRes.data.records.firstOrNull { it.weight != null }?.weight?.toDouble()
        } else {
            null
        }
        recomputeProgress(ongoing, recs)
    }

    private fun recomputeProgress(plans: List<SportPlanDto>, records: List<SportRecordDto>) {
        val from = Calendar.getInstance().apply { add(Calendar.DAY_OF_MONTH, -27) }
        val fromStr = dateFmt.format(from.time)
        val recent = records.filter { it.recordDate >= fromStr }
        val expected = (plans.sumOf { it.frequency }.coerceAtLeast(1)) * 4
        val pct = min(100, (recent.size * 100) / expected.coerceAtLeast(1))
        _progressPercent.value = pct
        _progressHint.value = "近 28 天有效打卡 ${recent.size} 次；按当前计划粗算约 $expected 次目标，完成度约 $pct%（仅供参考）。"
        updateMissedCheckInReminder(plans, records)
    }

    private fun updateMissedCheckInReminder(plans: List<SportPlanDto>, records: List<SportRecordDto>) {
        if (plans.isEmpty()) {
            _missedCheckInReminder.value = null
            lastReminderDays = null
            return
        }
        val latestDate = records.maxByOrNull { it.recordDate }?.recordDate?.let { raw ->
            runCatching { dateFmt.parse(raw) }.getOrNull()
        }
        val days = if (latestDate == null) {
            99
        } else {
            TimeUnit.MILLISECONDS.toDays(System.currentTimeMillis() - latestDate.time).toInt().coerceAtLeast(0)
        }
        if (days >= 3) {
            if (lastReminderDays != days) {
                _missedCheckInReminder.value = days
                lastReminderDays = days
            }
        } else {
            _missedCheckInReminder.value = null
            lastReminderDays = null
        }
    }

    fun createPlan(form: SportPlanFormState) {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val aiIntensity = decideIntensityByAi(form)
                val body = buildCreateDto(form, aiIntensity)
                val res = RetrofitClient.api.createSportPlan(body)
                if (res.code == 200 && res.data != null) {
                    refreshInternal()
                    requestNewPlanAiFeedback(form, aiIntensity)
                } else {
                    _error.value = res.message ?: "创建失败"
                }
            } catch (e: Exception) {
                _error.value = e.message
            } finally {
                _loading.value = false
            }
        }
    }

    fun updatePlan(planId: Int, form: SportPlanFormState) {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val aiIntensity = decideIntensityByAi(form)
                val body = buildCreateDto(form, aiIntensity)
                val res = RetrofitClient.api.updateSportPlan(planId, body)
                if (res.code == 200) {
                    refreshInternal()
                } else {
                    _error.value = res.message
                }
            } catch (e: Exception) {
                _error.value = e.message
            } finally {
                _loading.value = false
            }
        }
    }

    fun deletePlan(planId: Int) {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val res = RetrofitClient.api.deleteSportPlan(planId)
                if (res.code == 200) {
                    refreshInternal()
                } else {
                    _error.value = res.message
                }
            } catch (e: Exception) {
                _error.value = e.message
            } finally {
                _loading.value = false
            }
        }
    }

    fun checkIn(planId: Int, actualMinutes: Int, calories: Int?, recordDate: String = dateFmt.format(Date())) {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val currentRecords = _records.value.orEmpty()
                if (currentRecords.any { it.planId == planId && it.recordDate == recordDate }) {
                    _error.value = "该日期已为此计划打卡"
                    return@launch
                }
                val res = RetrofitClient.api.createSportRecord(
                    SportRecordCreateDto(
                        planId = planId,
                        recordDate = recordDate,
                        actualDuration = actualMinutes,
                        calories = calories
                    )
                )
                if (res.code != 200) {
                    _error.value = res.message
                    return@launch
                }
                val plan = _ongoingPlans.value.orEmpty().firstOrNull { it.id == planId }
                refreshInternal()
                val healthSummary = fetchHealthSummaryText()
                val recordsForPlan = RetrofitClient.api.sportRecordsByPlan(planId).data.orEmpty()
                val streak = calculateConsecutiveCheckInStreak(recordsForPlan, recordDate)
                val feedbackPeriodReached = streak > 0 && streak % 3 == 0
                if (feedbackPeriodReached) {
                    val aiText = requestCheckInAndStageAi(plan, actualMinutes, recordsForPlan, healthSummary)
                    _checkInAiSummary.value = aiText
                } else {
                    val remain = if (streak > 0) (3 - (streak % 3)) % 3 else 0
                    _info.value = if (remain == 0) {
                        "打卡成功，继续保持！"
                    } else {
                        "打卡成功，当前已连续打卡 ${streak} 天；再连续打卡 ${remain} 天可触发阶段反馈。"
                    }
                }
                val intensity = plan?.decodePayload()?.intensityLevel ?: 1
                if (intensity >= 3 && plan != null) {
                    _highIntensityFollowUp.value = HighIntensityUi(planId = planId, planTitle = plan.displayTitle())
                }
            } catch (e: Exception) {
                _error.value = e.message
            } finally {
                _loading.value = false
            }
        }
    }

    private fun calculateConsecutiveCheckInStreak(recordsForPlan: List<SportRecordDto>, endDate: String): Int {
        val daySet = recordsForPlan.mapNotNull {
            runCatching { LocalDate.parse(it.recordDate, localDateFmt) }.getOrNull()
        }.toSet()
        val end = runCatching { LocalDate.parse(endDate, localDateFmt) }.getOrNull() ?: return 0
        var cursor = end
        var streak = 0
        while (daySet.contains(cursor)) {
            streak++
            cursor = cursor.minusDays(1)
        }
        return streak
    }

    private suspend fun fetchHealthSummaryText(): String {
        val res = RetrofitClient.api.healthDataList(null, 1, 40)
        if (res.code != 200 || res.data == null) return "暂无最近健康指标记录。"
        val rows = res.data.records.take(6)
        if (rows.isEmpty()) return "暂无最近健康指标记录。"
        return rows.joinToString("\n") { r ->
            "${r.recordTime.take(10)} type=${r.dataType} 体重=${r.weight} 血压=${r.systolic}/${r.diastolic} 血糖=${r.fastingGlucose} 血脂=${r.totalCholesterol}"
        }
    }

    private suspend fun requestCheckInAndStageAi(
        plan: SportPlanDto?,
        actualMinutes: Int,
        recordsForPlan: List<SportRecordDto>,
        healthSummary: String
    ): String {
        val p = plan?.decodePayload()
        val msg = buildString {
            append("请用中文回答，分两段：【本次运动反馈】【阶段评价与建议】，总字数 400 内。\n")
            append("用户刚完成打卡：时长 ${actualMinutes} 分钟。\n")
            if (plan != null) {
                append("计划：形式=${p?.exerciseForm ?: "-"}；规划=${p?.exerciseSchedule ?: "-"}；")
                append("内容=${p?.exerciseDetail ?: plan.planContent}；每周${plan.frequency}次，单次目标${plan.duration}分钟；强度=${p?.intensityLevel?.let { intensityLabel(it) } ?: "-"}\n")
            }
            append("该计划历史打卡次数：${recordsForPlan.size}；最近记录：")
            append(recordsForPlan.takeLast(5).joinToString { "${it.recordDate} ${it.actualDuration}分" })
            append("\n近期健康数据摘要：\n$healthSummary\n")
            append("若用户坚持运动且健康指标有改善趋势，请给予鼓励；若频次或时长明显不足、或效果可能不佳，请提醒并给出可执行的改进建议（如调整强度、增加频次、热身拉伸等）。同时结合打卡情况给一句阶段性评价。")
        }
        return runAi(msg)
    }

    private suspend fun requestNewPlanAiFeedback(form: SportPlanFormState, aiIntensity: Int) {
        val msg = buildString {
            append("请用中文简洁说明（250 字内）：\n")
            append("用户新建运动计划：形式=${form.exerciseForm}；规划=${form.exerciseSchedule}；内容=${form.exerciseDetail}。\n")
            append("每周${form.weeklyFrequency}次，单次${form.expectedMinutesPerSession}分钟；AI判定强度=${intensityLabel(aiIntensity)}；提醒=${form.remindEnabled}${form.remindTime?.let { "($it)" } ?: ""}。\n")
            append("请说明该计划的特点、注意事项、是否适合一般健康成年人执行（有禁忌请说明）。")
        }
        _planCreatedAi.value = runAi(msg)
    }

    private suspend fun runAi(message: String): String {
        if (BuildConfig.ARK_API_KEY.isBlank() || BuildConfig.ARK_MODEL.isBlank()) return "AI 暂时不可用"
        val now = System.currentTimeMillis()
        val cached = aiCache[message]
        if (cached != null && now - cached.first <= aiCacheTtlMs) return cached.second
        val res = ArkRetrofitClient.api.createResponse(
            ArkResponsesRequestDto(
                model = BuildConfig.ARK_MODEL,
                input = message
            )
        )
        val finalText = res.output_text
            ?: res.output?.flatMap { it.content.orEmpty() }?.mapNotNull { it.text }?.joinToString("\n")
            ?: res.error?.message
            ?: "AI 暂时不可用"
        aiCache[message] = now to finalText
        if (aiCache.size > 30) aiCache.remove(aiCache.entries.first().key)
        return finalText
    }

    private suspend fun decideIntensityByAi(form: SportPlanFormState): Int {
        val ask = buildString {
            append("请仅回复一个数字（1或2或3），用于表示运动强度：1低强度，2中强度，3高强度。\n")
            append("请根据计划内容判断，不要输出其它文字。\n")
            append("运动形式：${form.exerciseForm}\n")
            append("运动规划：${form.exerciseSchedule}\n")
            append("运动内容：${form.exerciseDetail}\n")
            append("每周次数：${form.weeklyFrequency}\n")
            append("单次分钟：${form.expectedMinutesPerSession}")
        }
        val text = runCatching { runAi(ask) }.getOrNull().orEmpty()
        val level = Regex("[123]").find(text)?.value?.toIntOrNull()
        return level ?: when {
            form.expectedMinutesPerSession >= 60 || form.weeklyFrequency >= 6 -> 3
            form.expectedMinutesPerSession >= 35 || form.weeklyFrequency >= 4 -> 2
            else -> 1
        }
    }

    fun consumePlanCreatedAi() {
        _planCreatedAi.value = null
    }

    fun consumeCheckInAi() {
        _checkInAiSummary.value = null
    }

    fun consumeHighIntensityFollowUp() {
        _highIntensityFollowUp.value = null
    }

    fun consumeMissedCheckInReminder() {
        _missedCheckInReminder.value = null
    }

    fun clearError() {
        _error.value = null
    }

    fun consumeInfo() {
        _info.value = null
    }

    private fun buildCreateDto(form: SportPlanFormState, aiIntensityLevel: Int): SportPlanCreateDto {
        val cal = Calendar.getInstance()
        val start = dateFmt.format(cal.time)
        cal.add(Calendar.DAY_OF_MONTH, 27)
        val end = dateFmt.format(cal.time)
        val payload = SportPlanPayload(
            exerciseForm = form.exerciseForm.trim(),
            exerciseSchedule = form.exerciseSchedule.trim(),
            exerciseDetail = form.exerciseDetail.trim(),
            remindEnabled = form.remindEnabled,
            remindTime = form.remindTime,
            intensityLevel = aiIntensityLevel.coerceIn(1, 3)
        )
        return SportPlanCreateDto(
            goalType = form.goalCategory.coerceIn(1, 3),
            startDate = start,
            endDate = end,
            frequency = form.weeklyFrequency.coerceIn(1, 14),
            duration = form.expectedMinutesPerSession.coerceIn(5, 300),
            planContent = payload.toJson()
        )
    }

    /** 兼容旧 Compose 入口 */
    fun createPlan(goalType: Int) {
        val now = Calendar.getInstance()
        val remind = String.format("%02d:%02d", now.get(Calendar.HOUR_OF_DAY), now.get(Calendar.MINUTE))
        createPlan(
            SportPlanFormState(
                exerciseForm = when (goalType) {
                    2 -> "力量训练"
                    3 -> "放松活动"
                    else -> "有氧运动"
                },
                exerciseSchedule = "每周 3 次",
                exerciseDetail = "适度运动，注意热身与拉伸",
                weeklyFrequency = 3,
                expectedMinutesPerSession = 30,
                remindEnabled = true,
                remindTime = remind,
                goalCategory = goalType.coerceIn(1, 3)
            )
        )
    }

    fun checkIn(duration: Int, calories: Int?) {
        val id = _plan.value?.id ?: run {
            _error.value = "请先创建进行中的计划"
            return
        }
        checkIn(id, duration, calories)
    }

}
