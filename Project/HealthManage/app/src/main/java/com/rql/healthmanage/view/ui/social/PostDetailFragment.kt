package com.rql.healthmanage.view.ui.social

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.bumptech.glide.Glide
import com.rql.healthmanage.databinding.FragmentPostDetailBinding
import com.rql.healthmanage.databinding.ItemSocialCommentBinding
import com.rql.healthmanage.model.entity.SocialCommentDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.util.MediaUploadHelper
import com.rql.healthmanage.viewmodel.social.PostDetailViewModel

class PostDetailFragment : Fragment() {
    private var _binding: FragmentPostDetailBinding? = null
    private val binding get() = _binding!!
    private lateinit var vm: PostDetailViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentPostDetailBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        vm = ViewModelProvider(this)[PostDetailViewModel::class.java]
        binding.btnBackSocial.setOnClickListener { parentFragmentManager.popBackStack() }
        binding.rvComments.layoutManager = LinearLayoutManager(requireContext())

        val postId = arguments?.getInt(ARG_POST_ID) ?: 0

        vm.post.observe(viewLifecycleOwner) { bindPost(it) }
        vm.status.observe(viewLifecycleOwner) { binding.tvStatus.text = it }
        vm.comments.observe(viewLifecycleOwner) { binding.rvComments.adapter = CommentAdapter(it) }
        vm.error.observe(viewLifecycleOwner) { msg ->
            if (!msg.isNullOrBlank()) Toast.makeText(requireContext(), msg, Toast.LENGTH_SHORT).show()
        }
        vm.needsParentFeedRefresh.observe(viewLifecycleOwner) { need ->
            if (need == true) {
                parentFragmentManager.setFragmentResult(
                    RESULT_REQUEST_KEY,
                    bundleOf(BUNDLE_REFRESH_FEED to true)
                )
                vm.consumeParentFeedRefresh()
            }
        }

        binding.iconPostLike.setOnClickListener { vm.toggleParentLike() }
        binding.tvPostLike.setOnClickListener { vm.toggleParentLike() }
        binding.iconPostCollect.setOnClickListener { vm.toggleParentCollect() }
        binding.tvPostCollect.setOnClickListener { vm.toggleParentCollect() }
        val scrollToComments = {
            if (binding.rvComments.adapter != null && binding.rvComments.adapter!!.itemCount > 0) {
                binding.rvComments.smoothScrollToPosition(0)
            } else {
                Toast.makeText(requireContext(), "暂无评论", Toast.LENGTH_SHORT).show()
            }
        }
        binding.iconPostComment.setOnClickListener { scrollToComments() }
        binding.btnPostComment.setOnClickListener { scrollToComments() }

        vm.loadPost(postId)
        vm.loadComments(postId)
    }

    private fun bindPost(p: SocialPostDto?) {
        if (p == null) {
            binding.tvName.text = "加载中…"
            binding.tvContent.text = ""
            return
        }
        binding.tvName.text = if (p.username.isBlank()) "用户" else p.username
        binding.tvContent.text = if (p.content.isBlank()) "暂无内容" else p.content
        val url = MediaUploadHelper.resolveUserAvatarUrl(p.userId, p.avatar)
        Glide.with(binding.imgAvatar).load(url).circleCrop().into(binding.imgAvatar)
        binding.tvPostLike.text = p.likeCount.toString()
        binding.iconPostLike.setImageResource(
            if (p.isLiked) android.R.drawable.btn_star_big_on else android.R.drawable.btn_star_big_off
        )
        binding.btnPostComment.text = "评论 ${p.commentCount}"
        binding.tvPostCollect.text = if (p.isCollected) "已收藏" else "收藏"
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }

    companion object {
        const val RESULT_REQUEST_KEY = "post_detail"
        const val BUNDLE_REFRESH_FEED = "refresh_feed"

        private const val ARG_POST_ID = "post_id"

        fun newInstance(postId: Int): PostDetailFragment =
            PostDetailFragment().apply {
                arguments = Bundle().apply {
                    putInt(ARG_POST_ID, postId)
                }
            }
    }
}

private class CommentAdapter(private val items: List<SocialCommentDto>) :
    androidx.recyclerview.widget.RecyclerView.Adapter<CommentVH>() {
    private val liked = mutableSetOf<Int>()
    private val likeCount = mutableMapOf<Int, Int>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CommentVH {
        val b = ItemSocialCommentBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return CommentVH(b)
    }

    override fun getItemCount() = items.size

    override fun onBindViewHolder(holder: CommentVH, position: Int) =
        holder.bind(
            item = items[position],
            isLiked = liked.contains(items[position].id),
            likes = likeCount[items[position].id] ?: 0,
            onToggleLike = { id ->
                if (liked.contains(id)) {
                    liked.remove(id)
                    likeCount[id] = (likeCount[id] ?: 1) - 1
                } else {
                    liked.add(id)
                    likeCount[id] = (likeCount[id] ?: 0) + 1
                }
                notifyDataSetChanged()
            }
        )
}

private class CommentVH(private val b: ItemSocialCommentBinding) : androidx.recyclerview.widget.RecyclerView.ViewHolder(b.root) {
    fun bind(
        item: SocialCommentDto,
        isLiked: Boolean,
        likes: Int,
        onToggleLike: (Int) -> Unit
    ) {
        b.tvUser.text = item.username
        b.tvContent.text = item.content
        b.btnCommentLike.text = if (isLiked) "已点赞 $likes" else "点赞 $likes"
        b.btnCommentLike.setOnClickListener { onToggleLike(item.id) }
    }
}
