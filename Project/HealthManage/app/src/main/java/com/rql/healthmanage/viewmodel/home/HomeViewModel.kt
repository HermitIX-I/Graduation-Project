package com.rql.healthmanage.viewmodel.home

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.SystemNoticeDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.repository.HomeRepository
import kotlinx.coroutines.launch

class HomeViewModel : ViewModel() {
    companion object {
        /** 首页推荐区展示条数（网格约 2 列 × N 行） */
        private const val HOME_VIDEO_PREVIEW = 6
        private const val HOME_RECIPE_PREVIEW = 6
        /** 首页搜索时最多展示条数，避免一屏过长 */
        private const val HOME_SEARCH_MAX = 48
    }

    private val repository = HomeRepository()
    private val _notices = MutableLiveData<List<SystemNoticeDto>>(emptyList())
    val notices: LiveData<List<SystemNoticeDto>> = _notices
    private val _videos = MutableLiveData<List<VideoItemDto>>(emptyList())
    val videos: LiveData<List<VideoItemDto>> = _videos
    private val _recipes = MutableLiveData<List<RecipeItemDto>>(emptyList())
    val recipes: LiveData<List<RecipeItemDto>> = _recipes
    private val _hotPosts = MutableLiveData<List<SocialPostDto>>(emptyList())
    val hotPosts: LiveData<List<SocialPostDto>> = _hotPosts
    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error
    private val _loading = MutableLiveData(false)
    val loading: LiveData<Boolean> = _loading
    private val _assessed = MutableLiveData(false)
    val assessed: LiveData<Boolean> = _assessed
    private val _constitutionType = MutableLiveData<String?>()
    val constitutionType: LiveData<String?> = _constitutionType
    private val _subhealthTotalScore = MutableLiveData<Int?>()
    val subhealthTotalScore: LiveData<Int?> = _subhealthTotalScore
    private val _subhealthLevel = MutableLiveData<Int?>()
    val subhealthLevel: LiveData<Int?> = _subhealthLevel
    private val _subhealthLevelLabel = MutableLiveData<String?>()
    val subhealthLevelLabel: LiveData<String?> = _subhealthLevelLabel
    private val _toast = MutableLiveData<String?>()
    val toast: LiveData<String?> = _toast
    private var allVideos: List<VideoItemDto> = emptyList()
    private var allRecipes: List<RecipeItemDto> = emptyList()
    /** 最近一次评估体质，用于推荐接口与客户端协同过滤重排 */
    private var constitutionForRecommend: String? = null

    fun refresh() {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val latest = RetrofitClient.api.latestAssessment().data
                val hasAssessment = latest != null
                _assessed.value = hasAssessment
                _constitutionType.value = latest?.constitutionType
                constitutionForRecommend = latest?.constitutionType?.trim()?.takeIf { it.isNotEmpty() }
                val completedSubhealth = latest?.psychologicalScore != null && latest.lifestyleScore != null
                if (completedSubhealth && latest != null) {
                    _subhealthTotalScore.value = latest.totalScore
                    _subhealthLevel.value = latest.level
                    _subhealthLevelLabel.value = subhealthLabel(latest.level)
                } else {
                    _subhealthTotalScore.value = null
                    _subhealthLevel.value = null
                    _subhealthLevelLabel.value = null
                }
                val content = repository.fetchHomeContent(hasAssessment, constitutionForRecommend)
                _notices.value = content.notices
                allVideos = content.videos
                allRecipes = content.recipes
                _videos.value = allVideos.take(HOME_VIDEO_PREVIEW)
                _recipes.value = allRecipes.take(HOME_RECIPE_PREVIEW)
                _hotPosts.value = content.hotPosts
            } catch (e: Exception) {
                _error.value = e.message ?: "网络异常"
            } finally {
                _loading.value = false
            }
        }
    }

    fun refreshRecommendations() {
        refresh()
    }

    /** 「更多」进入视频列表页：拉取较多条供浏览（与首页预览独立） */
    fun loadVideosForListPage(limit: Int = 120) {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                allVideos = repository.fetchRecommendedVideos(limit, constitutionForRecommend)
                _videos.value = allVideos
            } catch (e: Exception) {
                _error.value = e.message ?: "网络异常"
            } finally {
                _loading.value = false
            }
        }
    }

    /** 「更多」进入食谱列表页 */
    fun loadRecipesForListPage(limit: Int = 120) {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                allRecipes = repository.fetchRecommendedRecipes(limit, constitutionForRecommend)
                _recipes.value = allRecipes
            } catch (e: Exception) {
                _error.value = e.message ?: "网络异常"
            } finally {
                _loading.value = false
            }
        }
    }

    fun reportVideoClick(videoId: Int) {
        viewModelScope.launch {
            runCatching { RetrofitClient.api.reportVideoView(videoId) }
            refreshRecommendations()
        }
    }

    fun reportRecipeClick(recipeId: Int) {
        viewModelScope.launch {
            runCatching { RetrofitClient.api.reportRecipeView(recipeId) }
            refreshRecommendations()
        }
    }

    fun toggleVideoCollect(video: VideoItemDto) {
        viewModelScope.launch {
            val res = if (video.isCollected) {
                runCatching { RetrofitClient.api.uncollectVideo(video.id) }.getOrNull()
            } else {
                runCatching { RetrofitClient.api.collectVideo(video.id) }.getOrNull()
            }
            if (res?.code == 200) {
                _toast.value = if (video.isCollected) "已取消收藏视频" else "已收藏视频"
                refreshRecommendations()
            } else {
                _toast.value = res?.message ?: "收藏操作失败"
            }
        }
    }

    fun toggleRecipeCollect(recipe: RecipeItemDto) {
        viewModelScope.launch {
            val res = if (recipe.isCollected) {
                runCatching { RetrofitClient.api.uncollectRecipe(recipe.id) }.getOrNull()
            } else {
                runCatching { RetrofitClient.api.collectRecipe(recipe.id) }.getOrNull()
            }
            if (res?.code == 200) {
                _toast.value = if (recipe.isCollected) "已取消收藏食谱" else "已收藏食谱"
                refreshRecommendations()
            } else {
                _toast.value = res?.message ?: "收藏操作失败"
            }
        }
    }

    fun consumeToast() {
        _toast.value = null
    }

    fun searchVideos(keywordOrTag: String) {
        val key = keywordOrTag.trim()
        _videos.value = if (key.isBlank()) {
            allVideos.take(HOME_VIDEO_PREVIEW)
        } else {
            allVideos.filter { v ->
                v.title.contains(key, ignoreCase = true) ||
                    (v.tags?.contains(key, ignoreCase = true) == true)
            }.take(HOME_SEARCH_MAX)
        }
    }

    fun searchRecipes(keywordOrTag: String) {
        val key = keywordOrTag.trim()
        _recipes.value = if (key.isBlank()) {
            allRecipes.take(HOME_RECIPE_PREVIEW)
        } else {
            allRecipes.filter { r ->
                r.name.contains(key, ignoreCase = true) ||
                    (r.tags?.contains(key, ignoreCase = true) == true) ||
                    (r.suitableConstitution?.contains(key, ignoreCase = true) == true)
            }.take(HOME_SEARCH_MAX)
        }
    }

    private fun subhealthLabel(level: Int): String = when (level) {
        0 -> "健康"
        1 -> "轻度亚健康"
        2 -> "中度亚健康"
        3 -> "重度亚健康"
        else -> "未知"
    }
}
