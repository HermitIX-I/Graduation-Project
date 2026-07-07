package com.rql.healthmanage.view.ui.main

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.rql.healthmanage.databinding.ActivityMineDetailBinding
import com.rql.healthmanage.databinding.ItemMineManageRowBinding
import com.rql.healthmanage.model.entity.HealthDataItemDto
import com.rql.healthmanage.model.entity.SocialCommentDto
import com.rql.healthmanage.model.entity.SocialPostDto
import com.rql.healthmanage.model.entity.VideoItemDto
import com.rql.healthmanage.model.entity.RecipeItemDto
import com.rql.healthmanage.util.SPUtil
import com.rql.healthmanage.view.ui.auth.LoginActivity
import com.rql.healthmanage.viewmodel.main.MineDetailViewModel

class MineDetailActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMineDetailBinding
    private lateinit var vm: MineDetailViewModel
    private lateinit var section: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMineDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)
        vm = ViewModelProvider(this)[MineDetailViewModel::class.java]
        section = intent.getStringExtra(EXTRA_SECTION).orEmpty()
        binding.tvTitle.text = intent.getStringExtra(EXTRA_TITLE).orEmpty()
        binding.btnBack.setOnClickListener { finish() }

        binding.btnSave.setOnClickListener { onSaveClicked() }
        binding.btnChangePassword.setOnClickListener { showChangePasswordDialog() }

        vm.toast.observe(this) { t ->
            if (!t.isNullOrBlank()) {
                Toast.makeText(this, t, Toast.LENGTH_SHORT).show()
                vm.clearToast()
            }
        }
        vm.error.observe(this) { e ->
            if (!e.isNullOrBlank()) {
                Toast.makeText(this, e, Toast.LENGTH_SHORT).show()
                vm.clearError()
            }
        }
        vm.mustRelogin.observe(this) { need ->
            if (need != true) return@observe
            vm.consumeMustRelogin()
            clearLocalSession()
            startActivity(
                Intent(this, LoginActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            )
            finishAffinity()
        }

        when (section) {
            SECTION_PROFILE -> setupProfile()
            SECTION_HEALTH -> setupHealth()
            SECTION_POSTS -> setupPosts()
            SECTION_COMMENTS -> setupComments()
            SECTION_COLLECTIONS -> setupCollections()
            else -> {
                binding.tvHint.text = "未知模块"
                binding.scrollForm.visibility = View.VISIBLE
            }
        }
    }

    private fun clearLocalSession() {
        SPUtil.putString("token", "")
        SPUtil.putBoolean("is_login", false)
        SPUtil.putString("user_name", "")
        SPUtil.putString("saved_login_password", "")
        SPUtil.putString("saved_login_account", "")
        SPUtil.putBoolean("remember_password", false)
    }

    private fun setupProfile() {
        binding.scrollForm.visibility = View.VISIBLE
        binding.sectionProfile.visibility = View.VISIBLE
        binding.btnSave.visibility = View.VISIBLE
        binding.btnChangePassword.visibility = View.VISIBLE
        binding.tvHint.text = "修改后点击保存。修改密码成功后将退出并需重新登录。"
        vm.loadUser()
        vm.user.observe(this) { u ->
            if (u == null) return@observe
            binding.etEmail.setText(u.email.orEmpty())
            when (u.gender) {
                1 -> binding.rbMale.isChecked = true
                0 -> binding.rbFemale.isChecked = true
                else -> binding.rbFemale.isChecked = true
            }
            binding.etAvatar.setText(u.avatar.orEmpty())
            binding.etAge.setText(u.age?.toString().orEmpty())
        }
    }

    private fun setupHealth() {
        binding.scrollForm.visibility = View.VISIBLE
        binding.sectionHealth.visibility = View.VISIBLE
        binding.btnSave.visibility = View.VISIBLE
        binding.tvHint.text = "以下为最近一次各类型记录预填，修改后点保存将更新原记录（非重复新增）。"
        vm.loadHealthRows()
        vm.healthRows.observe(this) { rows -> applyHealthPrefill(rows) }
    }

    private fun applyHealthPrefill(rows: List<HealthDataItemDto>) {
        val sorted = rows.sortedByDescending { it.recordTime }
        sorted.firstOrNull { it.dataType == 1 }?.let {
            binding.etHeight.setText(it.height?.toString().orEmpty())
            binding.etWeight.setText(it.weight?.toString().orEmpty())
        }
        sorted.firstOrNull { it.dataType == 2 }?.let {
            binding.etSystolic.setText(it.systolic?.toString().orEmpty())
            binding.etDiastolic.setText(it.diastolic?.toString().orEmpty())
        }
        sorted.firstOrNull { it.dataType == 3 }?.let {
            binding.etGlucose.setText(it.fastingGlucose?.toString().orEmpty())
        }
        sorted.firstOrNull { it.dataType == 4 }?.let {
            binding.etCholesterol.setText(it.totalCholesterol?.toString().orEmpty())
        }
    }

    private fun setupPosts() {
        binding.recycler.visibility = View.VISIBLE
        binding.tvHint.text = "我的动态：点击编辑或删除。"
        vm.loadUser()
        vm.user.observe(this) { u ->
            val uid = u?.id ?: return@observe
            vm.loadMyPosts(uid)
        }
        vm.myPosts.observe(this) { posts ->
            binding.recycler.layoutManager = LinearLayoutManager(this)
            binding.recycler.adapter = PostAdapter(posts, { post -> editPostDialog(post) }, { post -> confirmDeletePost(post) })
        }
    }

    private fun setupComments() {
        binding.recycler.visibility = View.VISIBLE
        binding.tvHint.text = "我的评论：可编辑文字或删除。"
        vm.loadMyComments()
        vm.myComments.observe(this) { list ->
            binding.recycler.layoutManager = LinearLayoutManager(this)
            binding.recycler.adapter = CommentAdapter(list, { c -> editCommentDialog(c) }, { c -> confirmDeleteComment(c) })
        }
    }

    private fun setupCollections() {
        binding.recycler.visibility = View.VISIBLE
        binding.tvHint.text = "我的收藏：取消收藏后从列表移除。"
        vm.loadCollections()
        vm.videos.observe(this) { rebuildCollectionAdapter() }
        vm.recipes.observe(this) { rebuildCollectionAdapter() }
    }

    private fun rebuildCollectionAdapter() {
        val v = vm.videos.value.orEmpty()
        val r = vm.recipes.value.orEmpty()
        val rows = mutableListOf<CollectionRow>()
        v.forEach { rows += CollectionRow.VideoRow(it) }
        r.forEach { rows += CollectionRow.RecipeRow(it) }
        binding.recycler.layoutManager = LinearLayoutManager(this)
        binding.recycler.adapter = CollectionAdapter(rows, { id -> vm.uncollectVideo(id) }, { id -> vm.uncollectRecipe(id) })
    }

    private fun onSaveClicked() {
        when (section) {
            SECTION_PROFILE -> {
                val email = binding.etEmail.text?.toString()?.trim().orEmpty()
                if (email.isBlank()) {
                    Toast.makeText(this, "请填写邮箱", Toast.LENGTH_SHORT).show()
                    return
                }
                if (!binding.rbMale.isChecked && !binding.rbFemale.isChecked) {
                    Toast.makeText(this, "请选择性别", Toast.LENGTH_SHORT).show()
                    return
                }
                val gender = if (binding.rbMale.isChecked) 1 else 0
                val avatar = binding.etAvatar.text?.toString()?.trim().orEmpty()
                val age = binding.etAge.text?.toString()?.toIntOrNull()
                vm.saveProfile(email, gender, avatar.ifBlank { null }, age)
            }
            SECTION_HEALTH -> {
                val h = binding.etHeight.text?.toString()?.toDoubleOrNull()
                val w = binding.etWeight.text?.toString()?.toDoubleOrNull()
                val sys = binding.etSystolic.text?.toString()?.toIntOrNull()
                val dia = binding.etDiastolic.text?.toString()?.toIntOrNull()
                val g = binding.etGlucose.text?.toString()?.toDoubleOrNull()
                val c = binding.etCholesterol.text?.toString()?.toDoubleOrNull()
                if (h == null || w == null || sys == null || dia == null || g == null || c == null) {
                    Toast.makeText(this, "请完整填写身高、体重、血压、空腹血糖与总胆固醇", Toast.LENGTH_SHORT).show()
                    return
                }
                vm.saveHealthBatch(h, w, sys, dia, g, c)
            }
        }
    }

    private fun showChangePasswordDialog() {
        val oldPwd = EditText(this).apply { hint = "原密码" }
        val newPwd = EditText(this).apply { hint = "新密码（≥6位）"; inputType = android.text.InputType.TYPE_CLASS_TEXT or android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD }
        val confirm = EditText(this).apply { hint = "确认新密码"; inputType = android.text.InputType.TYPE_CLASS_TEXT or android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD }
        val box = android.widget.LinearLayout(this).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            setPadding(48, 16, 48, 0)
            addView(oldPwd)
            addView(newPwd)
            addView(confirm)
        }
        MaterialAlertDialogBuilder(this)
            .setTitle("修改密码")
            .setView(box)
            .setNegativeButton("取消", null)
            .setPositiveButton("确定") { _, _ ->
                val o = oldPwd.text?.toString().orEmpty()
                val n = newPwd.text?.toString().orEmpty()
                val c = confirm.text?.toString().orEmpty()
                if (o.isBlank() || n.length < 6) {
                    Toast.makeText(this, "请填写原密码且新密码不少于6位", Toast.LENGTH_SHORT).show()
                    return@setPositiveButton
                }
                if (n != c) {
                    Toast.makeText(this, "两次新密码不一致", Toast.LENGTH_SHORT).show()
                    return@setPositiveButton
                }
                vm.changePassword(o, n)
            }
            .show()
    }

    private fun editPostDialog(post: SocialPostDto) {
        val input = EditText(this).apply { setText(post.content) }
        MaterialAlertDialogBuilder(this)
            .setTitle("编辑动态")
            .setView(input)
            .setNegativeButton("取消", null)
            .setPositiveButton("保存") { _, _ ->
                vm.updatePost(post.id, input.text?.toString().orEmpty())
            }
            .show()
    }

    private fun confirmDeletePost(post: SocialPostDto) {
        MaterialAlertDialogBuilder(this)
            .setTitle("删除动态")
            .setMessage("确定删除该条动态？")
            .setNegativeButton("取消", null)
            .setPositiveButton("删除") { _, _ ->
                vm.user.value?.id?.let { vm.deletePost(post.id, it) }
            }
            .show()
    }

    private fun editCommentDialog(c: SocialCommentDto) {
        val input = EditText(this).apply { setText(c.content) }
        MaterialAlertDialogBuilder(this)
            .setTitle("编辑评论")
            .setView(input)
            .setNegativeButton("取消", null)
            .setPositiveButton("保存") { _, _ ->
                vm.updateComment(c.id, input.text?.toString().orEmpty())
            }
            .show()
    }

    private fun confirmDeleteComment(c: SocialCommentDto) {
        MaterialAlertDialogBuilder(this)
            .setTitle("删除评论")
            .setMessage("确定删除？")
            .setNegativeButton("取消", null)
            .setPositiveButton("删除") { _, _ -> vm.deleteComment(c.id) }
            .show()
    }

    private class PostAdapter(
        private val items: List<SocialPostDto>,
        private val onEdit: (SocialPostDto) -> Unit,
        private val onDelete: (SocialPostDto) -> Unit
    ) : RecyclerView.Adapter<PostAdapter.VH>() {
        class VH(val b: ItemMineManageRowBinding) : RecyclerView.ViewHolder(b.root)
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
            val b = ItemMineManageRowBinding.inflate(LayoutInflater.from(parent.context), parent, false)
            return VH(b)
        }
        override fun getItemCount() = items.size
        override fun onBindViewHolder(holder: VH, position: Int) {
            val p = items[position]
            holder.b.tvPrimary.text = p.content.take(80) + if (p.content.length > 80) "…" else ""
            holder.b.tvSecondary.text = "点赞 ${p.likeCount} · 评论 ${p.commentCount} · ${p.createTime}"
            holder.b.btnPrimary.text = "编辑"
            holder.b.btnSecondary.visibility = View.VISIBLE
            holder.b.btnSecondary.text = "删除"
            holder.b.btnPrimary.setOnClickListener { onEdit(p) }
            holder.b.btnSecondary.setOnClickListener { onDelete(p) }
        }
    }

    private class CommentAdapter(
        private val items: List<SocialCommentDto>,
        private val onEdit: (SocialCommentDto) -> Unit,
        private val onDelete: (SocialCommentDto) -> Unit
    ) : RecyclerView.Adapter<CommentAdapter.VH>() {
        class VH(val b: ItemMineManageRowBinding) : RecyclerView.ViewHolder(b.root)
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
            val b = ItemMineManageRowBinding.inflate(LayoutInflater.from(parent.context), parent, false)
            return VH(b)
        }
        override fun getItemCount() = items.size
        override fun onBindViewHolder(holder: VH, position: Int) {
            val c = items[position]
            holder.b.tvPrimary.text = c.content.take(120) + if (c.content.length > 120) "…" else ""
            holder.b.tvSecondary.text = "动态ID ${c.postId} · ${c.createTime ?: ""}"
            holder.b.btnPrimary.text = "编辑"
            holder.b.btnSecondary.visibility = View.VISIBLE
            holder.b.btnSecondary.text = "删除"
            holder.b.btnPrimary.setOnClickListener { onEdit(c) }
            holder.b.btnSecondary.setOnClickListener { onDelete(c) }
        }
    }

    private sealed class CollectionRow {
        data class VideoRow(val v: VideoItemDto) : CollectionRow()
        data class RecipeRow(val r: RecipeItemDto) : CollectionRow()
    }

    private class CollectionAdapter(
        private val rows: List<CollectionRow>,
        private val onVideo: (Int) -> Unit,
        private val onRecipe: (Int) -> Unit
    ) : RecyclerView.Adapter<CollectionAdapter.VH>() {
        class VH(val b: ItemMineManageRowBinding) : RecyclerView.ViewHolder(b.root)
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
            val b = ItemMineManageRowBinding.inflate(LayoutInflater.from(parent.context), parent, false)
            return VH(b)
        }
        override fun getItemCount() = rows.size
        override fun onBindViewHolder(holder: VH, position: Int) {
            when (val row = rows[position]) {
                is CollectionRow.VideoRow -> {
                    holder.b.tvPrimary.text = row.v.title
                    holder.b.tvSecondary.text = "视频收藏"
                    holder.b.btnSecondary.visibility = View.GONE
                    holder.b.btnPrimary.text = "取消收藏"
                    holder.b.btnPrimary.setOnClickListener { onVideo(row.v.id) }
                }
                is CollectionRow.RecipeRow -> {
                    holder.b.tvPrimary.text = row.r.name
                    holder.b.tvSecondary.text = "食谱收藏"
                    holder.b.btnSecondary.visibility = View.GONE
                    holder.b.btnPrimary.text = "取消收藏"
                    holder.b.btnPrimary.setOnClickListener { onRecipe(row.r.id) }
                }
            }
        }
    }

    companion object {
        const val EXTRA_SECTION = "extra_section"
        const val EXTRA_TITLE = "extra_title"
        const val SECTION_PROFILE = "profile"
        const val SECTION_HEALTH = "health"
        const val SECTION_POSTS = "posts"
        const val SECTION_COMMENTS = "comments"
        const val SECTION_COLLECTIONS = "collections"
    }
}
