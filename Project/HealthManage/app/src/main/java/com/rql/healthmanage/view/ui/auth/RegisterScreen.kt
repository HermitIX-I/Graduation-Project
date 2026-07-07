package com.rql.healthmanage.view.ui.auth

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp

@Composable
fun RegisterScreen(
    loading: Boolean,
    error: String?,
    onRegister: (String, String, String, String, Int) -> Unit,
    onBackToLogin: () -> Unit
) {
    var username by remember { mutableStateOf("") }
    var phone by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var gender by remember { mutableStateOf<Int?>(null) }
    var formError by remember { mutableStateOf<String?>(null) }

    Column(
        modifier = Modifier.fillMaxSize().padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp, Alignment.CenterVertically)
    ) {
        Text("注册", style = MaterialTheme.typography.headlineMedium)
        OutlinedTextField(value = username, onValueChange = { username = it }, label = { Text("用户名") }, modifier = Modifier.fillMaxWidth())
        OutlinedTextField(value = phone, onValueChange = { phone = it }, label = { Text("手机号") }, modifier = Modifier.fillMaxWidth())
        OutlinedTextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("密码") },
            modifier = Modifier.fillMaxWidth(),
            visualTransformation = PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password)
        )
        OutlinedTextField(
            value = email,
            onValueChange = { email = it },
            label = { Text("邮箱（必填）") },
            modifier = Modifier.fillMaxWidth(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email)
        )
        Text("性别（必填）", style = MaterialTheme.typography.bodyMedium)
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            OutlinedButton(
                onClick = { gender = 0 },
                colors = ButtonDefaults.outlinedButtonColors(
                    containerColor = if (gender == 0) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.surface
                )
            ) { Text("女") }
            OutlinedButton(
                onClick = { gender = 1 },
                colors = ButtonDefaults.outlinedButtonColors(
                    containerColor = if (gender == 1) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.surface
                )
            ) { Text("男") }
        }
        if (!formError.isNullOrBlank()) {
            Text(formError!!, color = MaterialTheme.colorScheme.error)
        }
        if (!error.isNullOrBlank()) {
            Text(error, color = MaterialTheme.colorScheme.error)
        }
        Button(
            onClick = {
                formError = when {
                    email.isBlank() -> "请填写邮箱"
                    gender == null -> "请选择性别"
                    else -> null
                }
                if (formError == null) {
                    onRegister(username.trim(), password, phone.trim(), email.trim(), gender!!)
                }
            },
            enabled = !loading,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(if (loading) "注册中..." else "注册")
        }
        Button(onClick = onBackToLogin, enabled = !loading, modifier = Modifier.fillMaxWidth()) {
            Text("返回登录")
        }
    }
}
