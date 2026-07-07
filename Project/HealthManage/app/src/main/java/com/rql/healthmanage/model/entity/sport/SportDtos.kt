package com.rql.healthmanage.model.entity

data class SportPlanDto(val id: Int, val userId: Int, val goalType: Int, val startDate: String, val endDate: String, val frequency: Int, val duration: Int, val planContent: String?, val status: Int)
data class SportPlanCreateDto(val goalType: Int, val startDate: String, val endDate: String, val frequency: Int, val duration: Int, val planContent: String?)
data class SportRecordCreateDto(val planId: Int, val recordDate: String, val actualDuration: Int, val calories: Int?)
data class SportRecordDto(
    val id: Int,
    val userId: Int,
    val planId: Int,
    val recordDate: String,
    val duration: Int,
    val calories: Int?,
    val status: Int,
    val actualDuration: Int
)
