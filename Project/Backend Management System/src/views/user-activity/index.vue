<template>
  <div class="user-activity">
    <h1>收藏与运动管理</h1>
    <el-tabs v-model="activeTab">
      <el-tab-pane label="视频收藏" name="video">
        <div class="search-bar">
          <el-input v-model.number="vUserId" placeholder="用户ID" clearable style="width: 140px; margin-right: 8px" />
          <el-input v-model.number="vVideoId" placeholder="视频ID" clearable style="width: 140px; margin-right: 8px" />
          <el-button type="primary" @click="loadVideoCollections">查询</el-button>
          <el-button @click="openVideoDialog('create')">新增收藏</el-button>
        </div>
        <el-table :data="videoList" style="width: 100%; margin-top: 16px">
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="userId" label="用户ID" width="90" />
          <el-table-column prop="username" label="用户名" width="120" />
          <el-table-column prop="videoId" label="视频ID" width="90" />
          <el-table-column prop="videoTitle" label="视频标题" min-width="160" />
          <el-table-column prop="createTime" label="收藏时间" width="180" />
          <el-table-column label="操作" width="160" fixed="right">
            <template #default="{ row }">
              <el-button size="small" @click="openVideoDialog('edit', row)">编辑</el-button>
              <el-button size="small" type="danger" @click="removeVideo(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          v-model:current-page="vPage"
          v-model:page-size="vSize"
          :total="vTotal"
          layout="total, sizes, prev, pager, next"
          :page-sizes="[10, 20, 50]"
          style="margin-top: 16px"
          @size-change="loadVideoCollections"
          @current-change="loadVideoCollections"
        />
      </el-tab-pane>

      <el-tab-pane label="食谱收藏" name="recipe">
        <div class="search-bar">
          <el-input v-model.number="rUserId" placeholder="用户ID" clearable style="width: 140px; margin-right: 8px" />
          <el-input v-model.number="rRecipeId" placeholder="食谱ID" clearable style="width: 140px; margin-right: 8px" />
          <el-button type="primary" @click="loadRecipeCollections">查询</el-button>
          <el-button @click="openRecipeDialog('create')">新增收藏</el-button>
        </div>
        <el-table :data="recipeList" style="width: 100%; margin-top: 16px">
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="userId" label="用户ID" width="90" />
          <el-table-column prop="username" label="用户名" width="120" />
          <el-table-column prop="recipeId" label="食谱ID" width="90" />
          <el-table-column prop="recipeName" label="食谱名称" min-width="160" />
          <el-table-column prop="createTime" label="收藏时间" width="180" />
          <el-table-column label="操作" width="160" fixed="right">
            <template #default="{ row }">
              <el-button size="small" @click="openRecipeDialog('edit', row)">编辑</el-button>
              <el-button size="small" type="danger" @click="removeRecipe(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          v-model:current-page="rPage"
          v-model:page-size="rSize"
          :total="rTotal"
          layout="total, sizes, prev, pager, next"
          :page-sizes="[10, 20, 50]"
          style="margin-top: 16px"
          @size-change="loadRecipeCollections"
          @current-change="loadRecipeCollections"
        />
      </el-tab-pane>

      <el-tab-pane label="个性化调理方案库" name="regimen">
        <div class="search-bar">
          <el-select v-model="regPlanType" placeholder="方案类型" clearable style="width: 150px; margin-right: 8px">
            <el-option label="药膳" :value="1" />
            <el-option label="穴位" :value="2" />
            <el-option label="运动" :value="3" />
          </el-select>
          <el-select v-model="regStatus" placeholder="状态" clearable style="width: 150px; margin-right: 8px">
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
          </el-select>
          <el-input v-model="regConstitution" placeholder="适用体质" clearable style="width: 180px; margin-right: 8px" />
          <el-button type="primary" @click="loadRegimenPlans">查询</el-button>
          <el-button @click="openRegimenDialog('create')">新增方案</el-button>
        </div>
        <el-table :data="regimenList" style="width: 100%; margin-top: 16px">
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="name" label="方案名称" min-width="140" />
          <el-table-column label="类型" width="90">
            <template #default="{ row }">{{ regimenTypeLabel(row.planType) }}</template>
          </el-table-column>
          <el-table-column prop="suitableConstitution" label="适用体质" min-width="120" />
          <el-table-column prop="suitableLevel" label="适用等级" width="120" />
          <el-table-column prop="status" label="状态" width="90">
            <template #default="{ row }">
              <el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '上架' : '下架' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="tags" label="标签" min-width="120" />
          <el-table-column label="操作" width="220" fixed="right">
            <template #default="{ row }">
              <el-button size="small" @click="openRegimenDialog('edit', row)">编辑</el-button>
              <el-button size="small" :type="row.status === 1 ? 'warning' : 'success'" @click="toggleRegimenStatus(row)">
                {{ row.status === 1 ? '下架' : '上架' }}
              </el-button>
              <el-button size="small" type="danger" @click="removeRegimen(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          v-model:current-page="regPage"
          v-model:page-size="regSize"
          :total="regTotal"
          layout="total, sizes, prev, pager, next"
          :page-sizes="[10, 20, 50]"
          style="margin-top: 16px"
          @size-change="loadRegimenPlans"
          @current-change="loadRegimenPlans"
        />
      </el-tab-pane>

      <el-tab-pane label="运动计划" name="plan">
        <div class="search-bar">
          <el-input v-model.number="pUserId" placeholder="用户ID" clearable style="width: 140px; margin-right: 8px" />
          <el-select v-model="pStatus" placeholder="状态" clearable style="width: 140px; margin-right: 8px">
            <el-option label="进行中" :value="0" />
            <el-option label="已完成" :value="1" />
            <el-option label="已放弃" :value="2" />
          </el-select>
          <el-button type="primary" @click="loadPlans">查询</el-button>
          <el-button @click="openPlanDialog('create')">新增计划</el-button>
        </div>
        <el-table :data="planList" style="width: 100%; margin-top: 16px">
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="userId" label="用户ID" width="90" />
          <el-table-column label="目标" width="100">
            <template #default="{ row }">{{ goalLabel(row.goalType) }}</template>
          </el-table-column>
          <el-table-column prop="startDate" label="开始" width="120" />
          <el-table-column prop="endDate" label="结束" width="120" />
          <el-table-column prop="frequency" label="周次" width="70" />
          <el-table-column prop="duration" label="时长(分)" width="90" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }">
              <el-tag>{{ planStatusLabel(row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="创建时间" width="170" />
          <el-table-column label="操作" width="260" fixed="right">
            <template #default="{ row }">
              <el-button size="small" @click="openPlanDialog('edit', row)">编辑</el-button>
              <el-button size="small" @click="openPlanStatus(row)">改状态</el-button>
              <el-button size="small" type="danger" @click="removePlan(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          v-model:current-page="pPage"
          v-model:page-size="pSize"
          :total="pTotal"
          layout="total, sizes, prev, pager, next"
          :page-sizes="[10, 20, 50]"
          style="margin-top: 16px"
          @size-change="loadPlans"
          @current-change="loadPlans"
        />
      </el-tab-pane>

      <el-tab-pane label="运动打卡" name="record">
        <div class="search-bar">
          <el-input v-model.number="recUserId" placeholder="用户ID" clearable style="width: 140px; margin-right: 8px" />
          <el-input v-model.number="recPlanId" placeholder="计划ID" clearable style="width: 140px; margin-right: 8px" />
          <el-button type="primary" @click="loadRecords">查询</el-button>
          <el-button @click="openRecordDialog('create')">新增打卡</el-button>
        </div>
        <el-table :data="recordList" style="width: 100%; margin-top: 16px">
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="userId" label="用户ID" width="90" />
          <el-table-column prop="planId" label="计划ID" width="90" />
          <el-table-column prop="recordDate" label="日期" width="120" />
          <el-table-column prop="actualDuration" label="实际时长" width="100" />
          <el-table-column prop="calories" label="热量" width="80" />
          <el-table-column label="完成" width="80">
            <template #default="{ row }">{{ row.status === 1 ? '是' : '否' }}</template>
          </el-table-column>
          <el-table-column prop="createTime" label="创建时间" width="170" />
          <el-table-column label="操作" width="160" fixed="right">
            <template #default="{ row }">
              <el-button size="small" @click="openRecordDialog('edit', row)">编辑</el-button>
              <el-button size="small" type="danger" @click="removeRecord(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          v-model:current-page="recPage"
          v-model:page-size="recSize"
          :total="recTotal"
          layout="total, sizes, prev, pager, next"
          :page-sizes="[10, 20, 50]"
          style="margin-top: 16px"
          @size-change="loadRecords"
          @current-change="loadRecords"
        />
      </el-tab-pane>
    </el-tabs>

    <el-dialog v-model="videoDlg" :title="videoMode === 'create' ? '新增视频收藏' : '编辑视频收藏'" width="420px">
      <el-form label-width="90px">
        <el-form-item label="用户ID"><el-input v-model.number="videoForm.userId" /></el-form-item>
        <el-form-item label="视频ID"><el-input v-model.number="videoForm.videoId" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="videoDlg = false">取消</el-button>
        <el-button type="primary" @click="submitVideo">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="recipeDlg" :title="recipeMode === 'create' ? '新增食谱收藏' : '编辑食谱收藏'" width="420px">
      <el-form label-width="90px">
        <el-form-item label="用户ID"><el-input v-model.number="recipeForm.userId" /></el-form-item>
        <el-form-item label="食谱ID"><el-input v-model.number="recipeForm.recipeId" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="recipeDlg = false">取消</el-button>
        <el-button type="primary" @click="submitRecipe">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="planDlg" :title="planMode === 'create' ? '新增运动计划' : '编辑运动计划'" width="520px">
      <el-form label-width="100px">
        <el-form-item v-if="planMode === 'create'" label="用户ID"><el-input v-model.number="planForm.userId" /></el-form-item>
        <el-form-item label="目标类型">
          <el-select v-model="planForm.goalType" style="width: 100%">
            <el-option label="减脂" :value="1" />
            <el-option label="增肌" :value="2" />
            <el-option label="缓解压力" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="开始日期"><el-date-picker v-model="planForm.startDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" /></el-form-item>
        <el-form-item label="结束日期"><el-date-picker v-model="planForm.endDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" /></el-form-item>
        <el-form-item label="每周次数"><el-input v-model.number="planForm.frequency" /></el-form-item>
        <el-form-item label="每次时长(分)"><el-input v-model.number="planForm.duration" /></el-form-item>
        <el-form-item label="计划内容"><el-input v-model="planForm.planContent" type="textarea" rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="planDlg = false">取消</el-button>
        <el-button type="primary" @click="submitPlan">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="planStatusDlg" title="修改计划状态" width="400px">
      <el-select v-model="planStatusVal" placeholder="状态" style="width: 100%">
        <el-option label="进行中" :value="0" />
        <el-option label="已完成" :value="1" />
        <el-option label="已放弃" :value="2" />
      </el-select>
      <template #footer>
        <el-button @click="planStatusDlg = false">取消</el-button>
        <el-button type="primary" @click="submitPlanStatus">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="recordDlg" :title="recordMode === 'create' ? '新增打卡' : '编辑打卡'" width="480px">
      <el-form label-width="100px">
        <el-form-item v-if="recordMode === 'create'" label="用户ID"><el-input v-model.number="recordForm.userId" /></el-form-item>
        <el-form-item label="计划ID"><el-input v-model.number="recordForm.planId" /></el-form-item>
        <el-form-item label="记录日期"><el-date-picker v-model="recordForm.recordDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" /></el-form-item>
        <el-form-item label="实际时长(分)"><el-input v-model.number="recordForm.actualDuration" /></el-form-item>
        <el-form-item label="热量(可选)"><el-input v-model.number="recordForm.calories" placeholder="可空" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="recordDlg = false">取消</el-button>
        <el-button type="primary" @click="submitRecord">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="regimenDlg" :title="regimenMode === 'create' ? '新增个性化调理方案' : '编辑个性化调理方案'" width="640px">
      <el-form label-width="100px">
        <el-form-item label="方案名称"><el-input v-model="regimenForm.name" /></el-form-item>
        <el-form-item label="方案类型">
          <el-select v-model="regimenForm.planType" style="width: 100%">
            <el-option label="药膳" :value="1" />
            <el-option label="穴位" :value="2" />
            <el-option label="运动" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="适用体质"><el-input v-model="regimenForm.suitableConstitution" placeholder="如：平和质,气虚质" /></el-form-item>
        <el-form-item label="适用等级"><el-input v-model="regimenForm.suitableLevel" placeholder="如：0,1,2" /></el-form-item>
        <el-form-item label="标签"><el-input v-model="regimenForm.tags" placeholder="如：减脂,助眠,健脾" /></el-form-item>
        <el-form-item label="方案内容"><el-input v-model="regimenForm.content" type="textarea" :rows="6" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="regimenDlg = false">取消</el-button>
        <el-button type="primary" @click="submitRegimen">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  getVideoCollections,
  createVideoCollection,
  updateVideoCollection,
  deleteVideoCollection,
  getRecipeCollections,
  createRecipeCollection,
  updateRecipeCollection,
  deleteRecipeCollection,
  getSportPlans,
  createSportPlan,
  updateSportPlan,
  updateSportPlanStatus,
  deleteSportPlan,
  getSportRecords,
  createSportRecord,
  updateSportRecord,
  deleteSportRecord
} from '../../api/userActivity'
import {
  getRegimenPlans,
  createRegimenPlan,
  updateRegimenPlan,
  deleteRegimenPlan
} from '../../api/content'

const activeTab = ref('video')

const toListTotal = (data) => ({
  list: data?.list || data?.records || [],
  total: data?.total ?? data?.records?.length ?? 0
})

const goalLabel = (t) => ({ 1: '减脂', 2: '增肌', 3: '缓解压力' }[t] || t)
const regimenTypeLabel = (t) => ({ 1: '药膳', 2: '穴位', 3: '运动' }[t] || t)
const planStatusLabel = (s) => ({ 0: '进行中', 1: '已完成', 2: '已放弃' }[s] || s)

const vUserId = ref(null)
const vVideoId = ref(null)
const vPage = ref(1)
const vSize = ref(10)
const vTotal = ref(0)
const videoList = ref([])
const videoDlg = ref(false)
const videoMode = ref('create')
const videoEditId = ref(null)
const videoForm = ref({ userId: null, videoId: null })

const loadVideoCollections = async () => {
  const res = await getVideoCollections({
    userId: vUserId.value || undefined,
    videoId: vVideoId.value || undefined,
    page: vPage.value,
    size: vSize.value
  })
  if (res.code === 200) {
    const { list, total } = toListTotal(res.data)
    videoList.value = list
    vTotal.value = total
  } else ElMessage.error(res.message || '加载失败')
}

const openVideoDialog = (mode, row) => {
  videoMode.value = mode
  if (mode === 'create') {
    videoEditId.value = null
    videoForm.value = { userId: null, videoId: null }
  } else {
    videoEditId.value = row.id
    videoForm.value = { userId: row.userId, videoId: row.videoId }
  }
  videoDlg.value = true
}

const submitVideo = async () => {
  const { userId, videoId } = videoForm.value
  if (!userId || !videoId) {
    ElMessage.warning('请填写用户ID与视频ID')
    return
  }
  const res =
    videoMode.value === 'create'
      ? await createVideoCollection({ userId, videoId })
      : await updateVideoCollection(videoEditId.value, { userId, videoId })
  if (res.code === 200) {
    ElMessage.success('保存成功')
    videoDlg.value = false
    loadVideoCollections()
  } else ElMessage.error(res.message || '保存失败')
}

const removeVideo = (row) => {
  ElMessageBox.confirm('确定删除该收藏？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteVideoCollection(row.id)
    if (res.code === 200) {
      ElMessage.success('已删除')
      loadVideoCollections()
    } else ElMessage.error(res.message || '删除失败')
  }).catch(() => {})
}

const rUserId = ref(null)
const rRecipeId = ref(null)
const rPage = ref(1)
const rSize = ref(10)
const rTotal = ref(0)
const recipeList = ref([])
const recipeDlg = ref(false)
const recipeMode = ref('create')
const recipeEditId = ref(null)
const recipeForm = ref({ userId: null, recipeId: null })

const loadRecipeCollections = async () => {
  const res = await getRecipeCollections({
    userId: rUserId.value || undefined,
    recipeId: rRecipeId.value || undefined,
    page: rPage.value,
    size: rSize.value
  })
  if (res.code === 200) {
    const { list, total } = toListTotal(res.data)
    recipeList.value = list
    rTotal.value = total
  } else ElMessage.error(res.message || '加载失败')
}

const openRecipeDialog = (mode, row) => {
  recipeMode.value = mode
  if (mode === 'create') {
    recipeEditId.value = null
    recipeForm.value = { userId: null, recipeId: null }
  } else {
    recipeEditId.value = row.id
    recipeForm.value = { userId: row.userId, recipeId: row.recipeId }
  }
  recipeDlg.value = true
}

const submitRecipe = async () => {
  const { userId, recipeId } = recipeForm.value
  if (!userId || !recipeId) {
    ElMessage.warning('请填写用户ID与食谱ID')
    return
  }
  const res =
    recipeMode.value === 'create'
      ? await createRecipeCollection({ userId, recipeId })
      : await updateRecipeCollection(recipeEditId.value, { userId, recipeId })
  if (res.code === 200) {
    ElMessage.success('保存成功')
    recipeDlg.value = false
    loadRecipeCollections()
  } else ElMessage.error(res.message || '保存失败')
}

const removeRecipe = (row) => {
  ElMessageBox.confirm('确定删除该收藏？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteRecipeCollection(row.id)
    if (res.code === 200) {
      ElMessage.success('已删除')
      loadRecipeCollections()
    } else ElMessage.error(res.message || '删除失败')
  }).catch(() => {})
}

const regPlanType = ref(undefined)
const regStatus = ref(undefined)
const regConstitution = ref('')
const regPage = ref(1)
const regSize = ref(10)
const regTotal = ref(0)
const regimenList = ref([])
const regimenDlg = ref(false)
const regimenMode = ref('create')
const regimenEditId = ref(null)
const regimenForm = ref({
  name: '',
  planType: 1,
  suitableConstitution: '',
  suitableLevel: '0,1',
  tags: '',
  content: '',
  status: 1
})

const loadRegimenPlans = async () => {
  const res = await getRegimenPlans({
    planType: regPlanType.value ?? undefined,
    status: regStatus.value ?? undefined,
    suitableConstitution: regConstitution.value || undefined,
    page: regPage.value,
    size: regSize.value
  })
  if (res.code === 200) {
    const { list, total } = toListTotal(res.data)
    regimenList.value = list
    regTotal.value = total
  } else ElMessage.error(res.message || '加载失败')
}

const openRegimenDialog = (mode, row) => {
  regimenMode.value = mode
  if (mode === 'create') {
    regimenEditId.value = null
    regimenForm.value = {
      name: '',
      planType: Number(regPlanType.value || 1),
      suitableConstitution: '',
      suitableLevel: '0,1',
      tags: '',
      content: '',
      status: 1
    }
  } else {
    regimenEditId.value = row.id
    regimenForm.value = {
      name: row.name || '',
      planType: Number(row.planType || 1),
      suitableConstitution: row.suitableConstitution || '',
      suitableLevel: row.suitableLevel || '0,1',
      tags: row.tags || '',
      content: row.content || '',
      status: Number(row.status ?? 1)
    }
  }
  regimenDlg.value = true
}

const submitRegimen = async () => {
  const f = regimenForm.value
  if (!f.name || !f.suitableConstitution || !f.content) {
    ElMessage.warning('请填写方案名称、适用体质和方案内容')
    return
  }
  const body = {
    name: f.name,
    planType: Number(f.planType || 1),
    suitableConstitution: f.suitableConstitution,
    suitableLevel: f.suitableLevel || '0,1',
    tags: f.tags || '',
    content: f.content,
    status: Number(f.status ?? 1)
  }
  const res =
    regimenMode.value === 'create'
      ? await createRegimenPlan(body)
      : await updateRegimenPlan(regimenEditId.value, body)
  if (res.code === 200) {
    ElMessage.success('保存成功')
    regimenDlg.value = false
    loadRegimenPlans()
  } else ElMessage.error(res.message || '保存失败')
}

const toggleRegimenStatus = (row) => {
  const newStatus = row.status === 1 ? 0 : 1
  ElMessageBox.confirm(`确定要${newStatus === 1 ? '上架' : '下架'}该方案吗？`, '提示', { type: 'warning' }).then(async () => {
    const res = await updateRegimenPlan(row.id, {
      ...row,
      status: newStatus
    })
    if (res.code === 200) {
      ElMessage.success('状态已更新')
      loadRegimenPlans()
    } else ElMessage.error(res.message || '更新失败')
  }).catch(() => {})
}

const removeRegimen = (row) => {
  ElMessageBox.confirm('确定删除该方案？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteRegimenPlan(row.id)
    if (res.code === 200) {
      ElMessage.success('已删除')
      loadRegimenPlans()
    } else ElMessage.error(res.message || '删除失败')
  }).catch(() => {})
}

const pUserId = ref(null)
const pStatus = ref(undefined)
const pPage = ref(1)
const pSize = ref(10)
const pTotal = ref(0)
const planList = ref([])
const planDlg = ref(false)
const planMode = ref('create')
const planEditId = ref(null)
const planForm = ref({
  userId: null,
  goalType: 1,
  startDate: '',
  endDate: '',
  frequency: 3,
  duration: 30,
  planContent: ''
})
const planStatusDlg = ref(false)
const planStatusId = ref(null)
const planStatusVal = ref(0)

const loadPlans = async () => {
  const res = await getSportPlans({
    userId: pUserId.value || undefined,
    status: pStatus.value === '' || pStatus.value === undefined ? undefined : pStatus.value,
    page: pPage.value,
    size: pSize.value
  })
  if (res.code === 200) {
    const { list, total } = toListTotal(res.data)
    planList.value = list
    pTotal.value = total
  } else ElMessage.error(res.message || '加载失败')
}

const openPlanDialog = (mode, row) => {
  planMode.value = mode
  if (mode === 'create') {
    planEditId.value = null
    planForm.value = {
      userId: null,
      goalType: 1,
      startDate: '',
      endDate: '',
      frequency: 3,
      duration: 30,
      planContent: ''
    }
  } else {
    planEditId.value = row.id
    planForm.value = {
      userId: row.userId,
      goalType: row.goalType,
      startDate: row.startDate,
      endDate: row.endDate,
      frequency: row.frequency,
      duration: row.duration,
      planContent: row.planContent || ''
    }
  }
  planDlg.value = true
}

const submitPlan = async () => {
  const f = planForm.value
  if (planMode.value === 'create' && !f.userId) {
    ElMessage.warning('请填写用户ID')
    return
  }
  if (!f.startDate || !f.endDate) {
    ElMessage.warning('请选择开始与结束日期')
    return
  }
  const body = {
    goalType: f.goalType,
    startDate: f.startDate,
    endDate: f.endDate,
    frequency: f.frequency,
    duration: f.duration,
    planContent: f.planContent || null
  }
  let res
  if (planMode.value === 'create') {
    res = await createSportPlan({ userId: f.userId, ...body })
  } else {
    res = await updateSportPlan(planEditId.value, body)
  }
  if (res.code === 200) {
    ElMessage.success('保存成功')
    planDlg.value = false
    loadPlans()
  } else ElMessage.error(res.message || '保存失败')
}

const openPlanStatus = (row) => {
  planStatusId.value = row.id
  planStatusVal.value = row.status
  planStatusDlg.value = true
}

const submitPlanStatus = async () => {
  const res = await updateSportPlanStatus(planStatusId.value, planStatusVal.value)
  if (res.code === 200) {
    ElMessage.success('已更新')
    planStatusDlg.value = false
    loadPlans()
  } else ElMessage.error(res.message || '更新失败')
}

const removePlan = (row) => {
  ElMessageBox.confirm('确定删除该计划？关联打卡将一并删除。', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteSportPlan(row.id)
    if (res.code === 200) {
      ElMessage.success('已删除')
      loadPlans()
    } else ElMessage.error(res.message || '删除失败')
  }).catch(() => {})
}

const recUserId = ref(null)
const recPlanId = ref(null)
const recPage = ref(1)
const recSize = ref(10)
const recTotal = ref(0)
const recordList = ref([])
const recordDlg = ref(false)
const recordMode = ref('create')
const recordEditId = ref(null)
const recordForm = ref({
  userId: null,
  planId: null,
  recordDate: '',
  actualDuration: 30,
  calories: null
})

const loadRecords = async () => {
  const res = await getSportRecords({
    userId: recUserId.value || undefined,
    planId: recPlanId.value || undefined,
    page: recPage.value,
    size: recSize.value
  })
  if (res.code === 200) {
    const { list, total } = toListTotal(res.data)
    recordList.value = list
    recTotal.value = total
  } else ElMessage.error(res.message || '加载失败')
}

const openRecordDialog = (mode, row) => {
  recordMode.value = mode
  if (mode === 'create') {
    recordEditId.value = null
    recordForm.value = {
      userId: null,
      planId: null,
      recordDate: '',
      actualDuration: 30,
      calories: null
    }
  } else {
    recordEditId.value = row.id
    recordForm.value = {
      userId: row.userId,
      planId: row.planId,
      recordDate: row.recordDate,
      actualDuration: row.actualDuration,
      calories: row.calories
    }
  }
  recordDlg.value = true
}

const submitRecord = async () => {
  const f = recordForm.value
  if (recordMode.value === 'create' && !f.userId) {
    ElMessage.warning('请填写用户ID')
    return
  }
  if (!f.planId || !f.recordDate) {
    ElMessage.warning('请填写计划ID与记录日期')
    return
  }
  const body = {
    planId: f.planId,
    recordDate: f.recordDate,
    actualDuration: f.actualDuration,
    calories: f.calories === '' || f.calories === undefined ? null : f.calories
  }
  let res
  if (recordMode.value === 'create') {
    res = await createSportRecord({ userId: f.userId, ...body })
  } else {
    res = await updateSportRecord(recordEditId.value, body)
  }
  if (res.code === 200) {
    ElMessage.success('保存成功')
    recordDlg.value = false
    loadRecords()
  } else ElMessage.error(res.message || '保存失败')
}

const removeRecord = (row) => {
  ElMessageBox.confirm('确定删除该打卡记录？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteSportRecord(row.id)
    if (res.code === 200) {
      ElMessage.success('已删除')
      loadRecords()
    } else ElMessage.error(res.message || '删除失败')
  }).catch(() => {})
}

onMounted(() => {
  loadVideoCollections()
  loadRecipeCollections()
  loadPlans()
  loadRecords()
  loadRegimenPlans()
})
</script>

<style scoped>
.user-activity h1 {
  margin-bottom: 16px;
}
.search-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
}
</style>
