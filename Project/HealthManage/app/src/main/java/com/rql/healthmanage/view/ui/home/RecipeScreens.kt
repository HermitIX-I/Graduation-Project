package com.rql.healthmanage.view.ui.home

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
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.Button
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.view.ui.main.RemoteCoverImage
import com.rql.healthmanage.viewmodel.home.HomeViewModel

@Composable
fun RecipeListScreen(
    onBack: () -> Unit,
    onOpenRecipe: ((RecipeItemDto) -> Unit)? = null,
    vm: HomeViewModel = viewModel()
) {
    val recipes by vm.recipes.observeAsState(emptyList())
    val loading by vm.loading.observeAsState(false)
    val err by vm.error.observeAsState()
    val toast by vm.toast.observeAsState()
    val ctx = LocalContext.current
    LaunchedEffect(Unit) { vm.loadRecipesForListPage() }
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
            Text("健康食谱", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.width(8.dp))
            OutlinedButton(onClick = { vm.loadRecipesForListPage() }) { Text("换一换") }
        }
        if (loading && recipes.isEmpty()) CircularProgressIndicator()
        LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            items(recipes.chunked(2)) { rowRecipes ->
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    rowRecipes.forEach { recipe ->
                        RecipeGridCard(recipe = recipe, modifier = Modifier.weight(1f), onClick = {
                            vm.reportRecipeClick(recipe.id)
                            onOpenRecipe?.invoke(recipe)
                        })
                    }
                    if (rowRecipes.size == 1) Spacer(modifier = Modifier.weight(1f))
                }
            }
        }
        if (!err.isNullOrBlank()) Text("错误：$err")
    }
}

@Composable
fun RecipeDetailScreen(recipe: RecipeItemDto?, onBack: () -> Unit) {
    if (recipe == null) {
        Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Text("未找到食谱详情")
        }
        return
    }
    Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Spacer(Modifier.width(8.dp))
            Text("食谱详情", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
        }
        RemoteCoverImage(url = recipe.cover, modifier = Modifier.fillMaxWidth().aspectRatio(1.5f))
        Text(recipe.name, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        Text("食材：${recipe.ingredients}")
        Text("做法：${recipe.steps}")
        Text("浏览 ${recipe.viewCount}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

@Composable
fun RecipeDetailScreenWithActions(
    recipe: RecipeItemDto?,
    onBack: () -> Unit,
    vm: HomeViewModel = viewModel()
) {
    if (recipe == null) {
        RecipeDetailScreen(recipe, onBack)
        return
    }
    Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            OutlinedButton(onClick = onBack) { Text("返回") }
            Spacer(Modifier.width(8.dp))
            Text("食谱详情", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
        }
        RemoteCoverImage(url = recipe.cover, modifier = Modifier.fillMaxWidth().aspectRatio(1.5f))
        Text(recipe.name, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        Text("食材：${recipe.ingredients}")
        Text("做法：${recipe.steps}")
        Text("浏览 ${recipe.viewCount}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        Button(onClick = { vm.toggleRecipeCollect(recipe) }) {
            Text(if (recipe.isCollected) "取消收藏" else "收藏")
        }
    }
}

@Composable
fun RecipeGridCard(
    recipe: RecipeItemDto,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Card(modifier = modifier.clickable { onClick() }) {
        Column(modifier = Modifier.fillMaxWidth()) {
            RemoteCoverImage(url = recipe.cover, modifier = Modifier.fillMaxWidth().aspectRatio(1f))
            Column(modifier = Modifier.padding(8.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text(text = recipe.name, style = MaterialTheme.typography.bodyMedium, maxLines = 2, overflow = TextOverflow.Ellipsis)
                Text(text = "浏览 ${recipe.viewCount}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
        }
    }
}

