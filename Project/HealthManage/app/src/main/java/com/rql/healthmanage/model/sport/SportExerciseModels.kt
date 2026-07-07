package com.rql.healthmanage.model.sport

data class SportPlanFormState(
    val exerciseForm: String,
    val exerciseSchedule: String,
    val exerciseDetail: String,
    val weeklyFrequency: Int,
    val expectedMinutesPerSession: Int,
    val remindEnabled: Boolean,
    /** HH:mm */
    val remindTime: String?,
    /** 1 减脂 2 增肌 3 减压 */
    val goalCategory: Int
)

data class HighIntensityUi(
    val planId: Int,
    val planTitle: String
)
