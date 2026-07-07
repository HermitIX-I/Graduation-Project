package com.rql.healthmanage.model.datasource.remote

import com.google.gson.GsonBuilder
import com.rql.healthmanage.BuildConfig
import com.rql.healthmanage.model.datasource.remote.api.HealthApi
import com.rql.healthmanage.util.SPUtil
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

object RetrofitClient {
    private val okHttpClient by lazy {
        val logging = HttpLoggingInterceptor().apply {
            level = if (BuildConfig.DEBUG) HttpLoggingInterceptor.Level.BODY else HttpLoggingInterceptor.Level.NONE
        }
        OkHttpClient.Builder()
            .addInterceptor(UnauthorizedInterceptor())
            .addInterceptor(logging)
            .addInterceptor { chain ->
                val token = SPUtil.getString("token", "")
                val builder = chain.request().newBuilder()
                    .header("Content-Type", "application/json;charset=UTF-8")
                    .header("Accept", "application/json;charset=UTF-8")
                    .header("Accept-Charset", "UTF-8")
                if (token.isNotEmpty()) builder.header("Authorization", "Bearer $token")
                chain.proceed(builder.build())
            }
            .connectTimeout(20, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build()
    }

    private val retrofit: Retrofit by lazy {
        Retrofit.Builder()
            .baseUrl(BuildConfig.API_BASE_URL)
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create(GsonBuilder().setLenient().create()))
            .build()
    }

    val api: HealthApi by lazy { retrofit.create(HealthApi::class.java) }
}
