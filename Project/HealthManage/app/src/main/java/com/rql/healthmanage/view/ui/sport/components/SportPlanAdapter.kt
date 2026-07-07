package com.rql.healthmanage.view.ui.sport.components

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.rql.healthmanage.databinding.ItemSportPlanBinding
import com.rql.healthmanage.model.entity.SportPlanDto
import com.rql.healthmanage.model.sport.displaySubtitle
import com.rql.healthmanage.model.sport.displayTitle

class SportPlanAdapter(
    private val onEdit: (SportPlanDto) -> Unit,
    private val onDelete: (SportPlanDto) -> Unit
) : RecyclerView.Adapter<SportPlanAdapter.SportPlanVH>() {
    private var items: List<SportPlanDto> = emptyList()

    fun submit(list: List<SportPlanDto>) {
        items = list
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SportPlanVH {
        val b = ItemSportPlanBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return SportPlanVH(b, onEdit, onDelete)
    }

    override fun getItemCount() = items.size

    override fun onBindViewHolder(holder: SportPlanVH, position: Int) = holder.bind(items[position])

    class SportPlanVH(
        private val b: ItemSportPlanBinding,
        private val onEdit: (SportPlanDto) -> Unit,
        private val onDelete: (SportPlanDto) -> Unit
    ) : RecyclerView.ViewHolder(b.root) {
        fun bind(plan: SportPlanDto) {
            b.tvPlanTitle.text = plan.displayTitle()
            b.tvPlanBody.text = plan.displaySubtitle()
            b.btnEdit.setOnClickListener { onEdit(plan) }
            b.btnDelete.setOnClickListener { onDelete(plan) }
        }
    }
}
