package com.rql.healthmanage.model.datasource.remote.api

import com.rql.healthmanage.model.entity.ArkResponsesRequestDto
import com.rql.healthmanage.model.entity.ArkResponsesResponseDto
import retrofit2.http.Body
import retrofit2.http.POST

interface ArkResponsesApi {
    @POST("responses")
    suspend fun createResponse(@Body body: ArkResponsesRequestDto): ArkResponsesResponseDto
}
