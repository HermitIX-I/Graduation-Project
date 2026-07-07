package com.rql.healthmanage.model.sport

import com.google.gson.Gson
import com.rql.healthmanage.model.entity.SportPlanDto

private val gson = Gson()

/**
 * 扩展字段序列化进 [SportPlanDto.planContent]（JSON），兼容旧版纯文本计划。
 */
data class SportPlanPayload(
    val exerciseForm: String,
    val exerciseSchedule: String,
    val exerciseDetail: String,
    val remindEnabled: Boolean,
    /** HH:mm */
    val remindTime: String? = null,
    /** 1 低 2 中 3 高 */
    val intensityLevel: Int
) {
    fun toJson(): String = gson.toJson(this)
}

fun SportPlanDto.decodePayload(): SportPlanPayload? {
    val raw = planContent?.trim().orEmpty()
    if (raw.isEmpty() || !raw.startsWith("{")) return null
    return runCatching { gson.fromJson(raw, SportPlanPayload::class.java) }.getOrNull()
}

/** 用于提醒调度：优先解析 JSON；旧版纯文本计划仍按每日 20:00 开启提醒。 */
fun SportPlanDto.payloadForReminder(): SportPlanPayload? {
    decodePayload()?.let { return it }
    val raw = planContent?.trim().orEmpty()
    if (raw.isEmpty()) return null
    return SportPlanPayload(
        exerciseForm = "运动计划",
        exerciseSchedule = "每周${frequency}次",
        exerciseDetail = raw.take(200),
        remindEnabled = true,
        remindTime = "20:00",
        intensityLevel = 1
    )
}

fun SportPlanDto.displayTitle(): String {
    val p = decodePayload()
    return if (p != null) "${p.exerciseForm} · 每周${frequency}次" else (planContent?.take(40) ?: "运动计划 #${id}")
}

fun SportPlanDto.displaySubtitle(): String {
    val p = decodePayload()
    return if (p != null) {
        "${p.exerciseSchedule}\n${p.exerciseDetail}\n强度：${intensityLabel(p.intensityLevel)} · 单次${duration}分钟 · 提醒：${
            if (p.remindEnabled) "开${p.remindTime?.let { "（$it）" } ?: ""}" else "关"
        }"
    } else {
        "目标类型 $goalType · ${startDate} ~ ${endDate}"
    }
}

fun intensityLabel(level: Int): String = when (level) {
    3 -> "高"
    2 -> "中"
    else -> "低"
}
