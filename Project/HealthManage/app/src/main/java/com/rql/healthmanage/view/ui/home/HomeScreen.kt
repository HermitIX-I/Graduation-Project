package com.rql.healthmanage.view.ui.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.view.ui.main.HotPostsFragment
import com.rql.healthmanage.view.ui.main.RecommendedRecipesFragment
import com.rql.healthmanage.view.ui.main.RecommendedVideosFragment
import com.rql.healthmanage.viewmodel.home.HomeViewModel

@Composable
fun HomeScreenPage(
    onStartAssessment: () -> Unit,
    onMoreVideos: () -> Unit,
    onMoreRecipes: () -> Unit,
    onOpenVideo: (VideoItemDto) -> Unit,
    onOpenRecipe: (RecipeItemDto) -> Unit,
    onOpenPost: (SocialPostDto) -> Unit,
    vm: HomeViewModel = viewModel()
) {
    val notices by vm.notices.observeAsState(emptyList())
    val videos by vm.videos.observeAsState(emptyList())
    val recipes by vm.recipes.observeAsState(emptyList())
    val posts by vm.hotPosts.observeAsState(emptyList())
    val loading by vm.loading.observeAsState(false)
    val err by vm.error.observeAsState()
    val assessed by vm.assessed.observeAsState(false)
    val constitutionType by vm.constitutionType.observeAsState()
    val subhealthTotal by vm.subhealthTotalScore.observeAsState()
    val subhealthLevelLabel by vm.subhealthLevelLabel.observeAsState()

    LaunchedEffect(Unit) { vm.refresh() }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(12.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        item {
            Card(Modifier.fillMaxWidth()) {
                Column(Modifier.padding(12.dp)) {
                    Text("系统公告", fontWeight = FontWeight.Bold)
                    Text(notices.firstOrNull()?.title ?: "暂无公告")
                }
            }
        }
        item {
            Card(Modifier.fillMaxWidth()) {
                Column(Modifier.padding(12.dp)) {
                    Text("亚健康与中医体质评估", fontWeight = FontWeight.Bold)
                    if (subhealthLevelLabel != null && subhealthTotal != null) {
                        Text("当前亚健康程度：$subhealthLevelLabel（综合得分 $subhealthTotal）")
                    } else {
                        Text("尚未完成亚健康综合评估，请先完成问卷。")
                    }
                    Text(if (assessed) "体质辨识：${constitutionType ?: "未知"}" else "尚未建档评估")
                    Spacer(Modifier.height(8.dp))
                    Button(onClick = onStartAssessment) { Text(if (assessed) "重新评估" else "开始评估") }
                }
            }
        }
        item {
            RecommendedVideosFragment(
                videos = videos,
                onMoreVideos = onMoreVideos,
                onOpenVideo = onOpenVideo
            )
        }
        item {
            RecommendedRecipesFragment(
                recipes = recipes,
                onMoreRecipes = onMoreRecipes,
                onOpenRecipe = onOpenRecipe
            )
        }
        item {
            HotPostsFragment(
                posts = posts,
                onOpenPost = onOpenPost
            )
        }
        if (loading) item { Text("加载中...") }
        if (!err.isNullOrBlank()) item { Text("错误：$err", color = MaterialTheme.colorScheme.error) }
    }
}

