package com.rql.healthmanage.viewmodel.health

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.AiAdviceRequestDto
import com.rql.healthmanage.model.entity.AssessmentEvaluateDto
import com.rql.healthmanage.model.entity.AssessmentQuestionDto
import com.rql.healthmanage.model.entity.answerKey
import com.rql.healthmanage.model.entity.AssessmentResultDto
import com.rql.healthmanage.model.entity.ConstitutionRequestDto
import com.rql.healthmanage.model.entity.RegimenPlanItemDto
import com.rql.healthmanage.model.entity.RegimenPlanSectionsDto
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class AssessmentViewModel : ViewModel() {
    companion object {
        const val STEP_SUB_HEALTH = 1
        const val STEP_CONSTITUTION = 2
        const val STEP_COMPLETED = 3

        /** 九种体质常见表现（科普向简述，便于评估页展示） */
        private val CONSTITUTION_TRAITS: Map<String, String> = mapOf(
            "平和质" to "阴阳气血调和，体态适中、睡眠与消化多较稳定，对环境适应力较好。仍需规律作息、均衡饮食与适度运动以维持状态。",
            "气虚质" to "常见易疲乏、气短懒言、自汗、声音偏低、易感冒；活动后更易累。宜循序渐进增强体能，忌久卧少动与突然剧烈运动。",
            "阳虚质" to "多畏寒怕冷、手足不温、喜热饮食、精神不振；易腹泻或小便清长。宜温养避寒，少食生冷，注意腰腹与足部保暖。",
            "阴虚质" to "常见口干咽燥、手足心热、易失眠、大便偏干、盗汗；耐冬不耐夏。宜滋阴清润，少食辛辣煎炸，避免熬夜。",
            "痰湿质" to "多见体形偏胖、腹部肥满、身重困倦、痰多口黏、胸闷；舌苔多腻。宜清淡饮食、控制甜腻与酒精，循序渐进增加活动量。",
            "湿热质" to "常见面垢油腻、易生痤疮、口苦、身热不扬、小便黄、大便黏滞。宜清热利湿，少食辛辣烧烤与甜腻，保证饮水与规律排便。",
            "血瘀质" to "多见肤色晦暗、易出现瘀斑、口唇色暗、疼痛固定或刺痛；健忘。宜活血通络，避免久坐，保证睡眠与情绪疏导。",
            "气郁质" to "常见情绪不稳、易焦虑抑郁、胸胁胀闷、喜叹息；咽喉异物感。宜疏肝理气，规律运动与社交，减少长期精神紧张。",
            "特禀质" to "对药物、食物、气味、花粉或气候变化较敏感，易发鼻炎、荨麻疹等。宜回避已知诱因，增强体质，必要时寻求专科指导。"
        )

        private fun constitutionTraitText(label: String): String {
            val t = label.trim()
            if (t.isEmpty()) return CONSTITUTION_TRAITS["平和质"].orEmpty()
            val key = CONSTITUTION_TRAITS.keys.sortedByDescending { it.length }.firstOrNull { k -> t.contains(k) }
            return key?.let { CONSTITUTION_TRAITS[it] }
                ?: "建议结合生活方式干预与专业医师随访，综合理解自身体质特点。"
        }
    }

    private val _questions = MutableLiveData<List<AssessmentQuestionDto>>(emptyList())
    val questions: LiveData<List<AssessmentQuestionDto>> = _questions

    private val _loading = MutableLiveData(false)
    val loading: LiveData<Boolean> = _loading

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _advice = MutableLiveData<String?>()
    val advice: LiveData<String?> = _advice
    private val _hasRecentHealthData = MutableLiveData(false)
    val hasRecentHealthData: LiveData<Boolean> = _hasRecentHealthData
    private val _constitutionCompleted = MutableLiveData(false)
    val constitutionCompleted: LiveData<Boolean> = _constitutionCompleted
    private val _prerequisiteHint = MutableLiveData<String?>()
    val prerequisiteHint: LiveData<String?> = _prerequisiteHint
    private val _evaluationSummary = MutableLiveData<String?>()
    val evaluationSummary: LiveData<String?> = _evaluationSummary
    private val _assessmentStep = MutableLiveData(STEP_SUB_HEALTH)
    val assessmentStep: LiveData<Int> = _assessmentStep
    /** 第二步完成后：按「亚健康等级 + 体质」匹配的调理方案分区（药膳/穴位/运动） */
    private val _regimenSections = MutableLiveData<RegimenPlanSectionsDto?>(null)
    val regimenSections: LiveData<RegimenPlanSectionsDto?> = _regimenSections

    /** 已有完整评估记录时，提示「重新评估 / 查看调理方案」 */
    private val _showResumeChoice = MutableLiveData(false)
    val showResumeChoice: LiveData<Boolean> = _showResumeChoice

    /** 正在拉取「上次评估展示」时，对话框内显示加载，避免误以为无响应 */
    private val _resumeChoiceBusy = MutableLiveData(false)
    val resumeChoiceBusy: LiveData<Boolean> = _resumeChoiceBusy

    /** 选择重新评估时递增，用于清空 Compose 中已选答案 */
    private val _formResetSignal = MutableLiveData(0L)
    val formResetSignal: LiveData<Long> = _formResetSignal

    private var latestEvaluation: AssessmentResultDto? = null
    private var latestConstitution: com.rql.healthmanage.model.entity.ConstitutionResultDto? = null
    private val dateFmt = SimpleDateFormat("yyyy-MM-dd", Locale.CHINA)

    fun loadQuestions() {
        viewModelScope.launch {
            _loading.value = true
            checkPrerequisites()
            val res = runCatching { RetrofitClient.api.assessmentQuestions() }.getOrNull()
            if (res?.code == 200 && res.data != null && res.data.isNotEmpty()) {
                val enabled = res.data.filter { it.status == 1 }
                val fallback = fallbackQuestions()
                val enabledSubHealthDims = enabled.filter { it.dimension in 1..3 }.map { it.dimension }.toSet()
                val enabledTcmDims = enabled.filter { it.dimension >= 4 }.map { it.dimension }.toSet()
                val merged: List<AssessmentQuestionDto> = buildList {
                    addAll(enabled.filter { it.dimension in 1..3 })
                    addAll(
                        fallback.filter { it.dimension in 1..3 && it.dimension !in enabledSubHealthDims }
                    )
                    addAll(enabled.filter { it.dimension >= 4 })
                    addAll(
                        fallback.filter { it.dimension >= 4 && it.dimension !in enabledTcmDims }
                    )
                }
                // 生理维度(1)由健康数据计分，不应出现在问卷；并对题库 id/题干去重，避免与内置题或脏数据叠加重复
                _questions.value = merged
                    .filter { it.dimension != 1 }
                    .distinctByStableOrder()
                _error.value = null
            } else {
                _questions.value = fallbackQuestions().filter { it.dimension != 1 }.distinctByStableOrder()
                _error.value = "问卷接口暂不可用，已切换为内置问卷"
            }
            _loading.value = false
        }
    }

    fun loadLatestRegimenDisplay() {
        viewModelScope.launch {
            _error.value = null
            _resumeChoiceBusy.value = true
            _loading.value = true
            val outcome = runCatching { RetrofitClient.api.latestAssessmentDisplay() }
            val ex = outcome.exceptionOrNull()
            if (ex != null) {
                _loading.value = false
                _resumeChoiceBusy.value = false
                _error.value = "加载调理方案失败：${ex.message ?: ex.javaClass.simpleName}"
                return@launch
            }
            val res = outcome.getOrNull()
            _loading.value = false
            _resumeChoiceBusy.value = false
            if (res?.code == 200 && res.data != null) {
                val d = res.data
                latestEvaluation = d
                latestConstitution = null
                val plans = d.regimenPlans.orEmpty()
                val sections = d.regimenSections ?: groupPlansByType(plans)
                _regimenSections.value = sections
                val primary = d.constitutionType?.trim().orEmpty().ifBlank { "平和质" }
                _evaluationSummary.value = buildCompletedEvaluationSummary(
                    eval = d,
                    primaryConstitution = primary,
                    secondaryConstitution = null,
                    sections = sections,
                    mergedPlans = plans
                )
                _advice.value = null
                _assessmentStep.value = STEP_COMPLETED
                _showResumeChoice.value = false
            } else {
                _error.value = res?.message ?: "未找到已保存的综合评估结果，请先完成问卷"
            }
        }
    }

    fun startFreshAssessment() {
        _resumeChoiceBusy.value = false
        _showResumeChoice.value = false
        latestEvaluation = null
        latestConstitution = null
        _evaluationSummary.value = null
        _regimenSections.value = null
        _advice.value = null
        _assessmentStep.value = STEP_SUB_HEALTH
        _error.value = null
        _formResetSignal.value = (_formResetSignal.value ?: 0L) + 1L
    }

    fun submitSubHealthAssessment(
        questions: List<AssessmentQuestionDto>,
        selectedScores: Map<Int, Int>
    ) {
        viewModelScope.launch {
            _error.value = null
            if (_hasRecentHealthData.value != true) {
                _error.value = "请先录入近 30 天内的健康数据后再评估"
                return@launch
            }
            val step1Qs = questions.filter { it.dimension == 2 || it.dimension == 3 }
            val psychQs = step1Qs.filter { it.dimension == 2 }
            val lifeQs = step1Qs.filter { it.dimension == 3 }
            if (step1Qs.isEmpty()) {
                _error.value = "问卷题目未加载，请下拉刷新后重试"
                return@launch
            }
            if (psychQs.isEmpty() || lifeQs.isEmpty()) {
                _error.value = "请完成心理与生活习惯全部题目后再提交（若列表缺少某一类题目，请下拉刷新问卷）"
                return@launch
            }
            for (q in step1Qs) {
                if (!selectedScores.containsKey(q.answerKey())) {
                    _error.value = when (q.dimension) {
                        2 -> "请完成心理问卷全部题目后再提交"
                        3 -> "请完成生活习惯问卷全部题目后再提交"
                        else -> "请完成当前步骤全部题目后再提交"
                    }
                    return@launch
                }
                if (q.id == null) {
                    _error.value = "问卷配置异常（题目缺少编号），请联系管理员"
                    return@launch
                }
            }
            val psychology = psychQs.associate { it.id!!.toString() to selectedScores[it.answerKey()]!! }
            val lifestyle = lifeQs.associate { it.id!!.toString() to selectedScores[it.answerKey()]!! }
            _loading.value = true
            val evaluateRes = runCatching {
                RetrofitClient.api.evaluate(AssessmentEvaluateDto(psychologyAnswers = psychology, lifestyleAnswers = lifestyle))
            }.getOrNull()
            _loading.value = false
            if (evaluateRes?.code == 200 && evaluateRes.data != null) {
                latestEvaluation = evaluateRes.data
                _regimenSections.value = null
                _assessmentStep.value = STEP_CONSTITUTION
                _evaluationSummary.value = buildString {
                    append("第一步完成：亚健康程度评估")
                    append("\n亚健康等级：${levelName(evaluateRes.data.level)}")
                    append("\n总分：${evaluateRes.data.totalScore}")
                    append("\n初步诊断：${evaluateRes.data.diagnosis.orEmpty()}")
                    append("\n请继续完成第二步中医体质评估。")
                }
                _advice.value = null
            } else {
                _error.value = evaluateRes?.message ?: "亚健康评估失败"
            }
        }
    }

    fun submitConstitutionAndGeneratePlan(
        questions: List<AssessmentQuestionDto>,
        selectedScores: Map<Int, Int>
    ) {
        viewModelScope.launch {
            _error.value = null
            val eval = latestEvaluation
            if (eval == null) {
                _error.value = "请先完成第一步亚健康程度评估"
                return@launch
            }
            val tcmQs = questions.filter { it.dimension >= 4 }
            if (tcmQs.isEmpty()) {
                _error.value = "中医体质评估题目不足，请刷新后重试"
                return@launch
            }
            for (q in tcmQs) {
                if (!selectedScores.containsKey(q.answerKey())) {
                    _error.value = "请完成中医体质问卷全部题目后再提交"
                    return@launch
                }
                if (q.id == null) {
                    _error.value = "问卷配置异常（体质题缺少编号），请联系管理员"
                    return@launch
                }
            }
            val constitutionAnswers = tcmQs.associate { it.id!!.toString() to selectedScores[it.answerKey()]!! }
            _loading.value = true
            val constitutionOutcome = runCatching {
                RetrofitClient.api.constitution(ConstitutionRequestDto(constitutionAnswers))
            }
            val constitutionEx = constitutionOutcome.exceptionOrNull()
            if (constitutionEx != null) {
                _loading.value = false
                _error.value = "提交第二步失败：${constitutionEx.message ?: constitutionEx.javaClass.simpleName}"
                return@launch
            }
            val constitutionRes = constitutionOutcome.getOrNull()
            if (constitutionRes?.code == 200 && constitutionRes.data != null) {
                latestConstitution = constitutionRes.data
                val constitutionType = constitutionRes.data.primaryType.ifBlank {
                    eval.constitutionType.orEmpty().ifBlank { "平和质" }
                }
                val mergedPlans = constitutionRes.data.regimenPlans
                    .orEmpty()
                    .ifEmpty { eval.regimenPlans.orEmpty() }
                val sections = constitutionRes.data.regimenSections
                    ?: groupPlansByType(mergedPlans)
                _regimenSections.value = sections
                _evaluationSummary.value = buildCompletedEvaluationSummary(
                    eval = eval,
                    primaryConstitution = constitutionType,
                    secondaryConstitution = constitutionRes.data.secondaryConstitution?.trim()?.takeIf { it.isNotEmpty() },
                    sections = sections,
                    mergedPlans = mergedPlans
                )
                val adviceRes = runCatching {
                    RetrofitClient.api.aiAdvice(
                        AiAdviceRequestDto(
                            constitutionType = constitutionType,
                            level = eval.level,
                            diagnosis = eval.diagnosis.orEmpty(),
                            regimenSummary = mergedPlans.joinToString { it.name }
                        )
                    )
                }.getOrNull()
                _advice.value = adviceRes?.data?.content ?: "AI 建议暂时失败，请稍后再试"
                _assessmentStep.value = STEP_COMPLETED
            } else {
                _error.value = constitutionRes?.message ?: "中医体质评估失败"
            }
            _loading.value = false
        }
    }

    private fun buildCompletedEvaluationSummary(
        eval: AssessmentResultDto,
        primaryConstitution: String,
        secondaryConstitution: String?,
        sections: RegimenPlanSectionsDto,
        mergedPlans: List<RegimenPlanItemDto>
    ): String = buildString {
        append("第一步：亚健康程度评估\n")
        append("亚健康等级：${levelName(eval.level)}\n")
        append("总分：${eval.totalScore}\n")
        append("初步诊断：${eval.diagnosis.orEmpty()}\n\n")
        append("第二步：中医体质评估\n")
        append("主要体质：$primaryConstitution\n")
        val primaryTraits = constitutionTraitText(primaryConstitution)
        if (primaryTraits.isNotBlank()) {
            append("体质特点：$primaryTraits\n")
        }
        val secondary = secondaryConstitution?.trim().orEmpty()
        if (secondary.isNotBlank()) {
            append("次要体质：$secondary\n")
            val secondaryTraits = constitutionTraitText(secondary)
            if (secondaryTraits.isNotBlank() && secondaryTraits != primaryTraits) {
                append("次要体质特点：$secondaryTraits\n")
            }
        }
        append("\n个性化调理方案（按您的亚健康程度与体质匹配）\n")
        append(formatRegimenSummary(sections, mergedPlans))
    }

    private fun levelName(level: Int): String {
        return when (level) {
            0 -> "健康"
            1 -> "轻度亚健康"
            2 -> "中度亚健康"
            3 -> "重度亚健康"
            else -> "未知"
        }
    }

    private fun groupPlansByType(plans: List<RegimenPlanItemDto>) = RegimenPlanSectionsDto(
        medicinalDiet = plans.filter { it.planType == 1 },
        acupointMassage = plans.filter { it.planType == 2 },
        exercise = plans.filter { it.planType == 3 }
    )

    private fun formatRegimenSummary(sections: RegimenPlanSectionsDto, plans: List<RegimenPlanItemDto>): String {
        if (plans.isEmpty()) {
            return "暂无系统内置方案，可在管理端「调理方案」中补充，或咨询医生获取个体化建议。"
        }
        return buildString {
            fun block(title: String, items: List<RegimenPlanItemDto>) {
                if (items.isEmpty()) return
                append("\n【$title】\n")
                items.forEach { p ->
                    append("• ${p.name}\n  ${p.content}\n")
                }
            }
            block("药膳调理", sections.medicinalDiet.orEmpty())
            block("穴位按摩", sections.acupointMassage.orEmpty())
            block("运动锻炼", sections.exercise.orEmpty())
        }.trimEnd()
    }

    private suspend fun checkPrerequisites() {
        val endCal = Calendar.getInstance()
        val startCal = Calendar.getInstance().apply { add(Calendar.DAY_OF_MONTH, -30) }
        val startStr = dateFmt.format(startCal.time)
        val endStr = dateFmt.format(endCal.time)
        val healthRes = runCatching { RetrofitClient.api.healthDataList(null, 1, 200) }.getOrNull()
        val hasRecent = healthRes?.code == 200 && healthRes.data != null && healthRes.data.records.any {
            val datePart = it.recordTime.take(10)
            datePart >= startStr && datePart <= endStr
        }
        _hasRecentHealthData.value = hasRecent
        val latest = runCatching { RetrofitClient.api.latestAssessment() }.getOrNull()?.data
        val done = !latest?.constitutionType.isNullOrBlank()
        _constitutionCompleted.value = done
        val fullHistory = latest != null &&
            latest.psychologicalScore != null &&
            latest.lifestyleScore != null &&
            !latest.constitutionType.isNullOrBlank()
        _showResumeChoice.value = fullHistory
        _prerequisiteHint.value = when {
            !hasRecent -> "您尚未在近 30 天内录入健康数据，请先在「健康数据」模块录入。"
            !done -> "您尚未完成中医体质测评，请在本页填写问卷后再提交。"
            else -> "前置条件已满足；建议保持近期健康数据与问卷完整，以便获得更准确的评估与建议。"
        }
    }

    /**
     * 按接口返回顺序保留优先项：同 id 或同「维度+题干」只保留第一条，消除管理端重复录入或与内置题叠加造成的重复题。
     */
    private fun List<AssessmentQuestionDto>.distinctByStableOrder(): List<AssessmentQuestionDto> {
        val seenIds = HashSet<Int>()
        val seenDimContent = HashSet<String>()
        val out = ArrayList<AssessmentQuestionDto>(size)
        for (q in this) {
            val id = q.id
            if (id != null) {
                if (!seenIds.add(id)) continue
            }
            val dimContent = "${q.dimension}|||${q.content.trim().replace(Regex("\\s+"), " ")}"
            if (!seenDimContent.add(dimContent)) continue
            out.add(q)
        }
        return out
    }

    private fun fallbackQuestions(): List<AssessmentQuestionDto> {
        val psychOptions = """[{"option":"从不","score":0},{"option":"很少","score":1},{"option":"有时","score":2},{"option":"经常","score":3},{"option":"总是","score":4}]"""
        val lifeOptions = """[{"option":"不足","score":0},{"option":"一般","score":10},{"option":"较好","score":20}]"""
        val tcmOptions = """[{"option":"没有","score":1},{"option":"偶尔","score":2},{"option":"有时","score":3},{"option":"经常","score":4},{"option":"非常明显","score":5}]"""
        return listOf(
            AssessmentQuestionDto(2001, 2, "您是否容易焦虑或紧张？", psychOptions, 1, 1, 1),
            AssessmentQuestionDto(2002, 2, "是否存在睡眠质量问题？", psychOptions, 1, 1, 1),
            AssessmentQuestionDto(2003, 2, "是否容易感到疲劳乏力？", psychOptions, 1, 1, 1),
            AssessmentQuestionDto(3001, 3, "近一周运动频率如何？", lifeOptions, 1, 1, 1),
            AssessmentQuestionDto(3002, 3, "近一周饮食状况如何？", lifeOptions, 1, 1, 1),
            AssessmentQuestionDto(3003, 3, "近一周作息规律如何？", lifeOptions, 1, 1, 1),
            AssessmentQuestionDto(4101, 4, "您精力充沛吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4102, 4, "您对气候、环境的适应能力较强吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4001, 6, "您手脚发凉吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4002, 6, "您比一般人更怕冷、喜热饮食吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4003, 5, "您容易疲乏吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4004, 5, "您容易气短、呼吸表浅吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4005, 7, "您感到口干咽燥、手足心发热吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4006, 7, "您容易便秘或大便干燥吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4007, 8, "您腹部肥满或身体沉重困倦吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4008, 8, "您痰多、口黏或胸闷吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4009, 9, "您面部油腻、易生痤疮或口苦吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4010, 9, "您小便色黄、大便黏滞不爽吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4011, 10, "您面色晦暗或易出现瘀斑吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4012, 10, "您身体某处时有刺痛、固定不移吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4013, 11, "您情绪低沉或容易紧张焦虑吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4014, 11, "您胸胁或乳房胀闷不舒吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4015, 12, "您容易过敏（药物、食物、气味、花粉等）吗？", tcmOptions, 1, 1, 1),
            AssessmentQuestionDto(4016, 12, "您因季节、异味、温度变化而容易不适吗？", tcmOptions, 1, 1, 1)
        )
    }
}
