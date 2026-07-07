package com.rql.healthmanage.view.ui.sport.components

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class SportReminderBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action.orEmpty()
        if (action == Intent.ACTION_BOOT_COMPLETED || action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            SportReminderScheduler.restoreFromCache(context)
        }
    }
}
