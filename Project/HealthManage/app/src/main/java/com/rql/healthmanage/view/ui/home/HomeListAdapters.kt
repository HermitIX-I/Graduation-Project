package com.rql.healthmanage.view.ui.home

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.rql.healthmanage.databinding.ItemBannerNoticeBinding
import com.rql.healthmanage.databinding.ItemPostPreviewBinding
import com.rql.healthmanage.databinding.ItemRecipeCardBinding
import com.rql.healthmanage.databinding.ItemVideoCardBinding
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.SystemNoticeDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.util.MediaUploadHelper

class BannerAdapter(private val items: List<SystemNoticeDto>) : RecyclerView.Adapter<BannerVH>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BannerVH {
        return BannerVH(ItemBannerNoticeBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }
    override fun getItemCount() = if (items.isEmpty()) 1 else items.size
    override fun onBindViewHolder(holder: BannerVH, position: Int) = holder.bind(items.getOrNull(position))
}

class BannerVH(private val b: ItemBannerNoticeBinding) : RecyclerView.ViewHolder(b.root) {
    fun bind(item: SystemNoticeDto?) {
        b.tvBannerTitle.text = item?.title ?: "暂无公告"
        b.tvBannerSub.text = item?.content ?: "系统暂无最新通知"
    }
}

class VideoAdapter(private val items: List<VideoItemDto>, private val onClick: (VideoItemDto) -> Unit) :
    RecyclerView.Adapter<VideoVH>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VideoVH {
        return VideoVH(ItemVideoCardBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }
    override fun getItemCount() = items.size
    override fun onBindViewHolder(holder: VideoVH, position: Int) = holder.bind(items[position], onClick)
}

class VideoVH(private val b: ItemVideoCardBinding) : RecyclerView.ViewHolder(b.root) {
    fun bind(item: VideoItemDto, onClick: (VideoItemDto) -> Unit) {
        b.tvTitle.text = item.title
        b.tvMeta.text = "播放 ${item.viewCount}"
        Glide.with(b.imgCover).load(MediaUploadHelper.resolveMediaUrl(item.cover.ifBlank { item.url })).into(b.imgCover)
        b.root.setOnClickListener { onClick(item) }
    }
}

class RecipeAdapter(private val items: List<RecipeItemDto>, private val onClick: (RecipeItemDto) -> Unit) :
    RecyclerView.Adapter<RecipeVH>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecipeVH {
        return RecipeVH(ItemRecipeCardBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }
    override fun getItemCount() = items.size
    override fun onBindViewHolder(holder: RecipeVH, position: Int) = holder.bind(items[position], onClick)
}

class RecipeVH(private val b: ItemRecipeCardBinding) : RecyclerView.ViewHolder(b.root) {
    fun bind(item: RecipeItemDto, onClick: (RecipeItemDto) -> Unit) {
        b.tvTitle.text = item.name
        b.tvSub.text = "浏览 ${item.viewCount}"
        Glide.with(b.imgCover).load(MediaUploadHelper.resolveMediaUrl(item.cover)).into(b.imgCover)
        b.root.setOnClickListener { onClick(item) }
    }
}

class PostAdapter(private val items: List<SocialPostDto>, private val onClick: (SocialPostDto) -> Unit) :
    RecyclerView.Adapter<PostVH>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PostVH {
        return PostVH(ItemPostPreviewBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }
    override fun getItemCount() = items.size
    override fun onBindViewHolder(holder: PostVH, position: Int) = holder.bind(items[position], onClick)
}

class PostVH(private val b: ItemPostPreviewBinding) : RecyclerView.ViewHolder(b.root) {
    fun bind(item: SocialPostDto, onClick: (SocialPostDto) -> Unit) {
        val avatarUrl = MediaUploadHelper.resolveUserAvatarUrl(item.userId, item.avatar)
        Glide.with(b.imgAvatar).load(avatarUrl).circleCrop().into(b.imgAvatar)
        b.tvName.text = item.username
        b.tvContent.text = item.content
        b.tvMeta.text = "点赞 ${item.likeCount}  评论 ${item.commentCount}"
        b.root.setOnClickListener { onClick(item) }
    }
}
