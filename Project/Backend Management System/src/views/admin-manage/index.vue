<template>
  <div class="admin-manage">
    <h1>管理员管理</h1>
    <div class="search-bar">
      <el-input v-model="keyword" placeholder="用户名关键词" clearable style="width: 220px; margin-right: 10px;" />
      <el-select v-model="status" placeholder="状态" clearable style="width: 140px; margin-right: 10px;">
        <el-option label="启用" :value="1" />
        <el-option label="停用" :value="0" />
      </el-select>
      <el-button type="primary" @click="loadAdmins">查询</el-button>
      <el-button type="success" @click="openCreateDialog">新增管理员</el-button>
    </div>

    <el-table :data="adminList" style="width: 100%; margin-top: 16px;">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column label="角色" width="140">
        <template #default="{ row }">
          <el-tag :type="roleTagType(row.role)">{{ roleLabel(row.role) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="120">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '启用' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180" />
      <el-table-column prop="updateTime" label="更新时间" width="180" />
      <el-table-column label="操作" width="300" fixed="right">
        <template #default="{ row }">
          <el-button size="small" @click="openRoleDialog(row)">改权限</el-button>
          <el-button size="small" @click="openPasswordDialog(row)">改密码</el-button>
          <el-button size="small" :type="row.status === 1 ? 'warning' : 'success'" @click="toggleStatus(row)">
            {{ row.status === 1 ? '停用' : '启用' }}
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      v-model:current-page="page"
      v-model:page-size="size"
      :total="total"
      layout="total, sizes, prev, pager, next"
      :page-sizes="[10, 20, 50]"
      style="margin-top: 16px;"
      @size-change="loadAdmins"
      @current-change="loadAdmins"
    />

    <el-dialog v-model="createDialogVisible" title="新增管理员" width="460px">
      <el-form label-width="90px">
        <el-form-item label="用户名"><el-input v-model="createForm.username" /></el-form-item>
        <el-form-item label="密码"><el-input v-model="createForm.password" type="password" show-password /></el-form-item>
        <el-form-item label="角色">
          <el-select v-model="createForm.role" style="width: 100%">
            <el-option label="管理员" value="admin" />
            <el-option label="审核员" value="auditor" />
            <el-option label="超级管理员" value="super" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="createDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitCreate">创建</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="roleDialogVisible" title="修改管理员权限" width="420px">
      <el-form label-width="80px">
        <el-form-item label="用户名"><el-input :model-value="currentRow?.username || ''" disabled /></el-form-item>
        <el-form-item label="角色">
          <el-select v-model="roleForm.role" style="width: 100%">
            <el-option label="管理员" value="admin" />
            <el-option label="审核员" value="auditor" />
            <el-option label="超级管理员" value="super" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="roleDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitRole">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="passwordDialogVisible" title="修改管理员密码" width="420px">
      <el-form label-width="80px">
        <el-form-item label="用户名"><el-input :model-value="currentRow?.username || ''" disabled /></el-form-item>
        <el-form-item label="新密码"><el-input v-model="passwordForm.password" type="password" show-password /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="passwordDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitPassword">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import {
  getAdminList,
  createAdmin,
  updateAdminRole,
  updateAdminPassword,
  updateAdminStatus
} from '../../api/user'

const keyword = ref('')
const status = ref<number | undefined>(undefined)
const page = ref(1)
const size = ref(10)
const total = ref(0)
const adminList = ref<any[]>([])

const createDialogVisible = ref(false)
const roleDialogVisible = ref(false)
const passwordDialogVisible = ref(false)
const currentRow = ref<any | null>(null)

const createForm = ref({ username: '', password: '', role: 'admin' })
const roleForm = ref({ role: 'admin' })
const passwordForm = ref({ password: '' })

const roleLabel = (role: string) => {
  const m: Record<string, string> = { super: '超级管理员', admin: '管理员', auditor: '审核员', disabled: '停用' }
  return m[role] || role
}
const roleTagType = (role: string) => {
  if (role === 'super') return 'danger'
  if (role === 'auditor') return 'warning'
  if (role === 'disabled') return 'info'
  return 'success'
}

const toListAndTotal = (data: any) => ({
  list: data?.list || data?.records || [],
  total: data?.total ?? data?.records?.length ?? 0
})

const loadAdmins = async () => {
  const res = await getAdminList({
    keyword: keyword.value || undefined,
    status: status.value,
    page: page.value,
    size: size.value
  })
  if (res.code === 200) {
    const { list, total: t } = toListAndTotal(res.data)
    adminList.value = list
    total.value = t
  } else {
    ElMessage.error(res.message || '加载失败')
  }
}

const openCreateDialog = () => {
  createForm.value = { username: '', password: '', role: 'admin' }
  createDialogVisible.value = true
}

const submitCreate = async () => {
  if (!createForm.value.username || createForm.value.password.length < 6) {
    ElMessage.warning('用户名不能为空且密码至少 6 位')
    return
  }
  const res = await createAdmin(createForm.value)
  if (res.code === 200) {
    ElMessage.success('创建成功')
    createDialogVisible.value = false
    loadAdmins()
  } else {
    ElMessage.error(res.message || '创建失败')
  }
}

const openRoleDialog = (row: any) => {
  currentRow.value = row
  roleForm.value.role = row.role === 'disabled' ? 'admin' : row.role
  roleDialogVisible.value = true
}

const submitRole = async () => {
  if (!currentRow.value) return
  const res = await updateAdminRole(currentRow.value.id, roleForm.value.role)
  if (res.code === 200) {
    ElMessage.success('权限更新成功')
    roleDialogVisible.value = false
    loadAdmins()
  } else {
    ElMessage.error(res.message || '更新失败')
  }
}

const openPasswordDialog = (row: any) => {
  currentRow.value = row
  passwordForm.value.password = ''
  passwordDialogVisible.value = true
}

const submitPassword = async () => {
  if (!currentRow.value) return
  if (passwordForm.value.password.length < 6) {
    ElMessage.warning('密码至少 6 位')
    return
  }
  const res = await updateAdminPassword(currentRow.value.id, passwordForm.value.password)
  if (res.code === 200) {
    ElMessage.success('密码修改成功')
    passwordDialogVisible.value = false
  } else {
    ElMessage.error(res.message || '修改失败')
  }
}

const toggleStatus = async (row: any) => {
  const newStatus = row.status === 1 ? 0 : 1
  const roleWhenEnable = row.role === 'disabled' ? 'admin' : row.role
  const res = await updateAdminStatus(row.id, newStatus, roleWhenEnable)
  if (res.code === 200) {
    ElMessage.success('状态更新成功')
    loadAdmins()
  } else {
    ElMessage.error(res.message || '更新失败')
  }
}

onMounted(() => {
  loadAdmins()
})
</script>

<style scoped>
.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}
</style>

