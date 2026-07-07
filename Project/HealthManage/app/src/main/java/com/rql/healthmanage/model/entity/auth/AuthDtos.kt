package com.rql.healthmanage.model.entity

data class LoginRequestDto(val account: String, val password: String)
data class LoginResponseDto(val token: String, val userInfo: UserInfoDto)
data class RegisterRequestDto(
    val username: String,
    val password: String,
    val phone: String,
    val email: String,
    /** 0 女 1 男 */
    val gender: Int
)

data class UserInfoDto(val id: Int, val username: String, val phone: String, val email: String?, val avatar: String?, val age: Int?, val gender: Int?)
data class UpdateUserInfoDto(val email: String? = null, val avatar: String? = null, val age: Int? = null, val gender: Int? = null)
data class UpdatePasswordDto(val oldPassword: String, val newPassword: String)
