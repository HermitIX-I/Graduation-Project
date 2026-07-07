package com.rql.healthmanage.util

import android.content.Context
import android.graphics.Typeface
import android.graphics.pdf.PdfDocument
import android.text.TextPaint
import com.rql.healthmanage.model.health.HealthRecordGroup
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * 将健康档案记录组导出为 A4 PDF（多页自动分页）。
 */
object HealthArchivePdfExporter {

    private const val PAGE_WIDTH = 595
    private const val PAGE_HEIGHT = 842
    private const val MARGIN_H = 48f
    private const val MARGIN_TOP = 56f
    private const val MARGIN_BOTTOM = 56f
    private const val LINE_SPACING = 6f

    fun exportToCacheFile(
        context: Context,
        groups: List<HealthRecordGroup>,
        filterDescription: String? = null
    ): File {
        val document = PdfDocument()
        val titlePaint = TextPaint().apply {
            isAntiAlias = true
            textSize = 20f
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
            color = 0xFF3D8B7E.toInt()
        }
        val metaPaint = TextPaint().apply {
            isAntiAlias = true
            textSize = 11f
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.NORMAL)
            color = 0xFF666666.toInt()
        }
        val bodyPaint = TextPaint().apply {
            isAntiAlias = true
            textSize = 12f
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.NORMAL)
            color = 0xFF222222.toInt()
        }
        val contentWidth = PAGE_WIDTH - MARGIN_H * 2
        var pageNumber = 1
        var pageInfo = PdfDocument.PageInfo.Builder(PAGE_WIDTH, PAGE_HEIGHT, pageNumber).create()
        var page = document.startPage(pageInfo)
        var canvas = page.canvas
        var y = MARGIN_TOP

        fun newPage() {
            document.finishPage(page)
            pageNumber++
            pageInfo = PdfDocument.PageInfo.Builder(PAGE_WIDTH, PAGE_HEIGHT, pageNumber).create()
            page = document.startPage(pageInfo)
            canvas = page.canvas
            y = MARGIN_TOP
        }

        fun ensureSpace(needed: Float) {
            if (y + needed > PAGE_HEIGHT - MARGIN_BOTTOM) {
                newPage()
            }
        }

        fun drawLine(text: String, paint: TextPaint, extraGap: Float = 0f) {
            val wrapped = wrapText(text, paint, contentWidth)
            for (line in wrapped) {
                val lineHeight = paint.fontSpacing + LINE_SPACING
                ensureSpace(lineHeight)
                canvas.drawText(line, MARGIN_H, y + paint.textSize, paint)
                y += lineHeight
            }
            y += extraGap
        }

        drawLine("个人健康数据档案", titlePaint, extraGap = 12f)
        drawLine(
            "导出时间：${SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA).format(Date())}",
            metaPaint
        )
        if (!filterDescription.isNullOrBlank()) {
            drawLine("筛选条件：$filterDescription", metaPaint)
        }
        drawLine("记录组数：${groups.size}，指标条数：${groups.sumOf { it.items.size }}", metaPaint, extraGap = 16f)

        if (groups.isEmpty()) {
            drawLine("当前筛选条件下暂无健康数据。", bodyPaint)
        } else {
            groups.forEachIndexed { idx, group ->
                ensureSpace(bodyPaint.fontSpacing * 3)
                drawLine("${idx + 1}. 记录时间：${group.recordTime}", bodyPaint, extraGap = 4f)
                group.items.forEach { item ->
                    val content = when (item.dataType) {
                        1 -> "身高 ${item.height ?: "-"} cm，体重 ${item.weight ?: "-"} kg"
                        2 -> "血压 ${item.systolic ?: "-"} / ${item.diastolic ?: "-"} mmHg"
                        3 -> "空腹血糖 ${item.fastingGlucose ?: "-"} mmol/L"
                        else -> "总胆固醇 ${item.totalCholesterol ?: "-"} mmol/L"
                    }
                    drawLine("    · $content", bodyPaint)
                }
                y += 8f
            }
        }

        val footerPaint = TextPaint(metaPaint).apply { textSize = 10f }
        val footer = "第 $pageNumber 页"
        canvas.drawText(
            footer,
            PAGE_WIDTH - MARGIN_H - footerPaint.measureText(footer),
            PAGE_HEIGHT - 32f,
            footerPaint
        )

        document.finishPage(page)

        val fileName = "health_archive_${SimpleDateFormat("yyyyMMdd_HHmmss", Locale.CHINA).format(Date())}.pdf"
        val outFile = File(context.cacheDir, fileName)
        document.writeTo(outFile.outputStream())
        document.close()
        return outFile
    }

    private fun wrapText(text: String, paint: TextPaint, maxWidth: Float): List<String> {
        if (text.isEmpty()) return listOf("")
        val lines = mutableListOf<String>()
        val line = StringBuilder()
        for (ch in text) {
            if (ch == '\n') {
                if (line.isNotEmpty()) lines.add(line.toString())
                line.clear()
                continue
            }
            val candidate = line.toString() + ch
            if (paint.measureText(candidate) > maxWidth && line.isNotEmpty()) {
                lines.add(line.toString())
                line.clear()
                line.append(ch)
            } else {
                line.append(ch)
            }
        }
        if (line.isNotEmpty()) lines.add(line.toString())
        return lines
    }
}
