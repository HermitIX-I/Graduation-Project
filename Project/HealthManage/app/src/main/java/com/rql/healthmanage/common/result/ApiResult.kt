package com.rql.healthmanage.common.result

import com.google.gson.annotations.SerializedName

data class ApiResult<T>(
    val code: Int,
    @SerializedName("message") val message: String,
    val data: T?
)
