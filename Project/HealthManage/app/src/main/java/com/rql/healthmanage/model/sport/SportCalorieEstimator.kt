package com.rql.healthmanage.model.sport

import com.rql.healthmanage.model.entity.SportPlanDto
import kotlin.math.roundToInt

data class SportCalorieEstimate(
    val calories: Int,
    val feedback: String
)

object SportCalorieEstimator {
    fun estimate(plan: SportPlanDto, actualMinutes: Int, weightKg: Double?): SportCalorieEstimate {
        val payload = plan.decodePayload()
        val intensity = payload?.intensityLevel ?: 2
        val form = payload?.exerciseForm.orEmpty() + " " + payload?.exerciseDetail.orEmpty()
        val met = when {
            form.contains("跑", ignoreCase = true) -> when (intensity) {
                3 -> 12.5
                2 -> 10.0
                else -> 8.0
            }
            form.contains("力量", ignoreCase = true) || form.contains("抗阻", ignoreCase = true) -> when (intensity) {
                3 -> 6.0
                2 -> 5.0
                else -> 3.5
            }
            else -> when (intensity) {
                3 -> 8.0
                2 -> 6.0
                else -> 4.0
            }
        }
        val weight = (weightKg ?: 65.0).coerceIn(35.0, 180.0)
        // MET formula: kcal = MET * 3.5 * weight(kg) / 200 * minutes
        val calories = (met * 3.5 * weight / 200.0 * actualMinutes.coerceAtLeast(0)).roundToInt()
        val feedback = when {
            actualMinutes < 20 -> "时长偏短，建议逐步提升到 20-40 分钟，效果更稳定。"
            calories < 180 -> "本次消耗中等，可适当增加时长或提高配速。"
            calories < 350 -> "本次训练完成度不错，注意补水与拉伸。"
            else -> "本次消耗较高，建议关注心率并做好恢复。${if (weightKg == null) "（未获取到近期体重，按 65kg 估算）" else ""}"
        }
        return SportCalorieEstimate(calories = calories, feedback = feedback)
    }
}
