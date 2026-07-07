package com.rql.healthmanage.view.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.media3.common.MediaItem
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView
import com.rql.healthmanage.databinding.FragmentVideoDetailBinding
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.util.MediaUploadHelper
import com.rql.healthmanage.viewmodel.home.HomeViewModel

class VideoDetailFragment : Fragment() {
    private var _binding: FragmentVideoDetailBinding? = null
    private val binding get() = _binding!!
    private var player: ExoPlayer? = null
    private var resumePlaybackAfterPause: Boolean = false
    private lateinit var vm: HomeViewModel
    private lateinit var video: VideoItemDto

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentVideoDetailBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        vm = ViewModelProvider(requireActivity())[HomeViewModel::class.java]
        val args = requireArguments()
        video = VideoItemDto(
            id = args.getInt("id"),
            title = args.getString("title").orEmpty(),
            cover = args.getString("cover").orEmpty(),
            url = args.getString("url").orEmpty(),
            tags = args.getString("tags"),
            viewCount = args.getInt("views"),
            isCollected = args.getBoolean("isCollected"),
        )
        binding.tvBack.setOnClickListener { parentFragmentManager.popBackStack() }
        binding.tvTitle.text = video.title
        binding.tvMeta.text = "播放 ${video.viewCount}  标签 ${video.tags.orEmpty()}"
        renderCollectButton()
        binding.btnCollect.setOnClickListener {
            vm.toggleVideoCollect(video.copy(isCollected = video.isCollected))
            video = video.copy(isCollected = !video.isCollected)
            renderCollectButton()
        }
        vm.toast.observe(viewLifecycleOwner) { msg ->
            if (!msg.isNullOrBlank()) {
                Toast.makeText(requireContext(), msg, Toast.LENGTH_SHORT).show()
                vm.consumeToast()
            }
        }
        binding.playerView.setShowBuffering(PlayerView.SHOW_BUFFERING_WHEN_PLAYING)
        val playUrl = MediaUploadHelper.resolveMediaUrl(video.url)
        player = ExoPlayer.Builder(requireContext()).build().apply {
            setMediaItem(MediaItem.fromUri(playUrl))
            prepare()
            playWhenReady = true
        }
        binding.playerView.player = player
    }

    private fun renderCollectButton() {
        binding.btnCollect.text = if (video.isCollected) "取消收藏" else "收藏"
    }

    override fun onPause() {
        player?.let { p ->
            resumePlaybackAfterPause = p.playWhenReady
            p.playWhenReady = false
        }
        super.onPause()
    }

    override fun onResume() {
        super.onResume()
        if (resumePlaybackAfterPause) {
            player?.playWhenReady = true
        }
    }

    override fun onDestroyView() {
        binding.playerView.player = null
        player?.release()
        player = null
        _binding = null
        super.onDestroyView()
    }

    companion object {
        fun newInstance(video: VideoItemDto): VideoDetailFragment {
            return VideoDetailFragment().apply {
                arguments = Bundle().apply {
                    putInt("id", video.id)
                    putString("title", video.title)
                    putString("cover", video.cover)
                    putString("url", video.url)
                    putString("tags", video.tags)
                    putInt("views", video.viewCount)
                    putBoolean("isCollected", video.isCollected)
                }
            }
        }
    }
}
