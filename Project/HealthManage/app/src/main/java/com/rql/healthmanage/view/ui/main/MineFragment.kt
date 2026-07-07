package com.rql.healthmanage.view.ui.main



import android.content.Intent

import android.os.Bundle

import android.view.LayoutInflater

import android.view.View

import android.view.ViewGroup

import android.widget.Toast
import com.bumptech.glide.Glide

import androidx.fragment.app.Fragment

import androidx.lifecycle.ViewModelProvider

import com.rql.healthmanage.databinding.FragmentMineBinding
import com.rql.healthmanage.view.ui.auth.LoginActivity

import com.rql.healthmanage.viewmodel.main.MineViewModel



class MineFragment : Fragment() {

    private var _binding: FragmentMineBinding? = null

    private val binding get() = _binding!!

    private lateinit var vm: MineViewModel



    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {

        _binding = FragmentMineBinding.inflate(inflater, container, false)

        return binding.root

    }



    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        super.onViewCreated(view, savedInstanceState)

        vm = ViewModelProvider(this)[MineViewModel::class.java]



        vm.name.observe(viewLifecycleOwner) { binding.tvName.text = it }
        vm.avatar.observe(viewLifecycleOwner) {
            if (it.isNullOrBlank()) {
                binding.imgAvatar.setImageResource(com.rql.healthmanage.R.mipmap.ic_launcher_round)
            } else {
                Glide.with(binding.imgAvatar).load(it).circleCrop().into(binding.imgAvatar)
            }
        }
        vm.bmiLine.observe(viewLifecycleOwner) { binding.tvUserInfo.text = it }

        vm.loggingOut.observe(viewLifecycleOwner) { binding.btnLogout.isEnabled = it != true }

        vm.logoutCompleted.observe(viewLifecycleOwner) { event ->

            if (event != null) {

                Toast.makeText(requireContext(), "已退出登录", Toast.LENGTH_SHORT).show()

                vm.consumeLogoutCompleted()

                startActivity(Intent(requireContext(), LoginActivity::class.java))

                requireActivity().finish()

            }

        }



        binding.itemUserInfo.setOnClickListener { openMineDetail(MineDetailActivity.SECTION_PROFILE, "个人信息") }
        binding.itemHealthStatus.setOnClickListener { openMineDetail(MineDetailActivity.SECTION_HEALTH, "身体数据") }
        binding.itemMyPosts.setOnClickListener { openMineDetail(MineDetailActivity.SECTION_POSTS, "我的动态") }
        binding.itemMyComments.setOnClickListener { openMineDetail(MineDetailActivity.SECTION_COMMENTS, "我的评论") }
        binding.itemMyCollections.setOnClickListener { openMineDetail(MineDetailActivity.SECTION_COLLECTIONS, "我的收藏") }
        binding.btnLogout.setOnClickListener { vm.logout() }

        vm.loadProfile()

    }



    override fun onResume() {

        super.onResume()

        vm.loadProfile()

    }



    override fun onDestroyView() {

        _binding = null

        super.onDestroyView()

    }

    private fun openMineDetail(section: String, title: String) {
        startActivity(
            Intent(requireContext(), MineDetailActivity::class.java)
                .putExtra(MineDetailActivity.EXTRA_TITLE, title)
                .putExtra(MineDetailActivity.EXTRA_SECTION, section)
        )
    }

}


