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
import com.rql.healthmanage.databinding.FragmentVideoListBinding
import com.rql.healthmanage.databinding.ItemVideoCardBinding
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.viewmodel.home.HomeViewModel

class VideoListFragment : Fragment() {
    private var _binding: FragmentVideoListBinding? = null
    private val binding get() = _binding!!
    private lateinit var vm: HomeViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentVideoListBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        vm = ViewModelProvider(requireActivity())[HomeViewModel::class.java]
        binding.rvList.layoutManager = GridLayoutManager(requireContext(), 2)
        binding.tvBack.setOnClickListener { parentFragmentManager.popBackStack() }
        vm.videos.observe(viewLifecycleOwner) { list ->
            binding.rvList.adapter = VideoListAdapter(list) { video ->
                parentFragmentManager.beginTransaction()
                    .replace(R.id.fragment_container, VideoDetailFragment.newInstance(video))
                    .addToBackStack(null)
                    .commit()
            }
        }
        vm.loadVideosForListPage()
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }
}

private class VideoListAdapter(
    private val items: List<VideoItemDto>,
    private val onClick: (VideoItemDto) -> Unit
) : RecyclerView.Adapter<VideoListVH>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VideoListVH {
        return VideoListVH(ItemVideoCardBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }
    override fun getItemCount() = items.size
    override fun onBindViewHolder(holder: VideoListVH, position: Int) = holder.bind(items[position], onClick)
}

private class VideoListVH(private val b: ItemVideoCardBinding) : RecyclerView.ViewHolder(b.root) {
    fun bind(item: VideoItemDto, onClick: (VideoItemDto) -> Unit) {
        b.tvTitle.text = item.title
        b.tvMeta.text = "播放 ${item.viewCount}"
        Glide.with(b.imgCover).load(item.cover.ifBlank { item.url }).into(b.imgCover)
        b.root.setOnClickListener { onClick(item) }
    }
}

