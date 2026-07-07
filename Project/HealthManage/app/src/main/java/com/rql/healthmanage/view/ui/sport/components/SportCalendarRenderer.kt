package com.rql.healthmanage.view.ui.sport.components

import android.graphics.Color
import android.util.TypedValue
import android.widget.LinearLayout
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.rql.healthmanage.R
import com.rql.healthmanage.model.entity.SportRecordDto
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

private val dayFmt = SimpleDateFormat("yyyy-MM-dd", Locale.CHINA)

fun Fragment.renderSportCalendar(container: LinearLayout, records: List<SportRecordDto>) {
    container.removeAllViews()
    val checkDays = records.map { it.recordDate }.toSet()
    val dp4 = (4 * resources.displayMetrics.density).toInt()
    val dp8 = (8 * resources.displayMetrics.density).toInt()
    for (offset in 0 until 28) {
        val cal = Calendar.getInstance().apply { add(Calendar.DAY_OF_MONTH, -(27 - offset)) }
        val ds = dayFmt.format(cal.time)
        val tv = TextView(requireContext()).apply {
            text = "${cal.get(Calendar.MONTH) + 1}/${cal.get(Calendar.DAY_OF_MONTH)}\n${if (checkDays.contains(ds)) "✓" else ""}"
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 11f)
            setPadding(dp8, dp8, dp8, dp8)
            layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT).apply {
                marginEnd = dp4
            }
            if (checkDays.contains(ds)) {
                setBackgroundColor(requireContext().getColor(R.color.health_primary))
                setTextColor(Color.WHITE)
            }
        }
        container.addView(tv)
    }
}
