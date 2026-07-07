package com.rql.healthmanage.model.entity

data class ArkResponsesRequestDto(
    val model: String,
    val input: String
)

data class ArkResponsesResponseDto(
    val output_text: String? = null,
    val output: List<ArkOutputItemDto>? = null,
    val error: ArkErrorDto? = null
)

data class ArkOutputItemDto(
    val content: List<ArkContentItemDto>? = null
)

data class ArkContentItemDto(
    val text: String? = null
)

data class ArkErrorDto(
    val message: String? = null
)
