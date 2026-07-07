package com.rql.healthmanage.view.ui.home

import android.graphics.Color
import androidx.compose.foundation.clickable
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
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.media3.common.MediaItem
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.PlayerView
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.view.ui.main.RemoteCoverImage
import com.rql.healthmanage.viewmodel.home.HomeViewModel

@Composable
private fun ExoVideoPlayer(
    videoUrl: String,
    modifier: Modifier = Modifier,
) {
    val context = LocalContext.current
    val lifecycleOwner = LocalLifecycleOwner.current

    val exoPlayer = remember(videoUrl) {
        ExoPlayer.Builder(context).build().apply {
            setMediaItem(MediaItem.fromUri(videoUrl))
            prepare()
            playWhenReady = true
        }
    }

    DisposableEffect(exoPlayer) {
        onDispose { exoPlayer.release() }
    }

    val pendingResume = remember(videoUrl) { mutableStateOf(false) }
    DisposableEffect(lifecycleOwner, exoPlayer) {
        val observer = LifecycleEventObserver { _, event ->
            when (event) {
                Lifecycle.Event.ON_PAUSE -> {
                    pendingResume.value = exoPlayer.playWhenReady
                    exoPlayer.playWhenReady = false
                }
                Lifecycle.Event.ON_RESUME -> {
                    if (pendingResume.value) exoPlayer.playWhenReady = true
                }
                else -> Unit
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose { lifecycleOwner.lifecycle.removeObserver(observer) }
    }

    AndroidView(
        factory = { ctx ->
            PlayerView(ctx).apply {
                player = exoPlayer
                useController = true
                setShowBuffering(PlayerView.SHOW_BUFFERING_WHEN_PLAYING)
                resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
                setBackgroundColor(Color.BLACK)
            }
        },
        modifier = modifier,
    )
}

@Composable
fun VideoListScreen(
    onBack: () -> Unit,
    onOpenVideo: (VideoItemDto) -> Unit,
    vm: HomeViewModel = viewModel(),
) {
    val videos by vm.videos.observeAsState(emptyList())
    val loading by vm.loading.observeAsState(false)
    val err by vm.error.observeAsState()
    val toast by vm.toast.observeAsState()
    val ctx = LocalContext.current
    LaunchedEffect(Unit) { vm.loadVideosForListPage() }
    LaunchedEffect(toast) {
        if (!toast.isNullOrBlank()) {
            android.widget.Toast.makeText(ctx, toast, android.widget.Toast.LENGTH_SHORT).show()
            vm.consumeToast()
        }
    }

    Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Spacer(modifier = Modifier.width(8.dp))
            Text("推荐视频", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.width(8.dp))
            OutlinedButton(onClick = { vm.loadVideosForListPage() }) { Text("换一换") }
        }
        if (loading && videos.isEmpty()) CircularProgressIndicator()
        LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            items(videos.chunked(2)) { rowVideos ->
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    rowVideos.forEach { video ->
                        VideoGridCard(video = video, modifier = Modifier.weight(1f), onClick = {
                            vm.reportVideoClick(video.id)
                            onOpenVideo(video)
                        })
                    }
                    if (rowVideos.size == 1) Spacer(modifier = Modifier.weight(1f))
                }
            }
        }
        if (!err.isNullOrBlank()) Text("错误：$err")
    }
}

@Composable
fun VideoDetailScreen(video: VideoItemDto?, onBack: () -> Unit) {
    if (video == null) {
        Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Text("未找到视频详情")
        }
        return
    }
    Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Spacer(Modifier.width(8.dp))
            Text("视频详情", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
        }
        ExoVideoPlayer(
            videoUrl = video.url,
            modifier = Modifier.fillMaxWidth().aspectRatio(16f / 9f),
        )
        Text(video.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        Text("播放 ${video.viewCount}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        if (!video.tags.isNullOrBlank()) Text("标签：${video.tags}")
    }
}

@Composable
fun VideoDetailScreenWithActions(
    video: VideoItemDto?,
    onBack: () -> Unit,
    vm: HomeViewModel = viewModel(),
) {
    if (video == null) {
        VideoDetailScreen(video, onBack)
        return
    }
    Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Spacer(Modifier.width(8.dp))
            Text("视频详情", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
        }
        ExoVideoPlayer(
            videoUrl = video.url,
            modifier = Modifier.fillMaxWidth().aspectRatio(16f / 9f),
        )
        Text(video.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        Text("播放 ${video.viewCount}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        if (!video.tags.isNullOrBlank()) Text("标签：${video.tags}")
        Button(onClick = { vm.toggleVideoCollect(video) }) {
            Text(if (video.isCollected) "取消收藏" else "收藏")
        }
    }
}

@Composable
fun VideoGridCard(
    video: VideoItemDto,
    modifier: Modifier = Modifier,
    onClick: () -> Unit,
) {
    Card(modifier = modifier.clickable { onClick() }) {
        Column(modifier = Modifier.fillMaxWidth()) {
            RemoteCoverImage(
                url = video.cover.ifBlank { video.url },
                modifier = Modifier.fillMaxWidth().aspectRatio(1f),
            )
            Column(modifier = Modifier.padding(8.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text(text = video.title, style = MaterialTheme.typography.bodyMedium, maxLines = 2, overflow = TextOverflow.Ellipsis)
                Text(text = "播放 ${video.viewCount}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
        }
    }
}
