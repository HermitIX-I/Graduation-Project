package com.rql.healthmanage.view.ui.health.components

import android.content.Context
import androidx.fragment.app.Fragment
import com.github.mikephil.charting.charts.LineChart
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.data.LineData
import com.github.mikephil.charting.data.LineDataSet
import com.github.mikephil.charting.formatter.ValueFormatter
import android.graphics.Color
import com.google.android.material.color.MaterialColors
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.rql.healthmanage.R
import com.rql.healthmanage.model.entity.HealthDataItemDto
import com.rql.healthmanage.model.health.HealthRecordGroup
import java.util.Locale

private data class ChartSeries(val label: String, val entries: List<Entry>)

private fun denseYEntries(values: List<Float>): List<Entry> =
    values.mapIndexed { i, y -> Entry(i.toFloat(), y) }

/** 单项指标：每条 dataType 记录一个点；limitDays 非空时仅保留这些日期的记录（用于双时段对比）。 */
private fun metricRows(
    allFlat: List<HealthDataItemDto>,
    dataType: Int,
    limitDays: Set<String>?
): List<HealthDataItemDto> {
    return allFlat
        .filter { it.dataType == dataType }
        .filter { limitDays == null || it.recordTime.take(10) in limitDays }
        .sortedBy { it.recordTime }
}

/**
 * Configures the health trend [LineChart] and handles the empty-state dialog.
 */
class HealthTrendChartController(
    private val chart: LineChart,
    private val fragment: Fragment
) {
    private var noChartDialogShown = false

    fun configure() {
        chart.description.isEnabled = false
        chart.legend.isEnabled = false
        chart.setNoDataText("")
        chart.axisRight.isEnabled = false
        chart.isDragEnabled = true
        chart.setScaleEnabled(true)
        chart.setScaleYEnabled(false)
        chart.setPinchZoom(true)
        applyAxisLabelColors()
        chart.axisLeft.axisMinimum = 0f
        chart.axisLeft.axisMaximum = 100f
        chart.axisLeft.granularity = 10f
        chart.axisLeft.valueFormatter = object : ValueFormatter() {
            override fun getFormattedValue(value: Float): String = "${value.toInt()}分"
        }
        chart.xAxis.setDrawGridLines(false)
        chart.axisLeft.setDrawGridLines(true)
    }

    /** 纵轴刻度默认可能接近背景色，显式使用主题 onSurface 并留出左侧边距。 */
    private fun applyAxisLabelColors() {
        val ctx = fragment.requireContext()
        val c = MaterialColors.getColor(ctx, com.google.android.material.R.attr.colorOnSurface, Color.DKGRAY)
        chart.axisLeft.textColor = c
        chart.axisLeft.setDrawLabels(true)
        chart.axisLeft.textSize = 11f
        chart.xAxis.textColor = c
        chart.xAxis.setDrawLabels(true)
        chart.xAxis.textSize = 11f
        chart.xAxis.position = com.github.mikephil.charting.components.XAxis.XAxisPosition.BOTTOM
        chart.setExtraLeftOffset(14f)
        chart.setExtraBottomOffset(8f)
    }

    /** 血压、血糖、血脂在点旁显示数值（点不过密时）；血脂/胆固醇与血糖用小数格式。 */
    private fun shouldDrawPointValues(keyword: String?, entryCount: Int): Boolean {
        if (entryCount <= 0 || entryCount > 48) return false
        val k = keyword.orEmpty()
        return k.contains("血压", ignoreCase = true) ||
            k.contains("收缩压", ignoreCase = true) ||
            k.contains("舒张压", ignoreCase = true) ||
            k.contains("高压", ignoreCase = true) ||
            k.contains("低压", ignoreCase = true) ||
            k.contains("血糖", ignoreCase = true) ||
            k.contains("血脂", ignoreCase = true) ||
            k.contains("胆固醇", ignoreCase = true)
    }

    private fun styleLineDataSet(
        ds: LineDataSet,
        ctx: Context,
        entryCount: Int,
        orangeCompare: Boolean,
        drawValues: Boolean,
        keyword: String?
    ) {
        if (orangeCompare) {
            ds.color = ctx.getColor(android.R.color.holo_orange_dark)
            ds.setCircleColor(ctx.getColor(android.R.color.holo_orange_dark))
        } else {
            ds.color = ctx.getColor(R.color.health_primary)
            ds.setCircleColor(ctx.getColor(R.color.health_primary_dark))
        }
        ds.valueTextColor = ds.color
        ds.setDrawValues(drawValues)
        if (drawValues) {
            ds.valueTextSize = 9f
            val decimalChart = keyword?.contains("血糖", ignoreCase = true) == true ||
                keyword?.contains("血脂", ignoreCase = true) == true ||
                keyword?.contains("胆固醇", ignoreCase = true) == true
            ds.valueFormatter = object : ValueFormatter() {
                override fun getFormattedValue(value: Float): String =
                    if (decimalChart) String.format(Locale.US, "%.2f", value) else value.toInt().toString()
            }
        }
        ds.lineWidth = 2f
        val dense = entryCount > 48
        ds.circleRadius = if (dense) 2.2f else 4f
        ds.setDrawCircles(!dense || entryCount <= 120)
    }

    private fun applyChartData(dataSet: LineDataSet, ctx: Context, entryCount: Int, keyword: String?) {
        val drawVals = shouldDrawPointValues(keyword, entryCount)
        styleLineDataSet(dataSet, ctx, entryCount, orangeCompare = false, drawValues = drawVals, keyword = keyword)
        chart.legend.isEnabled = false
        chart.data = LineData(dataSet)
        chart.data?.notifyDataChanged()
        chart.notifyDataSetChanged()
        chart.fitScreen()
        if (entryCount > 24) {
            chart.setVisibleXRangeMaximum(32f)
        }
        chart.invalidate()
    }

    private fun applyChartDataCompare(a: LineDataSet, b: LineDataSet, ctx: Context, countA: Int, countB: Int, keyword: String?) {
        styleLineDataSet(a, ctx, countA, orangeCompare = false, drawValues = shouldDrawPointValues(keyword, countA), keyword = keyword)
        styleLineDataSet(b, ctx, countB, orangeCompare = true, drawValues = shouldDrawPointValues(keyword, countB), keyword = keyword)
        chart.legend.isEnabled = true
        chart.data = LineData(a, b)
        chart.data?.notifyDataChanged()
        chart.notifyDataSetChanged()
        chart.fitScreen()
        if (maxOf(countA, countB) > 24) {
            chart.setVisibleXRangeMaximum(32f)
        }
        chart.invalidate()
    }

    fun render(groups: List<HealthRecordGroup>, listFetchCompleted: Boolean) {
        if (groups.isNotEmpty()) {
            noChartDialogShown = false
            val sortedGroups = groups.reversed()
            val series = buildSeriesByKeyword(sortedGroups, emptyList(), null)
            val ctx = fragment.requireContext()
            val dataSet = LineDataSet(series.entries, series.label)
            applyAxisStyleByKeyword(null)
            applyChartData(dataSet, ctx, series.entries.size, keyword = null)
            return
        }
        chart.clear()
        if (listFetchCompleted && !noChartDialogShown && fragment.isAdded) {
            noChartDialogShown = true
            MaterialAlertDialogBuilder(fragment.requireContext())
                .setTitle("暂无图表数据")
                .setMessage("当前还没有健康数据，请先录入后再查看趋势图。")
                .setPositiveButton("知道了", null)
                .show()
        }
    }

    fun renderByKeyword(
        groups: List<HealthRecordGroup>,
        allFlatItems: List<HealthDataItemDto>,
        listFetchCompleted: Boolean,
        keyword: String?
    ) {
        if (groups.isNotEmpty() || usesFlatMetricSeries(keyword)) {
            noChartDialogShown = false
            val sortedGroups = groups.reversed()
            val series = buildSeriesByKeyword(sortedGroups, allFlatItems, keyword)
            val ctx = fragment.requireContext()
            val dataSet = LineDataSet(series.entries, series.label)
            applyAxisStyleByKeyword(keyword)
            applyChartData(dataSet, ctx, series.entries.size, keyword)
            return
        }
        render(groups, listFetchCompleted)
    }

    fun renderCompareByKeyword(
        rangeA: List<HealthRecordGroup>,
        rangeB: List<HealthRecordGroup>,
        allFlatItems: List<HealthDataItemDto>,
        keyword: String?,
        labelA: String,
        labelB: String
    ) {
        val sortedA = rangeA.reversed()
        val sortedB = rangeB.reversed()
        val daysA = rangeA.map { it.recordTime.take(10) }.toSet()
        val daysB = rangeB.map { it.recordTime.take(10) }.toSet()
        val seriesA = buildSeriesByKeyword(sortedA, allFlatItems, keyword, metricLimitDays = daysA)
        val seriesB = buildSeriesByKeyword(sortedB, allFlatItems, keyword, metricLimitDays = daysB)
        val ctx = fragment.requireContext()
        val dataSetA = LineDataSet(seriesA.entries, "${seriesA.label}-$labelA")
        val dataSetB = LineDataSet(seriesB.entries, "${seriesB.label}-$labelB")
        applyAxisStyleByKeyword(keyword)
        applyChartDataCompare(dataSetA, dataSetB, ctx, seriesA.entries.size, seriesB.entries.size, keyword)
    }

    /** 综合评分仍按「组」；单项指标用扁平记录，故无组时也可能要画指标图。 */
    private fun usesFlatMetricSeries(keyword: String?): Boolean {
        val k = keyword.orEmpty().trim()
        if (k.isBlank()) return false
        return k.contains("体重") || k.contains("身高") || k.contains("血压") || k.contains("收缩压") ||
            k.contains("高压") || k.contains("舒张压") || k.contains("低压") ||
            k.contains("血糖") || k.contains("血脂") || k.contains("胆固醇")
    }

    private fun buildSeriesByKeyword(
        sortedGroups: List<HealthRecordGroup>,
        allFlatItems: List<HealthDataItemDto>,
        keyword: String?,
        metricLimitDays: Set<String>? = null
    ): ChartSeries {
        val k = keyword.orEmpty().trim()
        return when {
            k.contains("体重", ignoreCase = true) -> {
                val ys = metricRows(allFlatItems, 1, metricLimitDays).mapNotNull { it.weight?.toFloat() }
                ChartSeries(label = "体重趋势(kg)", entries = denseYEntries(ys))
            }
            k.contains("身高", ignoreCase = true) -> {
                val ys = metricRows(allFlatItems, 1, metricLimitDays).mapNotNull { it.height?.toFloat() }
                ChartSeries(label = "身高趋势(cm)", entries = denseYEntries(ys))
            }
            k.contains("收缩压", ignoreCase = true) || k.contains("高压", ignoreCase = true) -> {
                val ys = metricRows(allFlatItems, 2, metricLimitDays).mapNotNull { it.systolic?.toFloat() }
                ChartSeries(label = "收缩压趋势(mmHg)", entries = denseYEntries(ys))
            }
            k.contains("舒张压", ignoreCase = true) || k.contains("低压", ignoreCase = true) -> {
                val ys = metricRows(allFlatItems, 2, metricLimitDays).mapNotNull { it.diastolic?.toFloat() }
                ChartSeries(label = "舒张压趋势(mmHg)", entries = denseYEntries(ys))
            }
            k.contains("血压", ignoreCase = true) -> {
                val ys = metricRows(allFlatItems, 2, metricLimitDays).mapNotNull { it.systolic?.toFloat() }
                ChartSeries(label = "收缩压趋势(mmHg)", entries = denseYEntries(ys))
            }
            k.contains("血糖", ignoreCase = true) -> {
                val ys = metricRows(allFlatItems, 3, metricLimitDays).mapNotNull { it.fastingGlucose?.toFloat() }
                ChartSeries(label = "空腹血糖趋势(mmol/L)", entries = denseYEntries(ys))
            }
            k.contains("血脂", ignoreCase = true) || k.contains("胆固醇", ignoreCase = true) -> {
                val ys = metricRows(allFlatItems, 4, metricLimitDays).mapNotNull { it.totalCholesterol?.toFloat() }
                ChartSeries(label = "总胆固醇趋势(mmol/L)", entries = denseYEntries(ys))
            }
            else -> ChartSeries(
                label = "综合健康评分趋势",
                entries = sortedGroups.mapIndexedNotNull { index, group ->
                    calculateCompositeHealthScore(group)?.let { Entry(index.toFloat(), it) }
                }
            )
        }
    }

    private fun applyAxisStyleByKeyword(keyword: String?) {
        applyAxisLabelColors()
        val k = keyword.orEmpty().trim()
        if (k.isBlank()) {
            chart.axisLeft.isGranularityEnabled = true
            chart.axisLeft.axisMinimum = 0f
            chart.axisLeft.axisMaximum = 100f
            chart.axisLeft.granularity = 10f
            chart.axisLeft.valueFormatter = object : ValueFormatter() {
                override fun getFormattedValue(value: Float): String = "${value.toInt()}分"
            }
            return
        }
        chart.axisLeft.resetAxisMinimum()
        chart.axisLeft.resetAxisMaximum()
        chart.axisLeft.isGranularityEnabled = true
        if (k.contains("血糖", ignoreCase = true)) {
            chart.axisLeft.granularity = 0.1f
            chart.axisLeft.valueFormatter = object : ValueFormatter() {
                override fun getFormattedValue(value: Float): String =
                    String.format(Locale.US, "%.1f", value)
            }
        } else if (k.contains("血脂", ignoreCase = true) || k.contains("胆固醇", ignoreCase = true)) {
            chart.axisLeft.granularity = 0.1f
            chart.axisLeft.valueFormatter = object : ValueFormatter() {
                override fun getFormattedValue(value: Float): String =
                    String.format(Locale.US, "%.2f", value)
            }
        } else {
            chart.axisLeft.granularity = 1f
            chart.axisLeft.valueFormatter = object : ValueFormatter() {
                override fun getFormattedValue(value: Float): String = value.toInt().toString()
            }
        }
    }

    private fun calculateCompositeHealthScore(group: HealthRecordGroup): Float? {
        var weightedScoreSum = 0.0
        var weightSum = 0.0

        val body = group.items.firstOrNull { it.dataType == 1 }
        val height = body?.height
        val weight = body?.weight
        if (height != null && weight != null && height > 0.0) {
            val hMeter = height / 100.0
            val bmi = weight / (hMeter * hMeter)
            val bmiScore = piecewiseScore(
                value = bmi,
                normalMin = 18.5,
                normalMax = 23.9,
                hardMin = 14.0,
                hardMax = 35.0
            )
            weightedScoreSum += bmiScore * 0.30
            weightSum += 0.30
        }

        val bp = group.items.firstOrNull { it.dataType == 2 }
        if (bp?.systolic != null && bp.diastolic != null) {
            val systolicScore = piecewiseScore(
                value = bp.systolic.toDouble(),
                normalMin = 90.0,
                normalMax = 120.0,
                hardMin = 70.0,
                hardMax = 180.0
            )
            val diastolicScore = piecewiseScore(
                value = bp.diastolic.toDouble(),
                normalMin = 60.0,
                normalMax = 80.0,
                hardMin = 40.0,
                hardMax = 120.0
            )
            val bpScore = (systolicScore + diastolicScore) / 2.0
            weightedScoreSum += bpScore * 0.30
            weightSum += 0.30
        }

        val glucose = group.items.firstOrNull { it.dataType == 3 }?.fastingGlucose
        if (glucose != null) {
            val glucoseScore = piecewiseScore(
                value = glucose,
                normalMin = 3.9,
                normalMax = 6.1,
                hardMin = 2.5,
                hardMax = 16.0
            )
            weightedScoreSum += glucoseScore * 0.20
            weightSum += 0.20
        }

        val chol = group.items.firstOrNull { it.dataType == 4 }?.totalCholesterol
        if (chol != null) {
            val cholScore = piecewiseScore(
                value = chol,
                normalMin = 2.8,
                normalMax = 5.2,
                hardMin = 1.5,
                hardMax = 12.0
            )
            weightedScoreSum += cholScore * 0.20
            weightSum += 0.20
        }

        if (weightSum <= 0.0) return null
        return (weightedScoreSum / weightSum).toFloat().coerceIn(0f, 100f)
    }

    private fun piecewiseScore(
        value: Double,
        normalMin: Double,
        normalMax: Double,
        hardMin: Double,
        hardMax: Double
    ): Double {
        return when {
            value in normalMin..normalMax -> 100.0
            value < normalMin -> {
                val span = normalMin - hardMin
                val ratio = if (span <= 0) 0.0 else (normalMin - value) / span
                (100.0 - 90.0 * ratio).coerceIn(0.0, 100.0)
            }
            else -> {
                val span = hardMax - normalMax
                val ratio = if (span <= 0) 0.0 else (value - normalMax) / span
                (100.0 - 90.0 * ratio).coerceIn(0.0, 100.0)
            }
        }
    }
}
