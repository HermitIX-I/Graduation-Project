package com.rql.healthmanage.view.ui.main

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowRight
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.view.ui.home.VideoGridCard

@Composable
fun RecommendedVideosFragment(
    videos: List<VideoItemDto>,
    onMoreVideos: () -> Unit,
    onOpenVideo: (VideoItemDto) -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text("推荐视频", style = MaterialTheme.typography.titleMedium)
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.clickable { onMoreVideos() }
            ) {
                Text("更多", color = MaterialTheme.colorScheme.primary)
                Icon(Icons.Default.KeyboardArrowRight, contentDescription = "更多视频", tint = MaterialTheme.colorScheme.primary)
            }
        }
        val rows = videos.chunked(2)
        rows.forEach { rowVideos ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                rowVideos.forEach { video ->
                    VideoGridCard(video = video, modifier = Modifier.weight(1f), onClick = { onOpenVideo(video) })
                }
                if (rowVideos.size == 1) Spacer(modifier = Modifier.weight(1f))
            }
        }
    }
}

