import api from './index'

// 登录
interface LoginRequest {
  username: string
  password: string
}

interface LoginResponse {
  code: number
  message: string
  data: {
    token: string
    role: string
  }
}

export const login = async (data: LoginRequest): Promise<LoginResponse> => {
  return api.post('/api/admin/auth/login', data)
}

// 用户管理
export const getUserList = async (params: {
  keyword?: string
  status?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/users', { params })
}

export const getUserById = async (userId: number) => {
  return api.get(`/api/admin/user/${userId}`)
}

export const createUser = async (data: any) => {
  return api.post('/api/admin/user', data)
}

export const updateUser = async (userId: number, data: any) => {
  return api.put(`/api/admin/user/${userId}`, data)
}

export const updateUserStatus = async (userId: number, status: number) => {
  return api.put(`/api/admin/user/${userId}/status`, { status })
}

export const deleteUser = async (userId: number) => {
  return api.delete(`/api/admin/user/${userId}`)
}

// 异常健康数据管理
export const getAbnormalHealthData = async (params: {
  dataType?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/health-data/abnormal', { params })
}

export const updateHealthData = async (dataId: number, value: number) => {
  return api.put(`/api/admin/health-data/${dataId}`, { value })
}

export const deleteHealthData = async (dataId: number) => {
  return api.delete(`/api/admin/health-data/${dataId}`)
}

export const batchProcessHealthData = async (ids: number[], action: string) => {
  return api.post('/api/admin/health-data/batch', { ids, action })
}

// 超级管理员 - 管理员管理
export const getAdminList = async (params: {
  keyword?: string
  status?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/admins', { params })
}

export const createAdmin = async (data: {
  username: string
  password: string
  role: string
}) => {
  return api.post('/api/admin/admin', data)
}

export const updateAdminRole = async (adminId: number, role: string) => {
  return api.put(`/api/admin/admin/${adminId}/role`, { role })
}

export const updateAdminPassword = async (adminId: number, password: string) => {
  return api.put(`/api/admin/admin/${adminId}/password`, { password })
}

export const updateAdminStatus = async (adminId: number, status: number, role?: string) => {
  return api.put(`/api/admin/admin/${adminId}/status`, { status, role })
}