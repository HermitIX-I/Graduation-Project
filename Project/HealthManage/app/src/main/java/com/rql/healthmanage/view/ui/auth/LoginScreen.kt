package com.rql.healthmanage.view.ui.auth

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Checkbox
import androidx.compose.material3.MaterialTheme
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
fun LoginScreen(
    initialAccount: String,
    initialPassword: String,
    initialRemember: Boolean,
    loading: Boolean,
    error: String?,
    onLogin: (String, String, Boolean) -> Unit,
    onGoRegister: () -> Unit
) {
    var account by remember(initialAccount) { mutableStateOf(initialAccount) }
    var password by remember(initialPassword) { mutableStateOf(initialPassword) }
    var rememberPassword by remember(initialRemember) { mutableStateOf(initialRemember) }

    Column(
        modifier = Modifier.fillMaxSize().padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp, Alignment.CenterVertically)
    ) {
        Text("登录", style = MaterialTheme.typography.headlineMedium)
        OutlinedTextField(
            value = account,
            onValueChange = { account = it },
            label = { Text("账号(用户名/手机号)") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("密码") },
            modifier = Modifier.fillMaxWidth(),
            visualTransformation = PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password)
        )
        Row(verticalAlignment = Alignment.CenterVertically) {
            Checkbox(checked = rememberPassword, onCheckedChange = { rememberPassword = it })
            Text("记住密码")
        }
        if (!error.isNullOrBlank()) {
            Text(error, color = MaterialTheme.colorScheme.error)
        }
        Button(
            onClick = { onLogin(account.trim(), password, rememberPassword) },
            enabled = !loading,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(if (loading) "登录中..." else "登录")
        }
        Button(onClick = onGoRegister, enabled = !loading, modifier = Modifier.fillMaxWidth()) {
            Text("去注册")
        }
    }
}
