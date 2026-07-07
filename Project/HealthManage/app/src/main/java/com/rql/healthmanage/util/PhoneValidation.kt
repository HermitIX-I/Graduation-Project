package com.rql.healthmanage.util

/** 中国大陆手机号：11 位，1 开头第二位 3–9 */
private val CHINA_MOBILE = Regex("^1[3-9]\\d{9}$")

fun CharSequence?.isValidChinaMobile(): Boolean {
    val p = this?.trim()?.toString().orEmpty()
    return p.matches(CHINA_MOBILE)
}
