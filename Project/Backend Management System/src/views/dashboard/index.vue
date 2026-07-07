<template>
  <div class="dashboard">
    <h1>工作台</h1>
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="stats-card">
          <div class="stats-item">
            <div class="stats-number">{{ stats.todayActiveUsers }}</div>
            <div class="stats-label">今日活跃用户</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stats-card">
          <div class="stats-item">
            <div class="stats-number">{{ stats.totalUsers }}</div>
            <div class="stats-label">总用户数</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stats-card">
          <div class="stats-item">
            <div class="stats-number">{{ stats.pendingPosts }}</div>
            <div class="stats-label">待审核动态</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stats-card">
          <div class="stats-item">
            <div class="stats-number">{{ stats.abnormalHealthData }}</div>
            <div class="stats-label">异常健康数据</div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <div class="charts-section">
      <el-card class="chart-card">
        <template #header>
          <div class="card-header">
            <span>用户注册趋势</span>
          </div>
        </template>
        <div class="chart-container">
          <div id="userTrendChart" style="width: 100%; height: 300px;"></div>
        </div>
      </el-card>
      
      <el-card class="chart-card">
        <template #header>
          <div class="card-header">
            <span>健康指标分布</span>
          </div>
        </template>
        <div class="chart-container">
          <div id="healthDistributionChart" style="width: 100%; height: 300px;"></div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, nextTick, reactive } from 'vue'
import * as echarts from 'echarts'
import { ElMessage } from 'element-plus'
import { getUserList, getAbnormalHealthData } from '../../api/user'
import { getPendingPosts } from '../../api/social'
import { getUserRegistrationTrend, getHealthIndicatorDistribution, getUserActivity } from '../../api/system'

const stats = reactive({
  todayActiveUsers: 0,
  totalUsers: 0,
  pendingPosts: 0,
  abnormalHealthData: 0
})

let userTrendChart = null
let healthDistributionChart = null

const formatDate = (value) => {
  const date = new Date(value)
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${date.getFullYear()}-${month}-${day}`
}

const initCharts = async () => {
  await nextTick()
  const trendDom = document.getElementById('userTrendChart')
  const healthDom = document.getElementById('healthDistributionChart')
  if (trendDom && trendDom.clientWidth > 0 && trendDom.clientHeight > 0 && !userTrendChart) {
    userTrendChart = echarts.init(trendDom)
  }
  if (healthDom && healthDom.clientWidth > 0 && healthDom.clientHeight > 0 && !healthDistributionChart) {
    healthDistributionChart = echarts.init(healthDom)
  }
}

const loadDashboardStats = async () => {
  try {
    const [userRes, pendingRes, abnormalRes, activeRes] = await Promise.all([
      getUserList({ page: 1, size: 1000 }),
      getPendingPosts({ page: 1, size: 1000 }),
      getAbnormalHealthData({ page: 1, size: 1000 }),
      getUserActivity({
        startDate: formatDate(new Date()),
        endDate: formatDate(new Date()),
        interval: 'day'
      })
    ])
    if (userRes.code === 200) {
      stats.totalUsers = Array.isArray(userRes.data) ? userRes.data.length : (userRes.data?.total || 0)
    }
    if (pendingRes.code === 200) {
      stats.pendingPosts = Array.isArray(pendingRes.data) ? pendingRes.data.length : (pendingRes.data?.total || 0)
    }
    if (abnormalRes.code === 200) {
      stats.abnormalHealthData = Array.isArray(abnormalRes.data) ? abnormalRes.data.length : (abnormalRes.data?.total || 0)
    }
    if (activeRes.code === 200) {
      const counts = activeRes.data?.counts || []
      stats.todayActiveUsers = counts.reduce((sum, item) => sum + Number(item || 0), 0)
    }
  } catch (error) {
    ElMessage.error('加载工作台统计失败')
  }
}

const loadTrendChart = async () => {
  await initCharts()
  if (!userTrendChart) return
  try {
    const end = new Date()
    const start = new Date(Date.now() - 6 * 24 * 60 * 60 * 1000)
    const res = await getUserRegistrationTrend({
      startDate: formatDate(start),
      endDate: formatDate(end),
      interval: 'day'
    })
    const dates = res?.data?.dates || []
    const counts = res?.data?.counts || []
    userTrendChart.setOption({
      title: { text: '近7天用户注册趋势', left: 'center' },
      tooltip: { trigger: 'axis' },
      xAxis: { type: 'category', data: dates },
      yAxis: { type: 'value' },
      series: [{ data: counts, type: 'line', smooth: true }]
    })
  } catch (error) {
    ElMessage.error('加载趋势图失败')
  }
}

const loadHealthChart = async () => {
  await initCharts()
  if (!healthDistributionChart) return
  try {
    const res = await getHealthIndicatorDistribution('bmi')
    const distribution = res?.data?.distribution || {}
    const data = Object.keys(distribution).map(key => ({ name: key, value: Number(distribution[key] || 0) }))
    healthDistributionChart.setOption({
      title: { text: 'BMI分布', left: 'center' },
      tooltip: { trigger: 'item' },
      legend: { orient: 'vertical', left: 'left' },
      series: [{
        name: 'BMI分布',
        type: 'pie',
        radius: '60%',
        data,
        emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } }
      }]
    })
  } catch (error) {
    ElMessage.error('加载健康分布图失败')
  }
}

const handleResize = () => {
  userTrendChart?.resize()
  healthDistributionChart?.resize()
}

onMounted(() => {
  loadDashboardStats()
  loadTrendChart()
  loadHealthChart()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  userTrendChart?.dispose()
  healthDistributionChart?.dispose()
})
</script>

<style scoped>
.dashboard {
  padding: 20px;
}

.stats-card {
  margin-bottom: 20px;
}

.stats-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.stats-number {
  font-size: 32px;
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 10px;
}

.stats-label {
  font-size: 14px;
  color: #606266;
}

.charts-section {
  display: flex;
  gap: 20px;
  margin-top: 20px;
}

.chart-card {
  flex: 1;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chart-container {
  margin-top: 20px;
}
</style>
