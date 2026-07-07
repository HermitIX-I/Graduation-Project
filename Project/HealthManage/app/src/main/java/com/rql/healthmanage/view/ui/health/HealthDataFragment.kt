package com.rql.healthmanage.view.ui.health

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.core.content.FileProvider
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.button.MaterialButtonToggleGroup
import com.rql.healthmanage.databinding.FragmentHealthDataBinding
import com.rql.healthmanage.model.entity.HealthDataRequestDto
import com.rql.healthmanage.model.health.buildThirtyDayComparison
import com.rql.healthmanage.model.health.filterForExport
import com.rql.healthmanage.model.health.groupedByRecordTime
import com.rql.healthmanage.model.health.toReadableText
import com.rql.healthmanage.util.HealthArchivePdfExporter
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import android.content.Intent
import com.rql.healthmanage.view.ui.health.components.HealthAiDialogController
import com.rql.healthmanage.view.ui.health.components.HealthRecordGroupAdapter
import com.rql.healthmanage.view.ui.health.components.HealthTrendChartController
import com.rql.healthmanage.view.ui.health.components.showHealthDataEntryDialog
import com.rql.healthmanage.viewmodel.health.HealthDataViewModel
import java.util.Calendar
import java.util.Locale

class HealthDataFragment : Fragment() {
    private var _binding: FragmentHealthDataBinding? = null
    private val binding get() = _binding!!
    private lateinit var vm: HealthDataViewModel
    private lateinit var adapter: HealthRecordGroupAdapter
    private lateinit var chartController: HealthTrendChartController
    private lateinit var aiDialogController: HealthAiDialogController
    private var formDialog: AlertDialog? = null
    private var pendingAiSummary: String? = null
    private var pendingAiRecordTime: String? = null
    private var allGroups = emptyList<com.rql.healthmanage.model.health.HealthRecordGroup>()
    private var selectedDateRange: Pair<String, String>? = null
    private var selectedDataType: Int? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentHealthDataBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        vm = ViewModelProvider(this)[HealthDataViewModel::class.java]
        chartController = HealthTrendChartController(binding.chart, this)
        aiDialogController = HealthAiDialogController(this, vm)
        chartController.configure()

        binding.recycler.layoutManager = LinearLayoutManager(requireContext())
        adapter = HealthRecordGroupAdapter(
            onDeleteGroup = { group -> group.items.forEach { vm.delete(it) } },
            onAskAi = { group -> aiDialogController.open(group.summary, group.recordTime, autoRequest = true) },
            onEditGroup = { group -> showEditDataForm(group) }
        )
        binding.recycler.adapter = adapter

        binding.fabAdd.setOnClickListener { showHealthDataForm(force = false) }
        binding.btnCompare.setOnClickListener { showThirtyDayComparison() }
        binding.btnExportShare.setOnClickListener { exportAndShareArchive() }
        binding.btnFilterDate.setOnClickListener { showDateRangeFilterDialog() }
        binding.btnRange7d.setOnClickListener { applyQuickRange(days = 7) }
        binding.btnRange30d.setOnClickListener { applyQuickRange(days = 30) }
        binding.btnResetFilter.setOnClickListener { resetFilters() }
        binding.toggleDataType.check(binding.btnTypeAll.id)
        binding.toggleDataType.addOnButtonCheckedListener { _: MaterialButtonToggleGroup, checkedId: Int, isChecked: Boolean ->
            if (!isChecked) return@addOnButtonCheckedListener
            selectedDataType = when (checkedId) {
                binding.btnTypeBody.id -> 1
                binding.btnTypeBp.id -> 2
                binding.btnTypeGlucose.id -> 3
                binding.btnTypeLipid.id -> 4
                else -> null
            }
            applyFilters()
        }
        vm.healthDataListFetchCompleted.observe(viewLifecycleOwner) { completed ->
            if (completed == true) {
                applyFilters()
            }
        }
        vm.records.observe(viewLifecycleOwner) { list ->
            allGroups = list.groupedByRecordTime()
            applyFilters()
        }
        vm.error.observe(viewLifecycleOwner) { message ->
            if (!message.isNullOrBlank()) {
                Toast.makeText(requireContext(), message, Toast.LENGTH_SHORT).show()
                vm.clearError()
            }
        }
        vm.requireInitialInput.observe(viewLifecycleOwner) { required ->
            val noServerRecords = vm.records.value.orEmpty().isEmpty()
            if (required && noServerRecords && formDialog?.isShowing != true) {
                showHealthDataForm(force = true)
            }
        }
        vm.saveSucceeded.observe(viewLifecycleOwner) { saved ->
            if (saved) {
                formDialog?.dismiss()
                vm.clearSaveState()
                if (!pendingAiSummary.isNullOrBlank() && !pendingAiRecordTime.isNullOrBlank()) {
                    aiDialogController.open(pendingAiSummary!!, pendingAiRecordTime!!, autoRequest = true)
                }
                pendingAiSummary = null
                pendingAiRecordTime = null
            }
        }
        vm.aiReply.observe(viewLifecycleOwner) { reply ->
            if (!reply.isNullOrBlank()) {
                aiDialogController.showAiReply(reply)
                vm.clearAiReply()
            }
        }
        vm.loadAll()
    }

    override fun onDestroyView() {
        formDialog?.dismiss()
        formDialog = null
        aiDialogController.dismiss()
        _binding = null
        super.onDestroyView()
    }

    private fun showHealthDataForm(force: Boolean) {
        if (formDialog?.isShowing == true) return
        formDialog = showHealthDataEntryDialog(force = force) { stamped, summary, timestamp ->
            pendingAiSummary = summary
            pendingAiRecordTime = timestamp
            vm.addBatch(stamped)
        }
    }

    private fun showEditDataForm(group: com.rql.healthmanage.model.health.HealthRecordGroup) {
        if (formDialog?.isShowing == true) return
        val initial = group.items.map {
            HealthDataRequestDto(
                dataType = it.dataType,
                height = it.height,
                weight = it.weight,
                systolic = it.systolic,
                diastolic = it.diastolic,
                fastingGlucose = it.fastingGlucose,
                totalCholesterol = it.totalCholesterol
            )
        }
        formDialog = showHealthDataEntryDialog(
            force = false,
            initialValues = initial,
            dialogTitle = "编辑健康数据",
            fixedRecordTime = group.recordTime
        ) { stamped, _, _ ->
            vm.replaceGroup(group.items, stamped)
        }
    }

    private fun showThirtyDayComparison() {
        val startA = android.widget.EditText(requireContext()).apply { hint = "时段A开始（如 2026-5-15）" }
        val endA = android.widget.EditText(requireContext()).apply { hint = "时段A结束" }
        val startB = android.widget.EditText(requireContext()).apply { hint = "时段B开始" }
        val endB = android.widget.EditText(requireContext()).apply { hint = "时段B结束" }
        val container = android.widget.LinearLayout(requireContext()).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            setPadding(40, 20, 40, 0)
            addView(startA); addView(endA); addView(startB); addView(endB)
        }
        AlertDialog.Builder(requireContext())
            .setTitle("对比分析（双时段）")
            .setMessage(
                "任选两个日期区间（例如「今年3月」和「今年4月」），在同一幅图里用两条线分别画出各指标在两段时期内的走势，并计算两段平均值的升降比例，便于看阶段变化。"
            )
            .setView(container)
            .setPositiveButton("开始对比") { _, _ ->
                val aStart = startA.text?.toString()?.trim().orEmpty()
                val aEnd = endA.text?.toString()?.trim().orEmpty()
                val bStart = startB.text?.toString()?.trim().orEmpty()
                val bEnd = endB.text?.toString()?.trim().orEmpty()
                val ar = parseNormalizedDateRange(aStart, aEnd)
                val br = parseNormalizedDateRange(bStart, bEnd)
                if (ar == null || br == null) {
                    Toast.makeText(
                        requireContext(),
                        "请输入合法日期区间，支持 2026-5-15 或 2026-05-15",
                        Toast.LENGTH_SHORT
                    ).show()
                    return@setPositiveButton
                }
                val (aStartN, aEndN) = ar
                val (bStartN, bEndN) = br
                val rangeA = allGroups.filter { g ->
                    val d = g.recordTime.take(10)
                    d >= aStartN && d <= aEndN
                }
                val rangeB = allGroups.filter { g ->
                    val d = g.recordTime.take(10)
                    d >= bStartN && d <= bEndN
                }
                if (rangeA.isEmpty() || rangeB.isEmpty()) {
                    Toast.makeText(requireContext(), "两个时间段都需要有数据", Toast.LENGTH_SHORT).show()
                    return@setPositiveButton
                }
                val chartKeyword = selectedDataTypeKeyword()
                chartController.renderCompareByKeyword(
                    rangeA,
                    rangeB,
                    vm.records.value.orEmpty(),
                    chartKeyword,
                    "时段A",
                    "时段B"
                )
                val result = buildRangeComparisonResult(rangeA, rangeB, aStartN, aEndN, bStartN, bEndN)
                AlertDialog.Builder(requireContext())
                    .setTitle("对比结果")
                    .setMessage(result)
                    .setPositiveButton("知道了", null)
                    .show()
            }
            .setNegativeButton("取消", null)
            .show()
    }

    private fun exportAndShareArchive() {
        val groups = allGroups.filterForExport(selectedDataType, selectedDateRange)
        if (groups.isEmpty()) {
            Toast.makeText(requireContext(), "当前筛选条件下暂无数据可导出", Toast.LENGTH_SHORT).show()
            return
        }
        val filterDesc = buildExportFilterDescription()
        binding.btnExportShare.isEnabled = false
        lifecycleScope.launch {
            val file = runCatching {
                withContext(Dispatchers.Default) {
                    HealthArchivePdfExporter.exportToCacheFile(requireContext(), groups, filterDesc)
                }
            }.getOrElse {
                Toast.makeText(requireContext(), "PDF 生成失败：${it.message}", Toast.LENGTH_SHORT).show()
                binding.btnExportShare.isEnabled = true
                return@launch
            }
            binding.btnExportShare.isEnabled = true
            val uri = FileProvider.getUriForFile(
                requireContext(),
                "${requireContext().packageName}.fileprovider",
                file
            )
            val sendIntent = Intent(Intent.ACTION_SEND).apply {
                type = "application/pdf"
                putExtra(Intent.EXTRA_STREAM, uri)
                putExtra(Intent.EXTRA_SUBJECT, "健康数据档案")
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            startActivity(Intent.createChooser(sendIntent, "导出 PDF"))
        }
    }

    private fun buildExportFilterDescription(): String {
        val parts = mutableListOf<String>()
        selectedDataType?.let { type ->
            val label = when (type) {
                1 -> "体测"
                2 -> "血压"
                3 -> "血糖"
                4 -> "血脂"
                else -> "全部"
            }
            parts += "类型：$label"
        }
        selectedDateRange?.let { (start, end) ->
            parts += "日期：$start 至 $end"
        }
        return if (parts.isEmpty()) "全部记录" else parts.joinToString("；")
    }

    private fun showDateRangeFilterDialog() {
        val startInput = android.widget.EditText(requireContext()).apply {
            hint = "开始日期（如 2026-5-15）"
            setText(selectedDateRange?.first.orEmpty())
        }
        val endInput = android.widget.EditText(requireContext()).apply {
            hint = "结束日期"
            setText(selectedDateRange?.second.orEmpty())
        }
        val container = android.widget.LinearLayout(requireContext()).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            setPadding(40, 20, 40, 0)
            addView(startInput)
            addView(endInput)
        }
        AlertDialog.Builder(requireContext())
            .setTitle("日期筛选")
            .setView(container)
            .setPositiveButton("应用") { _, _ ->
                val start = startInput.text?.toString()?.trim().orEmpty()
                val end = endInput.text?.toString()?.trim().orEmpty()
                if (start.isBlank() && end.isBlank()) {
                    selectedDateRange = null
                    applyFilters()
                    return@setPositiveButton
                }
                val pair = parseNormalizedDateRange(start, end)
                if (pair == null) {
                    Toast.makeText(
                        requireContext(),
                        "请输入合法起止日期，支持 2026-5-15 或 2026-05-15",
                        Toast.LENGTH_SHORT
                    ).show()
                    return@setPositiveButton
                }
                selectedDateRange = pair
                applyFilters()
            }
            .setNegativeButton("取消", null)
            .show()
    }

    private fun resetFilters() {
        selectedDateRange = null
        selectedDataType = null
        binding.toggleDataType.check(binding.btnTypeAll.id)
        applyFilters()
    }

    private fun applyQuickRange(days: Int) {
        val cal = java.util.Calendar.getInstance()
        val end = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.CHINA).format(cal.time)
        cal.add(java.util.Calendar.DAY_OF_MONTH, -(days - 1))
        val start = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.CHINA).format(cal.time)
        selectedDateRange = start to end
        applyFilters()
    }

    private fun applyFilters() {
        val filtered = allGroups.filterForExport(selectedDataType, selectedDateRange)
        adapter.submitList(filtered)
        val filteredCount = filtered.sumOf { it.items.size }
        binding.tvLatest.text = "健康数据共 ${filtered.size} 组，记录 ${filteredCount} 条"
        if (filtered.isEmpty()) binding.tvLatest.append("，暂无记录")
        // 仅 Chip 决定趋势图类型；「全部」下始终综合评分。
        val chartKeyword = selectedDataTypeKeyword()
        val flatForChart = flatRecordsForTrendChart(vm.records.value.orEmpty(), filtered)
        chartController.renderByKeyword(
            groups = filtered,
            allFlatItems = flatForChart,
            listFetchCompleted = vm.healthDataListFetchCompleted.value == true,
            keyword = chartKeyword
        )
    }

    /**
     * 趋势图用的扁平数据：与当前列表 [filteredGroups] 的「日期」对齐（按日期聚合展示时，
     * 若仍用 recordTime 逐条匹配会漏掉同日期的血压/血糖行，导致折线无数据）。
     * 日期范围筛选仍作用于每条记录。
     */
    private fun flatRecordsForTrendChart(
        all: List<com.rql.healthmanage.model.entity.HealthDataItemDto>,
        filteredGroups: List<com.rql.healthmanage.model.health.HealthRecordGroup>
    ): List<com.rql.healthmanage.model.entity.HealthDataItemDto> {
        if (filteredGroups.isEmpty()) return emptyList()
        val allowedDays = filteredGroups.map { it.recordTime.take(10) }.toSet()
        return all.filter { item ->
            val date = item.recordTime.take(10)
            val inListDays = date in allowedDays
            val dateOk = selectedDateRange?.let { (start, end) ->
                date >= start && date <= end
            } ?: true
            inListDays && dateOk
        }
    }

    private fun selectedDataTypeKeyword(): String? = when (selectedDataType) {
        1 -> "体重"
        2 -> "血压"
        3 -> "血糖"
        4 -> "血脂"
        else -> null
    }

    /**
     * 将用户输入的 `yyyy-M-d` / `yyyy-MM-dd` 等规范为 `yyyy-MM-dd`，并与服务端 `recordTime` 前 10 位对齐比较。
     */
    private fun normalizeUserDateInput(raw: String): String? {
        val s = raw.trim()
        val m = Regex("""^(\d{4})-(\d{1,2})-(\d{1,2})$""").matchEntire(s) ?: return null
        val y = m.groupValues[1].toIntOrNull() ?: return null
        val mo = m.groupValues[2].toIntOrNull() ?: return null
        val day = m.groupValues[3].toIntOrNull() ?: return null
        if (mo !in 1..12 || day !in 1..31) return null
        val cal = Calendar.getInstance(Locale.US)
        cal.isLenient = false
        cal.clear()
        cal.set(Calendar.YEAR, y)
        cal.set(Calendar.MONTH, mo - 1)
        cal.set(Calendar.DAY_OF_MONTH, day)
        try {
            cal.timeInMillis
        } catch (_: IllegalArgumentException) {
            return null
        }
        if (cal.get(Calendar.YEAR) != y || cal.get(Calendar.MONTH) != mo - 1 || cal.get(Calendar.DAY_OF_MONTH) != day) {
            return null
        }
        return String.format(Locale.US, "%04d-%02d-%02d", y, mo, day)
    }

    private fun parseNormalizedDateRange(start: String, end: String): Pair<String, String>? {
        val s = normalizeUserDateInput(start) ?: return null
        val e = normalizeUserDateInput(end) ?: return null
        if (s > e) return null
        return s to e
    }

    private fun buildRangeComparisonResult(
        rangeA: List<com.rql.healthmanage.model.health.HealthRecordGroup>,
        rangeB: List<com.rql.healthmanage.model.health.HealthRecordGroup>,
        aStart: String,
        aEnd: String,
        bStart: String,
        bEnd: String
    ): String {
        val a = averageMetrics(rangeA)
        val b = averageMetrics(rangeB)
        fun rate(aVal: Double?, bVal: Double?): String {
            if (aVal == null || bVal == null || kotlin.math.abs(bVal) < 1e-6) return "数据不足"
            val pct = (aVal - bVal) / bVal * 100.0
            val dir = if (pct >= 0) "上升" else "下降"
            return "$dir ${"%.1f".format(java.util.Locale.CHINA, kotlin.math.abs(pct))}%"
        }
        return buildString {
            append("时段A：$aStart ~ $aEnd\n")
            append("时段B：$bStart ~ $bEnd\n\n")
            append("体重变化率：${rate(a.weight, b.weight)}\n")
            append("收缩压变化率：${rate(a.systolic, b.systolic)}\n")
            append("空腹血糖变化率：${rate(a.glucose, b.glucose)}\n")
            append("总胆固醇变化率：${rate(a.cholesterol, b.cholesterol)}")
        }
    }

    private data class AvgMetrics(
        val weight: Double?,
        val systolic: Double?,
        val glucose: Double?,
        val cholesterol: Double?
    )

    private fun averageMetrics(groups: List<com.rql.healthmanage.model.health.HealthRecordGroup>): AvgMetrics {
        val items = groups.flatMap { it.items }
        fun avg(selector: (com.rql.healthmanage.model.entity.HealthDataItemDto) -> Double?): Double? {
            val values = items.mapNotNull(selector)
            return if (values.isEmpty()) null else values.average()
        }
        return AvgMetrics(
            weight = avg { if (it.dataType == 1) it.weight else null },
            systolic = avg { if (it.dataType == 2) it.systolic?.toDouble() else null },
            glucose = avg { if (it.dataType == 3) it.fastingGlucose else null },
            cholesterol = avg { if (it.dataType == 4) it.totalCholesterol else null }
        )
    }
}
