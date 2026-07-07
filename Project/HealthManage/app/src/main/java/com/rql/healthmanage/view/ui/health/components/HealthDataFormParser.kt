package com.rql.healthmanage.view.ui.health.components



import android.content.Context

import android.widget.Toast

import com.rql.healthmanage.databinding.DialogHealthDataFormBinding

import com.rql.healthmanage.model.entity.HealthDataRequestDto



fun parseHealthDataRequestsFromForm(

    binding: DialogHealthDataFormBinding,

    @Suppress("UNUSED_PARAMETER") force: Boolean,

    context: Context

): List<HealthDataRequestDto>? {

    fun textOf(view: android.widget.EditText): String = view.text?.toString()?.trim().orEmpty()



    val heightText = textOf(binding.etHeight)

    val weightText = textOf(binding.etWeight)

    val systolicText = textOf(binding.etSystolic)

    val diastolicText = textOf(binding.etDiastolic)

    val glucoseText = textOf(binding.etGlucose)

    val cholesterolText = textOf(binding.etCholesterol)



    if (listOf(heightText, weightText, systolicText, diastolicText, glucoseText, cholesterolText).any { it.isBlank() }) {

        Toast.makeText(context, "每次保存须完整填写身高、体重、血压、空腹血糖与总胆固醇", Toast.LENGTH_SHORT).show()

        return null

    }



    val height = heightText.toDoubleOrNull()

    val weight = weightText.toDoubleOrNull()

    if (height == null || weight == null) {

        Toast.makeText(context, "请正确填写身高和体重", Toast.LENGTH_SHORT).show()

        return null

    }

    if (height !in 50.0..260.0 || weight !in 10.0..300.0) {

        Toast.makeText(context, "身高或体重超出合理范围", Toast.LENGTH_SHORT).show()

        return null

    }



    val systolic = systolicText.toIntOrNull()

    val diastolic = diastolicText.toIntOrNull()

    if (systolic == null || diastolic == null) {

        Toast.makeText(context, "请正确填写血压数据", Toast.LENGTH_SHORT).show()

        return null

    }

    if (systolic !in 70..250 || diastolic !in 40..150 || systolic <= diastolic) {

        Toast.makeText(context, "血压数据不合理，请检查后重试", Toast.LENGTH_SHORT).show()

        return null

    }



    val glucose = glucoseText.toDoubleOrNull()

    if (glucose == null) {

        Toast.makeText(context, "请正确填写空腹血糖", Toast.LENGTH_SHORT).show()

        return null

    }

    if (glucose !in 2.0..35.0) {

        Toast.makeText(context, "血糖数值超出合理范围", Toast.LENGTH_SHORT).show()

        return null

    }



    val cholesterol = cholesterolText.toDoubleOrNull()

    if (cholesterol == null) {

        Toast.makeText(context, "请正确填写总胆固醇", Toast.LENGTH_SHORT).show()

        return null

    }

    if (cholesterol !in 1.0..20.0) {

        Toast.makeText(context, "总胆固醇数值超出合理范围", Toast.LENGTH_SHORT).show()

        return null

    }



    return listOf(

        HealthDataRequestDto(dataType = 1, height = height, weight = weight),

        HealthDataRequestDto(dataType = 2, systolic = systolic, diastolic = diastolic),

        HealthDataRequestDto(dataType = 3, fastingGlucose = glucose),

        HealthDataRequestDto(dataType = 4, totalCholesterol = cholesterol)

    )

}


