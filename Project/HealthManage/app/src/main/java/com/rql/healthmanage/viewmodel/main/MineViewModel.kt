package com.rql.healthmanage.viewmodel.main

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rql.healthmanage.model.entity.UserInfoDto
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.util.SPUtil
import kotlinx.coroutines.async
import kotlinx.coroutines.supervisorScope
import kotlinx.coroutines.launch
import kotlin.math.pow

class MineViewModel : ViewModel() {
    private val _name = MutableLiveData("用户")
    val name: LiveData<String> = _name
    private val _avatar = MutableLiveData<String?>()
    val avatar: LiveData<String?> = _avatar
    private val _bmiLine = MutableLiveData("BMI：-")
    val bmiLine: LiveData<String> = _bmiLine
    private val _userInfo = MutableLiveData("用户名：-\n电话：-\n邮箱：-\n性别：-")
    val userInfo: LiveData<String> = _userInfo
    private val _healthStatus = MutableLiveData("暂无")
    val healthStatus: LiveData<String> = _healthStatus
    private val _myPosts = MutableLiveData("我的动态：暂无")
    val myPosts: LiveData<String> = _myPosts
    private val _myComments = MutableLiveData("我的评论：暂无")
    val myComments: LiveData<String> = _myComments
    private val _myCollections = MutableLiveData("我的收藏：暂无")
    val myCollections: LiveData<String> = _myCollections

    private val _loggingOut = MutableLiveData(false)
    val loggingOut: LiveData<Boolean> = _loggingOut

    private val _logoutCompleted = MutableLiveData<Unit?>()
    val logoutCompleted: LiveData<Unit?> = _logoutCompleted

    fun loadProfile() {
        viewModelScope.launch {
            runCatching {
                val user = runCatching { RetrofitClient.api.getUserInfo().data }.getOrNull()
                val uid = user?.id ?: return@runCatching
                supervisorScope {
                    val healthDeferred = async { runCatching { RetrofitClient.api.healthDataList(null, 1, 50).data?.records.orEmpty() }.getOrDefault(emptyList()) }
                    val assessDeferred = async { runCatching { RetrofitClient.api.latestAssessment().data }.getOrNull() }
                    val postsDeferred = async { runCatching { RetrofitClient.api.userPosts(uid, 1, 30).data.orEmpty() }.getOrDefault(emptyList()) }
                    val commentsDeferred = async {
                        val posts = postsDeferred.await()
                        posts.sumOf { post ->
                            runCatching { RetrofitClient.api.socialComments(post.id, 1, 100).data.orEmpty().size }.getOrDefault(0)
                        }
                    }
                    val videosDeferred = async { runCatching { RetrofitClient.api.collectedVideos().data.orEmpty() }.getOrDefault(emptyList()) }
                    val recipesDeferred = async { runCatching { RetrofitClient.api.collectedRecipes().data.orEmpty() }.getOrDefault(emptyList()) }
                    bindUser(user)
                    bindHealth(healthDeferred.await(), assessDeferred.await())
                    bindPosts(postsDeferred.await(), commentsDeferred.await())
                    bindCollections(videosDeferred.await().size, recipesDeferred.await().size)
                }
            }.onFailure {
                val displayName = SPUtil.getString("user_name", "用户")
                _name.value = displayName
            }
        }
    }

    fun logout() {
        viewModelScope.launch {
            _loggingOut.value = true
            runCatching { RetrofitClient.api.logout() }
            clearLocalSession()
            _loggingOut.value = false
            _logoutCompleted.value = Unit
        }
    }

    fun consumeLogoutCompleted() {
        _logoutCompleted.value = null
    }

    private fun clearLocalSession() {
        SPUtil.putString("token", "")
        SPUtil.putBoolean("is_login", false)
        SPUtil.putString("user_name", "")
        SPUtil.putString("saved_login_password", "")
        SPUtil.putString("saved_login_account", "")
        SPUtil.putBoolean("remember_password", false)
    }

    private fun bindUser(user: UserInfoDto?) {
        if (user == null) return
        _name.value = user.username
        _avatar.value = user.avatar
        val gender = when (user.gender) {
            1 -> "男"
            0 -> "女"
            else -> "未知"
        }
        _userInfo.value = "用户名：${user.username}\n电话：${user.phone}\n邮箱：${user.email ?: "-"}\n性别：$gender"
    }

    private fun bindHealth(
        rows: List<com.rql.healthmanage.model.entity.HealthDataItemDto>,
        assessment: com.rql.healthmanage.model.entity.AssessmentEntityDto?
    ) {
        val latestHeightWeight = rows.firstOrNull { it.dataType == 1 }
        val latestBp = rows.firstOrNull { it.dataType == 2 }
        val latestGlucose = rows.firstOrNull { it.dataType == 3 }
        val latestChol = rows.firstOrNull { it.dataType == 4 }
        val h = latestHeightWeight?.height
        val w = latestHeightWeight?.weight
        val bmi = if (h != null && w != null && h > 0) w / (h / 100.0).pow(2.0) else null
        _bmiLine.value = "BMI：${bmi?.let { String.format("%.1f", it) } ?: "-"}"
        val levelText = when (assessment?.level) {
            0 -> "健康"
            1 -> "轻度亚健康"
            2 -> "中度亚健康"
            3 -> "重度亚健康"
            else -> "暂无"
        }
        _healthStatus.value = buildString {
            append("身高/体重：${latestHeightWeight?.height ?: "-"}cm / ${latestHeightWeight?.weight ?: "-"}kg  BMI：${bmi?.let { String.format("%.1f", it) } ?: "-"}\n")
            append("血压：${latestBp?.systolic ?: "-"}/${latestBp?.diastolic ?: "-"} mmHg\n")
            append("空腹血糖：${latestGlucose?.fastingGlucose ?: "-"} mmol/L\n")
            append("总胆固醇：${latestChol?.totalCholesterol ?: "-"} mmol/L\n")
            append("亚健康评估：$levelText（总分 ${assessment?.totalScore ?: "-"}）\n")
            append("中医体质：${assessment?.constitutionType ?: "暂无"}")
        }
    }

    private fun bindPosts(posts: List<com.rql.healthmanage.model.entity.SocialPostDto>, commentCount: Int) {
        _myPosts.value = "我的动态：共 ${posts.size} 条，最近一条：${posts.firstOrNull()?.content ?: "暂无"}"
        _myComments.value = "我的评论（在我的动态下）：共 $commentCount 条"
    }

    private fun bindCollections(videoCount: Int, recipeCount: Int) {
        _myCollections.value = "我的收藏：视频 $videoCount 个，食谱 $recipeCount 个"
    }
}
