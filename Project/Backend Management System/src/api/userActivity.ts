import api from './index'

export const getVideoCollections = (params: {
  userId?: number
  videoId?: number
  page: number
  size: number
}) => api.get('/api/admin/video-collections', { params })

export const createVideoCollection = (data: { userId: number; videoId: number }) =>
  api.post('/api/admin/video-collections', data)

export const updateVideoCollection = (id: number, data: { userId: number; videoId: number }) =>
  api.put(`/api/admin/video-collections/${id}`, data)

export const deleteVideoCollection = (id: number) => api.delete(`/api/admin/video-collections/${id}`)

export const getRecipeCollections = (params: {
  userId?: number
  recipeId?: number
  page: number
  size: number
}) => api.get('/api/admin/recipe-collections', { params })

export const createRecipeCollection = (data: { userId: number; recipeId: number }) =>
  api.post('/api/admin/recipe-collections', data)

export const updateRecipeCollection = (id: number, data: { userId: number; recipeId: number }) =>
  api.put(`/api/admin/recipe-collections/${id}`, data)

export const deleteRecipeCollection = (id: number) => api.delete(`/api/admin/recipe-collections/${id}`)

export const getSportPlans = (params: {
  userId?: number
  status?: number
  page: number
  size: number
}) => api.get('/api/admin/sport-plans', { params })

export const createSportPlan = (data: Record<string, unknown>) => api.post('/api/admin/sport-plans', data)

export const updateSportPlan = (id: number, data: Record<string, unknown>) =>
  api.put(`/api/admin/sport-plans/${id}`, data)

export const updateSportPlanStatus = (id: number, status: number) =>
  api.put(`/api/admin/sport-plans/${id}/status`, { status })

export const deleteSportPlan = (id: number) => api.delete(`/api/admin/sport-plans/${id}`)

export const getSportRecords = (params: {
  userId?: number
  planId?: number
  page: number
  size: number
}) => api.get('/api/admin/sport-records', { params })

export const createSportRecord = (data: Record<string, unknown>) => api.post('/api/admin/sport-records', data)

export const updateSportRecord = (id: number, data: Record<string, unknown>) =>
  api.put(`/api/admin/sport-records/${id}`, data)

export const deleteSportRecord = (id: number) => api.delete(`/api/admin/sport-records/${id}`)
