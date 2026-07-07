package com.rql.healthmanage.view.ui.home

import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.rql.healthmanage.R
import com.rql.healthmanage.databinding.FragmentHomeBinding
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.view.ui.health.AssessmentHostFragment
import com.rql.healthmanage.view.ui.social.PostDetailFragment
import com.rql.healthmanage.viewmodel.home.HomeViewModel

/**
 * Wires the home [FragmentHomeBinding] to [HomeViewModel] and list adapters.
 */
fun Fragment.bindHomeScreen(binding: FragmentHomeBinding, vm: HomeViewModel) {
    binding.rvVideos.layoutManager = GridLayoutManager(requireContext(), 2)
    binding.rvRecipes.layoutManager = GridLayoutManager(requireContext(), 2)
    binding.rvHotPosts.layoutManager = LinearLayoutManager(requireContext())
    binding.rvVideos.adapter = VideoAdapter(emptyList()) {}
    binding.rvRecipes.adapter = RecipeAdapter(emptyList()) {}
    binding.rvHotPosts.adapter = PostAdapter(emptyList()) {}

    binding.cardAssess.setOnClickListener {
        parentFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, AssessmentHostFragment())
            .addToBackStack(null)
            .commit()
    }
    binding.tvMoreVideos.setOnClickListener {
        parentFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, VideoListFragment())
            .addToBackStack(null)
            .commit()
    }
    binding.tvMoreRecipes.setOnClickListener {
        parentFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, RecipeListFragment())
            .addToBackStack(null)
            .commit()
    }
    binding.btnVideoSearch.setOnClickListener {
        vm.searchVideos(binding.etVideoSearch.text?.toString().orEmpty())
    }
    binding.etVideoSearch.setOnEditorActionListener { _, _, _ ->
        vm.searchVideos(binding.etVideoSearch.text?.toString().orEmpty())
        true
    }
    binding.btnRecipeSearch.setOnClickListener {
        vm.searchRecipes(binding.etRecipeSearch.text?.toString().orEmpty())
    }
    binding.etRecipeSearch.setOnEditorActionListener { _, _, _ ->
        vm.searchRecipes(binding.etRecipeSearch.text?.toString().orEmpty())
        true
    }

    fun renderAssessmentSummary() {
        val level = vm.subhealthLevelLabel.value
        val score = vm.subhealthTotalScore.value
        val constitution = vm.constitutionType.value
        binding.tvAssessSub.text = if (level != null && score != null) {
            "亚健康程度：$level（$score 分） | 体质：${constitution ?: "未知"}"
        } else {
            "开始问卷评估，获取调理建议"
        }
    }

    vm.notices.observe(viewLifecycleOwner) { binding.bannerPager.adapter = BannerAdapter(it) }
    vm.subhealthLevelLabel.observe(viewLifecycleOwner) { renderAssessmentSummary() }
    vm.constitutionType.observe(viewLifecycleOwner) { renderAssessmentSummary() }
    vm.subhealthTotalScore.observe(viewLifecycleOwner) { renderAssessmentSummary() }
    vm.videos.observe(viewLifecycleOwner) { list ->
        binding.rvVideos.adapter = VideoAdapter(list) { openHomeVideo(it) }
    }
    vm.recipes.observe(viewLifecycleOwner) { list ->
        binding.rvRecipes.adapter = RecipeAdapter(list) { openHomeRecipe(it) }
    }
    vm.hotPosts.observe(viewLifecycleOwner) { list ->
        binding.rvHotPosts.adapter = PostAdapter(list.take(10)) { openHomePost(it) }
    }
    parentFragmentManager.setFragmentResultListener(
        PostDetailFragment.RESULT_REQUEST_KEY,
        viewLifecycleOwner
    ) { _, b ->
        if (b.getBoolean(PostDetailFragment.BUNDLE_REFRESH_FEED, false)) {
            vm.refresh()
        }
    }
    binding.swipe.setOnRefreshListener { vm.refresh() }
    vm.loading.observe(viewLifecycleOwner) { binding.swipe.isRefreshing = it }
    vm.refresh()
}

private fun Fragment.openHomePost(post: SocialPostDto) {
    parentFragmentManager.beginTransaction()
        .replace(
            R.id.fragment_container,
            PostDetailFragment.newInstance(post.id)
        )
        .addToBackStack(null)
        .commit()
}

private fun Fragment.openHomeVideo(video: VideoItemDto) {
    parentFragmentManager.beginTransaction()
        .replace(
            R.id.fragment_container,
            VideoDetailFragment.newInstance(video)
        )
        .addToBackStack(null)
        .commit()
}

private fun Fragment.openHomeRecipe(recipe: RecipeItemDto) {
    parentFragmentManager.beginTransaction()
        .replace(
            R.id.fragment_container,
            RecipeDetailFragment.newInstance(recipe)
        )
        .addToBackStack(null)
        .commit()
}
