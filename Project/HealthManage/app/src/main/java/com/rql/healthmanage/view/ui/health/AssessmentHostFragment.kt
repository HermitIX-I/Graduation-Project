package com.rql.healthmanage.view.ui.health

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.fragment.app.Fragment
import androidx.lifecycle.viewmodel.compose.viewModel
import com.rql.healthmanage.R
import com.rql.healthmanage.view.ui.main.MainActivity

class AssessmentHostFragment : Fragment() {
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        return ComposeView(requireContext()).apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                AssessmentQuestionnaireScreen(
                    vm = viewModel(viewModelStoreOwner = this@AssessmentHostFragment),
                    onBack = { parentFragmentManager.popBackStack() },
                    onCompleted = { parentFragmentManager.popBackStack() },
                    onGoHealthData = { openMainTab(R.id.nav_health) },
                    onGoSportPlan = { openMainTab(R.id.nav_sport) },
                    onGoSportCheckIn = { openMainTab(R.id.nav_sport) }
                )
            }
        }
    }

    private fun openMainTab(tabId: Int) {
        val main = activity as? MainActivity
        if (main != null) {
            parentFragmentManager.popBackStackImmediate()
            main.selectTab(tabId)
            return
        }
        val intent = Intent(requireContext(), MainActivity::class.java).apply {
            putExtra(MainActivity.EXTRA_INITIAL_TAB, tabId)
        }
        startActivity(intent)
        parentFragmentManager.popBackStack()
    }
}

