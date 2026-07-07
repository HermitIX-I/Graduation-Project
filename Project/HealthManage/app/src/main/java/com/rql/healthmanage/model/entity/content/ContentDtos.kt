package com.rql.healthmanage.model.entity

data class VideoItemDto(
    val id: Int,
    val title: String,
    val cover: String,
    val url: String,
    val tags: String?,
    val viewCount: Int,
    val isCollected: Boolean = false
)
data class RecipeItemDto(
    val id: Int,
    val name: String,
    val cover: String,
    val ingredients: String,
    val steps: String,
    val tags: String?,
    val suitableConstitution: String?,
    val viewCount: Int,
    val isCollected: Boolean = false
)
/** 与后端 [com.rql.healthmanage.healthmanager.dto.recommenddto.CollaborativeEdgeDto] 字段一致 */
data class CollaborativeEdgeDto(val userId: Int, val itemId: Int)
data class SystemNoticeDto(val id: Int?, val title: String, val content: String, val status: Int)
