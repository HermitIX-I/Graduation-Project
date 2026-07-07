import api from './index'

// 评估量表管理
export const getAssessmentQuestions = async (params: {
  dimension?: number
  version?: number
  status?: number
  page: number
  size: number
  /** 为 true 时仅查 dimension 1~3（亚健康），与中医体质表分开分页 */
  subhealthOnly?: boolean
}) => {
  return api.get('/api/admin/assessment/questions', { params })
}

export const createAssessmentQuestion = async (data: any) => {
  return api.post('/api/admin/assessment/question', data)
}

export const updateAssessmentQuestion = async (id: number, data: any) => {
  return api.put(`/api/admin/assessment/question/${id}`, data)
}

export const updateAssessmentVersionStatus = async (version: number, status: number) => {
  return api.put(`/api/admin/assessment/version/${version}/status`, { status })
}

// 中医体质评估量表管理
export const getTcmConstitutionScales = async (params: {
  constitutionType?: string
  status?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/tcm-constitution-scales', { params })
}

export const createTcmConstitutionScale = async (data: any) => {
  return api.post('/api/admin/tcm-constitution-scale', data)
}

export const updateTcmConstitutionScale = async (id: number, data: any) => {
  return api.put(`/api/admin/tcm-constitution-scale/${id}`, data)
}

export const deleteTcmConstitutionScale = async (id: number) => {
  return api.delete(`/api/admin/tcm-constitution-scale/${id}`)
}

// 调理方案管理
export const getRegimenPlans = async (params: {
  planType?: number
  status?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/regimen-plans', { params })
}

export const createRegimenPlan = async (data: any) => {
  return api.post('/api/admin/regimen-plan', data)
}

export const updateRegimenPlan = async (id: number, data: any) => {
  return api.put(`/api/admin/regimen-plan/${id}`, data)
}

export const deleteRegimenPlan = async (id: number) => {
  return api.delete(`/api/admin/regimen-plan/${id}`)
}

// 视频管理
export const getVideos = async (params: {
  tags?: string
  status?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/videos', { params })
}

export const createVideo = async (data: any) => {
  return api.post('/api/admin/video', data)
}

export const updateVideo = async (id: number, data: any) => {
  return api.put(`/api/admin/video/${id}`, data)
}

export const updateVideoStatus = async (id: number, status: number) => {
  return api.put(`/api/admin/video/${id}/status`, { status })
}

// 食谱管理
export const getRecipes = async (params: {
  tags?: string
  suitableConstitution?: string
  status?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/recipes', { params })
}

export const createRecipe = async (data: any) => {
  return api.post('/api/admin/recipe', data)
}

export const updateRecipe = async (id: number, data: any) => {
  return api.put(`/api/admin/recipe/${id}`, data)
}

export const updateRecipeStatus = async (id: number, status: number) => {
  return api.put(`/api/admin/recipe/${id}/status`, { status })
}