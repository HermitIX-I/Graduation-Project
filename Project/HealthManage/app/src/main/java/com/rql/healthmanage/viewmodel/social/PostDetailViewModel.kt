package com.rql.healthmanage.viewmodel.social

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.SocialCommentDto
import com.rql.healthmanage.model.entity.SocialPostDto
import kotlinx.coroutines.launch

class PostDetailViewModel : ViewModel() {
    private val _post = MutableLiveData<SocialPostDto?>(null)
    val post: LiveData<SocialPostDto?> = _post

    private val _comments = MutableLiveData<List<SocialCommentDto>>(emptyList())
    val comments: LiveData<List<SocialCommentDto>> = _comments

    private val _status = MutableLiveData("")
    val status: LiveData<String> = _status

    private val _loading = MutableLiveData(false)
    val loading: LiveData<Boolean> = _loading

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _needsParentFeedRefresh = MutableLiveData(false)
    val needsParentFeedRefresh: LiveData<Boolean> = _needsParentFeedRefresh

    fun consumeParentFeedRefresh() {
        _needsParentFeedRefresh.value = false
    }

    fun loadPost(postId: Int) {
        if (postId <= 0) return
        viewModelScope.launch {
            _error.value = null
            val result = runCatching { RetrofitClient.api.getSocialPost(postId) }.getOrNull()
            if (result == null || result.code != 200) {
                _error.value = result?.message
            } else {
                _post.value = result.data
            }
        }
    }

    fun loadComments(postId: Int) {
        if (postId <= 0) return
        viewModelScope.launch {
            _loading.value = true
            _status.value = "?????????..."
            _error.value = null
            val result = runCatching { RetrofitClient.api.socialComments(postId, 1, 20) }.getOrNull()
            if (result == null || result.code != 200) {
                _comments.value = emptyList()
                _status.value = "????????"
                _error.value = result?.message
            } else {
                val comments = result.data ?: emptyList()
                _comments.value = flattenComments(comments)
                _status.value = "???? ${comments.size} ??"
            }
            _loading.value = false
        }
    }

    fun toggleParentLike() {
        val p = _post.value ?: return
        viewModelScope.launch {
            _error.value = null
            val res = runCatching {
                if (p.isLiked) RetrofitClient.api.unlikePost(p.id) else RetrofitClient.api.likePost(p.id)
            }.getOrNull()
            if (res == null || res.code != 200) {
                _error.value = res?.message ?: "???????"
                return@launch
            }
            loadPost(p.id)
            _needsParentFeedRefresh.value = true
        }
    }

    fun toggleParentCollect() {
        val p = _post.value ?: return
        viewModelScope.launch {
            _error.value = null
            val res = runCatching {
                if (p.isCollected) RetrofitClient.api.uncollectSocialPost(p.id)
                else RetrofitClient.api.collectSocialPost(p.id)
            }.getOrNull()
            if (res == null || res.code != 200) {
                _error.value = res?.message ?: "??????"
                return@launch
            }
            loadPost(p.id)
            _needsParentFeedRefresh.value = true
        }
    }

    private fun flattenComments(comments: List<SocialCommentDto>): List<SocialCommentDto> {
        val all = mutableListOf<SocialCommentDto>()
        comments.forEach { c ->
            all += c
            c.replies.orEmpty().forEach { r -> all += r.copy(username = "${r.username} (�ظ�)") }
        }
        return all
    }
}
