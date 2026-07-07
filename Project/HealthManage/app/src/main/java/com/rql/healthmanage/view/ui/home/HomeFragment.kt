package com.rql.healthmanage.view.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.rql.healthmanage.databinding.FragmentHomeBinding
import com.rql.healthmanage.viewmodel.home.HomeViewModel

class HomeFragment : Fragment() {
    private var _binding: FragmentHomeBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val vm = ViewModelProvider(this)[HomeViewModel::class.java]
        bindHomeScreen(binding, vm)
    }

    override fun onDestroyView() {
        _binding = null
        super.onDestroyView()
    }
}
