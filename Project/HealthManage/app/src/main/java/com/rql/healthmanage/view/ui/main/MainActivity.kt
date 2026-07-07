package com.rql.healthmanage.view.ui.main

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.rql.healthmanage.R
import com.rql.healthmanage.databinding.ActivityMainBinding
import com.rql.healthmanage.util.SPUtil
import com.rql.healthmanage.view.ui.auth.LoginActivity
import com.rql.healthmanage.view.ui.health.HealthDataFragment
import com.rql.healthmanage.view.ui.home.HomeFragment
import com.rql.healthmanage.view.ui.social.SocialFragment
import com.rql.healthmanage.view.ui.sport.ExerciseFragment

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (SPUtil.getString("token").isBlank()) {
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
            return
        }
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        requestNotificationPermissionIfNeeded()

        val initialTab = if (savedInstanceState != null) {
            savedInstanceState.getInt(STATE_SELECTED_TAB, R.id.nav_home)
        } else {
            intent.getIntExtra(EXTRA_INITIAL_TAB, R.id.nav_home)
        }
        binding.bottomNav.selectedItemId = initialTab
        switchTab(initialTab)

        binding.bottomNav.setOnItemSelectedListener { item ->
            switchTab(item.itemId)
            true
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt(STATE_SELECTED_TAB, binding.bottomNav.selectedItemId)
    }

    fun selectTab(tabId: Int) {
        binding.bottomNav.selectedItemId = tabId
        switchTab(tabId)
    }

    private fun switchTab(itemId: Int) {
        val fm = supportFragmentManager
        // 首页等通过 replace+addToBackStack 压上的评估/详情等仍在同一 fragment_container 内，
        // 若不先出栈，会与 Tab Fragment 并存且仍可见，造成界面叠层（用户看到的「浮动」）。
        fm.executePendingTransactions()
        while (fm.backStackEntryCount > 0) {
            fm.popBackStackImmediate()
        }
        val tag = fragmentTagFor(itemId)
        val tx = fm.beginTransaction()
        TAB_TAGS.forEach { t ->
            fm.findFragmentByTag(t)?.let { tx.hide(it) }
        }
        var fragment = fm.findFragmentByTag(tag)
        if (fragment == null) {
            fragment = newTabFragment(itemId)
            tx.add(R.id.fragment_container, fragment, tag)
        } else {
            tx.show(fragment)
        }
        tx.commit()
    }

    private fun newTabFragment(itemId: Int): Fragment = when (itemId) {
        R.id.nav_health -> HealthDataFragment()
        R.id.nav_sport -> ExerciseFragment()
        R.id.nav_social -> SocialFragment()
        R.id.nav_mine -> MineFragment()
        else -> HomeFragment()
    }

    private fun fragmentTagFor(itemId: Int): String = when (itemId) {
        R.id.nav_health -> TAG_HEALTH
        R.id.nav_sport -> TAG_SPORT
        R.id.nav_social -> TAG_SOCIAL
        R.id.nav_mine -> TAG_MINE
        else -> TAG_HOME
    }

    private fun requestNotificationPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) return
        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1002)
    }

    companion object {
        /** 从其它页面跳转时传入 [R.id.nav_health] 等 */
        const val EXTRA_INITIAL_TAB = "extra_initial_tab"
        private const val STATE_SELECTED_TAB = "state_selected_tab"

        private const val TAG_HOME = "main_tab_home"
        private const val TAG_HEALTH = "main_tab_health"
        private const val TAG_SPORT = "main_tab_sport"
        private const val TAG_SOCIAL = "main_tab_social"
        private const val TAG_MINE = "main_tab_mine"

        private val TAB_TAGS = arrayOf(TAG_HOME, TAG_HEALTH, TAG_SPORT, TAG_SOCIAL, TAG_MINE)
    }
}
