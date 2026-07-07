package com.rql.healthmanage.model.entity

data class HomeContent(
    val notices: List<SystemNoticeDto>,
    val videos: List<VideoItemDto>,
    val recipes: List<RecipeItemDto>,
    val hotPosts: List<SocialPostDto>
)
