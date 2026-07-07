package com.rql.healthmanage.view.ui.health.components

import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.rql.healthmanage.databinding.DialogHealthDataFormBinding
import com.rql.healthmanage.model.entity.HealthDataRequestDto
import com.rql.healthmanage.model.health.formatHealthDataSummary
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/** ISO-8601 local date-time without fractional seconds; compatible with API 24+. */
private fun nowIsoLocalDateTime(): String =
    SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US).format(Date())

/**
 * Shows the health data entry dialog; invokes [onSubmit] with ISO timestamp and text summary for AI follow-up.
 */
fun Fragment.showHealthDataEntryDialog(
    force: Boolean,
    initialValues: List<HealthDataRequestDto> = emptyList(),
    dialogTitle: String = "健康数据录入",
    fixedRecordTime: String? = null,
    onSubmit: (stamped: List<HealthDataRequestDto>, summary: String, isoTimestamp: String) -> Unit
): AlertDialog {
    val formBinding = DialogHealthDataFormBinding.inflate(layoutInflater)
    fillFormWithInitialValues(formBinding, initialValues)
    formBinding.tvFormTip.text = if (force) {
        "首次登录请一次性填写完整的身高体重、血压、血糖和血脂数据"
    } else if (initialValues.isNotEmpty()) {
        "请修改后保存（须保留六项齐全），系统将同步更新本组记录"
    } else {
        "每次保存须完整填写身高、体重、血压、空腹血糖与总胆固醇"
    }

    val builder = MaterialAlertDialogBuilder(requireContext())
        .setTitle(dialogTitle)
        .setView(formBinding.root)
        .setPositiveButton("保存", null)

    if (!force) {
        builder.setNegativeButton("取消", null)
    }

    return builder.create().apply {
        setCancelable(!force)
        setCanceledOnTouchOutside(!force)
        setOnShowListener {
            getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
                val requests = parseHealthDataRequestsFromForm(formBinding, force, requireContext()) ?: return@setOnClickListener
                val timestamp = fixedRecordTime ?: nowIsoLocalDateTime()
                val stamped = requests.map { it.copy(recordTime = timestamp) }
                val summary = formatHealthDataSummary(stamped)
                onSubmit(stamped, summary, timestamp)
            }
        }
        show()
    }
}

private fun fillFormWithInitialValues(
    binding: DialogHealthDataFormBinding,
    initialValues: List<HealthDataRequestDto>
) {
    initialValues.forEach { item ->
        when (item.dataType) {
            1 -> {
                binding.etHeight.setText(item.height?.toString().orEmpty())
                binding.etWeight.setText(item.weight?.toString().orEmpty())
            }
            2 -> {
                binding.etSystolic.setText(item.systolic?.toString().orEmpty())
                binding.etDiastolic.setText(item.diastolic?.toString().orEmpty())
            }
            3 -> binding.etGlucose.setText(item.fastingGlucose?.toString().orEmpty())
            4 -> binding.etCholesterol.setText(item.totalCholesterol?.toString().orEmpty())
        }
    }
}
