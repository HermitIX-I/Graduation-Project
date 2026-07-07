package com.rql.healthmanage.viewmodel.main

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.HealthDataItemDto
import com.rql.healthmanage.model.entity.HealthDataRequestDto
import com.rql.healthmanage.model.entity.SocialCommentCreateDto
import com.rql.healthmanage.model.entity.SocialPostCreateDto
import com.rql.healthmanage.model.entity.UpdatePasswordDto
import com.rql.healthmanage.model.entity.UpdateUserInfoDto
import com.rql.healthmanage.model.entity.UserInfoDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.SocialCommentDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.model.entity.RecipeItemDto
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MineDetailViewModel : ViewModel() {

    private val _user = MutableLiveData<UserInfoDto?>()
    val user: LiveData<UserInfoDto?> = _user

    private val _myPosts = MutableLiveData<List<SocialPostDto>>(emptyList())
    val myPosts: LiveData<List<SocialPostDto>> = _myPosts

    private val _myComments = MutableLiveData<List<SocialCommentDto>>(emptyList())
    val myComments: LiveData<List<SocialCommentDto>> = _myComments

    private val _videos = MutableLiveData<List<VideoItemDto>>(emptyList())
    val videos: LiveData<List<VideoItemDto>> = _videos

    private val _recipes = MutableLiveData<List<RecipeItemDto>>(emptyList())
    val recipes: LiveData<List<RecipeItemDto>> = _recipes

    private val _healthRows = MutableLiveData<List<HealthDataItemDto>>(emptyList())
    val healthRows: LiveData<List<HealthDataItemDto>> = _healthRows

    private val _toast = MutableLiveData<String?>()
    val toast: LiveData<String?> = _toast

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _mustRelogin = MutableLiveData<Boolean>(false)
    val mustRelogin: LiveData<Boolean> = _mustRelogin

    private val dateFmt = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA)

    /** 各类型最近一次记录 id，用于「我的-身体数据」保存时走更新而非重复新增 */
    private val latestRecordIdByType = mutableMapOf<Int, Int>()

    fun clearToast() {
        _toast.value = null
    }

    fun clearError() {
        _error.value = null
    }

    fun consumeMustRelogin() {
        _mustRelogin.value = false
    }

    fun loadUser() {
        viewModelScope.launch {
            val res = runCatching { RetrofitClient.api.getUserInfo() }.getOrNull()
            if (res?.code == 200) _user.value = res.data
            else _error.value = res?.message ?: "加载用户信息失败"
        }
    }

    fun loadHealthRows() {
        viewModelScope.launch {
            val res = runCatching { RetrofitClient.api.healthDataList(null, 1, 50) }.getOrNull()
            if (res?.code == 200) {
                val rows = res.data?.records.orEmpty()
                _healthRows.value = rows
                latestRecordIdByType.clear()
                rows.groupBy { it.dataType }.forEach { (type, list) ->
                    list.maxByOrNull { it.recordTime }?.id?.let { latestRecordIdByType[type] = it }
                }
            }
        }
    }

    fun loadMyPosts(uid: Int) {
        viewModelScope.launch {
            val res = runCatching { RetrofitClient.api.userPosts(uid, 1, 50) }.getOrNull()
            if (res?.code == 200 && res.data != null) _myPosts.value = res.data
            else _error.value = res?.message ?: "加载动态失败"
        }
    }

    fun loadMyComments() {
        viewModelScope.launch {
            val res = runCatching { RetrofitClient.api.mySocialComments(1, 80) }.getOrNull()
            if (res?.code == 200 && res.data != null) _myComments.value = res.data
            else _error.value = res?.message ?: "加载评论失败"
        }
    }

    fun loadCollections() {
        viewModelScope.launch {
            val v = runCatching { RetrofitClient.api.collectedVideos() }.getOrNull()
            val r = runCatching { RetrofitClient.api.collectedRecipes() }.getOrNull()
            if (v?.code == 200) _videos.value = v.data.orEmpty()
            if (r?.code == 200) _recipes.value = r.data.orEmpty()
            if (v?.code != 200) _error.value = v?.message
            if (r?.code != 200) _error.value = r?.message
        }
    }

    fun saveProfile(email: String, gender: Int, avatar: String?, age: Int?) {
        viewModelScope.launch {
            val res = runCatching {
                RetrofitClient.api.updateUserInfo(
                    UpdateUserInfoDto(email = email, avatar = avatar?.ifBlank { null }, age = age, gender = gender)
                )
            }.getOrNull()
            if (res?.code == 200 && res.data != null) {
                _user.value = res.data
                _toast.value = "已保存"
            } else {
                _error.value = res?.message ?: "保存失败"
            }
        }
    }

    fun saveHealthBatch(
        height: Double?, weight: Double?,
        systolic: Int?, diastolic: Int?,
        glucose: Double?, cholesterol: Double?
    ) {
        viewModelScope.launch {
            if (height == null || weight == null || systolic == null || diastolic == null || glucose == null || cholesterol == null) {
                _toast.value = "请完整填写身高、体重、血压、空腹血糖与总胆固醇"
                return@launch
            }
            val ts = dateFmt.format(Date())
            val items = listOf(
                HealthDataRequestDto(dataType = 1, height = height, weight = weight, recordTime = ts),
                HealthDataRequestDto(dataType = 2, systolic = systolic, diastolic = diastolic, recordTime = ts),
                HealthDataRequestDto(dataType = 3, fastingGlucose = glucose, recordTime = ts),
                HealthDataRequestDto(dataType = 4, totalCholesterol = cholesterol, recordTime = ts)
            )
            var ok = true
            for (row in items) {
                val existingId = latestRecordIdByType[row.dataType]
                val res = runCatching {
                    if (existingId != null) {
                        RetrofitClient.api.updateHealthData(existingId, row)
                    } else {
                        RetrofitClient.api.addHealthData(row)
                    }
                }.getOrNull()
                if (res?.code == 200) {
                    res.data?.id?.let { latestRecordIdByType[row.dataType] = it }
                } else {
                    ok = false
                    _error.value = res?.message ?: "保存失败"
                    break
                }
            }
            if (ok) {
                _toast.value = "身体数据已更新"
                loadHealthRows()
            }
        }
    }

    fun updatePost(postId: Int, content: String) {
        viewModelScope.launch {
            val res = runCatching {
                RetrofitClient.api.updateSocialPost(postId, SocialPostCreateDto(content.trim(), null, null))
            }.getOrNull()
            if (res?.code == 200) {
                _toast.value = "动态已更新"
                _user.value?.id?.let { loadMyPosts(it) }
            } else {
                _error.value = res?.message ?: "更新失败"
            }
        }
    }

    fun deletePost(postId: Int, uid: Int) {
        viewModelScope.launch {
            val res = runCatching { RetrofitClient.api.deleteSocialPost(postId) }.getOrNull()
            if (res?.code == 200) {
                _toast.value = "已删除"
                loadMyPosts(uid)
            } else {
                _error.value = res?.message ?: "删除失败"
            }
        }
    }

    fun updateComment(commentId: Int, content: String) {
        viewModelScope.launch {
            val res = runCatching {
                RetrofitClient.api.updateSocialComment(commentId, SocialCommentCreateDto(content = content.trim()))
            }.getOrNull()
            if (res?.code == 200) {
                _toast.value = "评论已更新"
                loadMyComments()
            } else {
                _error.value = res?.message ?: "更新失败"
            }
        }
    }

    fun deleteComment(commentId: Int) {
        viewModelScope.launch {
            val res = runCatching { RetrofitClient.api.deleteSocialComment(commentId) }.getOrNull()
            if (res?.code == 200) {
                _toast.value = "评论已删除"
                loadMyComments()
            } else {
                _error.value = res?.message ?: "删除失败"
            }
        }
    }

    fun uncollectVideo(id: Int) {
        viewModelScope.launch {
            val res = runCatching { RetrofitClient.api.uncollectVideo(id) }.getOrNull()
            if (res?.code == 200) {
                _toast.value = "已取消收藏视频"
                loadCollections()
            } else {
                _error.value = res?.message
            }
        }
    }

    fun uncollectRecipe(id: Int) {
        viewModelScope.launch {
            val res = runCatching { RetrofitClient.api.uncollectRecipe(id) }.getOrNull()
            if (res?.code == 200) {
                _toast.value = "已取消收藏食谱"
                loadCollections()
            } else {
                _error.value = res?.message
            }
        }
    }

    fun changePassword(oldPassword: String, newPassword: String) {
        viewModelScope.launch {
            val res = runCatching {
                RetrofitClient.api.changePassword(UpdatePasswordDto(oldPassword, newPassword))
            }.getOrNull()
            if (res?.code == 200) {
                _toast.value = "密码已修改，请重新登录"
                _mustRelogin.value = true
            } else {
                _error.value = res?.message ?: "修改失败"
            }
        }
    }
}
