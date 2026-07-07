package com.rql.healthmanage.view.ui.health



import androidx.compose.foundation.layout.Arrangement

import androidx.compose.foundation.layout.Box

import androidx.compose.foundation.layout.Column

import androidx.compose.foundation.layout.PaddingValues

import androidx.compose.foundation.layout.Row

import androidx.compose.foundation.layout.fillMaxSize

import androidx.compose.foundation.layout.fillMaxWidth

import androidx.compose.foundation.layout.padding

import androidx.compose.foundation.lazy.LazyColumn

import androidx.compose.foundation.lazy.items

import androidx.compose.material3.AlertDialog

import androidx.compose.material3.Button

import androidx.compose.material3.ButtonDefaults

import androidx.compose.material3.Card

import androidx.compose.material3.CircularProgressIndicator

import androidx.compose.material3.MaterialTheme

import androidx.compose.material3.OutlinedButton

import androidx.compose.material3.Scaffold

import androidx.compose.material3.Text

import androidx.compose.material3.TextButton

import androidx.compose.runtime.Composable

import androidx.compose.runtime.LaunchedEffect

import androidx.compose.runtime.derivedStateOf

import androidx.compose.runtime.getValue

import androidx.compose.runtime.mutableStateMapOf

import androidx.compose.runtime.remember

import androidx.compose.runtime.livedata.observeAsState

import androidx.compose.ui.Alignment

import androidx.compose.ui.Modifier

import androidx.compose.ui.text.font.FontWeight

import androidx.compose.ui.text.style.TextAlign

import androidx.compose.ui.unit.dp

import androidx.compose.ui.window.DialogProperties

import androidx.lifecycle.viewmodel.compose.viewModel

import com.rql.healthmanage.model.entity.AssessmentQuestionDto
import com.rql.healthmanage.model.entity.answerKey

import com.rql.healthmanage.model.entity.RegimenPlanItemDto

import com.rql.healthmanage.viewmodel.health.AssessmentViewModel

import org.json.JSONArray



@Suppress("UNUSED_PARAMETER")
@Composable

fun AssessmentQuestionnaireScreen(

    onBack: () -> Unit,

    onCompleted: () -> Unit,

    onGoHealthData: () -> Unit = {},

    onGoSportPlan: () -> Unit = {},

    onGoSportCheckIn: () -> Unit = {},

    vm: AssessmentViewModel = viewModel()

) {

    val questions by vm.questions.observeAsState(emptyList())

    val loading by vm.loading.observeAsState(true)

    val error by vm.error.observeAsState()

    val advice by vm.advice.observeAsState()

    val hasRecentHealthData by vm.hasRecentHealthData.observeAsState(false)

    val constitutionCompleted by vm.constitutionCompleted.observeAsState(false)

    val prerequisiteHint by vm.prerequisiteHint.observeAsState()

    val evaluationSummary by vm.evaluationSummary.observeAsState()

    val regimenSections by vm.regimenSections.observeAsState()

    val assessmentStep by vm.assessmentStep.observeAsState(AssessmentViewModel.STEP_SUB_HEALTH)

    val showResumeChoice by vm.showResumeChoice.observeAsState(false)

    val resumeChoiceBusy by vm.resumeChoiceBusy.observeAsState(false)

    val formResetSignal by vm.formResetSignal.observeAsState(0L)

    val selectedScores = remember { mutableStateMapOf<Int, Int>() }

    LaunchedEffect(formResetSignal) {

        if (formResetSignal > 0L) {

            selectedScores.clear()

        }

    }

    val resumeDialogVisible = showResumeChoice &&

        assessmentStep == AssessmentViewModel.STEP_SUB_HEALTH &&

        (!loading || resumeChoiceBusy)

    /** 与 ViewModel / 后端一致：仅心理(2)+生活(3)，不含生理(1) */
    val step1Questions = remember(questions) { questions.filter { it.dimension == 2 || it.dimension == 3 } }

    val step2Questions = remember(questions) { questions.filter { it.dimension >= 4 } }

    val activeQuestions = remember(assessmentStep, step1Questions, step2Questions) {
        when (assessmentStep) {
            AssessmentViewModel.STEP_SUB_HEALTH -> step1Questions
            AssessmentViewModel.STEP_CONSTITUTION -> step2Questions
            else -> emptyList()
        }
    }



    LaunchedEffect(Unit) { vm.loadQuestions() }



    val stepTitle = when (assessmentStep) {

        AssessmentViewModel.STEP_SUB_HEALTH -> "第一步：亚健康程度评估"

        AssessmentViewModel.STEP_CONSTITUTION -> "第二步：中医体质评估"

        else -> "评估完成：个性化调理方案"

    }



    val allCurrentStepAnswered by remember(activeQuestions) {

        derivedStateOf {

            activeQuestions.isNotEmpty() &&

                activeQuestions.all { q -> selectedScores.containsKey(q.answerKey()) }

        }

    }

    val submitEnabled =

        !loading &&

            !resumeDialogVisible &&

            activeQuestions.isNotEmpty() &&

            allCurrentStepAnswered &&

            hasRecentHealthData &&

            assessmentStep != AssessmentViewModel.STEP_COMPLETED



    Scaffold(

        modifier = Modifier.fillMaxSize(),

        bottomBar = {

            Row(

                Modifier

                    .fillMaxWidth()

                    .padding(horizontal = 12.dp, vertical = 8.dp),

                horizontalArrangement = Arrangement.spacedBy(8.dp)

            ) {

                OutlinedButton(onClick = onBack, modifier = Modifier.weight(1f)) { Text("返回首页") }

                Button(

                    onClick = {

                        if (!allCurrentStepAnswered || resumeDialogVisible) {

                            return@Button

                        }

                        when (assessmentStep) {

                            AssessmentViewModel.STEP_SUB_HEALTH ->

                                vm.submitSubHealthAssessment(questions = questions, selectedScores = selectedScores)

                            AssessmentViewModel.STEP_CONSTITUTION ->

                                vm.submitConstitutionAndGeneratePlan(questions = questions, selectedScores = selectedScores)

                            else -> Unit

                        }

                    },

                    modifier = Modifier.weight(1f),

                    enabled = submitEnabled

                ) {

                    Text(

                        when (assessmentStep) {

                            AssessmentViewModel.STEP_SUB_HEALTH -> "提交第一步评估"

                            AssessmentViewModel.STEP_CONSTITUTION -> "提交第二步并生成方案"

                            else -> "已完成"

                        }

                    )

                }

            }

        }

    ) { innerPadding ->

        LazyColumn(

            Modifier

                .fillMaxSize()

                .padding(innerPadding)

                .padding(horizontal = 12.dp),

            contentPadding = PaddingValues(bottom = 12.dp),

            verticalArrangement = Arrangement.spacedBy(8.dp)

        ) {

            item {

                Text(stepTitle, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)

            }

            if (!prerequisiteHint.isNullOrBlank()) {

                item {

                    Card(Modifier.fillMaxWidth()) {

                        Column(

                            Modifier

                                .fillMaxWidth()

                                .padding(10.dp),

                            verticalArrangement = Arrangement.spacedBy(6.dp)

                        ) {

                            Text(prerequisiteHint.orEmpty())

                            if (!hasRecentHealthData) {

                                Button(onClick = onGoHealthData) { Text("去录入健康数据") }

                            } else if (!constitutionCompleted) {

                                Text("请完成问卷后继续评估。")

                            }

                        }

                    }

                }

            }

            if (loading) {

                item {

                    Box(

                        Modifier

                            .fillMaxWidth()

                            .padding(vertical = 32.dp),

                        contentAlignment = Alignment.Center

                    ) {

                        CircularProgressIndicator()

                    }

                }

            } else {

                items(

                    items = activeQuestions,

                    key = { q -> q.answerKey() }

                ) { q ->

                    Card(Modifier.fillMaxWidth()) {

                        Column(

                            Modifier

                                .fillMaxWidth()

                                .padding(10.dp),

                            verticalArrangement = Arrangement.spacedBy(6.dp)

                        ) {

                            Text(q.content)

                            val options = runCatching { JSONArray(q.options) }.getOrNull()

                            if (options != null && options.length() > 0) {

                                val qKey = q.answerKey()

                                Column(

                                    modifier = Modifier.fillMaxWidth(),

                                    verticalArrangement = Arrangement.spacedBy(6.dp)

                                ) {

                                    for (i in 0 until options.length()) {

                                        val obj = options.optJSONObject(i)

                                        val text = obj?.optString("option") ?: "选项${i + 1}"

                                        val score = obj?.optInt("score") ?: 0

                                        val picked = selectedScores[qKey] == score

                                        OutlinedButton(

                                            onClick = { selectedScores[qKey] = score },

                                            modifier = Modifier.fillMaxWidth(),

                                            colors = ButtonDefaults.outlinedButtonColors(

                                                containerColor = if (picked) {

                                                    MaterialTheme.colorScheme.primaryContainer

                                                } else {

                                                    MaterialTheme.colorScheme.surface

                                                }

                                            )

                                        ) {

                                            Text(text = "$text($score)", textAlign = TextAlign.Center)

                                        }

                                    }

                                }

                            }

                        }

                    }

                }

                if (activeQuestions.isEmpty() && assessmentStep != AssessmentViewModel.STEP_COMPLETED) {

                    item {

                        Text(

                            text = if (assessmentStep == AssessmentViewModel.STEP_CONSTITUTION) {

                                "中医体质评估题暂未加载，请返回重试或检查题库配置。"

                            } else {

                                "亚健康评估题暂未加载，请返回重试或检查题库配置。"

                            },

                            color = MaterialTheme.colorScheme.error

                        )

                    }

                }

            }

            if (!error.isNullOrBlank()) {

                item { Text(error.orEmpty(), color = MaterialTheme.colorScheme.error) }

            }

            if (!evaluationSummary.isNullOrBlank()) {

                item {
                    Text(
                        text = "评估结果：\n$evaluationSummary",
                        modifier = Modifier.fillMaxWidth(),
                        style = MaterialTheme.typography.bodyMedium
                    )
                }

            }

            if (assessmentStep == AssessmentViewModel.STEP_COMPLETED && regimenSections != null) {

                item {

                    val sec = regimenSections!!

                    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {

                        Text(

                            "调理方案（药膳 / 穴位 / 运动）",

                            style = MaterialTheme.typography.titleMedium,

                            fontWeight = FontWeight.Bold

                        )

                        RegimenSectionBlock("药膳调理", sec.medicinalDiet.orEmpty())

                        RegimenSectionBlock("穴位按摩", sec.acupointMassage.orEmpty())

                        RegimenSectionBlock("运动锻炼", sec.exercise.orEmpty())

                    }

                }

            }

            if (!advice.isNullOrBlank()) {

                item { Text("融合建议：$advice") }

            }

            if (assessmentStep == AssessmentViewModel.STEP_COMPLETED) {

                item {

                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {

                        OutlinedButton(onClick = onGoSportPlan, modifier = Modifier.weight(1f)) { Text("查看运动计划") }

                        OutlinedButton(onClick = onGoSportCheckIn, modifier = Modifier.weight(1f)) { Text("运动打卡") }

                    }

                }

            }

        }

    }

    if (resumeDialogVisible) {

        AlertDialog(

            onDismissRequest = { },

            properties = DialogProperties(dismissOnBackPress = false, dismissOnClickOutside = false),

            title = { Text("检测到已有评估记录") },

            text = {

                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {

                    if (resumeChoiceBusy) {

                        Row(

                            Modifier.fillMaxWidth(),

                            horizontalArrangement = Arrangement.Center

                        ) {

                            CircularProgressIndicator(Modifier.padding(8.dp))

                        }

                        Text("正在加载上次评估与调理方案…")

                    } else {

                        Text(

                            "您已有一份完成的亚健康与体质综合评估。可选择「重新评估」清空本次填写并重新问卷，或「查看调理方案」直接浏览上次结果。首页推荐区已加载更多视频与食谱供挑选。"

                        )

                    }

                }

            },

            confirmButton = {

                TextButton(

                    onClick = { vm.startFreshAssessment() },

                    enabled = !resumeChoiceBusy

                ) { Text("重新评估") }

            },

            dismissButton = {

                TextButton(

                    onClick = { vm.loadLatestRegimenDisplay() },

                    enabled = !resumeChoiceBusy

                ) { Text("查看调理方案") }

            }

        )

    }

}



@Composable

private fun RegimenSectionBlock(title: String, items: List<RegimenPlanItemDto>) {

    if (items.isEmpty()) return

    Card(Modifier.fillMaxWidth().padding(top = 6.dp)) {

        Column(

            Modifier

                .fillMaxWidth()

                .padding(10.dp),

            verticalArrangement = Arrangement.spacedBy(6.dp)

        ) {

            Text(title, fontWeight = FontWeight.SemiBold)

            items.forEach { p ->

                Text("· ${p.name}", style = MaterialTheme.typography.titleSmall)

                Text(p.content, style = MaterialTheme.typography.bodySmall)

            }

        }

    }

}

