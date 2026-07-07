package com.rql.healthmanage.model.entity

import com.google.gson.annotations.SerializedName

data class SocialPostDto(
    val id: Int,
    val userId: Int,
    val username: String,
    val avatar: String?,
    val content: String,
    val images: List<String>?,
    val tags: List<String>?,
    val likeCount: Int,
    val commentCount: Int,
    @SerializedName(value = "isLiked", alternate = ["liked"]) val isLiked: Boolean,
    @SerializedName(value = "isCollected", alternate = ["collected"]) val isCollected: Boolean = false,
    val status: Int,
    val createTime: String
)
data class SocialCommentDto(
    val id: Int,
    val postId: Int,
    val userId: Int,
    val username: String = "用户",
    val avatar: String?,
    val content: String = "",
    val parentId: Int? = null,
    val status: Int? = null,
    val createTime: String? = null,
    val replies: List<SocialCommentDto>? = null
)
data class SocialPostCreateDto(val content: String, val images: List<String>? = null, val tags: List<String>? = null)
data class SocialCommentCreateDto(val content: String, val parentId: Int? = null)
