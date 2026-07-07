package com.rql.healthmanage.view.ui.sport

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.rql.healthmanage.R
import com.rql.healthmanage.databinding.FragmentExerciseBinding
import com.rql.healthmanage.model.entity.SportPlanDto
import com.rql.healthmanage.model.entity.SportRecordDto
import com.rql.healthmanage.model.sport.displayTitle
import com.rql.healthmanage.view.ui.sport.components.SportPlanAdapter
import com.rql.healthmanage.view.ui.sport.components.SportReminderScheduler
import com.rql.healthmanage.view.ui.sport.components.renderSportCalendar
import com.rql.healthmanage.view.ui.sport.components.showSportCheckInDialog
import com.rql.healthmanage.view.ui.sport.components.showSportPlanFormDialog
import com.rql.healthmanage.viewmodel.sport.ExerciseViewModel
import com.rql.healthmanage.viewmodel.sport.SportPlanListMode

class ExerciseFragment : Fragment() {
    private var _binding: FragmentExerciseBinding? = null
    private val binding get() = _binding!!
    private lateinit var vm: ExerciseViewModel
    private lateinit var planAdapter: SportPlanAdapter
    /** 与「运动计划」下拉项一一对应：null 表示全部计划 */
    private var recordFilterPlanChoices: List<Pair<Int?, String>> = emptyList()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentExerciseBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        vm = ViewModelProvider(this)[ExerciseViewModel::class.java]
        planAdapter = SportPlanAdapter(onEdit = { openPlanForm(it) }, onDelete = { confirmDelete(it) })
        binding.rvPlans.layoutManager = LinearLayoutManager(requireContext())
        binding.rvPlans.adapter = planAdapter
        binding.chipPlanFilter.setOnCheckedStateChangeListener { _, checkedIds ->
            val id = checkedIds.firstOrNull() ?: return@setOnCheckedStateChangeListener
            val mode = when (id) {
                binding.chipCompleted.id -> SportPlanListMode.COMPLETED
                binding.chipAll.id -> SportPlanListMode.ALL
                else -> SportPlanListMode.ONGOING
            }
            vm.setPlanListMode(mode)
        }

        vm.planListMode.observe(viewLifecycleOwner) { mode ->
            val targetId = when (mode) {
                SportPlanListMode.COMPLETED -> binding.chipCompleted.id
                SportPlanListMode.ALL -> binding.chipAll.id
                SportPlanListMode.ONGOING -> binding.chipOngoing.id
            }
            if (binding.chipPlanFilter.checkedChipId != targetId) {
                binding.chipPlanFilter.check(targetId)
            }
        }

        binding.btnAddPlan.setOnClickListener { openPlanForm(existing = null) }
        binding.btnCheckIn.setOnClickListener { openCheckInDialog() }

        binding.btnFilterApply.setOnClickListener { applyRecordFilters() }
        binding.btnFilterClear.setOnClickListener { clearRecordFiltersUi() }

        vm.plans.observe(viewLifecycleOwner) {
            planAdapter.submit(it)
            rebuildRecordPlanDropdown()
        }
        vm.ongoingPlans.observe(viewLifecycleOwner) {
            SportReminderScheduler.sync(requireContext(), it)
            rebuildRecordPlanDropdown()
        }
        vm.records.observe(viewLifecycleOwner) { rebuildRecordPlanDropdown() }
        vm.calendarRecords.observe(viewLifecycleOwner) { list ->
            renderSportCalendar(binding.calendarRow, list)
            binding.tvCalendarHint.text = if (vm.hasRecordFilters()) {
                "以下为筛选后的打卡分布（日历「✓」仅统计筛选结果）。"
            } else {
                "横向滑动查看；有「✓」表示当日有打卡记录。"
            }
            binding.tvFilteredRecords.text = formatFilteredRecords(list)
        }
        vm.progressPercent.observe(viewLifecycleOwner) { pct ->
            binding.progressCheckIn.setProgressCompat(pct, true)
        }
        vm.progressHint.observe(viewLifecycleOwner) { binding.tvProgressLabel.text = it }
        vm.error.observe(viewLifecycleOwner) { msg ->
            if (!msg.isNullOrBlank()) {
                Toast.makeText(requireContext(), msg, Toast.LENGTH_SHORT).show()
                vm.clearError()
            }
        }
        vm.info.observe(viewLifecycleOwner) { msg ->
            if (!msg.isNullOrBlank()) {
                Toast.makeText(requireContext(), msg, Toast.LENGTH_SHORT).show()
                vm.consumeInfo()
            }
        }
        vm.planCreatedAi.observe(viewLifecycleOwner) { text ->
            if (!text.isNullOrBlank()) {
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("计划说明与适配性（AI）")
                    .setMessage(text)
                    .setPositiveButton("好的", null)
                    .show()
                vm.consumePlanCreatedAi()
            }
        }
        vm.checkInAiSummary.observe(viewLifecycleOwner) { text ->
            if (!text.isNullOrBlank()) {
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("运动反馈与阶段评价")
                    .setMessage(text)
                    .setPositiveButton("好的", null)
                    .show()
                vm.consumeCheckInAi()
            }
        }
        vm.highIntensityFollowUp.observe(viewLifecycleOwner) { ui ->
            if (ui != null) {
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("高强度运动提醒")
                    .setMessage(
                        "「${ui.planTitle}」强度较高。\n\n建议您在短时间内补充录入一次健康数据（身高、体重、血糖、血压、血脂），便于评估身体反应。\n\n是否需要前往「健康数据」页录入？"
                    )
                    .setNegativeButton("稍后", null)
                    .setPositiveButton("去录入") { _, _ ->
                        requireActivity().findViewById<BottomNavigationView>(R.id.bottom_nav)?.selectedItemId = R.id.nav_health
                    }
                    .setNeutralButton("修改计划") { _, _ ->
                        val plan = vm.findPlanForEdit(ui.planId)
                        if (plan != null) openPlanForm(existing = plan)
                    }
                    .show()
                vm.consumeHighIntensityFollowUp()
            }
        }
        vm.missedCheckInReminder.observe(viewLifecycleOwner) { days ->
            if (days != null) {
                MaterialAlertDialogBuilder(requireContext())
                    .setTitle("打卡提醒")
                    .setMessage("您已经 $days 天未打卡。可通过“今日/补打卡”补录历史日期，帮助保持连续记录。")
                    .setNegativeButton("稍后", null)
                    .setPositiveButton("去补打卡") { _, _ -> openCheckInDialog() }
                    .show()
                vm.consumeMissedCheckInReminder()
            }
        }
        vm.refresh()
    }

    private fun rebuildRecordPlanDropdown() {
        val merged = (vm.ongoingPlans.value.orEmpty() + vm.plans.value.orEmpty()).distinctBy { it.id }.sortedBy { it.id }
        val knownIds = merged.map { it.id }.toSet()
        val orphanIds = vm.records.value.orEmpty().map { it.planId }.distinct().filter { it !in knownIds }.sorted()
        val choices = mutableListOf<Pair<Int?, String>>()
        choices += null to "全部计划"
        merged.forEach { choices += it.id to it.displayTitle() }
        orphanIds.forEach { pid -> choices += pid to "计划 #$pid" }
        recordFilterPlanChoices = choices
        val labels = choices.map { it.second }
        val act = binding.actFilterPlan
        act.setAdapter(ArrayAdapter(requireContext(), android.R.layout.simple_list_item_1, labels))
        if (act.text.isNullOrBlank()) {
            act.setText(labels.firstOrNull().orEmpty(), false)
        }
    }

    private fun applyRecordFilters() {
        val label = binding.actFilterPlan.text?.toString()?.trim().orEmpty()
        val planId = recordFilterPlanChoices.firstOrNull { it.second == label }?.first
        vm.setRecordFilterPlanId(planId)
        vm.setRecordFilterDateRange(
            binding.etFilterStart.text?.toString(),
            binding.etFilterEnd.text?.toString()
        )
        Toast.makeText(requireContext(), "已应用筛选", Toast.LENGTH_SHORT).show()
    }

    private fun clearRecordFiltersUi() {
        binding.actFilterPlan.setText("全部计划", false)
        binding.etFilterStart.text?.clear()
        binding.etFilterEnd.text?.clear()
        vm.clearRecordFilters()
        Toast.makeText(requireContext(), "已清除筛选", Toast.LENGTH_SHORT).show()
    }

    private fun formatFilteredRecords(list: List<SportRecordDto>): String {
        if (list.isEmpty()) return if (vm.hasRecordFilters()) "筛选结果：暂无打卡记录。" else "暂无打卡记录。"
        return "打卡时间列表：\n" + list.joinToString("\n") { rec ->
            val title = vm.findPlanForEdit(rec.planId)?.displayTitle() ?: "计划 #${rec.planId}"
            val cal = rec.calories?.let { "，${it} 千卡" } ?: ""
            "${rec.recordDate}  ·  $title  ·  ${rec.actualDuration} 分钟$cal"
        }
    }

    private fun confirmDelete(plan: SportPlanDto) {
        MaterialAlertDialogBuilder(requireContext())
            .setTitle("删除计划")
            .setMessage("确定删除「${plan.displayTitle()}」吗？")
            .setNegativeButton("取消", null)
            .setPositiveButton("删除") { _, _ -> vm.deletePlan(plan.id) }
            .show()
    }

    private fun openPlanForm(existing: SportPlanDto?) {
        showSportPlanFormDialog(existing) { form ->
            if (existing == null) vm.createPlan(form) else vm.updatePlan(existing.id, form)
        }
    }

    private fun openCheckInDialog() {
        showSportCheckInDialog(vm.ongoingPlans.value.orEmpty(), vm.recentWeightKg.value) { plan, minutes, calories, recordDate ->
            vm.checkIn(plan.id, minutes, calories, recordDate)
        }
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }
}
