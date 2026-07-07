package com.rql.healthmanage.view.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.bumptech.glide.Glide
import com.rql.healthmanage.databinding.FragmentRecipeDetailBinding
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.util.MediaUploadHelper
import com.rql.healthmanage.viewmodel.home.HomeViewModel

class RecipeDetailFragment : Fragment() {
    private var _binding: FragmentRecipeDetailBinding? = null
    private val binding get() = _binding!!
    private lateinit var vm: HomeViewModel
    private lateinit var recipe: RecipeItemDto

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentRecipeDetailBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        vm = ViewModelProvider(requireActivity())[HomeViewModel::class.java]
        val args = requireArguments()
        recipe = RecipeItemDto(
            id = args.getInt("id"),
            name = args.getString("name").orEmpty(),
            cover = args.getString("cover").orEmpty(),
            ingredients = args.getString("ingredients").orEmpty(),
            steps = args.getString("steps").orEmpty(),
            tags = args.getString("tags"),
            suitableConstitution = args.getString("suitableConstitution"),
            viewCount = args.getInt("views"),
            isCollected = args.getBoolean("isCollected"),
        )
        binding.tvBack.setOnClickListener { parentFragmentManager.popBackStack() }
        binding.tvName.text = recipe.name
        binding.tvMeta.text = "浏览 ${recipe.viewCount}"
        binding.tvIngredients.text = "食材：${recipe.ingredients}"
        binding.tvSteps.text = "做法：${recipe.steps}"
        Glide.with(binding.imgCover).load(MediaUploadHelper.resolveMediaUrl(recipe.cover)).into(binding.imgCover)
        renderCollectButton()
        binding.btnCollect.setOnClickListener {
            vm.toggleRecipeCollect(recipe.copy(isCollected = recipe.isCollected))
            recipe = recipe.copy(isCollected = !recipe.isCollected)
            renderCollectButton()
        }
        vm.toast.observe(viewLifecycleOwner) { msg ->
            if (!msg.isNullOrBlank()) {
                Toast.makeText(requireContext(), msg, Toast.LENGTH_SHORT).show()
                vm.consumeToast()
            }
        }
    }

    private fun renderCollectButton() {
        binding.btnCollect.text = if (recipe.isCollected) "取消收藏" else "收藏"
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }

    companion object {
        fun newInstance(recipe: RecipeItemDto): RecipeDetailFragment {
            return RecipeDetailFragment().apply {
                arguments = Bundle().apply {
                    putInt("id", recipe.id)
                    putString("name", recipe.name)
                    putString("cover", recipe.cover)
                    putString("ingredients", recipe.ingredients)
                    putString("steps", recipe.steps)
                    putString("tags", recipe.tags)
                    putString("suitableConstitution", recipe.suitableConstitution)
                    putInt("views", recipe.viewCount)
                    putBoolean("isCollected", recipe.isCollected)
                }
            }
        }
    }
}
