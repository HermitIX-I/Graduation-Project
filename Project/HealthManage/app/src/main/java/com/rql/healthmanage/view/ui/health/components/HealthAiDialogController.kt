package com.rql.healthmanage.view.ui.health.components

import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.rql.healthmanage.databinding.DialogHealthAiBinding
import com.rql.healthmanage.model.entity.AiAdviceRequestDto
import com.rql.healthmanage.viewmodel.health.HealthDataViewModel

/**
 * Owns the AI health analysis dialog UI and request wiring.
 */
class HealthAiDialogController(
    private val fragment: Fragment,
    private val vm: HealthDataViewModel
) {
    private companion object {
        const val INITIAL_ANALYZE_PROMPT =
            "请基于我的健康数据先做一次身体指标分析，并给出风险提示与可执行建议。"
    }

    private var aiDialog: AlertDialog? = null
    private var aiBinding: DialogHealthAiBinding? = null
    private var activeAiSummary: String? = null
    private var activeAiRecordTime: String? = null
    private var aiHistoryText: String = ""
    private var waitingAiReply = false
    private val pendingAiPlaceholder = "正在生成，请稍候..."

    fun dismiss() {
        aiDialog?.dismiss()
        aiDialog = null
        aiBinding = null
    }

    fun open(summary: String, recordTime: String, autoRequest: Boolean) {
        activeAiSummary = summary
        activeAiRecordTime = recordTime
        aiHistoryText = "本组数据：$summary"
        val dialogBinding = DialogHealthAiBinding.inflate(fragment.layoutInflater)
        aiBinding = dialogBinding
        dialogBinding.tvAiHistory.text = aiHistoryText
        aiDialog?.dismiss()
        aiDialog = MaterialAlertDialogBuilder(fragment.requireContext())
            .setTitle("AI 健康分析")
            .setView(dialogBinding.root)
            .setPositiveButton("发送", null)
            .setNegativeButton("关闭", null)
            .create().apply {
                setOnShowListener {
                    getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
                        val input = dialogBinding.etAiInput.text?.toString()?.trim().orEmpty()
                        if (input.isBlank()) {
                            Toast.makeText(fragment.requireContext(), "请输入想追问的问题", Toast.LENGTH_SHORT).show()
                            return@setOnClickListener
                        }
                        appendMessage("你", input)
                        showPendingAi()
                        dialogBinding.etAiInput.setText("")
                        vm.requestAiAdvice(
                            AiAdviceRequestDto(
                                recordsSummary = activeAiSummary,
                                latestRecordTime = activeAiRecordTime,
                                message = buildFollowUpMessage(input)
                            )
                        )
                    }
                }
                show()
            }
        if (autoRequest) {
            showPendingAi()
            vm.requestAiAdvice(
                AiAdviceRequestDto(
                    recordsSummary = summary,
                    latestRecordTime = recordTime,
                    message = INITIAL_ANALYZE_PROMPT
                )
            )
        }
    }

    fun appendMessage(role: String, content: String) {
        aiHistoryText += "\n\n$role：$content"
        aiBinding?.tvAiHistory?.text = aiHistoryText
    }

    fun showPendingAi() {
        waitingAiReply = true
        appendMessage("AI", pendingAiPlaceholder)
    }

    fun showAiReply(content: String) {
        if (waitingAiReply) {
            aiHistoryText = aiHistoryText.replace("AI：$pendingAiPlaceholder", "AI：$content")
            aiBinding?.tvAiHistory?.text = aiHistoryText
            waitingAiReply = false
            return
        }
        appendMessage("AI", content)
    }

    fun updateStreamingAi(content: String) {
        if (!waitingAiReply) return
        aiHistoryText = aiHistoryText.replace("AI：$pendingAiPlaceholder", "AI：$content")
        aiBinding?.tvAiHistory?.text = aiHistoryText
    }

    private fun buildFollowUpMessage(userInput: String): String {
        val contextTail = aiHistoryText
            .lines()
            .takeLast(6)
            .joinToString("\n")
        return buildString {
            append("请基于我的健康数据与以下对话上下文继续回答。\n")
            append("【对话上下文】\n")
            append(contextTail.takeLast(500))
            append("\n【用户最新问题】\n")
            append(userInput.take(180))
        }
    }
}
