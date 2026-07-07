package com.rql.healthmanage.viewmodel.social

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.SocialCommentCreateDto
import com.rql.healthmanage.model.entity.SocialPostCreateDto
import com.rql.healthmanage.model.entity.SocialPostDto
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class SocialViewModel : ViewModel() {
    private val dateFmt = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA)
    private val pageSize = 20
    private var nextPage = 1
    private var hasMoreRemote = true
    private var isPaging = false

    private val _posts = MutableLiveData<List<SocialPostDto>>(emptyList())
    val posts: LiveData<List<SocialPostDto>> = _posts

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _toast = MutableLiveData<String?>()
    val toast: LiveData<String?> = _toast

    private val _followingUserIds = MutableLiveData<Set<Int>>(emptySet())
    val followingUserIds: LiveData<Set<Int>> = _followingUserIds

    private val _hasMore = MutableLiveData(true)
    val hasMore: LiveData<Boolean> = _hasMore

    private val _loadingMore = MutableLiveData(false)
    val loadingMore: LiveData<Boolean> = _loadingMore

    var feedType: String = "recommend"

    /** 下拉刷新或切换 Tab：从第一页重新加载 */
    fun refresh() {
        viewModelScope.launch {
            try {
                nextPage = 1
                hasMoreRemote = true
                isPaging = false
                _hasMore.value = true
                if (feedType == "follow") {
                    val followingRes = RetrofitClient.api.followingList(1, 300)
                    if (followingRes.code == 200 && followingRes.data != null) {
                        _followingUserIds.value = followingRes.data.map { it.id }.toSet()
                    }
                }
                val page = 1
                val res = RetrofitClient.api.socialFeed(feedType, page, pageSize)
                if (res.code == 200 && res.data != null) {
                    val raw = res.data
                    val rows = applyFollowFilter(raw)
                    _posts.value = rows
                    nextPage = 2
                    hasMoreRemote = raw.size >= pageSize
                    _hasMore.value = hasMoreRemote
                } else {
                    _error.value = res.message
                }
            } catch (e: Exception) {
                _error.value = e.message
            }
        }
    }

    /** 列表滑到底部时追加下一页 */
    fun loadMore() {
        if (!hasMoreRemote || isPaging) return
        viewModelScope.launch {
            isPaging = true
            _loadingMore.value = true
            try {
                val res = RetrofitClient.api.socialFeed(feedType, nextPage, pageSize)
                if (res.code != 200 || res.data == null) {
                    _error.value = res.message
                    return@launch
                }
                val raw = res.data
                val rows = applyFollowFilter(raw)
                val existingIds = _posts.value.orEmpty().map { it.id }.toSet()
                val merged = _posts.value.orEmpty() + rows.filter { it.id !in existingIds }
                _posts.value = merged
                if (raw.isEmpty() || raw.size < pageSize) {
                    hasMoreRemote = false
                    _hasMore.value = false
                } else {
                    nextPage += 1
                }
            } catch (e: Exception) {
                _error.value = e.message
            } finally {
                isPaging = false
                _loadingMore.value = false
            }
        }
    }

    private fun applyFollowFilter(rows: List<SocialPostDto>): List<SocialPostDto> {
        return if (feedType == "follow") {
            val following = _followingUserIds.value.orEmpty()
            rows.filter { following.contains(it.userId) }
        } else {
            rows
        }
    }

    fun publish(content: String, imageUrls: List<String>?, tags: List<String>?) {
        if (content.isBlank()) {
            _toast.value = "请输入动态内容"
            return
        }
        viewModelScope.launch {
            try {
                val text = content.trim()
                val res = RetrofitClient.api.createPost(SocialPostCreateDto(text, imageUrls, tags))
                if (res.code == 200) {
                    _toast.value = "已提交，等待管理员审核通过后在广场展示"
                    refresh()
                } else {
                    _error.value = res.message
                }
            } catch (e: Exception) {
                _error.value = e.message
            }
        }
    }

    fun toggleLike(post: SocialPostDto) {
        viewModelScope.launch {
            try {
                val res = if (post.isLiked) {
                    RetrofitClient.api.unlikePost(post.id)
                } else {
                    RetrofitClient.api.likePost(post.id)
                }
                if (res.code == 200) {
                    refresh()
                } else {
                    _error.value = res.message
                }
            } catch (e: Exception) {
                _error.value = e.message
            }
        }
    }

    fun comment(postId: Int, content: String) {
        if (content.isBlank()) {
            _toast.value = "请输入评论内容"
            return
        }
        viewModelScope.launch {
            try {
                val res = RetrofitClient.api.createComment(postId, SocialCommentCreateDto(content = content.trim()))
                if (res.code == 200) {
                    _toast.value = "评论成功"
                    refresh()
                } else {
                    _error.value = res.message
                }
            } catch (e: Exception) {
                _error.value = e.message
            }
        }
    }

    fun toggleFollow(targetUserId: Int) {
        if (targetUserId <= 0) return
        viewModelScope.launch {
            try {
                val following = _followingUserIds.value.orEmpty()
                val res = if (following.contains(targetUserId)) {
                    RetrofitClient.api.unfollowUser(targetUserId)
                } else {
                    RetrofitClient.api.followUser(targetUserId)
                }
                if (res.code == 200) {
                    _followingUserIds.value = if (following.contains(targetUserId)) following - targetUserId else following + targetUserId
                    _toast.value = if (following.contains(targetUserId)) "已取消关注" else "关注成功"
                } else {
                    _error.value = res.message
                }
            } catch (e: Exception) {
                _error.value = e.message
            }
        }
    }

    fun clearToast() {
        _toast.value = null
    }

    private fun optimisticInsertPost(content: String, imageUrls: List<String>?, tags: List<String>?) {
        val current = _posts.value.orEmpty()
        val exists = current.any { it.content == content && it.images == imageUrls }
        if (exists) return
        val localPost = SocialPostDto(
            id = -System.currentTimeMillis().toInt(),
            userId = 0,
            username = "我",
            avatar = null,
            content = content,
            images = imageUrls,
            tags = tags,
            likeCount = 0,
            commentCount = 0,
            isLiked = false,
            isCollected = false,
            status = 1,
            createTime = dateFmt.format(Date())
        )
        _posts.value = listOf(localPost) + current
    }
}
