package com.rql.healthmanage.view.ui.social

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material3.Card
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.rql.healthmanage.viewmodel.social.SocialViewModel

@Composable
fun SocialScreenPage(vm: SocialViewModel = viewModel()) {
    var input by rememberSaveable { mutableStateOf("") }
    var tab by rememberSaveable { mutableIntStateOf(1) }
    val posts by vm.posts.observeAsState(emptyList())
    val err by vm.error.observeAsState()
    val toast by vm.toast.observeAsState()
    val hasMore by vm.hasMore.observeAsState(true)

    LaunchedEffect(tab) {
        vm.feedType = if (tab == 0) "follow" else "recommend"
        vm.refresh()
    }

    Scaffold(
        floatingActionButton = { FloatingActionButton(onClick = { vm.publish(input, null, null) }) { Text("+") } }
    ) { padding ->
        Column(
            Modifier
                .padding(padding)
                .fillMaxSize()
                .padding(12.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            TabRow(selectedTabIndex = tab) {
                Tab(selected = tab == 0, onClick = { tab = 0 }, text = { Text("关注动态") })
                Tab(selected = tab == 1, onClick = { tab = 1 }, text = { Text("广场动态") })
            }
            OutlinedTextField(value = input, onValueChange = { input = it }, label = { Text("发布动态（文字/图片链接）") }, modifier = Modifier.fillMaxWidth())
            LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                items(posts) { p ->
                    Card(Modifier.fillMaxWidth()) {
                        Column(Modifier.padding(10.dp)) {
                            Text(p.username, fontWeight = FontWeight.Bold)
                            Spacer(Modifier.height(4.dp))
                            Text(p.content)
                            Spacer(Modifier.height(8.dp))
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                OutlinedButton(onClick = { vm.toggleLike(p) }) {
                                    Icon(Icons.Default.Favorite, contentDescription = null)
                                    Spacer(Modifier.width(6.dp))
                                    Text("${p.likeCount}")
                                }
                                Spacer(Modifier.width(8.dp))
                                Text("评论 ${p.commentCount}")
                            }
                        }
                    }
                }
                item {
                    if (posts.isNotEmpty()) {
                        if (hasMore) {
                            TextButton(
                                onClick = { vm.loadMore() },
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Text("加载更多")
                            }
                        } else {
                            Text(
                                "已加载全部",
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 12.dp),
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }
            }
            if (!err.isNullOrBlank()) Text("错误：$err")
            if (!toast.isNullOrBlank()) {
                Text(toast ?: "")
                LaunchedEffect(toast) { vm.clearToast() }
            }
        }
    }
}

