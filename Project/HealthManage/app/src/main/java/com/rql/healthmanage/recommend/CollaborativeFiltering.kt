package com.rql.healthmanage.recommend

import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.VideoItemDto
import kotlin.math.sqrt

/**
 * 与后端 [RecommendationServiceImpl] 一致的基于用户的协同过滤（余弦形式相似度 + 近邻物品聚合），
 * 在客户端用收藏隐式反馈边数据对服务端已融合列表做二次重排。
 */
object CollaborativeFiltering {

    fun <T> cosineSimilarity(set1: Set<T>, set2: Set<T>): Double {
        val inter = set1.intersect(set2).size
        val den = sqrt(set1.size.toDouble() * set2.size.toDouble())
        return if (den <= 0.0) 0.0 else inter / den
    }

    private fun <T> similarUsers(userId: Int, userItemMap: Map<Int, Set<T>>): List<Pair<Int, Double>> {
        val target = userItemMap[userId] ?: return emptyList()
        val sims = mutableListOf<Pair<Int, Double>>()
        userItemMap.forEach { (other, items) ->
            if (other != userId && items.isNotEmpty()) {
                val s = cosineSimilarity(target, items)
                if (s > 0) sims.add(other to s)
            }
        }
        sims.sortByDescending { it.second }
        return sims
    }

    /** 近邻用户未收藏物品的加权得分（权重 = 用户间相似度之和） */
    fun neighborItemScores(userId: Int, edges: List<Pair<Int, Int>>): Map<Int, Double> {
        val map = mutableMapOf<Int, MutableSet<Int>>()
        edges.forEach { (u, item) -> map.computeIfAbsent(u) { mutableSetOf() }.add(item) }
        val mine = map[userId] ?: emptySet()
        val sims = similarUsers(userId, map)
        val scores = mutableMapOf<Int, Double>()
        for ((neighbor, w) in sims) {
            val theirs = map[neighbor] ?: continue
            for (item in theirs) {
                if (item in mine) continue
                scores[item] = (scores[item] ?: 0.0) + w
            }
        }
        return scores
    }

    fun rerankVideos(
        videos: List<VideoItemDto>,
        edges: List<Pair<Int, Int>>,
        userId: Int,
        constitution: String?,
    ): List<VideoItemDto> {
        if (edges.isEmpty()) return videos
        val scores = neighborItemScores(userId, edges)
        if (scores.isEmpty()) return videos
        val const = constitution?.trim()?.takeIf { it.isNotEmpty() }
        val origIndex = videos.withIndex().associate { it.value.id to it.index }
        return videos.sortedWith(
            compareByDescending<VideoItemDto> { it ->
                const != null && (it.tags?.contains(const) == true)
            }.thenByDescending { it ->
                scores[it.id] ?: 0.0
            }.thenBy { it ->
                origIndex[it.id] ?: 0
            },
        )
    }

    fun rerankRecipes(
        recipes: List<RecipeItemDto>,
        edges: List<Pair<Int, Int>>,
        userId: Int,
        constitution: String?,
    ): List<RecipeItemDto> {
        if (edges.isEmpty()) return recipes
        val scores = neighborItemScores(userId, edges)
        if (scores.isEmpty()) return recipes
        val const = constitution?.trim()?.takeIf { it.isNotEmpty() }
        val origIndex = recipes.withIndex().associate { it.value.id to it.index }
        return recipes.sortedWith(
            compareByDescending<RecipeItemDto> { it ->
                const != null && (
                    (it.suitableConstitution?.contains(const) == true) ||
                        (it.tags?.contains(const) == true)
                    )
            }.thenByDescending { it ->
                scores[it.id] ?: 0.0
            }.thenBy { it ->
                origIndex[it.id] ?: 0
            },
        )
    }
}
