package com.rql.healthmanage.util

import android.content.Context
import android.net.Uri
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.rql.healthmanage.BuildConfig
import com.rql.healthmanage.common.result.ApiResult
import com.rql.healthmanage.util.SPUtil
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.TimeUnit

object MediaUploadHelper {
    private val gson = Gson()
    private val client by lazy {
        OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .writeTimeout(60, TimeUnit.SECONDS)
            .build()
    }

    fun resolveMediaUrl(path: String?): String {
        val raw = path?.trim().orEmpty()
        if (raw.isBlank()) return ""
        if (raw.startsWith("http://") || raw.startsWith("https://")) return raw
        val base = BuildConfig.API_BASE_URL.trimEnd('/')
        return if (raw.startsWith("/")) "$base$raw" else "$base/$raw"
    }

    /** 用户头像：无有效 URL 时用稳定占位图（按 userId 种子），保证列表与详情均有头像展示 */
    fun resolveUserAvatarUrl(userId: Int, avatar: String?): String {
        val u = resolveMediaUrl(avatar)
        if (u.isNotBlank()) return u
        val seed = if (userId > 0) userId else (System.currentTimeMillis() % 1_000_000).toInt()
        return "https://api.dicebear.com/7.x/avataaars/png?seed=user$seed"
    }

    suspend fun uploadImages(context: Context, uris: List<Uri>): List<String> = withContext(Dispatchers.IO) {
        uris.mapNotNull { uploadImage(context, it) }
    }

    suspend fun uploadImage(context: Context, uri: Uri): String? = withContext(Dispatchers.IO) {
        val file = copyUriToCache(context, uri, "upload_img") ?: return@withContext null
        uploadFile(file, "image")
    }

    private fun uploadFile(file: File, kind: String): String? {
        val token = SPUtil.getString("token", "")
        if (token.isBlank()) return null
        val mediaType = (if (kind == "video") "video/*" else "image/*").toMediaTypeOrNull()
        val part = MultipartBody.Part.createFormData("file", file.name, file.asRequestBody(mediaType))
        val multipart = MultipartBody.Builder().setType(MultipartBody.FORM).addPart(part).build()
        val endpoint = if (kind == "video") "api/upload/video" else "api/upload/image"
        val request = Request.Builder()
            .url("${BuildConfig.API_BASE_URL.trimEnd('/')}/$endpoint")
            .header("Authorization", "Bearer $token")
            .post(multipart)
            .build()
        client.newCall(request).execute().use { response ->
            if (!response.isSuccessful) return null
            val type = object : TypeToken<ApiResult<Map<String, String>>>() {}.type
            val parsed: ApiResult<Map<String, String>> = gson.fromJson(response.body?.string(), type)
            if (parsed.code != 200) return null
            return parsed.data?.get("url")
        }
    }

    private fun copyUriToCache(context: Context, uri: Uri, prefix: String): File? {
        return runCatching {
            val ext = when (context.contentResolver.getType(uri)) {
                "image/png" -> "png"
                "image/gif" -> "gif"
                "image/webp" -> "webp"
                else -> "jpg"
            }
            val file = File(context.cacheDir, "${prefix}_${System.currentTimeMillis()}.$ext")
            context.contentResolver.openInputStream(uri)?.use { input ->
                FileOutputStream(file).use { output -> input.copyTo(output) }
            }
            file.takeIf { it.exists() && it.length() > 0 }
        }.getOrNull()
    }
}
