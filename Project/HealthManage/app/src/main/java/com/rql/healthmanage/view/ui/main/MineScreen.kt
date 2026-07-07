package com.rql.healthmanage.view.ui.main

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.rql.healthmanage.util.SPUtil
import kotlin.math.pow

@Composable
fun MineTab(onLogout: () -> Unit) {
    val h = SPUtil.getString("user_height", "").toFloatOrNull()
    val w = SPUtil.getString("user_weight", "").toFloatOrNull()
    val bmi = if (h != null && w != null && h > 0) w / (h / 100f).pow(2) else null
    LazyColumn(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        item {
            Card(Modifier.fillMaxWidth()) {
                Column(Modifier.padding(12.dp)) {
                    Text("用户：${SPUtil.getString("user_name", "用户")}", fontWeight = FontWeight.Bold)
                    Text("BMI：${bmi?.let { String.format("%.1f", it) } ?: "暂无"}")
                }
            }
        }
        item { Text("我的健康档案 / 历史评估报告 / 详细趋势分析 / 中医体质报告 / 我的收藏 / 设置") }
        item { Button(onClick = onLogout) { Text("退出登录") } }
    }
}

