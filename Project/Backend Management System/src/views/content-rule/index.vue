<template>
  <div class="content-rule">
    <h1>内容与规则管理</h1>
    
    <el-tabs v-model="activeTab">
      <el-tab-pane label="评估量表维护" name="assessment">
        <div class="search-bar">
          <el-select v-model="questionType" placeholder="全部类型（亚健康/体质分页）" clearable style="width: 280px; margin-right: 10px;">
            <el-option
              v-for="item in assessmentTypeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
          <el-select v-model="status" placeholder="状态" style="width: 150px; margin-right: 10px;">
            <el-option label="草稿" :value="0" />
            <el-option label="生效" :value="1" />
            <el-option label="归档" :value="2" />
          </el-select>
          <el-button @click="searchQuestions">查询</el-button>
          <el-button type="primary" @click="openAddQuestionDialog">新增题目</el-button>
        </div>
        
        <div style="margin-top: 20px; font-weight: 600;">亚健康评估量表</div>
        <el-table :data="subHealthQuestionList" style="width: 100%; margin-top: 12px;">
          <el-table-column type="index" label="序号" width="80" :index="questionSubHealthIndex" />
          <el-table-column prop="typeName" label="类型" width="260" />
          <el-table-column prop="content" label="题目内容" />
          <el-table-column prop="version" label="版本" width="100" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="getStatusType(scope.row.status)">
                {{ getStatusName(scope.row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="创建时间" width="180" />
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="editQuestion(scope.row)">编辑</el-button>
              <el-button size="small" v-if="scope.row.status === 0" type="success" @click="submitQuestion(scope.row)">提交审核</el-button>
              <el-button size="small" v-if="scope.row.status === 1" type="warning" @click="archiveQuestion(scope.row)">归档</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          v-if="!questionType"
          v-model:current-page="shPage"
          v-model:page-size="shPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="shTotal"
          @size-change="handleShQuestionSizeChange"
          @current-change="searchQuestions"
          style="margin-top: 12px;"
        />

        <div style="margin-top: 24px; font-weight: 600;">中医体质评估量表</div>
        <el-table :data="tcmQuestionList" style="width: 100%; margin-top: 12px;">
          <el-table-column type="index" label="序号" width="80" :index="questionTcmIndex" />
          <el-table-column prop="typeName" label="类型" width="260" />
          <el-table-column prop="sortOrder" label="排序" width="90" />
          <el-table-column prop="questionText" label="题目内容" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
                {{ scope.row.status === 1 ? '启用' : '停用' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="创建时间" width="180" />
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="editTcmScale(scope.row)">编辑</el-button>
              <el-button size="small" type="danger" @click="deleteTcmScaleRow(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          v-if="!questionType"
          v-model:current-page="tcmQPage"
          v-model:page-size="tcmQPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="tcmQTotal"
          @size-change="handleTcmQuestionSizeChange"
          @current-change="searchQuestions"
          style="margin-top: 12px;"
        />

        <el-pagination
          v-if="questionType"
          v-model:current-page="questionPage"
          v-model:page-size="questionPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="questionTotal"
          @size-change="handleQuestionSizeChange"
          @current-change="handleQuestionCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
      
      <el-tab-pane label="调理方案库" name="regimen">
        <div class="search-bar">
          <el-select v-model="planType" placeholder="方案类型" style="width: 150px; margin-right: 10px;">
            <el-option label="药膳" :value="1" />
            <el-option label="穴位" :value="2" />
            <el-option label="运动" :value="3" />
          </el-select>
          <el-select v-model="planStatus" placeholder="状态" style="width: 150px; margin-right: 10px;">
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
          </el-select>
          <el-button @click="searchPlans">查询</el-button>
          <el-button type="primary" @click="addPlan">新增方案</el-button>
        </div>
        
        <el-table :data="planList" style="width: 100%; margin-top: 20px;">
          <el-table-column type="index" label="序号" width="80" :index="planIndex" />
          <el-table-column prop="name" label="方案名称" />
          <el-table-column prop="planType" label="类型" width="100">
            <template #default="scope">
              {{ getPlanTypeName(scope.row.planType) }}
            </template>
          </el-table-column>
          <el-table-column prop="suitableConstitution" label="适用体质" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
                {{ scope.row.status === 1 ? '上架' : '下架' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="editPlan(scope.row)">编辑</el-button>
              <el-button size="small" :type="scope.row.status === 1 ? 'warning' : 'success'" @click="togglePlanStatus(scope.row)">
                {{ scope.row.status === 1 ? '下架' : '上架' }}
              </el-button>
              <el-button size="small" type="danger" @click="deletePlan(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="planPage"
          v-model:page-size="planPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="planTotal"
          @size-change="handlePlanSizeChange"
          @current-change="handlePlanCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
      
      <el-tab-pane label="视频管理" name="video">
        <div class="search-bar">
          <el-select v-model="videoStatus" placeholder="状态" style="width: 150px; margin-right: 10px;">
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
          </el-select>
          <el-input v-model="videoSearch" placeholder="搜索视频标题" style="width: 300px; margin-right: 10px;">
            <template #append>
              <el-button @click="searchVideos"><el-icon><Search /></el-icon></el-button>
            </template>
          </el-input>
          <el-button type="primary" @click="addVideo">新增视频</el-button>
        </div>
        
        <el-table :data="videoList" style="width: 100%; margin-top: 20px;">
          <el-table-column type="index" label="序号" width="80" :index="videoIndex" />
          <el-table-column label="封面" width="100">
            <template #default="scope">
              <el-image :src="resolveMediaUrl(scope.row.cover || scope.row.coverUrl || scope.row.thumbnail)" fit="cover" style="width: 80px; height: 60px;" />
            </template>
          </el-table-column>
          <el-table-column prop="title" label="名称" />
          <el-table-column prop="duration" label="时长" width="100" />
          <el-table-column prop="tags" label="标签" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
                {{ scope.row.status === 1 ? '上架' : '下架' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="editVideo(scope.row)">编辑</el-button>
              <el-button size="small" :type="scope.row.status === 1 ? 'warning' : 'success'" @click="toggleVideoStatus(scope.row)">
                {{ scope.row.status === 1 ? '下架' : '上架' }}
              </el-button>
              <el-button size="small" type="danger" @click="deleteVideo(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="videoPage"
          v-model:page-size="videoPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="videoTotal"
          @size-change="handleVideoSizeChange"
          @current-change="handleVideoCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
      
      <el-tab-pane label="食谱管理" name="recipe">
        <div class="search-bar">
          <el-select v-model="recipeStatus" placeholder="状态" style="width: 150px; margin-right: 10px;">
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
          </el-select>
          <el-input v-model="recipeSearch" placeholder="搜索食谱标题" style="width: 300px; margin-right: 10px;">
            <template #append>
              <el-button @click="searchRecipes"><el-icon><Search /></el-icon></el-button>
            </template>
          </el-input>
          <el-button type="primary" @click="addRecipe">新增食谱</el-button>
        </div>
        
        <el-table :data="recipeList" style="width: 100%; margin-top: 20px;">
          <el-table-column type="index" label="序号" width="80" :index="recipeIndex" />
          <el-table-column label="封面" width="100">
            <template #default="scope">
              <el-image :src="resolveMediaUrl(scope.row.cover || scope.row.coverUrl || scope.row.thumbnail)" fit="cover" style="width: 80px; height: 60px;" />
            </template>
          </el-table-column>
          <el-table-column prop="name" label="名称" />
          <el-table-column prop="tags" label="标签" />
          <el-table-column prop="suitableConstitution" label="适用体质" />
          <el-table-column prop="viewCount" label="浏览量" width="100" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
                {{ scope.row.status === 1 ? '上架' : '下架' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="editRecipe(scope.row)">编辑</el-button>
              <el-button size="small" :type="scope.row.status === 1 ? 'warning' : 'success'" @click="toggleRecipeStatus(scope.row)">
                {{ scope.row.status === 1 ? '下架' : '上架' }}
              </el-button>
              <el-button size="small" type="danger" @click="deleteRecipe(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="recipePage"
          v-model:page-size="recipePageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="recipeTotal"
          @size-change="handleRecipeSizeChange"
          @current-change="handleRecipeCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
    </el-tabs>

    <el-dialog v-model="addQuestionDialogVisible" title="新增评估题目" width="560px" destroy-on-close>
      <el-form :model="addQuestionForm" label-width="120px">
        <el-form-item label="题目所属类别" required>
          <el-select v-model="addQuestionForm.category" placeholder="请选择（如：中医体质评估量表：气虚质）" filterable style="width: 100%">
            <el-option
              v-for="item in assessmentTypeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="题目内容" required>
          <el-input v-model="addQuestionForm.content" type="textarea" :rows="4" placeholder="请输入题干/题目描述" />
        </el-form-item>
        <template v-if="isAddSubHealthCategory">
          <el-form-item label="选项 JSON">
            <el-input v-model="addQuestionForm.optionsJson" type="textarea" :rows="5" placeholder='如 [{"option":"从不","score":0}, ...]' />
          </el-form-item>
          <el-form-item label="权重(1-100)">
            <el-input-number v-model="addQuestionForm.weight" :min="1" :max="100" style="width: 100%" />
          </el-form-item>
        </template>
        <el-form-item v-else-if="isAddTcmCategory" label="排序值">
          <el-input-number v-model="addQuestionForm.sortOrder" :min="0" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="addQuestionDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitAddQuestion">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="planDialogVisible" :title="planDialogMode === 'create' ? '新增方案' : '编辑方案'" width="640px">
      <el-form :model="planForm" label-width="100px">
        <el-form-item label="方案名称">
          <el-input v-model="planForm.name" />
        </el-form-item>
        <el-form-item label="方案类型">
          <el-select v-model="planForm.planType" style="width: 100%">
            <el-option label="药膳" :value="1" />
            <el-option label="穴位" :value="2" />
            <el-option label="运动" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="适用体质">
          <el-input v-model="planForm.suitableConstitution" placeholder="如：平和质,气虚质" />
        </el-form-item>
        <el-form-item label="方案内容">
          <el-input v-model="planForm.content" type="textarea" :rows="6" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="planDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitPlan">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="videoDialogVisible" :title="videoDialogMode === 'create' ? '新增视频' : '编辑视频'" width="640px">
      <el-form :model="videoForm" label-width="90px">
        <el-form-item label="视频名称">
          <el-input v-model="videoForm.title" />
        </el-form-item>
        <el-form-item label="封面图">
          <el-upload
            :show-file-list="false"
            accept="image/*"
            :http-request="handleVideoCoverUpload"
          >
            <el-button type="primary">选择封面图片</el-button>
          </el-upload>
          <el-image
            v-if="videoForm.cover"
            :src="resolveMediaUrl(videoForm.cover)"
            fit="cover"
            style="width: 120px; height: 90px; margin-top: 8px;"
          />
        </el-form-item>
        <el-form-item label="视频文件">
          <el-upload
            :show-file-list="false"
            accept="video/*"
            :http-request="handleVideoFileUpload"
          >
            <el-button>选择视频文件</el-button>
          </el-upload>
          <div v-if="videoForm.url" style="margin-top: 6px; color: #666; font-size: 12px;">已上传：{{ videoForm.url }}</div>
        </el-form-item>
        <el-form-item label="视频标签">
          <el-input v-model="videoForm.tags" placeholder="多个标签可逗号分隔" />
        </el-form-item>
        <el-form-item label="时长(秒)">
          <el-input v-model.number="videoForm.duration" type="number" min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="videoDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitVideo">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="recipeDialogVisible" :title="recipeDialogMode === 'create' ? '新增食谱' : '编辑食谱'" width="700px">
      <el-form :model="recipeForm" label-width="100px">
        <el-form-item label="食谱名称">
          <el-input v-model="recipeForm.name" />
        </el-form-item>
        <el-form-item label="封面图">
          <el-upload
            :show-file-list="false"
            accept="image/*"
            :http-request="handleRecipeCoverUpload"
          >
            <el-button type="primary">选择封面图片</el-button>
          </el-upload>
          <el-image
            v-if="recipeForm.cover"
            :src="resolveMediaUrl(recipeForm.cover)"
            fit="cover"
            style="width: 120px; height: 90px; margin-top: 8px;"
          />
        </el-form-item>
        <el-form-item label="食材清单">
          <el-input v-model="recipeForm.ingredients" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="制作步骤">
          <el-input v-model="recipeForm.steps" type="textarea" :rows="5" />
        </el-form-item>
        <el-form-item label="适用体质">
          <el-input v-model="recipeForm.suitableConstitution" />
        </el-form-item>
        <el-form-item label="标签">
          <el-input v-model="recipeForm.tags" placeholder="多个标签可逗号分隔" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="recipeDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitRecipe">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import { resolveMediaUrl } from '../../utils/media'
import { uploadAdminImage, uploadAdminVideo } from '../../api/upload'
import {
  getAssessmentQuestions,
  getTcmConstitutionScales,
  getRegimenPlans,
  getVideos,
  getRecipes,
  createAssessmentQuestion,
  createTcmConstitutionScale,
  updateAssessmentQuestion,
  updateTcmConstitutionScale,
  createRegimenPlan,
  updateRegimenPlan,
  createVideo,
  updateVideo,
  createRecipe,
  updateRecipe,
  updateAssessmentVersionStatus,
  updateVideoStatus,
  updateRecipeStatus,
  deleteRegimenPlan,
  deleteTcmConstitutionScale
} from '../../api/content'

const activeTab = ref('assessment')

// 评估量表相关
const questionList = ref([])
const tcmScaleList = ref([])
const questionType = ref('')
const status = ref('')
const questionPage = ref(1)
const questionPageSize = ref(10)
const questionTotal = ref(0)
/** 未选「类型」时：亚健康与中医体质两套分页，避免共用 total=max 导致某一表翻到空页 */
const shPage = ref(1)
const shTotal = ref(0)
const tcmQPage = ref(1)
const tcmQTotal = ref(0)
const shPageSize = ref(10)
const tcmQPageSize = ref(10)

const addQuestionDialogVisible = ref(false)
const addQuestionForm = ref({
  category: null,
  content: '',
  optionsJson: '[{"option":"从不","score":0},{"option":"很少","score":1},{"option":"有时","score":2},{"option":"经常","score":3},{"option":"总是","score":4}]',
  weight: 10,
  sortOrder: 0
})

const isAddSubHealthCategory = computed(() => {
  const c = Number(addQuestionForm.value.category)
  return !Number.isNaN(c) && c >= 1 && c <= 3
})

const isAddTcmCategory = computed(() => {
  const c = Number(addQuestionForm.value.category)
  return !Number.isNaN(c) && c >= 4
})

const assessmentTypeOptions = [
  { value: 1, label: '亚健康评估量表：生理指标' },
  { value: 2, label: '亚健康评估量表：心理状态' },
  { value: 3, label: '亚健康评估量表：生活习惯' },
  { value: 4, label: '中医体质评估量表：平和质' },
  { value: 5, label: '中医体质评估量表：气虚质' },
  { value: 6, label: '中医体质评估量表：阳虚质' },
  { value: 7, label: '中医体质评估量表：阴虚质' },
  { value: 8, label: '中医体质评估量表：痰湿质' },
  { value: 9, label: '中医体质评估量表：湿热质' },
  { value: 10, label: '中医体质评估量表：血瘀质' },
  { value: 11, label: '中医体质评估量表：气郁质' },
  { value: 12, label: '中医体质评估量表：特禀质' }
]

const typeNameMap = assessmentTypeOptions.reduce((acc, item) => {
  acc[item.value] = item.label
  return acc
}, {})

const constitutionTypeByCode = {
  4: '平和质',
  5: '气虚质',
  6: '阳虚质',
  7: '阴虚质',
  8: '痰湿质',
  9: '湿热质',
  10: '血瘀质',
  11: '气郁质',
  12: '特禀质'
}

const withTypeName = (question) => ({
  ...question,
  typeName: typeNameMap[question.dimension] || `未知类型(${question.dimension ?? '-'})`
})

const subHealthQuestionList = computed(() => questionList.value.filter((item) => [1, 2, 3].includes(item.dimension)))
const tcmQuestionList = computed(() =>
  tcmScaleList.value.map((item) => ({
    ...item,
    typeName: `中医体质评估量表：${item.constitutionType || '未知体质'}`
  }))
)

// 调理方案相关
const planList = ref([])
const planType = ref('')
const planStatus = ref('')
const planPage = ref(1)
const planPageSize = ref(10)
const planTotal = ref(0)
const planDialogVisible = ref(false)
const planDialogMode = ref('create')
const planForm = ref({
  id: null,
  name: '',
  planType: 1,
  content: '',
  suitableConstitution: '',
  suitableLevel: '0,1',
  tags: '',
  status: 1
})

// 视频相关
const videoList = ref([])
const videoStatus = ref('')
const videoSearch = ref('')
const videoPage = ref(1)
const videoPageSize = ref(10)
const videoTotal = ref(0)
const videoDialogVisible = ref(false)
const videoDialogMode = ref('create')
const videoForm = ref({
  id: null,
  title: '',
  cover: '',
  url: '',
  tags: '',
  duration: 0,
  status: 1
})

// 食谱相关
const recipeList = ref([])
const recipeStatus = ref('')
const recipeSearch = ref('')
const recipePage = ref(1)
const recipePageSize = ref(10)
const recipeTotal = ref(0)
const recipeDialogVisible = ref(false)
const recipeDialogMode = ref('create')
const recipeForm = ref({
  id: null,
  name: '',
  cover: '',
  ingredients: '',
  steps: '',
  suitableConstitution: '',
  tags: '',
  status: 1
})

const getStatusType = (status) => {
  const typeMap = {
    0: 'info',
    1: 'success',
    2: 'warning'
  }
  return typeMap[status] || 'info'
}

const getStatusName = (status) => {
  const nameMap = {
    0: '草稿',
    1: '生效',
    2: '归档'
  }
  return nameMap[status] || '未知'
}

const getPlanTypeName = (type) => {
  const typeMap = {
    1: '药膳',
    2: '穴位',
    3: '运动'
  }
  return typeMap[type] || '未知'
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

const normalizeOptional = (value) => (value === '' || value === null || value === undefined ? undefined : value)

const questionSubHealthIndex = (index) => {
  if (questionType.value) {
    return (questionPage.value - 1) * questionPageSize.value + index + 1
  }
  return (shPage.value - 1) * shPageSize.value + index + 1
}

const questionTcmIndex = (index) => {
  if (questionType.value) {
    return (questionPage.value - 1) * questionPageSize.value + index + 1
  }
  return (tcmQPage.value - 1) * tcmQPageSize.value + index + 1
}

const planIndex = (index) => {
  return (planPage.value - 1) * planPageSize.value + index + 1
}

const videoIndex = (index) => {
  return (videoPage.value - 1) * videoPageSize.value + index + 1
}

const recipeIndex = (index) => {
  return (recipePage.value - 1) * recipePageSize.value + index + 1
}

const searchQuestions = async () => {
  try {
    const st = normalizeOptional(status.value)
    const typeRaw = questionType.value
    const typeEmpty = typeRaw === '' || typeRaw === null || typeRaw === undefined
    const typeCode = Number(typeRaw)

    if (typeEmpty) {
      const [response, tcmResponse] = await Promise.all([
        getAssessmentQuestions({
          subhealthOnly: true,
          status: st,
          page: shPage.value,
          size: shPageSize.value
        }),
        getTcmConstitutionScales({
          constitutionType: undefined,
          status: st,
          page: tcmQPage.value,
          size: tcmQPageSize.value
        })
      ])
      if (response.code === 200) {
        const { list, total } = toListAndTotal(response.data)
        questionList.value = list.map(withTypeName)
        shTotal.value = total
      } else {
        ElMessage.error(response.message || '获取亚健康评估量表失败')
      }
      if (tcmResponse.code === 200) {
        const { list, total } = toListAndTotal(tcmResponse.data)
        tcmScaleList.value = list
        tcmQTotal.value = total
      } else {
        ElMessage.error(tcmResponse.message || '获取中医体质量表失败')
      }
      return
    }

    const response = await getAssessmentQuestions({
      dimension: normalizeOptional(questionType.value),
      status: st,
      page: questionPage.value,
      size: questionPageSize.value
    })
    const tcmResponse = await getTcmConstitutionScales({
      constitutionType: !Number.isNaN(typeCode) && typeCode >= 4
        ? constitutionTypeByCode[typeCode]
        : undefined,
      status: st,
      page: questionPage.value,
      size: questionPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      questionList.value = list.map(withTypeName)
      questionTotal.value = total
    } else {
      ElMessage.error(response.message || '获取评估量表失败')
    }
    if (tcmResponse.code === 200) {
      const { list, total } = toListAndTotal(tcmResponse.data)
      tcmScaleList.value = list
      if (!Number.isNaN(typeCode) && typeCode >= 4) {
        questionTotal.value = total
      }
    } else {
      ElMessage.error(tcmResponse.message || '获取中医体质量表失败')
    }
  } catch (error) {
    ElMessage.error('获取评估量表失败')
  }
}

const handleShQuestionSizeChange = (size) => {
  shPageSize.value = size
  shPage.value = 1
  searchQuestions()
}

const handleTcmQuestionSizeChange = (size) => {
  tcmQPageSize.value = size
  tcmQPage.value = 1
  searchQuestions()
}

watch(questionType, () => {
  questionPage.value = 1
  shPage.value = 1
  tcmQPage.value = 1
})

const openAddQuestionDialog = () => {
  addQuestionForm.value = {
    category: null,
    content: '',
    optionsJson: '[{"option":"从不","score":0},{"option":"很少","score":1},{"option":"有时","score":2},{"option":"经常","score":3},{"option":"总是","score":4}]',
    weight: 10,
    sortOrder: 0
  }
  addQuestionDialogVisible.value = true
}

const submitAddQuestion = async () => {
  const dimNum = Number(addQuestionForm.value.category)
  if (Number.isNaN(dimNum) || !assessmentTypeOptions.some((item) => item.value === dimNum)) {
    ElMessage.warning('请从下拉框中选择题目所属类别')
    return
  }
  const content = (addQuestionForm.value.content || '').trim()
  if (!content) {
    ElMessage.warning('请输入题目内容')
    return
  }
  try {
    let response
    if (dimNum <= 3) {
      let options = addQuestionForm.value.optionsJson?.trim() || '[]'
      try {
        JSON.parse(options)
      } catch {
        ElMessage.error('选项 JSON 格式不正确')
        return
      }
      response = await createAssessmentQuestion({
        dimension: dimNum,
        content,
        options,
        weight: Number(addQuestionForm.value.weight) || 10
      })
    } else {
      response = await createTcmConstitutionScale({
        constitutionType: constitutionTypeByCode[dimNum],
        questionText: content,
        sortOrder: Number(addQuestionForm.value.sortOrder) || 0,
        status: 1
      })
    }
    if (response.code === 200) {
      ElMessage.success('新增成功')
      addQuestionDialogVisible.value = false
      searchQuestions()
    } else {
      ElMessage.error(response.message || '新增失败')
    }
  } catch (e) {
    ElMessage.error('新增失败')
  }
}

const editQuestion = (question) => {
  if (question.dimension >= 4) {
    editTcmScale(question)
    return
  }
  ElMessageBox.prompt('修改题目内容', '编辑题目', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputValue: question.content || ''
  }).then(async ({ value }) => {
    const response = await updateAssessmentQuestion(question.id, { ...question, content: value })
    if (response.code === 200) {
      ElMessage.success('更新成功')
      searchQuestions()
    } else {
      ElMessage.error(response.message || '更新失败')
    }
  }).catch(() => {})
}

const editTcmScale = (scale) => {
  ElMessageBox.prompt('修改题目内容', '编辑中医体质题目', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputValue: scale.questionText || ''
  }).then(async ({ value }) => {
    const response = await updateTcmConstitutionScale(scale.id, {
      ...scale,
      questionText: value
    })
    if (response.code === 200) {
      ElMessage.success('更新成功')
      searchQuestions()
    } else {
      ElMessage.error(response.message || '更新失败')
    }
  }).catch(() => {})
}

const deleteTcmScaleRow = (scale) => {
  ElMessageBox.confirm('确定要删除该中医体质题目吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const response = await deleteTcmConstitutionScale(scale.id)
    if (response.code === 200) {
      ElMessage.success('删除成功')
      searchQuestions()
    } else {
      ElMessage.error(response.message || '删除失败')
    }
  }).catch(() => {})
}

const submitQuestion = (question) => {
  ElMessageBox.confirm('确定要提交审核吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const response = await updateAssessmentVersionStatus(question.version, 1)
    if (response.code === 200) {
      ElMessage.success('提交审核成功')
      searchQuestions()
    } else {
      ElMessage.error(response.message || '提交失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const archiveQuestion = (question) => {
  ElMessageBox.confirm('确定要归档该版本吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const response = await updateAssessmentVersionStatus(question.version, 2)
    if (response.code === 200) {
      ElMessage.success('归档成功')
      searchQuestions()
    } else {
      ElMessage.error(response.message || '归档失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handleQuestionSizeChange = (size) => {
  questionPageSize.value = size
  questionPage.value = 1
  searchQuestions()
}

const handleQuestionCurrentChange = (current) => {
  questionPage.value = current
  searchQuestions()
}

const searchPlans = async () => {
  try {
    const response = await getRegimenPlans({
      planType: normalizeOptional(planType.value),
      status: normalizeOptional(planStatus.value),
      page: planPage.value,
      size: planPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      planList.value = list
      planTotal.value = total
    } else {
      ElMessage.error(response.message || '获取调理方案失败')
    }
  } catch (error) {
    ElMessage.error('获取调理方案失败')
  }
}

const addPlan = () => {
  planDialogMode.value = 'create'
  planForm.value = {
    id: null,
    name: '',
    planType: Number(planType.value || 1),
    content: '',
    suitableConstitution: '',
    suitableLevel: '0,1',
    tags: '',
    status: 1
  }
  planDialogVisible.value = true
}

const editPlan = (plan) => {
  planDialogMode.value = 'edit'
  planForm.value = {
    id: plan.id,
    name: plan.name || '',
    planType: Number(plan.planType || 1),
    content: plan.content || '',
    suitableConstitution: plan.suitableConstitution || '',
    suitableLevel: plan.suitableLevel || '0,1',
    tags: plan.tags || '',
    status: Number(plan.status ?? 1)
  }
  planDialogVisible.value = true
}

const submitPlan = async () => {
  if (!planForm.value.name || !planForm.value.suitableConstitution || !planForm.value.content) {
    ElMessage.warning('请填写完整的方案信息')
    return
  }
  if (![1, 2, 3].includes(Number(planForm.value.planType))) {
    ElMessage.warning('方案类型只能是药膳/穴位/运动')
    return
  }
  try {
    let response
    if (planDialogMode.value === 'create') {
      response = await createRegimenPlan({
        name: planForm.value.name,
        planType: Number(planForm.value.planType),
        content: planForm.value.content,
        suitableConstitution: planForm.value.suitableConstitution,
        suitableLevel: planForm.value.suitableLevel || '0,1',
        tags: planForm.value.tags || '',
        status: Number(planForm.value.status ?? 1)
      })
    } else {
      response = await updateRegimenPlan(planForm.value.id, {
        ...planForm.value,
        planType: Number(planForm.value.planType),
        status: Number(planForm.value.status ?? 1)
      })
    }
    if (response.code === 200) {
      ElMessage.success(planDialogMode.value === 'create' ? '新增成功' : '更新成功')
      planDialogVisible.value = false
      searchPlans()
    } else {
      ElMessage.error(response.message || '保存失败')
    }
  } catch (error) {
    ElMessage.error('保存失败')
  }
}

const togglePlanStatus = (plan) => {
  ElMessageBox.confirm(`确定要${plan.status === 1 ? '下架' : '上架'}该方案吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const newStatus = plan.status === 1 ? 0 : 1
    const response = await updateRegimenPlan(plan.id, {
      ...plan,
      status: newStatus
    })
    if (response.code === 200) {
      ElMessage.success(`方案已${newStatus === 1 ? '上架' : '下架'}`)
      searchPlans()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const deletePlan = (plan) => {
  ElMessageBox.confirm('确定要删除该方案吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'danger'
  }).then(async () => {
    const response = await deleteRegimenPlan(plan.id)
    if (response.code === 200) {
      ElMessage.success('方案已下架')
      searchPlans()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handlePlanSizeChange = (size) => {
  planPageSize.value = size
  searchPlans()
}

const handlePlanCurrentChange = (current) => {
  planPage.value = current
  searchPlans()
}

const searchVideos = async () => {
  try {
    const response = await getVideos({
      tags: normalizeOptional(videoSearch.value),
      status: normalizeOptional(videoStatus.value),
      page: videoPage.value,
      size: videoPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      videoList.value = list
      videoTotal.value = total
    } else {
      ElMessage.error(response.message || '获取视频失败')
    }
  } catch (error) {
    ElMessage.error('获取视频失败')
  }
}

const addVideo = () => {
  videoDialogMode.value = 'create'
  videoForm.value = {
    id: null,
    title: '',
    cover: '',
    url: '',
    tags: videoSearch.value || '',
    duration: 0,
    status: 1
  }
  videoDialogVisible.value = true
}

const editVideo = (video) => {
  videoDialogMode.value = 'edit'
  videoForm.value = {
    id: video.id,
    title: video.title || video.name || '',
    cover: video.cover || '',
    url: video.url || '',
    tags: video.tags || '',
    duration: Number(video.duration || 0),
    status: Number(video.status ?? 1)
  }
  videoDialogVisible.value = true
}

const handleVideoCoverUpload = async ({ file }) => {
  try {
    videoForm.value.cover = await uploadAdminImage(file)
    ElMessage.success('封面上传成功')
  } catch (e) {
    ElMessage.error(e?.message || '封面上传失败')
  }
}

const handleVideoFileUpload = async ({ file }) => {
  try {
    videoForm.value.url = await uploadAdminVideo(file)
    ElMessage.success('视频上传成功')
  } catch (e) {
    ElMessage.error(e?.message || '视频上传失败')
  }
}

const handleRecipeCoverUpload = async ({ file }) => {
  try {
    recipeForm.value.cover = await uploadAdminImage(file)
    ElMessage.success('封面上传成功')
  } catch (e) {
    ElMessage.error(e?.message || '封面上传失败')
  }
}

const submitVideo = async () => {
  if (!videoForm.value.title || !videoForm.value.cover || !videoForm.value.url) {
    ElMessage.warning('请填写完整的视频信息')
    return
  }
  try {
    let response
    if (videoDialogMode.value === 'create') {
      response = await createVideo({
        title: videoForm.value.title,
        cover: videoForm.value.cover,
        url: videoForm.value.url,
        tags: videoForm.value.tags || '',
        duration: Number(videoForm.value.duration || 0),
        status: Number(videoForm.value.status ?? 1)
      })
    } else {
      response = await updateVideo(videoForm.value.id, {
        ...videoForm.value,
        title: videoForm.value.title,
        tags: videoForm.value.tags || '',
        duration: Number(videoForm.value.duration || 0),
        status: Number(videoForm.value.status ?? 1)
      })
    }
    if (response.code === 200) {
      ElMessage.success(videoDialogMode.value === 'create' ? '新增成功' : '更新成功')
      videoDialogVisible.value = false
      searchVideos()
    } else {
      ElMessage.error(response.message || '保存失败')
    }
  } catch (error) {
    ElMessage.error('保存失败')
  }
}

const toggleVideoStatus = (video) => {
  ElMessageBox.confirm(`确定要${video.status === 1 ? '下架' : '上架'}该视频吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const newStatus = video.status === 1 ? 0 : 1
    const response = await updateVideoStatus(video.id, newStatus)
    if (response.code === 200) {
      ElMessage.success(`视频已${newStatus === 1 ? '上架' : '下架'}`)
      searchVideos()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const deleteVideo = (video) => {
  ElMessageBox.confirm('确定要删除该视频吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'danger'
  }).then(async () => {
    const response = await updateVideoStatus(video.id, 0)
    if (response.code === 200) {
      ElMessage.success('视频已下架')
      searchVideos()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handleVideoSizeChange = (size) => {
  videoPageSize.value = size
  searchVideos()
}

const handleVideoCurrentChange = (current) => {
  videoPage.value = current
  searchVideos()
}

const searchRecipes = async () => {
  try {
    const response = await getRecipes({
      tags: normalizeOptional(recipeSearch.value),
      status: normalizeOptional(recipeStatus.value),
      page: recipePage.value,
      size: recipePageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      recipeList.value = list
      recipeTotal.value = total
    } else {
      ElMessage.error(response.message || '获取食谱失败')
    }
  } catch (error) {
    ElMessage.error('获取食谱失败')
  }
}

const addRecipe = () => {
  recipeDialogMode.value = 'create'
  recipeForm.value = {
    id: null,
    name: '',
    cover: '',
    ingredients: '',
    steps: '',
    suitableConstitution: '',
    tags: recipeSearch.value || '',
    status: 1
  }
  recipeDialogVisible.value = true
}

const editRecipe = (recipe) => {
  recipeDialogMode.value = 'edit'
  recipeForm.value = {
    id: recipe.id,
    name: recipe.name || recipe.title || '',
    cover: recipe.cover || '',
    ingredients: recipe.ingredients || '',
    steps: recipe.steps || '',
    suitableConstitution: recipe.suitableConstitution || '',
    tags: recipe.tags || '',
    status: Number(recipe.status ?? 1)
  }
  recipeDialogVisible.value = true
}

const submitRecipe = async () => {
  if (!recipeForm.value.name || !recipeForm.value.cover || !recipeForm.value.ingredients || !recipeForm.value.steps) {
    ElMessage.warning('请填写完整的食谱信息')
    return
  }
  try {
    let response
    if (recipeDialogMode.value === 'create') {
      response = await createRecipe({
        name: recipeForm.value.name,
        title: recipeForm.value.name,
        cover: recipeForm.value.cover,
        ingredients: recipeForm.value.ingredients,
        steps: recipeForm.value.steps,
        suitableConstitution: recipeForm.value.suitableConstitution || '',
        tags: recipeForm.value.tags || '',
        status: Number(recipeForm.value.status ?? 1)
      })
    } else {
      response = await updateRecipe(recipeForm.value.id, {
        ...recipeForm.value,
        name: recipeForm.value.name,
        title: recipeForm.value.name,
        status: Number(recipeForm.value.status ?? 1)
      })
    }
    if (response.code === 200) {
      ElMessage.success(recipeDialogMode.value === 'create' ? '新增成功' : '更新成功')
      recipeDialogVisible.value = false
      searchRecipes()
    } else {
      ElMessage.error(response.message || '保存失败')
    }
  } catch (error) {
    ElMessage.error('保存失败')
  }
}

const toggleRecipeStatus = (recipe) => {
  ElMessageBox.confirm(`确定要${recipe.status === 1 ? '下架' : '上架'}该食谱吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const newStatus = recipe.status === 1 ? 0 : 1
    const response = await updateRecipeStatus(recipe.id, newStatus)
    if (response.code === 200) {
      ElMessage.success(`食谱已${newStatus === 1 ? '上架' : '下架'}`)
      searchRecipes()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const deleteRecipe = (recipe) => {
  ElMessageBox.confirm('确定要删除该食谱吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'danger'
  }).then(async () => {
    const response = await updateRecipeStatus(recipe.id, 0)
    if (response.code === 200) {
      ElMessage.success('食谱已下架')
      searchRecipes()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handleRecipeSizeChange = (size) => {
  recipePageSize.value = size
  searchRecipes()
}

const handleRecipeCurrentChange = (current) => {
  recipePage.value = current
  searchRecipes()
}

onMounted(() => {
  searchQuestions()
  searchPlans()
  searchVideos()
  searchRecipes()
})
</script>

<style scoped>
.content-rule {
  padding: 20px;
}

.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}
</style>
