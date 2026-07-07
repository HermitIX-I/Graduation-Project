package com.rql.healthmanage.view.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.rql.healthmanage.R
import com.rql.healthmanage.databinding.FragmentRecipeListBinding
import com.rql.healthmanage.databinding.ItemRecipeCardBinding
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.viewmodel.home.HomeViewModel

class RecipeListFragment : Fragment() {
    private var _binding: FragmentRecipeListBinding? = null
    private val binding get() = _binding!!
    private lateinit var vm: HomeViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentRecipeListBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        vm = ViewModelProvider(requireActivity())[HomeViewModel::class.java]
        binding.rvList.layoutManager = GridLayoutManager(requireContext(), 2)
        binding.tvBack.setOnClickListener { parentFragmentManager.popBackStack() }
        vm.recipes.observe(viewLifecycleOwner) { list ->
            binding.rvList.adapter = RecipeListAdapter(list) { recipe ->
                parentFragmentManager.beginTransaction()
                    .replace(R.id.fragment_container, RecipeDetailFragment.newInstance(recipe))
                    .addToBackStack(null)
                    .commit()
            }
        }
        vm.loadRecipesForListPage()
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }
}

private class RecipeListAdapter(
    private val items: List<RecipeItemDto>,
    private val onClick: (RecipeItemDto) -> Unit
) : RecyclerView.Adapter<RecipeListVH>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecipeListVH {
        return RecipeListVH(ItemRecipeCardBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }
    override fun getItemCount() = items.size
    override fun onBindViewHolder(holder: RecipeListVH, position: Int) = holder.bind(items[position], onClick)
}

private class RecipeListVH(private val b: ItemRecipeCardBinding) : RecyclerView.ViewHolder(b.root) {
    fun bind(item: RecipeItemDto, onClick: (RecipeItemDto) -> Unit) {
        b.tvTitle.text = item.name
        b.tvSub.text = "浏览 ${item.viewCount}"
        Glide.with(b.imgCover).load(item.cover).into(b.imgCover)
        b.root.setOnClickListener { onClick(item) }
    }
}

