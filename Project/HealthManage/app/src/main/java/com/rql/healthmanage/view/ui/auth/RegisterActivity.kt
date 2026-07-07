package com.rql.healthmanage.view.ui.auth

import android.os.Bundle
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import com.rql.healthmanage.databinding.ActivityRegisterPageBinding
import com.rql.healthmanage.viewmodel.auth.LoginViewModel

class RegisterActivity : AppCompatActivity() {
    private lateinit var binding: ActivityRegisterPageBinding
    private val vm: LoginViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRegisterPageBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.btnBack.setOnClickListener { finish() }
        binding.tvLogin.setOnClickListener { finish() }

        vm.loading.observe(this) { loading ->
            binding.btnRegister.isEnabled = !loading
            binding.btnRegister.text = if (loading) "注册中..." else "完成注册"
        }
        vm.error.observe(this) { message ->
            if (!message.isNullOrBlank()) {
                Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
                vm.clearError()
            }
        }
        vm.registerSuccess.observe(this) { event ->
            if (event != null) {
                Toast.makeText(this, "注册成功，请登录新账号", Toast.LENGTH_SHORT).show()
                vm.consumeRegisterSuccess()
                finish()
            }
        }

        binding.btnRegister.setOnClickListener {
            val username = binding.etUserName.text?.toString()?.trim().orEmpty()
            val phone = binding.etPhone.text?.toString()?.trim().orEmpty()
            val email = binding.etEmail.text?.toString()?.trim().orEmpty()
            val pwd = binding.etPwd.text?.toString().orEmpty()
            val confirm = binding.etPwdConfirm.text?.toString().orEmpty()
            if (email.isBlank()) {
                Toast.makeText(this, "请填写邮箱", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            if (!binding.regRbMale.isChecked && !binding.regRbFemale.isChecked) {
                Toast.makeText(this, "请选择性别", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            val gender = if (binding.regRbMale.isChecked) 1 else 0
            if (pwd != confirm) {
                Toast.makeText(this, "两次输入密码不一致", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            vm.register(username = username, password = pwd, phone = phone, email = email, gender = gender)
        }
    }
}
