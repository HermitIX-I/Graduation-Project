package com.rql.healthmanage.view.ui.health.components

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.rql.healthmanage.databinding.ItemHealthRecordBinding
import com.rql.healthmanage.model.health.HealthRecordGroup

class HealthRecordGroupAdapter(
    private val onDeleteGroup: (HealthRecordGroup) -> Unit,
    private val onAskAi: (HealthRecordGroup) -> Unit,
    private val onEditGroup: (HealthRecordGroup) -> Unit
) : RecyclerView.Adapter<HealthRecordVH>() {
    private var items: List<HealthRecordGroup> = emptyList()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): HealthRecordVH {
        val b = ItemHealthRecordBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return HealthRecordVH(b)
    }

    override fun getItemCount() = items.size

    override fun onBindViewHolder(holder: HealthRecordVH, position: Int) =
        holder.bind(items[position], onDeleteGroup, onAskAi, onEditGroup)

    fun submitList(list: List<HealthRecordGroup>) {
        items = list
        notifyDataSetChanged()
    }
}

class HealthRecordVH(private val b: ItemHealthRecordBinding) : RecyclerView.ViewHolder(b.root) {
    fun bind(
        group: HealthRecordGroup,
        onDeleteGroup: (HealthRecordGroup) -> Unit,
        onAskAi: (HealthRecordGroup) -> Unit,
        onEditGroup: (HealthRecordGroup) -> Unit
    ) {
        b.tvGroupTitle.text = "录入时间：${group.recordTime}"
        b.tvLine.text = group.items.joinToString("\n") { item ->
            when (item.dataType) {
                1 -> "身高 ${item.height ?: "-"} cm，体重 ${item.weight ?: "-"} kg"
                2 -> "血压 ${item.systolic ?: "-"} / ${item.diastolic ?: "-"} mmHg"
                3 -> "空腹血糖 ${item.fastingGlucose ?: "-"} mmol/L"
                else -> "总胆固醇 ${item.totalCholesterol ?: "-"} mmol/L"
            }
        }
        b.btnAi.setOnClickListener { onAskAi(group) }
        b.btnEdit.setOnClickListener { onEditGroup(group) }
        b.btnDel.setOnClickListener { onDeleteGroup(group) }
    }
}
