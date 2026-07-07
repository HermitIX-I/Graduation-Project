package com.rql.healthmanage.model.entity

data class AiAdviceRequestDto(
    val bmi: Double? = null,
    val constitutionType: String? = null,
    val level: Int? = null,
    val diagnosis: String? = null,
    val regimenSummary: String? = null,
    val recordsSummary: String? = null,
    val latestRecordTime: String? = null,
    val message: String? = null
)
data class AiAdviceResponseDto(val content: String)
