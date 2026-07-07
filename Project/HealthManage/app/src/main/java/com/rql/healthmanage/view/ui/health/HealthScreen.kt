package com.rql.healthmanage.view.ui.health

import android.widget.Toast
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.lifecycle.viewmodel.compose.viewModel
import com.github.mikephil.charting.charts.LineChart
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.data.LineData
import com.github.mikephil.charting.data.LineDataSet
import com.rql.healthmanage.model.entity.HealthDataItemDto
import com.rql.healthmanage.model.entity.HealthDataRequestDto
import com.rql.healthmanage.viewmodel.health.HealthDataViewModel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HealthScreenPage(vm: HealthDataViewModel = viewModel()) {
    val ctx = LocalContext.current
    var height by rememberSaveable { mutableStateOf("") }
    var weight by rememberSaveable { mutableStateOf("") }
    var systolic by rememberSaveable { mutableStateOf("") }
    var diastolic by rememberSaveable { mutableStateOf("") }
    var glucose by rememberSaveable { mutableStateOf("") }
    var cholesterol by rememberSaveable { mutableStateOf("") }
    val records by vm.records.observeAsState(emptyList())
    val syncStatus by vm.syncStatus.observeAsState("Synced")
    val err by vm.error.observeAsState()
    LaunchedEffect(Unit) { vm.loadAll() }

    Column(Modifier.fillMaxSize().padding(12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Card(Modifier.fillMaxWidth()) {
            Column(Modifier.padding(12.dp)) {
                Text("Sync status: $syncStatus")
                Text("Latest: ${records.firstOrNull()?.recordTime ?: "-"}")
            }
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedTextField(value = height, onValueChange = { height = it }, label = { Text("身高cm") }, modifier = Modifier.weight(1f))
            OutlinedTextField(value = weight, onValueChange = { weight = it }, label = { Text("体重kg") }, modifier = Modifier.weight(1f))
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedTextField(value = systolic, onValueChange = { systolic = it }, label = { Text("收缩压") }, modifier = Modifier.weight(1f))
            OutlinedTextField(value = diastolic, onValueChange = { diastolic = it }, label = { Text("舒张压") }, modifier = Modifier.weight(1f))
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedTextField(value = glucose, onValueChange = { glucose = it }, label = { Text("空腹血糖") }, modifier = Modifier.weight(1f))
            OutlinedTextField(value = cholesterol, onValueChange = { cholesterol = it }, label = { Text("总胆固醇") }, modifier = Modifier.weight(1f))
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = {
                val h = height.toDoubleOrNull()
                val w = weight.toDoubleOrNull()
                val sys = systolic.toIntOrNull()
                val dia = diastolic.toIntOrNull()
                val g = glucose.toDoubleOrNull()
                val c = cholesterol.toDoubleOrNull()
                if (h == null || w == null || sys == null || dia == null || g == null || c == null) {
                    Toast.makeText(ctx, "请完整填写六项后再提交", Toast.LENGTH_SHORT).show()
                    return@Button
                }
                val ts = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US).format(Date())
                vm.addBatch(
                    listOf(
                        HealthDataRequestDto(1, height = h, weight = w, recordTime = ts),
                        HealthDataRequestDto(2, systolic = sys, diastolic = dia, recordTime = ts),
                        HealthDataRequestDto(3, fastingGlucose = g, recordTime = ts),
                        HealthDataRequestDto(4, totalCholesterol = c, recordTime = ts)
                    )
                )
            }) { Text("Add Data") }
            OutlinedButton(onClick = { vm.syncPending() }) { Text("Sync Offline") }
        }
        HealthTrendChart(records, 1)
        Text("History", fontWeight = FontWeight.Bold)
        LazyColumn(verticalArrangement = Arrangement.spacedBy(6.dp)) {
            items(records) { item ->
                Card(Modifier.fillMaxWidth()) {
                    Row(Modifier.fillMaxWidth().padding(10.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text(item.recordTime)
                        OutlinedButton(onClick = { vm.delete(item) }) { Text("Delete") }
                    }
                }
            }
        }
        if (!err.isNullOrBlank()) Text("Error: $err")
    }
}

@Composable
private fun HealthTrendChart(records: List<HealthDataItemDto>, dataType: Int) {
    val sorted = records.sortedBy { it.recordTime }.takeLast(7)
    AndroidView(factory = { ctx -> LineChart(ctx) }, modifier = Modifier.fillMaxWidth().height(180.dp)) { chart ->
        val entries = sorted.mapIndexed { index, item ->
            val y = when (dataType) {
                1 -> item.weight?.toFloat() ?: 0f
                2 -> item.systolic?.toFloat() ?: 0f
                3 -> item.fastingGlucose?.toFloat() ?: 0f
                else -> item.totalCholesterol?.toFloat() ?: 0f
            }
            Entry(index.toFloat(), y)
        }
        val ds = LineDataSet(entries, "Last 7 days").apply {
            setDrawValues(false)
            lineWidth = 2f
            circleRadius = 4f
        }
        chart.data = LineData(ds)
        chart.description.isEnabled = false
        chart.invalidate()
    }
}
