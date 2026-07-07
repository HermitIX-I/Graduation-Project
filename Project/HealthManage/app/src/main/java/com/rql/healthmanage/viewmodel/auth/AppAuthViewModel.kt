package com.rql.healthmanage.viewmodel.auth

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.LoginRequestDto
import com.rql.healthmanage.model.entity.RegisterRequestDto
import com.rql.healthmanage.util.SPUtil
import com.rql.healthmanage.util.isValidChinaMobile
import kotlinx.coroutines.launch

class AppAuthViewModel : ViewModel() {
    private val _loading = MutableLiveData(false)
    val loading: LiveData<Boolean> = _loading

    private val _loginError = MutableLiveData<String?>()
    val loginError: LiveData<String?> = _loginError

    private val _registerError = MutableLiveData<String?>()
    val registerError: LiveData<String?> = _registerError

    private val _targetRoute = MutableLiveData<String?>()
    val targetRoute: LiveData<String?> = _targetRoute

    fun checkSession(routeLogin: String, routeMain: String) {
        viewModelScope.launch {
            val token = SPUtil.getString("token", "")
            val target = if (token.isBlank()) {
                routeLogin
            } else {
                val valid = runCatching { RetrofitClient.api.getUserInfo().code == 200 }.getOrDefault(false)
                if (valid) routeMain else {
                    clearLocalSession()
                    routeLogin
                }
            }
            _targetRoute.value = target
        }
    }

    fun login(account: String, password: String, rememberPassword: Boolean, routeMain: String) {
        viewModelScope.launch {
            _loading.value = true
            _loginError.value = null
            val result = runCatching { RetrofitClient.api.login(LoginRequestDto(account, password)) }.getOrNull()
            if (result?.code == 200 && result.data != null) {
                val data = result.data
                SPUtil.putString("token", data.token)
                SPUtil.putBoolean("is_login", true)
                SPUtil.putString("user_name", data.userInfo.username)
                SPUtil.saveLoginCredentials(account, password, rememberPassword)
                _targetRoute.value = routeMain
            } else {
                _loginError.value = result?.message ?: "登录失败"
            }
            _loading.value = false
        }
    }

    fun register(
        username: String,
        password: String,
        phone: String,
        email: String,
        gender: Int,
        routeAfterSuccess: String
    ) {
        viewModelScope.launch {
            if (!phone.trim().isValidChinaMobile()) {
                _registerError.value = "请输入正确的11位中国大陆手机号"
                return@launch
            }
            _loading.value = true
            _registerError.value = null
            val result = runCatching {
                RetrofitClient.api.register(
                    RegisterRequestDto(username = username, password = password, phone = phone.trim(), email = email.trim(), gender = gender)
                )
            }.getOrNull()
            if (result?.code == 200) {
                SPUtil.saveLoginCredentials(username, password, rememberPassword = true)
                _targetRoute.value = routeAfterSuccess
            } else {
                _registerError.value = result?.message ?: "注册失败"
            }
            _loading.value = false
        }
    }

    fun logout(routeLogin: String) {
        viewModelScope.launch {
            runCatching { RetrofitClient.api.logout() }
            clearLocalSession()
            _targetRoute.value = routeLogin
        }
    }

    fun consumeRoute() {
        _targetRoute.value = null
    }

    fun clearLoginError() {
        _loginError.value = null
    }

    fun clearRegisterError() {
        _registerError.value = null
    }

    private fun clearLocalSession() {
        SPUtil.putString("token", "")
        SPUtil.putBoolean("is_login", false)
        SPUtil.putString("user_name", "")
    }
}
