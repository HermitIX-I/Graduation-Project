package com.rql.healthmanage.view.ui.sport

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.rql.healthmanage.viewmodel.sport.ExerciseViewModel

@Composable
fun SportScreenPage(vm: ExerciseViewModel = viewModel()) {
    val plan by vm.plan.observeAsState()
    val err by vm.error.observeAsState()
    var minutes by rememberSaveable { mutableStateOf("30") }
    var calories by rememberSaveable { mutableStateOf("") }
    LaunchedEffect(Unit) { vm.refresh() }

    Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Card(Modifier.fillMaxWidth()) {
            Column(Modifier.padding(12.dp)) {
                Text("Current Plan", fontWeight = FontWeight.Bold)
                Text(plan?.planContent ?: "No active plan")
                Text("Goal Type: ${plan?.goalType ?: "-"}")
            }
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = { vm.createPlan(1) }) { Text("Fat Loss") }
            OutlinedButton(onClick = { vm.createPlan(2) }) { Text("Muscle") }
            OutlinedButton(onClick = { vm.createPlan(3) }) { Text("Stress") }
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalAlignment = Alignment.CenterVertically) {
            OutlinedTextField(value = minutes, onValueChange = { minutes = it }, label = { Text("Minutes") }, modifier = Modifier.weight(1f))
            OutlinedTextField(value = calories, onValueChange = { calories = it }, label = { Text("Calories") }, modifier = Modifier.weight(1f))
            Button(onClick = { vm.checkIn(minutes.toIntOrNull() ?: 0, calories.toIntOrNull()) }) { Text("Check In") }
        }
        if (!err.isNullOrBlank()) Text("Error: $err")
    }
}

