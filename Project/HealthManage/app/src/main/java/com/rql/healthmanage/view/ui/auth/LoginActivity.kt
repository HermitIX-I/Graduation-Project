package com.rql.healthmanage.view.ui.auth



import android.content.Intent

import android.os.Bundle

import android.widget.Toast

import androidx.activity.viewModels

import androidx.appcompat.app.AppCompatActivity

import com.rql.healthmanage.databinding.ActivityLoginBinding

import com.rql.healthmanage.view.ui.auth.RegisterActivity
import com.rql.healthmanage.view.ui.main.MainActivity

import com.rql.healthmanage.viewmodel.auth.LoginViewModel



class LoginActivity : AppCompatActivity() {

    private lateinit var binding: ActivityLoginBinding

    private val vm: LoginViewModel by viewModels()



    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)



        if (vm.shouldOpenMainDirectly()) {

            navigateToMain()

            return

        }



        binding = ActivityLoginBinding.inflate(layoutInflater)

        setContentView(binding.root)



        vm.loading.observe(this) { loading ->

            binding.btnLogin.isEnabled = !loading

            binding.btnLogin.text = if (loading) "登录中..." else "登录"

        }

        vm.error.observe(this) { message ->

            if (!message.isNullOrBlank()) {

                Toast.makeText(this, message, Toast.LENGTH_SHORT).show()

                vm.clearError()

            }

        }

        vm.navigateToMain.observe(this) { event ->

            if (event != null) {

                vm.consumeNavigateToMain()

                navigateToMain()

            }

        }



        binding.btnLogin.setOnClickListener {

            val account = binding.etPhone.text?.toString()?.trim().orEmpty()

            val password = binding.etPwd.text?.toString().orEmpty()

            vm.login(account, password)

        }



        binding.tvRegister.setOnClickListener {
            startActivity(Intent(this, RegisterActivity::class.java))
        }

    }



    private fun navigateToMain() {

        startActivity(Intent(this, MainActivity::class.java))

        finish()

    }

}


