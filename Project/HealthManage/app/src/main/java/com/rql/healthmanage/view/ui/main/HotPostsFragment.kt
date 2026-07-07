package com.rql.healthmanage.view.ui.main

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.rql.healthmanage.model.entity.SocialPostDto

@Composable
fun HotPostsFragment(
    posts: List<SocialPostDto>,
    onOpenPost: (SocialPostDto) -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("热门动态", style = MaterialTheme.typography.titleMedium)
        posts.take(5).forEach { post ->
            Card(Modifier.fillMaxWidth()) {
                Column(
                    Modifier
                        .fillMaxWidth()
                        .clickable { onOpenPost(post) }
                        .padding(10.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        CircleAvatar(url = post.avatar, userId = post.userId, sizeDp = 34)
                        Text(post.username, fontWeight = FontWeight.Bold)
                    }
                    Text(post.content, maxLines = 2, overflow = TextOverflow.Ellipsis, style = MaterialTheme.typography.bodyMedium)
                    post.images?.firstOrNull()?.let { img ->
                        RemoteCoverImage(
                            url = img,
                            modifier = Modifier
                                .fillMaxWidth()
                                .aspectRatio(1.3f)
                        )
                    }
                    Text(
                        buildString {
                            append("点赞 ${post.likeCount}  评论 ${post.commentCount}")
                            if (post.isCollected) append("  · 已收藏")
                        },
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

