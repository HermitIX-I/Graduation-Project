import api from './index'

// 系统公告管理
export const getNotices = async (params: {
  status?: number
  keyword?: string
  page: number
  size: number
}) => {
  return api.get('/api/admin/notices', { params })
}

export const createNotice = async (data: any) => {
  return api.post('/api/admin/notice', data)
}

export const updateNotice = async (id: number, data: any) => {
  return api.put(`/api/admin/notice/${id}`, data)
}

export const offlineNotice = async (id: number) => {
  return api.put(`/api/admin/notice/${id}/offline`)
}

export const deleteNotice = async (id: number) => {
  return api.delete(`/api/admin/notice/${id}`)
}

// 数据统计接口
export const getUserRegistrationTrend = async (params: {
  startDate: string
  endDate: string
  interval?: string
}) => {
  return api.get('/api/admin/statistics/user/trend', { params })
}

export const getUserActivity = async (params: {
  startDate: string
  endDate: string
  interval?: string
}) => {
  return api.get('/api/admin/statistics/user/active', { params })
}

export const getHealthIndicatorDistribution = async (indicator: string) => {
  return api.get(`/api/admin/statistics/health/distribution?indicator=${indicator}`)
}

export const getRecommendationCTR = async (params: {
  startDate: string
  endDate: string
}) => {
  return api.get('/api/admin/statistics/recommend/ctr', { params })
}

// 导出统计报表
export const exportStatisticsReport = async (params: {
  startDate: string
  endDate: string
  format?: 'csv' | 'xlsx' | 'pdf'
}) => {
  return api.get('/api/admin/statistics/export', {
    params,
    responseType: 'blob'
  })
}