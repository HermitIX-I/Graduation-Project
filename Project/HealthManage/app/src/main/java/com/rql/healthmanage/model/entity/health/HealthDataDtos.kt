package com.rql.healthmanage.model.entity

data class HealthDataRequestDto(
    val dataType: Int,
    val height: Double? = null,
    val weight: Double? = null,
    val systolic: Int? = null,
    val diastolic: Int? = null,
    val fastingGlucose: Double? = null,
    val totalCholesterol: Double? = null,
    val recordTime: String? = null
)
data class HealthDataItemDto(
    val id: Int,
    val userId: Int,
    val dataType: Int,
    val height: Double?,
    val weight: Double?,
    val systolic: Int?,
    val diastolic: Int?,
    val fastingGlucose: Double?,
    val totalCholesterol: Double?,
    val recordTime: String,
    val isAbnormal: Int,
    val createTime: String
)
data class HealthDataListDto(val total: Long, val records: List<HealthDataItemDto>)
