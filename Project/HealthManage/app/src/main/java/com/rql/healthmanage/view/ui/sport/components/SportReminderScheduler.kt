package com.rql.healthmanage.view.ui.sport.components

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.rql.healthmanage.model.entity.SportPlanDto
import com.rql.healthmanage.model.sport.displayTitle
import com.rql.healthmanage.model.sport.payloadForReminder
import com.rql.healthmanage.view.ui.main.MainActivity
import java.util.Calendar

object SportReminderScheduler {
    private const val PREFS_NAME = "sport_reminder_prefs"
    private const val KEY_ITEMS = "items"
    private val gson = Gson()

    private data class ReminderItem(
        val planId: Int,
        val title: String,
        val hour: Int,
        val minute: Int
    )

    fun sync(context: Context, plans: List<SportPlanDto>) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        loadCachedItems(context).forEach { cancelOne(context, alarmManager, it.planId) }
        plans.forEach { cancelOne(context, alarmManager, it.id) }
        val enabledItems = mutableListOf<ReminderItem>()
        plans.forEach { plan ->
            val payload = plan.payloadForReminder() ?: return@forEach
            if (!payload.remindEnabled) return@forEach
            val (hour, minute) = parseTime(payload.remindTime ?: "20:00")
            val title = plan.displayTitle()
            enabledItems += ReminderItem(plan.id, title, hour, minute)
            scheduleNext(context, plan.id, title, hour, minute)
        }
        saveCachedItems(context, enabledItems)
    }

    fun restoreFromCache(context: Context) {
        val items = loadCachedItems(context)
        items.forEach { item ->
            scheduleNext(context, item.planId, item.title, item.hour, item.minute)
        }
    }

    fun scheduleNext(context: Context, planId: Int, title: String, hour: Int, minute: Int) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val triggerAt = nextTriggerAt(hour, minute)
        val pending = pending(context, planId, title, hour, minute)
        val showPending = PendingIntent.getActivity(
            context,
            21000 + planId,
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        // API 31+：无精确闹钟权限时 setAlarmClock 会抛 SecurityException
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmManager.canScheduleExactAlarms()) {
            alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAt, pending)
            return
        }
        try {
            alarmManager.setAlarmClock(
                AlarmManager.AlarmClockInfo(triggerAt, showPending),
                pending
            )
        } catch (_: SecurityException) {
            alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAt, pending)
        }
    }

    private fun cancelOne(context: Context, alarmManager: AlarmManager, planId: Int) {
        alarmManager.cancel(pending(context, planId, null, 0, 0))
    }

    private fun pending(context: Context, planId: Int, title: String?, hour: Int, minute: Int): PendingIntent {
        val i = Intent(context, SportReminderReceiver::class.java).apply {
            putExtra(SportReminderReceiver.EXTRA_PLAN_ID, planId)
            putExtra(SportReminderReceiver.EXTRA_TITLE, "运动计划提醒")
            if (!title.isNullOrBlank()) putExtra(SportReminderReceiver.EXTRA_PLAN_TITLE, title)
            if (!title.isNullOrBlank()) putExtra(SportReminderReceiver.EXTRA_BODY, "请完成「$title」今日打卡。")
            putExtra(SportReminderReceiver.EXTRA_HOUR, hour)
            putExtra(SportReminderReceiver.EXTRA_MINUTE, minute)
        }
        return PendingIntent.getBroadcast(
            context,
            7000 + planId,
            i,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun parseTime(raw: String): Pair<Int, Int> {
        val parts = raw.split(":")
        val h = parts.getOrNull(0)?.toIntOrNull()?.coerceIn(0, 23) ?: 20
        val m = parts.getOrNull(1)?.toIntOrNull()?.coerceIn(0, 59) ?: 0
        return h to m
    }

    private fun nextTriggerAt(hour: Int, minute: Int): Long {
        val now = Calendar.getInstance()
        val c = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        if (c.timeInMillis <= now.timeInMillis) c.add(Calendar.DAY_OF_MONTH, 1)
        return c.timeInMillis
    }

    private fun saveCachedItems(context: Context, items: List<ReminderItem>) {
        val json = gson.toJson(items)
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(KEY_ITEMS, json)
            .apply()
    }

    private fun loadCachedItems(context: Context): List<ReminderItem> {
        val json = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).getString(KEY_ITEMS, null)
            ?: return emptyList()
        return runCatching {
            val type = object : TypeToken<List<ReminderItem>>() {}.type
            gson.fromJson<List<ReminderItem>>(json, type).orEmpty()
        }.getOrDefault(emptyList())
    }
}
