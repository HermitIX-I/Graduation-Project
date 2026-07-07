package com.rql.healthmanage.util

import android.content.Context
import android.content.SharedPreferences

object SPUtil {
    private const val SP_NAME = "health_manage_sp"
    private lateinit var sp: SharedPreferences

    fun init(context: Context) {
        sp = context.applicationContext.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE)
    }

    fun putString(key: String, value: String) = sp.edit().putString(key, value).apply()
    fun getString(key: String, default: String = ""): String = sp.getString(key, default) ?: default

    fun putBoolean(key: String, value: Boolean) = sp.edit().putBoolean(key, value).apply()
    fun getBoolean(key: String, default: Boolean = false): Boolean = sp.getBoolean(key, default)

    fun putLong(key: String, value: Long) = sp.edit().putLong(key, value).apply()
    fun getLong(key: String, default: Long = 0L): Long = sp.getLong(key, default)

    // 登录凭据（用于“记住密码”）
    private const val KEY_REMEMBER_PASSWORD = "remember_password"
    private const val KEY_LOGIN_ACCOUNT = "login_account"
    private const val KEY_LOGIN_PASSWORD = "login_password"

    fun saveLoginCredentials(account: String, password: String, rememberPassword: Boolean) {
        sp.edit()
            .putBoolean(KEY_REMEMBER_PASSWORD, rememberPassword)
            .putString(KEY_LOGIN_ACCOUNT, account)
            .putString(KEY_LOGIN_PASSWORD, if (rememberPassword) password else "")
            .apply()
    }

    fun isRememberPasswordEnabled(): Boolean = getBoolean(KEY_REMEMBER_PASSWORD, false)
    fun getSavedLoginAccount(): String = getString(KEY_LOGIN_ACCOUNT, "")
    fun getSavedLoginPassword(): String = getString(KEY_LOGIN_PASSWORD, "")

    fun clearSavedLoginPassword() {
        sp.edit().putString(KEY_LOGIN_PASSWORD, "").putBoolean(KEY_REMEMBER_PASSWORD, false).apply()
    }
}
