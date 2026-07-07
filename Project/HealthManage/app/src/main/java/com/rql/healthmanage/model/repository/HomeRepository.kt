package com.rql.healthmanage.model.repository

import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.HomeContent
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.recommend.CollaborativeFiltering

class HomeRepository {
    suspend fun fetchHomeContent(assessed: Boolean, constitution: String?): HomeContent {
        val api = RetrofitClient.api
        val notices = runCatching { api.notices(1, 10).data }.getOrNull() ?: emptyList()
        val const = constitution?.trim()?.takeIf { it.isNotEmpty() }
        var videos = runCatching { api.recommendVideos(120, const).data }.getOrNull() ?: emptyList()
        var recipes = runCatching { api.recommendRecipes(120, const).data }.getOrNull() ?: emptyList()
        val user = runCatching { api.getUserInfo().data }.getOrNull()
        if (user != null) {
            val vEdges = runCatching { api.videoCollaborativeEdges().data.orEmpty() }
                .getOrDefault(emptyList())
                .map { it.userId to it.itemId }
            val rEdges = runCatching { api.recipeCollaborativeEdges().data.orEmpty() }
                .getOrDefault(emptyList())
                .map { it.userId to it.itemId }
            videos = CollaborativeFiltering.rerankVideos(videos, vEdges, user.id, const)
            recipes = CollaborativeFiltering.rerankRecipes(recipes, rEdges, user.id, const)
        }
        val hotPosts = if (assessed) {
            val follow = runCatching { api.socialFeed("follow", 1, 10).data }.getOrNull() ?: emptyList()
            if (follow.isNotEmpty()) follow else (runCatching { api.socialFeed("recommend", 1, 10).data }.getOrNull() ?: emptyList())
        } else {
            runCatching { api.socialFeed("recommend", 1, 10).data }.getOrNull() ?: emptyList()
        }
        return HomeContent(notices, videos, recipes, hotPosts)
    }

    suspend fun fetchRecommendedVideos(limit: Int, constitution: String?): List<VideoItemDto> {
        val api = RetrofitClient.api
        val const = constitution?.trim()?.takeIf { it.isNotEmpty() }
        var list = runCatching { api.recommendVideos(limit, const).data }.getOrNull() ?: emptyList()
        val user = runCatching { api.getUserInfo().data }.getOrNull() ?: return list
        val edges = runCatching { api.videoCollaborativeEdges().data.orEmpty() }
            .getOrDefault(emptyList())
            .map { it.userId to it.itemId }
        return CollaborativeFiltering.rerankVideos(list, edges, user.id, const)
    }

    suspend fun fetchRecommendedRecipes(limit: Int, constitution: String?): List<RecipeItemDto> {
        val api = RetrofitClient.api
        val const = constitution?.trim()?.takeIf { it.isNotEmpty() }
        var list = runCatching { api.recommendRecipes(limit, const).data }.getOrNull() ?: emptyList()
        val user = runCatching { api.getUserInfo().data }.getOrNull() ?: return list
        val edges = runCatching { api.recipeCollaborativeEdges().data.orEmpty() }
            .getOrDefault(emptyList())
            .map { it.userId to it.itemId }
        return CollaborativeFiltering.rerankRecipes(list, edges, user.id, const)
    }
}
