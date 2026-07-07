package com.rql.healthmanage.view.ui.main

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.MonitorHeart
import androidx.compose.material.icons.filled.SelfImprovement
import androidx.compose.material.icons.filled.Share
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.view.ui.health.HealthScreenPage
import com.rql.healthmanage.view.ui.home.HomeScreenPage
import com.rql.healthmanage.view.ui.social.SocialScreenPage
import com.rql.healthmanage.view.ui.sport.SportScreenPage

@Composable
fun MainContainer(
    selected: MainTab,
    onSelect: (MainTab) -> Unit,
    onLogout: () -> Unit,
    onStartAssessment: () -> Unit,
    onShowVideoList: () -> Unit,
    onShowRecipeList: () -> Unit,
    onOpenVideo: (VideoItemDto) -> Unit,
    onOpenRecipe: (RecipeItemDto) -> Unit,
    onOpenPost: (SocialPostDto) -> Unit
) {
    Scaffold(
        bottomBar = {
            NavigationBar {
                MainTab.entries.forEach { tab ->
                    NavigationBarItem(
                        selected = selected == tab,
                        onClick = { onSelect(tab) },
                        icon = {
                            Icon(
                                when (tab) {
                                    MainTab.Home -> Icons.Default.Home
                                    MainTab.Health -> Icons.Default.MonitorHeart
                                    MainTab.Sport -> Icons.Default.SelfImprovement
                                    MainTab.Social -> Icons.Default.Share
                                    MainTab.Mine -> Icons.Default.AccountCircle
                                },
                                contentDescription = tab.title
                            )
                        },
                        label = { Text(tab.title) }
                    )
                }
            }
        }
    ) { padding ->
        Column(Modifier.padding(padding).fillMaxSize()) {
            when (selected) {
                MainTab.Home -> HomeScreenPage(
                    onStartAssessment = onStartAssessment,
                    onMoreVideos = onShowVideoList,
                    onMoreRecipes = onShowRecipeList,
                    onOpenVideo = onOpenVideo,
                    onOpenRecipe = onOpenRecipe,
                    onOpenPost = onOpenPost
                )
                MainTab.Health -> HealthScreenPage()
                MainTab.Sport -> SportScreenPage()
                MainTab.Social -> SocialScreenPage()
                MainTab.Mine -> MineTab(onLogout)
            }
        }
    }
}

