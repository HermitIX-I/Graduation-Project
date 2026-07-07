package com.rql.healthmanage.common

import android.app.Application
import android.content.Context
import com.rql.healthmanage.util.SPUtil
import com.rql.healthmanage.view.ui.sport.components.SportReminderScheduler

class MyApp : Application() {
    companion object {
        lateinit var context: Context
            private set
    }

    override fun onCreate() {
        super.onCreate()
        context = applicationContext
        SPUtil.init(this)
        SportReminderScheduler.restoreFromCache(this)
    }
}
