package com.rql.healthmanage.model.datasource.remote

import com.google.gson.GsonBuilder
import com.rql.healthmanage.BuildConfig
import com.rql.healthmanage.model.datasource.remote.api.ArkResponsesApi
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

object ArkRetrofitClient {
    private val okHttpClient by lazy {
        val logging = HttpLoggingInterceptor().apply {
            level = if (BuildConfig.DEBUG) HttpLoggingInterceptor.Level.BASIC else HttpLoggingInterceptor.Level.NONE
        }
        OkHttpClient.Builder()
            .addInterceptor(logging)
            .addInterceptor { chain ->
                val builder = chain.request().newBuilder()
                    .header("Content-Type", "application/json")
                if (BuildConfig.ARK_API_KEY.isNotBlank()) {
                    builder.header("Authorization", "Bearer ${BuildConfig.ARK_API_KEY}")
                }
                chain.proceed(builder.build())
            }
            .connectTimeout(20, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build()
    }

    private val retrofit: Retrofit by lazy {
        Retrofit.Builder()
            .baseUrl(BuildConfig.ARK_BASE_URL)
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create(GsonBuilder().setLenient().create()))
            .build()
    }

    val api: ArkResponsesApi by lazy { retrofit.create(ArkResponsesApi::class.java) }
}
