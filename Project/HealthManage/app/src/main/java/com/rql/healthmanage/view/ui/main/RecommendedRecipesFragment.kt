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
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.view.ui.home.RecipeGridCard

@Composable
fun RecommendedRecipesFragment(
    recipes: List<RecipeItemDto>,
    onMoreRecipes: () -> Unit,
    onOpenRecipe: (RecipeItemDto) -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text("健康食谱", style = MaterialTheme.typography.titleMedium)
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.clickable { onMoreRecipes() }
            ) {
                Text("更多", color = MaterialTheme.colorScheme.primary)
                Icon(Icons.Default.KeyboardArrowRight, contentDescription = "更多食谱", tint = MaterialTheme.colorScheme.primary)
            }
        }
        val rows = recipes.chunked(2)
        rows.forEach { rowRecipes ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                rowRecipes.forEach { recipe ->
                    RecipeGridCard(recipe = recipe, modifier = Modifier.weight(1f), onClick = { onOpenRecipe(recipe) })
                }
                if (rowRecipes.size == 1) Spacer(modifier = Modifier.weight(1f))
            }
        }
    }
}

