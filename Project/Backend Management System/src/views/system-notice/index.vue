<template>
  <div class="system-notice">
    <h1>系统公告与数据统计</h1>
    
    <el-tabs v-model="activeTab">
      <el-tab-pane label="公告管理" name="notices">
        <div class="search-bar">
          <el-select v-model="noticeStatus" placeholder="状态" style="width: 150px; margin-right: 10px;">
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
          </el-select>
          <el-input v-model="noticeSearch" placeholder="搜索公告标题" style="width: 300px; margin-right: 10px;">
            <template #append>
              <el-button @click="searchNotices"><el-icon><Search /></el-icon></el-button>
            </template>
          </el-input>
          <el-button type="primary" @click="addNotice">发布公告</el-button>
        </div>
        
        <el-table :data="noticeList" style="width: 100%; margin-top: 20px;">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="title" label="标题" />
          <el-table-column prop="targetScope" label="推送范围" width="150" />
          <el-table-column label="有效期" width="240">
            <template #default="scope">
              <span>{{ formatValidity(scope.row.validFrom, scope.row.validTo) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
                {{ scope.row.status === 1 ? '上架' : '下架' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="publishTime" label="发布时间" width="180" />
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="editNotice(scope.row)">编辑</el-button>
              <el-button size="small" :type="scope.row.status === 1 ? 'warning' : 'success'" @click="toggleNoticeStatus(scope.row)">
                {{ scope.row.status === 1 ? '下架' : '上架' }}
              </el-button>
              <el-button size="small" type="danger" @click="deleteNotice(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="noticePage"
          v-model:page-size="noticePageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="noticeTotal"
          @size-change="handleNoticeSizeChange"
          @current-change="handleNoticeCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
      
      <el-tab-pane label="数据统计" name="statistics">
        <el-card class="stats-card">
          <template #header>
            <div class="card-header">
              <span>用户注册趋势</span>
              <el-date-picker
                v-model="userTrendDateRange"
                type="daterange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                style="margin-left: 20px;"
                @change="getUserTrend"
              />
            </div>
          </template>
          <div id="userTrendChart" style="width: 100%; height: 400px;"></div>
        </el-card>
        
        <el-row :gutter="20" style="margin-top: 20px;">
          <el-col :span="12">
            <el-card class="stats-card">
              <template #header>
                <div class="card-header">
                  <span>活跃用户统计</span>
                  <el-select v-model="activeType" style="margin-left: 20px;" @change="getActiveUsers">
                    <el-option label="日活" :value="'dau'" />
                    <el-option label="周活" :value="'wau'" />
                    <el-option label="月活" :value="'mau'" />
                  </el-select>
                  <el-date-picker
                    v-model="activeDate"
                    type="date"
                    placeholder="选择日期"
                    style="margin-left: 10px;"
                    @change="getActiveUsers"
                  />
                </div>
              </template>
              <div class="active-stats">
                <div class="active-number">{{ activeCount }}</div>
                <div class="active-label">{{ activeType === 'dau' ? '日活' : activeType === 'wau' ? '周活' : '月活' }}用户数</div>
              </div>
            </el-card>
          </el-col>
          
          <el-col :span="12">
            <el-card class="stats-card">
              <template #header>
                <div class="card-header">
                  <span>健康指标分布</span>
                  <el-select v-model="healthIndicator" style="margin-left: 20px;" @change="getHealthDistribution">
                    <el-option label="BMI" :value="'bmi'" />
                    <el-option label="血压" :value="'blood_pressure'" />
                    <el-option label="血糖" :value="'blood_sugar'" />
                  </el-select>
                </div>
              </template>
              <div id="healthDistributionChart" style="width: 100%; height: 300px;"></div>
            </el-card>
          </el-col>

          <el-col :span="12">
            <el-card class="stats-card">
              <template #header>
                <div class="card-header">
                  <span>留存率（估算）</span>
                </div>
              </template>
              <div id="retentionChart" style="width: 100%; height: 300px;"></div>
            </el-card>
          </el-col>
        </el-row>
        
        <el-card class="stats-card" style="margin-top: 20px;">
          <template #header>
            <div class="card-header">
              <span>推荐点击率</span>
              <el-date-picker
                v-model="ctrDateRange"
                type="daterange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                style="margin-left: 20px;"
                @change="getCtrData"
              />
            </div>
          </template>
          <div class="ctr-stats">
            <div class="ctr-item">
              <div class="ctr-number">{{ ctrData.impressions }}</div>
              <div class="ctr-label">曝光量</div>
            </div>
            <div class="ctr-item">
              <div class="ctr-number">{{ ctrData.clicks }}</div>
              <div class="ctr-label">点击量</div>
            </div>
            <div class="ctr-item">
              <div class="ctr-number">{{ ctrData.ctr }}%</div>
              <div class="ctr-label">点击率</div>
            </div>
          </div>
        </el-card>
        
        <el-card class="stats-card" style="margin-top: 20px;">
          <template #header>
            <div class="card-header">
              <span>导出统计报表</span>
            </div>
          </template>
          <div class="export-section">
            <el-date-picker
              v-model="exportDateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              style="width: 300px; margin-right: 10px;"
            />
            <el-select v-model="exportType" style="width: 200px; margin-right: 10px;">
              <el-option label="用户趋势" :value="'user_trend'" />
              <el-option label="健康分布" :value="'health_distribution'" />
              <el-option label="点击率" :value="'ctr'" />
            </el-select>
            <el-select v-model="exportFormat" style="width: 160px; margin-right: 10px;">
              <el-option label="CSV" :value="'csv'" />
              <el-option label="Excel(xlsx)" :value="'xlsx'" />
              <el-option label="PDF" :value="'pdf'" />
            </el-select>
            <el-button type="primary" @click="exportReport">导出报表</el-button>
          </div>
        </el-card>
      </el-tab-pane>
    </el-tabs>

    <el-dialog v-model="noticeDialogVisible" :title="noticeDialogMode === 'create' ? '发布公告' : '编辑公告'" width="640px">
      <el-form :model="noticeForm" label-width="90px">
        <el-form-item label="标题">
          <el-input v-model="noticeForm.title" />
        </el-form-item>
        <el-form-item label="推送范围">
          <el-select v-model="noticeForm.targetScope" style="width: 100%">
            <el-option label="全部用户" value="all" />
            <el-option label="普通用户" value="user" />
            <el-option label="管理员" value="admin" />
          </el-select>
        </el-form-item>
        <el-form-item label="内容">
          <el-input v-model="noticeForm.content" type="textarea" :rows="6" />
        </el-form-item>
        <el-form-item label="有效期">
          <el-date-picker
            v-model="noticeForm.validRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="noticeDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitNotice">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import {
  getNotices,
  createNotice,
  updateNotice,
  offlineNotice,
  deleteNotice as removeNotice,
  getUserRegistrationTrend,
  getUserActivity,
  getHealthIndicatorDistribution,
  getRecommendationCTR,
  exportStatisticsReport
} from '../../api/system'

const activeTab = ref('notices')

// 公告管理相关
const noticeList = ref([])
const noticeStatus = ref('')
const noticeSearch = ref('')
const noticePage = ref(1)
const noticePageSize = ref(10)
const noticeTotal = ref(0)
const noticeDialogVisible = ref(false)
const noticeDialogMode = ref('create')
const noticeForm = ref({
  id: null,
  title: '',
  content: '',
  targetScope: 'all'
})

// 数据统计相关
const userTrendDateRange = ref([new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), new Date()])
const activeType = ref('dau')
const activeDate = ref(new Date())
const activeCount = ref(0)
const healthIndicator = ref('bmi')
const ctrDateRange = ref([new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), new Date()])
const ctrData = ref({ impressions: 0, clicks: 0, ctr: 0 })
const exportDateRange = ref([new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), new Date()])
const exportType = ref('user_trend')
const exportFormat = ref('csv')

// 图表实例
let userTrendChart = null
let healthDistributionChart = null
let retentionChart = null

const formatDate = (value) => {
  const date = new Date(value)
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${date.getFullYear()}-${month}-${day}`
}

const formatValidity = (validFrom, validTo) => {
  if (!validFrom && !validTo) return '长期有效'
  return `${validFrom || '-'} 至 ${validTo || '-'}`
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

const searchNotices = async () => {
  try {
    const response = await getNotices({
      status: noticeStatus.value === '' ? undefined : noticeStatus.value,
      keyword: noticeSearch.value?.trim() || undefined,
      page: noticePage.value,
      size: noticePageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      noticeList.value = list
      noticeTotal.value = total
    } else {
      ElMessage.error(response.message || '获取公告失败')
    }
  } catch (error) {
    ElMessage.error('获取公告失败')
  }
}

const addNotice = () => {
  noticeDialogMode.value = 'create'
  noticeForm.value = { id: null, title: '', content: '', targetScope: 'all', validRange: [] }
  noticeDialogVisible.value = true
}

const editNotice = (notice) => {
  noticeDialogMode.value = 'edit'
  noticeForm.value = {
    id: notice.id,
    title: notice.title || '',
    content: notice.content || '',
    targetScope: notice.targetScope || 'all',
    validRange: notice.validFrom && notice.validTo ? [new Date(notice.validFrom), new Date(notice.validTo)] : []
  }
  noticeDialogVisible.value = true
}

const submitNotice = async () => {
  if (!noticeForm.value.title || !noticeForm.value.content) {
    ElMessage.warning('标题和内容不能为空')
    return
  }
  try {
    const [validFromDate, validToDate] = noticeForm.value.validRange || []
    const payload = {
      ...noticeForm.value,
      validFrom: validFromDate ? formatDate(validFromDate) : null,
      validTo: validToDate ? formatDate(validToDate) : null
    }
    const response = noticeDialogMode.value === 'create'
      ? await createNotice(payload)
      : await updateNotice(noticeForm.value.id, payload)
    if (response.code === 200) {
      ElMessage.success(noticeDialogMode.value === 'create' ? '公告发布成功' : '公告更新成功')
      noticeDialogVisible.value = false
      searchNotices()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const toggleNoticeStatus = (notice) => {
  ElMessageBox.confirm(`确定要${notice.status === 1 ? '下架' : '上架'}该公告吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const response = notice.status === 1
      ? await offlineNotice(notice.id)
      : await updateNotice(notice.id, {
          ...notice,
          status: 1
        })
    if (response.code === 200) {
      ElMessage.success(`公告已${notice.status === 1 ? '下架' : '上架'}`)
      searchNotices()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const deleteNotice = (notice) => {
  ElMessageBox.confirm('确定要删除该公告吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'danger'
  }).then(async () => {
    const response = await removeNotice(notice.id)
    if (response.code === 200) {
      ElMessage.success('公告已删除')
      searchNotices()
    } else {
      ElMessage.error(response.message || '删除失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handleNoticeSizeChange = (size) => {
  noticePageSize.value = size
  searchNotices()
}

const handleNoticeCurrentChange = (current) => {
  noticePage.value = current
  searchNotices()
}

const getUserTrend = async () => {
  const [start, end] = userTrendDateRange.value || []
  if (!start || !end) return
  if (!userTrendChart) {
    await nextTick()
    const dom = document.getElementById('userTrendChart')
    if (!dom || dom.clientWidth === 0 || dom.clientHeight === 0) return
    userTrendChart = echarts.init(dom)
  }

  try {
    const response = await getUserRegistrationTrend({
      startDate: formatDate(start),
      endDate: formatDate(end),
      interval: 'day'
    })
    const data = response?.data || {}
    const dates = data.dates || []
    const counts = data.counts || []
    userTrendChart.setOption({
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: dates
    },
    yAxis: {
      type: 'value'
    },
    series: [{
      data: counts,
      type: 'line',
      smooth: true
    }]
  })
  } catch (error) {
    ElMessage.error('获取用户趋势失败')
  }
}

const getActiveUsers = async () => {
  const date = activeDate.value || new Date()
  try {
    const response = await getUserActivity({
      startDate: formatDate(date),
      endDate: formatDate(date),
      interval: activeType.value === 'dau' ? 'day' : activeType.value === 'wau' ? 'week' : 'month'
    })
    const counts = response?.data?.counts || []
    activeCount.value = counts.reduce((sum, item) => sum + Number(item || 0), 0)
  } catch (error) {
    ElMessage.error('获取活跃用户失败')
  }
}

const getHealthDistribution = async () => {
  if (!healthDistributionChart) {
    await nextTick()
    const dom = document.getElementById('healthDistributionChart')
    if (!dom || dom.clientWidth === 0 || dom.clientHeight === 0) return
    healthDistributionChart = echarts.init(dom)
  }

  try {
    const response = await getHealthIndicatorDistribution(healthIndicator.value)
    const distribution = response?.data?.distribution || {}
    const data = Object.keys(distribution).map(key => ({
      name: key,
      value: Number(distribution[key] || 0)
    }))
    const chartData = data.length > 0 ? data : [{ name: '暂无数据', value: 1 }]
    healthDistributionChart.setOption({
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [{
      name: '健康指标分布',
      type: 'pie',
      radius: '60%',
      data: chartData,
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }]
  })
  } catch (error) {
    ElMessage.error('获取健康分布失败')
  }
}

const getCtrData = async () => {
  const [start, end] = ctrDateRange.value || []
  if (!start || !end) return
  try {
    const response = await getRecommendationCTR({
      startDate: formatDate(start),
      endDate: formatDate(end)
    })
    const ctr = Number(response?.data?.ctr || 0)
    ctrData.value = {
      impressions: 0,
      clicks: 0,
      ctr: Number((ctr * 100).toFixed(2))
    }
  } catch (error) {
    ElMessage.error('获取点击率失败')
  }
}

const getRetentionData = async () => {
  if (!retentionChart) {
    await nextTick()
    const dom = document.getElementById('retentionChart')
    if (!dom || dom.clientWidth === 0 || dom.clientHeight === 0) return
    retentionChart = echarts.init(dom)
  }
  try {
    const end = new Date()
    const start = new Date(Date.now() - 13 * 24 * 60 * 60 * 1000)
    const response = await getUserRegistrationTrend({
      startDate: formatDate(start),
      endDate: formatDate(end),
      interval: 'day'
    })
    const dates = response?.data?.dates || []
    const counts = (response?.data?.counts || []).map(v => Number(v || 0))
    const retentionSeries = counts.map((v, idx) => {
      if (idx === 0 || counts[idx - 1] === 0) return 0
      return Number(((v / counts[idx - 1]) * 100).toFixed(2))
    })
    retentionChart.setOption({
      tooltip: { trigger: 'axis' },
      xAxis: { type: 'category', data: dates },
      yAxis: { type: 'value', axisLabel: { formatter: '{value}%' } },
      series: [{ name: '估算留存率', data: retentionSeries, type: 'line', smooth: true }]
    })
  } catch (error) {
    ElMessage.error('获取留存率失败')
  }
}

const exportReport = async () => {
  const [start, end] = exportDateRange.value || []
  if (!start || !end) {
    ElMessage.warning('请选择导出时间范围')
    return
  }
  try {
    const fileData = await exportStatisticsReport({
      startDate: formatDate(start),
      endDate: formatDate(end),
      format: exportFormat.value
    })
    const mimeMap = {
      csv: 'text/csv;charset=utf-8;',
      xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      pdf: 'application/pdf'
    }
    const blob = fileData instanceof Blob ? fileData : new Blob([fileData], { type: mimeMap[exportFormat.value] })
    const downloadUrl = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = downloadUrl
    link.download = `statistics_report_${formatDate(start)}_${formatDate(end)}.${exportFormat.value}`
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(downloadUrl)
    ElMessage.success('报表已下载，请在浏览器默认下载目录查看')
  } catch (error) {
    ElMessage.error('导出失败')
  }
}

const initStatisticsIfNeeded = async () => {
  if (activeTab.value !== 'statistics') return
  await nextTick()
  await getUserTrend()
  await getHealthDistribution()
  await getActiveUsers()
  await getCtrData()
  await getRetentionData()
}

const handleResize = () => {
  userTrendChart?.resize()
  healthDistributionChart?.resize()
  retentionChart?.resize()
}

onMounted(() => {
  searchNotices()
  window.addEventListener('resize', handleResize)
  initStatisticsIfNeeded()
})

watch(activeTab, async (tab) => {
  if (tab === 'statistics') {
    await initStatisticsIfNeeded()
  }
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  userTrendChart?.dispose()
  healthDistributionChart?.dispose()
  retentionChart?.dispose()
})
</script>

<style scoped>
.system-notice {
  padding: 20px;
}

.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.active-stats {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}

.active-number {
  font-size: 48px;
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 10px;
}

.active-label {
  font-size: 18px;
  color: #606266;
}

.ctr-stats {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 20px;
}

.ctr-item {
  text-align: center;
}

.ctr-number {
  font-size: 32px;
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 10px;
}

.ctr-label {
  font-size: 16px;
  color: #606266;
}

.export-section {
  display: flex;
  align-items: center;
  padding: 20px;
}
</style>
