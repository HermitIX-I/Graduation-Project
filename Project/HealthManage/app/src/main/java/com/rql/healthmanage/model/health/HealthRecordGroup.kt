package com.rql.healthmanage.model.health

import com.rql.healthmanage.model.entity.HealthDataItemDto
import com.rql.healthmanage.model.entity.HealthDataRequestDto
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

data class HealthRecordGroup(
    val recordTime: String,
    val items: List<HealthDataItemDto>,
    val summary: String
)

fun List<HealthDataItemDto>.groupedByRecordTime(): List<HealthRecordGroup> {
    return this
        .groupBy { it.recordTime.toString() }
        .toSortedMap(compareByDescending { it })
        .map { (recordTime, groupItems) ->
            val sortedItems = groupItems.sortedBy { it.dataType }
            HealthRecordGroup(
                recordTime = recordTime,
                items = sortedItems,
                summary = formatHealthDataSummary(
                    sortedItems.map { item ->
                        HealthDataRequestDto(
                            dataType = item.dataType,
                            height = item.height?.toDouble(),
                            weight = item.weight?.toDouble(),
                            systolic = item.systolic,
                            diastolic = item.diastolic,
                            fastingGlucose = item.fastingGlucose?.toDouble(),
                            totalCholesterol = item.totalCholesterol?.toDouble(),
                            recordTime = recordTime
                        )
                    }
                )
            )
        }
}

fun formatHealthDataSummary(requests: List<HealthDataRequestDto>): String {
    return requests.sortedBy { it.dataType }.joinToString("；") { request ->
        when (request.dataType) {
            1 -> "身高${request.height}cm，体重${request.weight}kg"
            2 -> "血压${request.systolic}/${request.diastolic}mmHg"
            3 -> "空腹血糖${request.fastingGlucose}mmol/L"
            else -> "总胆固醇${request.totalCholesterol}mmol/L"
        }
    }
}

data class HealthComparison(
    val currentLabel: String,
    val previousLabel: String,
    val weightChangeRate: Double?,
    val systolicChangeRate: Double?,
    val glucoseChangeRate: Double?,
    val cholesterolChangeRate: Double?
)

fun List<HealthRecordGroup>.buildThirtyDayComparison(nowMs: Long = System.currentTimeMillis()): HealthComparison? {
    if (isEmpty()) return null
    val dayMs = 24L * 60L * 60L * 1000L
    val currentStart = nowMs - 30L * dayMs
    val previousStart = nowMs - 60L * dayMs
    val previousEnd = currentStart
    val current = filterByRange(currentStart, nowMs)
    val previous = filterByRange(previousStart, previousEnd)
    if (current.isEmpty() || previous.isEmpty()) return null
    return HealthComparison(
        currentLabel = "近30天",
        previousLabel = "前30天",
        weightChangeRate = current.avgMetric { if (it.dataType == 1) it.weight?.toDouble() else null }.changeRate(previous.avgMetric { if (it.dataType == 1) it.weight?.toDouble() else null }),
        systolicChangeRate = current.avgMetric { if (it.dataType == 2) it.systolic?.toDouble() else null }.changeRate(previous.avgMetric { if (it.dataType == 2) it.systolic?.toDouble() else null }),
        glucoseChangeRate = current.avgMetric { if (it.dataType == 3) it.fastingGlucose?.toDouble() else null }.changeRate(previous.avgMetric { if (it.dataType == 3) it.fastingGlucose?.toDouble() else null }),
        cholesterolChangeRate = current.avgMetric { if (it.dataType == 4) it.totalCholesterol?.toDouble() else null }.changeRate(previous.avgMetric { if (it.dataType == 4) it.totalCholesterol?.toDouble() else null })
    )
}

private fun List<HealthRecordGroup>.filterByRange(start: Long, end: Long): List<HealthRecordGroup> {
    return filter { group ->
        val ts = group.recordTime.toEpochMillisSafe() ?: return@filter false
        ts in start until end
    }
}

private fun List<HealthRecordGroup>.avgMetric(selector: (HealthDataItemDto) -> Double?): Double? {
    val values = flatMap { g -> g.items.mapNotNull(selector) }
    if (values.isEmpty()) return null
    return values.average()
}

private fun Double?.changeRate(previous: Double?): Double? {
    val c = this ?: return null
    val p = previous ?: return null
    if (kotlin.math.abs(p) < 1e-6) return null
    return ((c - p) / p) * 100.0
}

private fun String.toEpochMillisSafe(): Long? {
    val patterns = listOf(
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd HH:mm",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd"
    )
    for (pattern in patterns) {
        val date = runCatching {
            SimpleDateFormat(pattern, Locale.CHINA).parse(this)
        }.getOrNull()
        if (date != null) return date.time
    }
    return null
}

fun HealthComparison.toReadableText(): String {
    fun fmt(name: String, rate: Double?): String {
        if (rate == null) return "$name：数据不足"
        val arrow = if (rate > 0) "上升" else "下降"
        return "$name：$arrow ${"%.1f".format(Locale.CHINA, kotlin.math.abs(rate))}%"
    }
    return listOf(
        "$currentLabel 对比 $previousLabel",
        fmt("体重", weightChangeRate),
        fmt("收缩压", systolicChangeRate),
        fmt("空腹血糖", glucoseChangeRate),
        fmt("总胆固醇", cholesterolChangeRate)
    ).joinToString("\n")
}

fun List<HealthRecordGroup>.filterForExport(
    dataType: Int?,
    dateRange: Pair<String, String>?
): List<HealthRecordGroup> = filter { group ->
    val dataTypeOk = dataType?.let { type -> group.items.any { it.dataType == type } } ?: true
    val dateOk = dateRange?.let { (start, end) ->
        val date = group.recordTime.take(10)
        date >= start && date <= end
    } ?: true
    dateOk && dataTypeOk
}

fun List<HealthRecordGroup>.buildArchiveReportText(): String {
    if (isEmpty()) return "暂无健康档案数据。"
    val lines = mutableListOf<String>()
    lines.add("健康档案导出")
    lines.add("导出时间：${SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA).format(Date())}")
    lines.add("记录组数：$size")
    lines.add("")
    forEachIndexed { idx, group ->
        lines.add("${idx + 1}. 记录时间：${group.recordTime}")
        group.items.forEach { item ->
            val content = when (item.dataType) {
                1 -> "身高 ${item.height ?: "-"} cm，体重 ${item.weight ?: "-"} kg"
                2 -> "血压 ${item.systolic ?: "-"} / ${item.diastolic ?: "-"} mmHg"
                3 -> "空腹血糖 ${item.fastingGlucose ?: "-"} mmol/L"
                else -> "总胆固醇 ${item.totalCholesterol ?: "-"} mmol/L"
            }
            lines.add("   - $content")
        }
    }
    return lines.joinToString("\n")
}
