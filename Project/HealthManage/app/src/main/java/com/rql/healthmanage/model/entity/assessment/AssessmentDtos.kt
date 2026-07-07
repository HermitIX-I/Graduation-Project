package com.rql.healthmanage.model.entity

import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.google.gson.annotations.JsonAdapter
import com.google.gson.annotations.SerializedName
import java.lang.reflect.Type
import java.util.Locale

data class AssessmentEvaluateDto(val psychologyAnswers: Map<String, Int>, val lifestyleAnswers: Map<String, Int>)
data class AssessmentQuestionDto(val id: Int?, val dimension: Int, val content: String, val options: String, val weight: Int, val version: Int, val status: Int)

/** 与问卷列表项一致的答题 key：有题库 id 用 id，否则用维度+题干稳定值 */
fun AssessmentQuestionDto.answerKey(): Int =
    id ?: (dimension * 1_000_003 + content.hashCode())
data class ConstitutionRequestDto(val answers: Map<String, Int>)
data class ConstitutionResultDto(
    @SerializedName("primaryConstitution") val primaryConstitution: String? = null,
    @SerializedName("secondaryConstitution") val secondaryConstitution: String? = null,
    @SerializedName("regimenPlans") val regimenPlans: List<RegimenPlanItemDto>? = null,
    @SerializedName("regimenSections") val regimenSections: RegimenPlanSectionsDto? = null
) {
    val primaryType: String get() = primaryConstitution.orEmpty()
}
data class RegimenPlanItemDto(val id: Int, val name: String, val planType: Int, val content: String)

data class RegimenPlanSectionsDto(
    @SerializedName("medicinalDiet") val medicinalDiet: List<RegimenPlanItemDto>? = null,
    @SerializedName("acupointMassage") val acupointMassage: List<RegimenPlanItemDto>? = null,
    @SerializedName("exercise") val exercise: List<RegimenPlanItemDto>? = null
)

/** 兼容 Jackson 将时间序列化为数组或字符串，避免 [AssessmentResultDto] 整段解析失败。 */
class AssessTimeJsonAdapter : JsonDeserializer<String> {
    override fun deserialize(json: JsonElement, typeOfT: Type, context: JsonDeserializationContext): String {
        if (json.isJsonNull) return ""
        if (json.isJsonPrimitive) {
            val p = json.asJsonPrimitive
            return when {
                p.isString -> p.asString
                p.isNumber -> p.asString
                else -> ""
            }
        }
        if (json.isJsonArray) {
            val a = json.asJsonArray
            if (a.size() >= 3) {
                val y = a[0].asInt
                val mo = a[1].asInt
                val d = a[2].asInt
                return String.format(Locale.CHINA, "%04d-%02d-%02d", y, mo, d)
            }
        }
        return ""
    }
}

data class AssessmentResultDto(
    val totalScore: Int = 0,
    val level: Int = 0,
    val diagnosis: String? = null,
    val constitutionType: String? = null,
    /** 服务端可能省略或字段解析失败时用空列表，避免整段 JSON 反序列化失败 */
    val regimenPlans: List<RegimenPlanItemDto>? = null,
    @SerializedName("regimenSections") val regimenSections: RegimenPlanSectionsDto? = null,
    @JsonAdapter(AssessTimeJsonAdapter::class)
    @SerializedName("assessTime")
    val assessTime: String = ""
)

data class AssessmentEntityDto(
    val id: Int?,
    val userId: Int,
    val totalScore: Int,
    val level: Int,
    val diagnosis: String?,
    val constitutionType: String?,
    val physiologicalScore: Int? = null,
    val psychologicalScore: Int? = null,
    val lifestyleScore: Int? = null
)
