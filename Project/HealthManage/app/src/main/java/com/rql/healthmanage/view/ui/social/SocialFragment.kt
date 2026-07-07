package com.rql.healthmanage.view.ui.social

import android.net.Uri
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.CircleCrop
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.rql.healthmanage.R
import com.rql.healthmanage.databinding.FragmentSocialBinding
import com.rql.healthmanage.databinding.ItemSocialPostBinding
import com.rql.healthmanage.model.datasource.remote.RetrofitClient
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.UserInfoDto
import com.rql.healthmanage.util.MediaUploadHelper
import com.rql.healthmanage.viewmodel.social.SocialViewModel
import kotlinx.coroutines.launch

class SocialFragment : Fragment() {
    private var _binding: FragmentSocialBinding? = null
    private val binding get() = _binding!!
    private lateinit var vm: SocialViewModel
    private lateinit var postAdapter: SocialPostAdapter
    private var feedType = "recommend"
    private var sourcePosts: List<SocialPostDto> = emptyList()
    private var pendingPickUris: List<Uri> = emptyList()

    private val pickImages = registerForActivityResult(ActivityResultContracts.GetMultipleContents()) { uris ->
        pendingPickUris = uris
        publishDialogImageLabel?.text = if (uris.isEmpty()) "未选择图片" else "已选 ${uris.size} 张图片"
    }

    private var publishDialogImageLabel: TextView? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentSocialBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        vm = ViewModelProvider(this)[SocialViewModel::class.java]
        val lm = LinearLayoutManager(requireContext())
        binding.recycler.layoutManager = lm
        parentFragmentManager.setFragmentResultListener(PostDetailFragment.RESULT_REQUEST_KEY, viewLifecycleOwner) { _, b ->
            if (b.getBoolean(PostDetailFragment.BUNDLE_REFRESH_FEED, false)) {
                vm.refresh()
            }
        }

        postAdapter = SocialPostAdapter(
            onOpen = { post -> openDetail(post) },
            onLike = { post -> vm.toggleLike(post) },
            onComment = { post -> openCommentDialog(post.id) },
            onFollow = { post -> vm.toggleFollow(post.userId) }
        )
        binding.recycler.adapter = postAdapter
        binding.recycler.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(rv: RecyclerView, dx: Int, dy: Int) {
                if (dy <= 0) return
                val layoutManager = rv.layoutManager as? LinearLayoutManager ?: return
                val last = layoutManager.findLastVisibleItemPosition()
                val total = postAdapter.itemCount
                if (total > 0 && last >= total - 3) vm.loadMore()
            }
        })

        binding.tabFeed.addTab(binding.tabFeed.newTab().setText("关注动态"))
        binding.tabFeed.addTab(binding.tabFeed.newTab().setText("广场动态"), true)
        binding.tabFeed.addOnTabSelectedListener(object : com.google.android.material.tabs.TabLayout.OnTabSelectedListener {
            override fun onTabSelected(tab: com.google.android.material.tabs.TabLayout.Tab) {
                feedType = if (tab.position == 0) "follow" else "recommend"
                vm.feedType = feedType
                binding.etSearch.text?.clear()
                updateSearchUserButtonVisibility()
                vm.refresh()
            }

            override fun onTabUnselected(tab: com.google.android.material.tabs.TabLayout.Tab) = Unit
            override fun onTabReselected(tab: com.google.android.material.tabs.TabLayout.Tab) = Unit
        })

        binding.swipe.setOnRefreshListener {
            binding.etSearch.text?.clear()
            vm.refresh()
        }
        binding.fab.setOnClickListener { openPublishDialog() }
        binding.btnRecommendUsers.setOnClickListener { openSearchUsersDialog() }
        updateSearchUserButtonVisibility()
        binding.etSearch.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) = Unit
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) = Unit
            override fun afterTextChanged(s: Editable?) {
                renderFiltered()
            }
        })

        vm.posts.observe(viewLifecycleOwner) { posts ->
            sourcePosts = posts
            renderFiltered()
            binding.swipe.isRefreshing = false
        }
        vm.error.observe(viewLifecycleOwner) {
            binding.swipe.isRefreshing = false
            if (!it.isNullOrBlank()) Toast.makeText(requireContext(), it, Toast.LENGTH_SHORT).show()
        }
        vm.toast.observe(viewLifecycleOwner) {
            if (!it.isNullOrBlank()) Toast.makeText(requireContext(), it, Toast.LENGTH_SHORT).show()
        }
        vm.followingUserIds.observe(viewLifecycleOwner) { renderFiltered() }
        vm.refresh()
    }

    private fun renderFiltered() {
        postAdapter.submitFiltered(applySearchFilter(sourcePosts), vm.followingUserIds.value.orEmpty())
    }

    private fun applySearchFilter(posts: List<SocialPostDto>): List<SocialPostDto> {
        val keyword = binding.etSearch.text?.toString()?.trim().orEmpty()
        if (keyword.isBlank()) return posts
        return posts.filter {
            it.username.contains(keyword, ignoreCase = true) ||
                it.content.contains(keyword, ignoreCase = true) ||
                it.tags.orEmpty().any { tag -> tag.contains(keyword, ignoreCase = true) }
        }
    }

    private fun openDetail(post: SocialPostDto) {
        parentFragmentManager.beginTransaction()
            .replace(
                R.id.fragment_container,
                PostDetailFragment.newInstance(post.id)
            )
            .addToBackStack(null)
            .commit()
    }

    private fun openCommentDialog(postId: Int) {
        val input = EditText(requireContext()).apply { hint = "输入评论内容" }
        MaterialAlertDialogBuilder(requireContext())
            .setTitle("发表评论")
            .setView(input)
            .setNegativeButton("取消", null)
            .setPositiveButton("发送") { _, _ -> vm.comment(postId, input.text?.toString().orEmpty()) }
            .show()
    }

    private fun openPublishDialog() {
        pendingPickUris = emptyList()
        val inputContent = EditText(requireContext()).apply { hint = "动态文字" }
        val inputTopics = EditText(requireContext()).apply { hint = "话题标签，可留空，多个逗号分隔" }
        val btnPick = Button(requireContext()).apply { text = "选择图片" }
        val tvImages = TextView(requireContext()).apply {
            text = "未选择图片"
            setPadding(0, 8, 0, 8)
        }
        publishDialogImageLabel = tvImages
        btnPick.setOnClickListener { pickImages.launch("image/*") }
        val container = android.widget.LinearLayout(requireContext()).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            setPadding(32, 16, 32, 0)
            addView(inputContent)
            addView(btnPick)
            addView(tvImages)
            addView(inputTopics)
        }
        MaterialAlertDialogBuilder(requireContext())
            .setTitle("发布动态")
            .setView(container)
            .setNegativeButton("取消", null)
            .setPositiveButton("发布") { _, _ ->
                val tags = inputTopics.text?.toString().orEmpty()
                    .split(",")
                    .map { it.trim().removePrefix("#") }
                    .filter { it.isNotBlank() }
                    .takeIf { it.isNotEmpty() }
                val content = inputContent.text?.toString().orEmpty()
                lifecycleScope.launch {
                    val urls = if (pendingPickUris.isEmpty()) {
                        null
                    } else {
                        Toast.makeText(requireContext(), "正在上传图片…", Toast.LENGTH_SHORT).show()
                        MediaUploadHelper.uploadImages(requireContext(), pendingPickUris).takeIf { it.isNotEmpty() }
                    }
                    vm.publish(content, urls, tags)
                }
            }
            .show()
    }

    private fun updateSearchUserButtonVisibility() {
        binding.btnRecommendUsers.visibility = if (feedType == "follow") View.VISIBLE else View.GONE
    }

    private fun openSearchUsersDialog() {
        val input = EditText(requireContext()).apply {
            hint = "用户名或手机号"
            setSingleLine()
        }
        val padH = (48 * resources.displayMetrics.density).toInt()
        val padV = (12 * resources.displayMetrics.density).toInt()
        val container = android.widget.LinearLayout(requireContext()).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            setPadding(padH, padV, padH, padV)
            addView(
                input,
                android.widget.LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT
                )
            )
        }
        val dialog = MaterialAlertDialogBuilder(requireContext())
            .setTitle("搜索用户")
            .setView(container)
            .setNegativeButton("取消", null)
            .setPositiveButton("搜索", null)
            .create()
        dialog.setOnShowListener {
            dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
                val kw = input.text?.toString()?.trim().orEmpty()
                if (kw.isEmpty()) {
                    Toast.makeText(requireContext(), "请输入关键词", Toast.LENGTH_SHORT).show()
                    return@setOnClickListener
                }
                lifecycleScope.launch {
                    val res = runCatching { RetrofitClient.api.searchUsers(kw) }.getOrNull()
                    if (res == null) {
                        Toast.makeText(requireContext(), "网络异常", Toast.LENGTH_SHORT).show()
                        return@launch
                    }
                    if (res.code != 200) {
                        Toast.makeText(requireContext(), res.message ?: "搜索失败", Toast.LENGTH_SHORT).show()
                        return@launch
                    }
                    val users = res.data.orEmpty()
                    dialog.dismiss()
                    if (users.isEmpty()) {
                        Toast.makeText(requireContext(), "未找到用户", Toast.LENGTH_SHORT).show()
                    } else {
                        showUserSearchPickDialog(users)
                    }
                }
            }
        }
        dialog.show()
    }

    private fun showUserSearchPickDialog(users: List<UserInfoDto>) {
        val following = vm.followingUserIds.value.orEmpty()
        val labels = users.map { u ->
            val mark = if (following.contains(u.id)) "（已关注）" else ""
            "${u.username}（ID:${u.id}）$mark"
        }.toTypedArray()
        MaterialAlertDialogBuilder(requireContext())
            .setTitle("搜索结果")
            .setItems(labels) { _, which ->
                vm.toggleFollow(users[which].id)
            }
            .setNegativeButton("关闭", null)
            .show()
    }

    override fun onDestroyView() {
        publishDialogImageLabel = null
        _binding = null
        super.onDestroyView()
    }
}

private class SocialPostAdapter(
    private val onOpen: (SocialPostDto) -> Unit,
    private val onLike: (SocialPostDto) -> Unit,
    private val onComment: (SocialPostDto) -> Unit,
    private val onFollow: (SocialPostDto) -> Unit
) : RecyclerView.Adapter<SocialPostVH>() {
    private val items = mutableListOf<SocialPostDto>()
    private var following: Set<Int> = emptySet()

    fun submitFiltered(posts: List<SocialPostDto>, followingIds: Set<Int>) {
        following = followingIds
        items.clear()
        items.addAll(posts)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SocialPostVH {
        val b = ItemSocialPostBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return SocialPostVH(b, onOpen, onLike, onComment, onFollow)
    }

    override fun getItemCount() = items.size

    override fun onBindViewHolder(holder: SocialPostVH, position: Int) {
        holder.bind(items[position], following)
    }
}

private class SocialPostVH(
    private val b: ItemSocialPostBinding,
    private val onOpen: (SocialPostDto) -> Unit,
    private val onLike: (SocialPostDto) -> Unit,
    private val onComment: (SocialPostDto) -> Unit,
    private val onFollow: (SocialPostDto) -> Unit
) : RecyclerView.ViewHolder(b.root) {
    fun bind(item: SocialPostDto, following: Set<Int>) {
        b.tvName.text = item.username
        b.tvContent.text = item.content
        val avatarUrl = MediaUploadHelper.resolveUserAvatarUrl(item.userId, item.avatar)
        Glide.with(b.imgAvatar).load(avatarUrl).transform(CircleCrop()).into(b.imgAvatar)
        val image = item.images?.firstOrNull()
        if (!image.isNullOrBlank()) {
            b.imgPost.visibility = View.VISIBLE
            Glide.with(b.imgPost).load(MediaUploadHelper.resolveMediaUrl(image)).into(b.imgPost)
        } else {
            b.imgPost.visibility = View.GONE
        }
        b.btnLike.text = item.likeCount.toString()
        b.iconLike.setImageResource(
            if (item.isLiked) android.R.drawable.btn_star_big_on else android.R.drawable.btn_star_big_off
        )
        b.btnComment.text = "评论 ${item.commentCount}"
        b.btnFollow.text = if (following.contains(item.userId)) "已关注" else "关注"
        b.btnLike.setOnClickListener { onLike(item) }
        b.iconLike.setOnClickListener { onLike(item) }
        b.btnComment.setOnClickListener { onComment(item) }
        b.btnFollow.setOnClickListener { onFollow(item) }
        b.root.setOnClickListener { onOpen(item) }
    }
}

