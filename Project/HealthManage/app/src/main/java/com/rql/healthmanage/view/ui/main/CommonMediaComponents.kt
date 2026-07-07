package com.rql.healthmanage.view.ui.main

import android.widget.ImageView
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.viewinterop.AndroidView
import androidx.compose.ui.unit.dp
import com.bumptech.glide.Glide
import com.rql.healthmanage.util.MediaUploadHelper

@Composable
fun CircleAvatar(url: String?, userId: Int = 0, sizeDp: Int = 36) {
    AndroidView(
        modifier = Modifier.size(sizeDp.dp),
        factory = { ctx ->
            ImageView(ctx).apply { scaleType = ImageView.ScaleType.CENTER_CROP }
        },
        update = { iv ->
            val resolved = MediaUploadHelper.resolveUserAvatarUrl(userId, url)
            Glide.with(iv.context).load(resolved).circleCrop().into(iv)
        }
    )
}

@Composable
fun RemoteCoverImage(url: String, modifier: Modifier = Modifier) {
    Box(modifier = modifier) {
        AndroidView(
            modifier = Modifier.fillMaxSize(),
            factory = { ctx ->
                ImageView(ctx).apply { scaleType = ImageView.ScaleType.CENTER_CROP }
            },
            update = { iv ->
                Glide.with(iv.context).load(url).centerCrop().into(iv)
            }
        )
        if (url.isBlank()) {
            Box(
                modifier = Modifier.fillMaxSize().padding(4.dp),
                contentAlignment = Alignment.Center
            ) {
                Text("无封面", color = Color.Gray)
            }
        }
    }
}

