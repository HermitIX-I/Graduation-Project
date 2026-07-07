package com.rql.healthmanage.model.datasource.remote

import android.content.Intent
import com.rql.healthmanage.common.MyApp
import com.rql.healthmanage.util.SPUtil
import com.rql.healthmanage.view.ui.auth.LoginActivity
import okhttp3.Interceptor
import okhttp3.Response

/**
 * 带有效 Bearer 的请求返回 401 时清理登录态并回到登录页（短时间内去重）。
 */
class UnauthorizedInterceptor : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val response = chain.proceed(chain.request())
        if (response.code != 401) return response
        val auth = chain.request().header("Authorization").orEmpty()
        val hadBearerToken = auth.startsWith("Bearer ") && auth.length > "Bearer ".length + 2
        if (!hadBearerToken) return response
        val now = System.currentTimeMillis()
        synchronized(lock) {
            if (now - lastAuthRedirectMs < DEBOUNCE_MS) return response
            lastAuthRedirectMs = now
        }
        SPUtil.putString("token", "")
        val ctx = MyApp.context
        runCatching {
            ctx.startActivity(
                Intent(ctx, LoginActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                }
            )
        }
        return response
    }

    companion object {
        private val lock = Any()
        private var lastAuthRedirectMs = 0L
        private const val DEBOUNCE_MS = 2_000L
    }
}
