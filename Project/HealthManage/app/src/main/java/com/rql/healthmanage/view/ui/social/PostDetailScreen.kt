package com.rql.healthmanage.view.ui.social

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.view.ui.main.CircleAvatar
import com.rql.healthmanage.view.ui.main.RemoteCoverImage
import com.rql.healthmanage.viewmodel.social.PostDetailViewModel

@Composable
fun PostDetailScreen(post: SocialPostDto?, onBack: () -> Unit, vm: PostDetailViewModel = viewModel()) {
    val comments by vm.comments.observeAsState(emptyList())
    val loading by vm.loading.observeAsState(false)
    val err by vm.error.observeAsState()

    LaunchedEffect(post?.id) {
        if (post != null) vm.loadComments(post.id)
    }

    if (post == null) {
        Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Text("未找到动态信息")
        }
        return
    }

    Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Spacer(Modifier.width(8.dp))
            Text("动态详情", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
        }
        Card(Modifier.fillMaxWidth()) {
            Column(Modifier.padding(10.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    CircleAvatar(url = post.avatar, userId = post.userId, sizeDp = 34)
                    Text(post.username, fontWeight = FontWeight.Bold)
                }
                Text(post.content)
                post.images?.firstOrNull()?.let { img ->
                    RemoteCoverImage(url = img, modifier = Modifier.fillMaxWidth().aspectRatio(1.3f))
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
        Text("评论", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        if (loading) CircularProgressIndicator()
        LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            items(comments, key = { it.id }) { c ->
                Card(Modifier.fillMaxWidth()) {
                    Column(Modifier.padding(10.dp), verticalArrangement = Arrangement.spacedBy(6.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            CircleAvatar(url = c.avatar, userId = c.userId, sizeDp = 30)
                            Text(c.username, fontWeight = FontWeight.Bold)
                        }
                        Text(c.content)
                    }
                }
            }
        }
        if (!err.isNullOrBlank()) Text("错误：$err", color = MaterialTheme.colorScheme.error)
    }
}
