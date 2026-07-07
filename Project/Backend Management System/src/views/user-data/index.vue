<template>
  <div class="user-data">
    <h1>用户与数据管理</h1>
    
    <el-tabs v-model="activeTab">
      <el-tab-pane label="用户列表" name="users">
        <div class="search-bar">
          <el-input v-model="userSearch" placeholder="搜索用户名或手机号" style="width: 300px; margin-right: 10px;">
            <template #append>
              <el-button @click="searchUsers"><el-icon><Search /></el-icon></el-button>
            </template>
          </el-input>
          <el-button type="primary" @click="addUser">新增用户</el-button>
        </div>
        
        <el-table :data="userList" style="width: 100%; margin-top: 20px;">
          <el-table-column type="index" label="序号" width="80" :index="userIndex" />
          <el-table-column prop="username" label="用户名" />
          <el-table-column prop="phone" label="手机号" />
          <el-table-column prop="gender" label="性别" width="100">
            <template #default="scope">
              {{ getGenderName(scope.row.gender) }}
            </template>
          </el-table-column>
          <el-table-column prop="healthSummary" label="身体健康数据" min-width="220" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.status === 0 ? 'success' : 'danger'">
                {{ scope.row.status === 0 ? '启用' : '禁用' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="注册时间" width="180" />
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="editUser(scope.row)">编辑</el-button>
              <el-button size="small" :type="scope.row.status === 0 ? 'warning' : 'success'" @click="toggleUserStatus(scope.row)">
                {{ scope.row.status === 0 ? '禁用' : '启用' }}
              </el-button>
              <el-button size="small" type="danger" @click="deleteUserData(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="userPage"
          v-model:page-size="userPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="userTotal"
          @size-change="handleUserSizeChange"
          @current-change="handleUserCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
      
      <el-tab-pane label="异常健康数据" name="abnormal">
        <div class="search-bar">
          <el-select v-model="dataType" placeholder="数据类型" style="width: 150px; margin-right: 10px;">
            <el-option label="身高体重" :value="1" />
            <el-option label="血压" :value="2" />
            <el-option label="血糖" :value="3" />
            <el-option label="血脂" :value="4" />
          </el-select>
          <el-button @click="searchAbnormalData">查询</el-button>
        </div>
        
        <el-table :data="abnormalDataList" style="width: 100%; margin-top: 20px;">
          <el-table-column type="index" label="序号" width="80" :index="abnormalIndex" />
          <el-table-column prop="userId" label="用户ID" />
          <el-table-column prop="dataType" label="数据类型" width="100">
            <template #default="scope">
              {{ getDataTypeName(scope.row.dataType) }}
            </template>
          </el-table-column>
          <el-table-column label="异常指标数值" min-width="260">
            <template #default="scope">
              {{ formatAbnormalMetricDisplay(scope.row) }}
            </template>
          </el-table-column>
          <el-table-column prop="recordTime" label="记录时间" width="180" />
          <el-table-column label="操作" width="150">
            <template #default="scope">
              <el-button size="small" @click="correctData(scope.row)">修正</el-button>
              <el-button size="small" type="danger" @click="deleteData(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="dataPage"
          v-model:page-size="dataPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="dataTotal"
          @size-change="handleDataSizeChange"
          @current-change="handleDataCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
      
      <el-tab-pane label="操作日志" name="logs" v-if="hasPermission(['super'])">
        <div class="search-bar">
          <el-date-picker
            v-model="logDateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            style="width: 300px; margin-right: 10px;"
          />
          <el-input v-model="logAdmin" placeholder="管理员" style="width: 200px; margin-right: 10px;" />
          <el-button @click="searchLogs">查询</el-button>
        </div>
        
        <el-table :data="logList" style="width: 100%; margin-top: 20px;">
          <el-table-column type="index" label="序号" width="80" :index="logIndex" />
          <el-table-column prop="adminId" label="管理员ID" />
          <el-table-column prop="action" label="操作类型" />
          <el-table-column prop="targetType" label="目标类型" />
          <el-table-column prop="targetId" label="目标ID" />
          <el-table-column prop="oldValue" label="旧值" />
          <el-table-column prop="newValue" label="新值" />
          <el-table-column prop="createTime" label="操作时间" width="180" />
        </el-table>
        
        <el-pagination
          v-model:current-page="logPage"
          v-model:page-size="logPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="logTotal"
          @size-change="handleLogSizeChange"
          @current-change="handleLogCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
    </el-tabs>

    <el-dialog v-model="userDialogVisible" :title="userDialogMode === 'create' ? '新增用户' : '编辑用户'" width="520px">
      <el-form :model="userForm" label-width="90px" autocomplete="off">
        <el-form-item label="用户名">
          <el-input v-model="userForm.username" autocomplete="off" name="new-user-username" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="userForm.phone" autocomplete="off" name="new-user-phone" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="userForm.email" autocomplete="off" name="new-user-email" />
        </el-form-item>
        <el-form-item label="年龄">
          <el-input v-model.number="userForm.age" type="number" />
        </el-form-item>
        <el-form-item label="性别">
          <el-select v-model="userForm.gender" style="width: 100%">
            <el-option label="女" :value="0" />
            <el-option label="男" :value="1" />
            <el-option label="未知" :value="2" />
          </el-select>
        </el-form-item>
        <el-form-item :label="userDialogMode === 'create' ? '密码' : '新密码'">
          <el-input v-model="userForm.password" type="password" show-password placeholder="编辑时留空则不修改密码" autocomplete="new-password" name="new-user-password" />
        </el-form-item>
        <el-form-item label="身高/体重">
          <div style="display: flex; gap: 8px; width: 100%">
            <el-input v-model.number="userForm.healthData.height" placeholder="身高(cm)" />
            <el-input v-model.number="userForm.healthData.weight" placeholder="体重(kg)" />
          </div>
        </el-form-item>
        <el-form-item label="血压">
          <div style="display: flex; gap: 8px; width: 100%">
            <el-input v-model.number="userForm.healthData.systolic" placeholder="收缩压" />
            <el-input v-model.number="userForm.healthData.diastolic" placeholder="舒张压" />
          </div>
        </el-form-item>
        <el-form-item label="血糖">
          <el-input v-model.number="userForm.healthData.fastingGlucose" placeholder="空腹血糖(mmol/L)" />
        </el-form-item>
        <el-form-item label="血脂">
          <el-input v-model.number="userForm.healthData.totalCholesterol" placeholder="总胆固醇(mmol/L)" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="userDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitUser">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '../../stores/user'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import { getUserList, updateUserStatus, deleteUser, getAbnormalHealthData, updateHealthData, deleteHealthData, createUser, updateUser } from '../../api/user'
import { getAuditRecords } from '../../api/social'

const userStore = useUserStore()
const activeTab = ref('users')

// 用户列表相关
const userList = ref([])
const userSearch = ref('')
const userPage = ref(1)
const userPageSize = ref(10)
const userTotal = ref(0)

// 异常健康数据相关
const abnormalDataList = ref([])
const dataType = ref('')
const dataPage = ref(1)
const dataPageSize = ref(10)
const dataTotal = ref(0)

// 操作日志相关
const logList = ref([])
const logDateRange = ref([])
const logAdmin = ref('')
const logPage = ref(1)
const logPageSize = ref(10)
const logTotal = ref(0)
const userDialogVisible = ref(false)
const userDialogMode = ref('create')
const userForm = ref({
  id: null,
  username: '',
  phone: '',
  email: '',
  age: null,
  password: '',
  gender: 2,
  healthData: {
    height: null,
    weight: null,
    systolic: null,
    diastolic: null,
    fastingGlucose: null,
    totalCholesterol: null
  }
})

const hasPermission = (roles) => {
  return roles.includes(userStore.role)
}

const toListAndTotal = (payload) => {
  if (Array.isArray(payload)) {
    return { list: payload, total: payload.length }
  }
  return {
    list: payload?.list || [],
    total: payload?.total ?? (payload?.list?.length || 0)
  }
}

const getDataTypeName = (type) => {
  const typeMap = {
    1: '身高体重',
    2: '血压',
    3: '血糖',
    4: '血脂'
  }
  return typeMap[type] || '未知'
}

/** 后端返回 HealthData 分字段，无统一 value；按类型拼出用户可见的异常相关数值 */
const formatAbnormalMetricDisplay = (row) => {
  const t = row?.dataType
  if (t === 1) {
    const h = row.height != null ? Number(row.height) : null
    const w = row.weight != null ? Number(row.weight) : null
    if (h == null || w == null || Number.isNaN(h) || Number.isNaN(w)) return '—'
    const bmi = w / Math.pow(h / 100, 2)
    return `身高 ${h} cm，体重 ${w} kg，BMI ${bmi.toFixed(1)}`
  }
  if (t === 2) {
    const s = row.systolic
    const d = row.diastolic
    if (s == null || d == null) return '—'
    return `收缩压 ${s} / 舒张压 ${d} mmHg`
  }
  if (t === 3) {
    const g = row.fastingGlucose != null ? Number(row.fastingGlucose) : null
    if (g == null || Number.isNaN(g)) return '—'
    return `空腹血糖 ${g} mmol/L`
  }
  if (t === 4) {
    const c = row.totalCholesterol != null ? Number(row.totalCholesterol) : null
    if (c == null || Number.isNaN(c)) return '—'
    return `总胆固醇 ${c} mmol/L`
  }
  return '—'
}

/** 与后台 AdminUserServiceImpl.updateHealthData 一致：类型 1 改体重、2 改收缩压、3/4 改对应指标 */
const getCorrectableMetricHint = (row) => {
  const t = row?.dataType
  if (t === 1) return '请输入修正后的体重(kg)'
  if (t === 2) return '请输入修正后的收缩压(mmHg)'
  if (t === 3) return '请输入修正后的空腹血糖(mmol/L)'
  if (t === 4) return '请输入修正后的总胆固醇(mmol/L)'
  return '请输入修正后的数值'
}

const getCorrectableMetricDefault = (row) => {
  const t = row?.dataType
  if (t === 1) return row.weight != null ? String(row.weight) : ''
  if (t === 2) return row.systolic != null ? String(row.systolic) : ''
  if (t === 3) return row.fastingGlucose != null ? String(row.fastingGlucose) : ''
  if (t === 4) return row.totalCholesterol != null ? String(row.totalCholesterol) : ''
  return ''
}

const getGenderName = (gender) => {
  const map = { 0: '女', 1: '男', 2: '未知' }
  return map[gender] || '未知'
}

const userIndex = (index) => (userPage.value - 1) * userPageSize.value + index + 1
const abnormalIndex = (index) => (dataPage.value - 1) * dataPageSize.value + index + 1
const logIndex = (index) => (logPage.value - 1) * logPageSize.value + index + 1

const searchUsers = async () => {
  try {
    const response = await getUserList({
      keyword: userSearch.value,
      page: userPage.value,
      size: userPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      userList.value = list
      userTotal.value = total
    } else {
      ElMessage.error(response.message || '获取用户列表失败')
    }
  } catch (error) {
    ElMessage.error('获取用户列表失败')
  }
}

const addUser = () => {
  userDialogMode.value = 'create'
  userForm.value = {
    id: null,
    username: '',
    phone: '',
    email: '',
    age: null,
    password: '',
    gender: 2,
    healthData: {
      height: null,
      weight: null,
      systolic: null,
      diastolic: null,
      fastingGlucose: null,
      totalCholesterol: null
    }
  }
  userDialogVisible.value = true
}

const editUser = (user) => {
  userDialogMode.value = 'edit'
  userForm.value = {
    id: user.id,
    username: user.username || '',
    phone: user.phone || '',
    email: user.email || '',
    age: user.age ?? null,
    password: '',
    gender: user.gender ?? 2,
    healthData: {
      height: null,
      weight: null,
      systolic: null,
      diastolic: null,
      fastingGlucose: null,
      totalCholesterol: null
    }
  }
  userDialogVisible.value = true
}

const submitUser = async () => {
  try {
    if (!userForm.value.username || !userForm.value.phone) {
      ElMessage.warning('用户名和手机号必填')
      return
    }
    const phoneTrim = String(userForm.value.phone || '').trim()
    if (!/^1[3-9]\d{9}$/.test(phoneTrim)) {
      ElMessage.warning('请输入正确的11位中国大陆手机号（1开头）')
      return
    }
    userForm.value.phone = phoneTrim
    let response
    if (userDialogMode.value === 'create') {
      response = await createUser(userForm.value)
    } else {
      response = await updateUser(userForm.value.id, userForm.value)
    }
    if (response.code === 200) {
      ElMessage.success(userDialogMode.value === 'create' ? '用户创建成功' : '用户更新成功')
      userDialogVisible.value = false
      searchUsers()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const toggleUserStatus = async (user) => {
  ElMessageBox.confirm(`确定要${user.status === 0 ? '禁用' : '启用'}该用户吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const newStatus = user.status === 0 ? 1 : 0
      const response = await updateUserStatus(user.id, newStatus)
      if (response.code === 200) {
        user.status = newStatus
        ElMessage.success(`用户已${newStatus === 0 ? '启用' : '禁用'}`)
      } else {
        ElMessage.error(response.message || '操作失败')
      }
    } catch (error) {
      ElMessage.error('操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const deleteUserData = async (user) => {
  ElMessageBox.confirm('确定要删除该用户吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'danger'
  }).then(async () => {
    try {
      const response = await deleteUser(user.id)
      if (response.code === 200) {
        const index = userList.value.findIndex(u => u.id === user.id)
        if (index !== -1) {
          userList.value.splice(index, 1)
        }
        ElMessage.success('用户已删除')
      } else {
        ElMessage.error(response.message || '删除失败')
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handleUserSizeChange = (size) => {
  userPageSize.value = size
  searchUsers()
}

const handleUserCurrentChange = (current) => {
  userPage.value = current
  searchUsers()
}

const searchAbnormalData = async () => {
  try {
    const response = await getAbnormalHealthData({
      dataType: dataType.value,
      page: dataPage.value,
      size: dataPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      abnormalDataList.value = list
      dataTotal.value = total
    } else {
      ElMessage.error(response.message || '获取异常健康数据失败')
    }
  } catch (error) {
    ElMessage.error('获取异常健康数据失败')
  }
}

const correctData = async (data) => {
  try {
    const hint = getCorrectableMetricHint(data)
    const def = getCorrectableMetricDefault(data)
    const newValue = prompt(`${hint}:`, def)
    if (newValue !== null && newValue.trim() !== '') {
      const num = parseFloat(newValue)
      if (Number.isNaN(num)) {
        ElMessage.error('请输入有效数字')
        return
      }
      const response = await updateHealthData(data.id, num)
      if (response.code === 200) {
        if (data.dataType === 1) data.weight = num
        else if (data.dataType === 2) data.systolic = Math.round(num)
        else if (data.dataType === 3) data.fastingGlucose = num
        else if (data.dataType === 4) data.totalCholesterol = num
        ElMessage.success('数据已修正')
      } else {
        ElMessage.error(response.message || '修正失败')
      }
    }
  } catch (error) {
    ElMessage.error('修正失败')
  }
}

const deleteData = async (data) => {
  ElMessageBox.confirm('确定要删除该异常数据吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'danger'
  }).then(async () => {
    try {
      const response = await deleteHealthData(data.id)
      if (response.code === 200) {
        const index = abnormalDataList.value.findIndex(d => d.id === data.id)
        if (index !== -1) {
          abnormalDataList.value.splice(index, 1)
        }
        ElMessage.success('数据已删除')
      } else {
        ElMessage.error(response.message || '删除失败')
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handleDataSizeChange = (size) => {
  dataPageSize.value = size
  searchAbnormalData()
}

const handleDataCurrentChange = (current) => {
  dataPage.value = current
  searchAbnormalData()
}

const searchLogs = async () => {
  try {
    const response = await getAuditRecords({
      page: logPage.value,
      size: logPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      logList.value = list
      logTotal.value = total
    } else {
      ElMessage.error(response.message || '获取操作日志失败')
    }
  } catch (error) {
    ElMessage.error('获取操作日志失败')
  }
}

const handleLogSizeChange = (size) => {
  logPageSize.value = size
  searchLogs()
}

const handleLogCurrentChange = (current) => {
  logPage.value = current
  searchLogs()
}

onMounted(() => {
  searchUsers()
  searchAbnormalData()
  if (hasPermission(['super'])) {
    searchLogs()
  }
})
</script>

<style scoped>
.user-data {
  padding: 20px;
}

.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}
</style>
