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

class LoginViewModel : ViewModel() {

    private val _loading = MutableLiveData(false)
    val loading: LiveData<Boolean> = _loading

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _navigateToMain = MutableLiveData<Unit?>()
    val navigateToMain: LiveData<Unit?> = _navigateToMain
    private val _registerSuccess = MutableLiveData<Unit?>()
    val registerSuccess: LiveData<Unit?> = _registerSuccess

    fun shouldOpenMainDirectly(): Boolean = SPUtil.getString("token").isNotBlank()

    fun login(account: String, password: String) {
        if (account.isBlank() || password.isBlank()) {
            _error.value = "请输入账号和密码"
            return
        }
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val result = runCatching {
                    RetrofitClient.api.login(LoginRequestDto(account, password))
                }.getOrNull()

                if (result?.code == 200 && result.data != null) {
                    SPUtil.putString("token", result.data.token)
                    SPUtil.putBoolean("is_login", true)
                    SPUtil.putString("user_name", result.data.userInfo.username)
                    SPUtil.saveLoginCredentials(account, password, rememberPassword = true)
                    _navigateToMain.value = Unit
                } else {
                    _error.value = result?.message ?: "登录失败，请检查网络或账号密码"
                }
            } catch (e: Exception) {
                _error.value = e.message ?: "网络异常"
            } finally {
                _loading.value = false
            }
        }
    }

    fun register(username: String, password: String, phone: String, email: String, gender: Int) {
        if (username.isBlank() || password.isBlank() || phone.isBlank()) {
            _error.value = "请填写用户名、手机号和密码"
            return
        }
        if (email.isBlank()) {
            _error.value = "请填写邮箱"
            return
        }
        if (gender != 0 && gender != 1) {
            _error.value = "请选择性别"
            return
        }
        if (!phone.trim().isValidChinaMobile()) {
            _error.value = "请输入正确的11位中国大陆手机号"
            return
        }
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val result = runCatching {
                    RetrofitClient.api.register(RegisterRequestDto(username, password, phone.trim(), email.trim(), gender))
                }.getOrNull()
                if (result?.code == 200) {
                    _registerSuccess.value = Unit
                } else {
                    _error.value = result?.message ?: "注册失败"
                }
            } catch (e: Exception) {
                _error.value = e.message ?: "网络异常"
            } finally {
                _loading.value = false
            }
        }
    }

    fun consumeNavigateToMain() {
        _navigateToMain.value = null
    }

    fun clearError() {
        _error.value = null
    }

    fun consumeRegisterSuccess() {
        _registerSuccess.value = null
    }
}
