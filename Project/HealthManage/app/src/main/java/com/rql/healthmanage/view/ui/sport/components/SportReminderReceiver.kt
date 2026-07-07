package com.rql.healthmanage.view.ui.sport.components

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.rql.healthmanage.R
import com.rql.healthmanage.view.ui.main.MainActivity

class SportReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val planId = intent.getIntExtra(EXTRA_PLAN_ID, 0)
        val hour = intent.getIntExtra(EXTRA_HOUR, 20).coerceIn(0, 23)
        val minute = intent.getIntExtra(EXTRA_MINUTE, 0).coerceIn(0, 59)
        val planTitle = intent.getStringExtra(EXTRA_PLAN_TITLE) ?: "运动计划"
        SportReminderScheduler.scheduleNext(context, planId, planTitle, hour, minute)

        ensureChannel(context)
        val title = intent.getStringExtra(EXTRA_TITLE) ?: "运动提醒"
        val body = intent.getStringExtra(EXTRA_BODY) ?: "该进行今日运动打卡了。"
        val openIntent = Intent(context, MainActivity::class.java)
        val pending = PendingIntent.getActivity(
            context,
            20001,
            openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setContentIntent(pending)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        NotificationManagerCompat.from(context).notify(planId + 9000, notification)
    }

    private fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (manager.getNotificationChannel(CHANNEL_ID) == null) {
            manager.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, "运动提醒", NotificationManager.IMPORTANCE_HIGH).apply {
                    description = "运动计划提醒通知"
                    enableVibration(true)
                }
            )
        }
    }

    companion object {
        const val CHANNEL_ID = "sport_reminder_channel_v2"
        const val EXTRA_PLAN_ID = "extra_plan_id"
        const val EXTRA_TITLE = "extra_title"
        const val EXTRA_PLAN_TITLE = "extra_plan_title"
        const val EXTRA_BODY = "extra_body"
        const val EXTRA_HOUR = "extra_hour"
        const val EXTRA_MINUTE = "extra_minute"
    }
}
