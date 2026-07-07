package com.rql.healthmanage.view.ui.sport.components

import android.app.TimePickerDialog
import android.app.DatePickerDialog
import android.text.Editable
import android.text.TextWatcher
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.rql.healthmanage.databinding.DialogSportCheckinBinding
import com.rql.healthmanage.databinding.DialogSportPlanFormBinding
import com.rql.healthmanage.model.entity.SportPlanDto
import com.rql.healthmanage.model.sport.SportCalorieEstimator
import com.rql.healthmanage.model.sport.decodePayload
import com.rql.healthmanage.model.sport.displayTitle
import com.rql.healthmanage.model.sport.SportPlanFormState
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

private fun defaultRemindTime(): String {
    val now = Calendar.getInstance()
    return String.format("%02d:%02d", now.get(Calendar.HOUR_OF_DAY), now.get(Calendar.MINUTE))
}

fun Fragment.showSportPlanFormDialog(
    existing: SportPlanDto?,
    onSubmit: (SportPlanFormState) -> Unit
) {
    val dialogBinding = DialogSportPlanFormBinding.inflate(layoutInflater)
    val goals = listOf("减脂 (1)", "增肌 (2)", "缓解压力 (3)")
    dialogBinding.spinnerGoal.adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_dropdown_item, goals)

    val p = existing?.decodePayload()
    if (existing != null) {
        dialogBinding.etExerciseForm.setText(p?.exerciseForm ?: "")
        dialogBinding.etExerciseSchedule.setText(p?.exerciseSchedule ?: "")
        dialogBinding.etExerciseDetail.setText(p?.exerciseDetail ?: "")
        dialogBinding.etWeeklyFrequency.setText(existing.frequency.toString())
        dialogBinding.etExpectedMinutes.setText(existing.duration.toString())
        dialogBinding.switchRemind.isChecked = p?.remindEnabled == true
        dialogBinding.etRemindTime.setText(p?.remindTime ?: "20:00")
        dialogBinding.spinnerGoal.setSelection((existing.goalType - 1).coerceIn(0, 2))
    } else {
        dialogBinding.etWeeklyFrequency.setText("3")
        dialogBinding.etExpectedMinutes.setText("30")
        dialogBinding.switchRemind.isChecked = true
        dialogBinding.etRemindTime.setText(defaultRemindTime())
        dialogBinding.spinnerGoal.setSelection(0)
    }
    dialogBinding.etRemindTime.setOnClickListener {
        val parts = dialogBinding.etRemindTime.text?.toString().orEmpty().split(":")
        val h = parts.getOrNull(0)?.toIntOrNull()?.coerceIn(0, 23) ?: 20
        val m = parts.getOrNull(1)?.toIntOrNull()?.coerceIn(0, 59) ?: 0
        TimePickerDialog(requireContext(), { _, hour, minute ->
            dialogBinding.etRemindTime.setText(String.format("%02d:%02d", hour, minute))
        }, h, m, true).show()
    }
    dialogBinding.switchRemind.setOnCheckedChangeListener { _, checked ->
        dialogBinding.etRemindTime.isEnabled = checked
        if (checked && dialogBinding.etRemindTime.text.isNullOrBlank()) {
            dialogBinding.etRemindTime.setText(defaultRemindTime())
        }
    }
    dialogBinding.etRemindTime.isEnabled = dialogBinding.switchRemind.isChecked

    val dialog = MaterialAlertDialogBuilder(requireContext())
        .setTitle(if (existing == null) "添加运动计划" else "修改运动计划")
        .setView(dialogBinding.root)
        .setNegativeButton("取消", null)
        .setPositiveButton("保存", null)
        .create()

    dialog.setOnShowListener {
        dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
            val form = readSportForm(dialogBinding) ?: return@setOnClickListener
            onSubmit(form)
            dialog.dismiss()
        }
    }
    dialog.show()
}

fun Fragment.showSportCheckInDialog(
    plans: List<SportPlanDto>,
    recentWeightKg: Double?,
    onSubmit: (plan: SportPlanDto, minutes: Int, calories: Int?, recordDate: String) -> Unit
) {
    if (plans.isEmpty()) {
        Toast.makeText(requireContext(), "请先添加进行中的运动计划", Toast.LENGTH_SHORT).show()
        return
    }
    val checkBinding = DialogSportCheckinBinding.inflate(layoutInflater)
    val dateFmt = SimpleDateFormat("yyyy-MM-dd", Locale.CHINA)
    val labels = plans.map { it.displayTitle() }
    checkBinding.spinnerPlan.adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_dropdown_item, labels)
    checkBinding.etActualMinutes.setText(plans.first().duration.toString())
    checkBinding.etRecordDate.setText(dateFmt.format(Calendar.getInstance().time))
    checkBinding.etRecordDate.setOnClickListener {
        val cal = Calendar.getInstance()
        DatePickerDialog(
            requireContext(),
            { _, year, month, day ->
                val picked = Calendar.getInstance().apply { set(year, month, day) }
                checkBinding.etRecordDate.setText(dateFmt.format(picked.time))
            },
            cal.get(Calendar.YEAR),
            cal.get(Calendar.MONTH),
            cal.get(Calendar.DAY_OF_MONTH)
        ).show()
    }
    refreshCheckInEstimate(checkBinding, plans, recentWeightKg)
    checkBinding.spinnerPlan.setOnItemSelectedListener(object : android.widget.AdapterView.OnItemSelectedListener {
        override fun onItemSelected(parent: android.widget.AdapterView<*>?, view: android.view.View?, position: Int, id: Long) {
            refreshCheckInEstimate(checkBinding, plans, recentWeightKg)
        }
        override fun onNothingSelected(parent: android.widget.AdapterView<*>?) = Unit
    })
    checkBinding.etActualMinutes.addTextChangedListener(object : TextWatcher {
        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) = Unit
        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) = Unit
        override fun afterTextChanged(s: Editable?) {
            refreshCheckInEstimate(checkBinding, plans, recentWeightKg)
        }
    })

    val dialog = MaterialAlertDialogBuilder(requireContext())
        .setTitle("今日打卡")
        .setView(checkBinding.root)
        .setNegativeButton("取消", null)
        .setPositiveButton("打卡", null)
        .create()

    dialog.setOnShowListener {
        dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
            val idx = checkBinding.spinnerPlan.selectedItemPosition
            val plan = plans[idx]
            val mins = checkBinding.etActualMinutes.text?.toString()?.toIntOrNull()
            if (mins == null || mins < 1) {
                Toast.makeText(requireContext(), "请填写本次运动时长", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            val recordDate = checkBinding.etRecordDate.text?.toString()?.trim().orEmpty()
            if (!Regex("^\\d{4}-\\d{2}-\\d{2}$").matches(recordDate)) {
                Toast.makeText(requireContext(), "请选择有效打卡日期", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            val cal = SportCalorieEstimator.estimate(plan, mins, recentWeightKg).calories
            onSubmit(plan, mins, cal, recordDate)
            dialog.dismiss()
        }
    }
    dialog.show()
}

private fun refreshCheckInEstimate(checkBinding: DialogSportCheckinBinding, plans: List<SportPlanDto>, recentWeightKg: Double?) {
    val idx = checkBinding.spinnerPlan.selectedItemPosition.coerceIn(0, plans.lastIndex)
    val minutes = checkBinding.etActualMinutes.text?.toString()?.toIntOrNull()
    if (minutes == null || minutes < 1) {
        checkBinding.etCalories.setText("")
        checkBinding.tvFeedbackHint.text = "填写时长后将显示运动反馈"
        return
    }
    val result = SportCalorieEstimator.estimate(plans[idx], minutes, recentWeightKg)
    checkBinding.etCalories.setText(result.calories.toString())
    checkBinding.tvFeedbackHint.text = result.feedback
}

private fun Fragment.readSportForm(b: DialogSportPlanFormBinding): SportPlanFormState? {
    val form = b.etExerciseForm.text?.toString()?.trim().orEmpty()
    val schedule = b.etExerciseSchedule.text?.toString()?.trim().orEmpty()
    val detail = b.etExerciseDetail.text?.toString()?.trim().orEmpty()
    val freq = b.etWeeklyFrequency.text?.toString()?.toIntOrNull()
    val minutes = b.etExpectedMinutes.text?.toString()?.toIntOrNull()
    if (form.isBlank() || schedule.isBlank() || detail.isBlank()) {
        Toast.makeText(requireContext(), "请填写运动形式、规划与内容", Toast.LENGTH_SHORT).show()
        return null
    }
    if (freq == null || freq < 1 || minutes == null || minutes < 5) {
        Toast.makeText(requireContext(), "请填写合理的每周次数与单次时长", Toast.LENGTH_SHORT).show()
        return null
    }
    val remindTime = b.etRemindTime.text?.toString()?.trim().orEmpty()
    if (b.switchRemind.isChecked && !Regex("^([01]\\d|2[0-3]):[0-5]\\d$").matches(remindTime)) {
        Toast.makeText(requireContext(), "提醒时间格式应为 HH:mm", Toast.LENGTH_SHORT).show()
        return null
    }
    return SportPlanFormState(
        exerciseForm = form,
        exerciseSchedule = schedule,
        exerciseDetail = detail,
        weeklyFrequency = freq,
        expectedMinutesPerSession = minutes,
        remindEnabled = b.switchRemind.isChecked,
        remindTime = remindTime.takeIf { b.switchRemind.isChecked },
        goalCategory = b.spinnerGoal.selectedItemPosition + 1
    )
}
