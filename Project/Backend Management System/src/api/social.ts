import api from './index'

// 动态审核管理
export const getPendingPosts = async (params: {
  keyword?: string
  page: number
  size: number
}) => {
  return api.get('/api/admin/social/posts/pending', { params })
}

export const getPosts = async (params: {
  status?: number
  keyword?: string
  page: number
  size: number
}) => {
  return api.get('/api/admin/social/posts', { params })
}

export const auditPost = async (postId: number, action: string, reason?: string) => {
  return api.put(`/api/admin/social/post/${postId}/audit`, { action, reason })
}

// 驳回后通知用户（若后端未实现，调用方应自行兜底）
export const notifyPostAuditResult = async (postId: number, userId: number, action: string, reason?: string) => {
  return api.post('/api/admin/social/notify', {
    postId,
    userId,
    action,
    reason
  })
}

export const updatePostStatus = async (postId: number, status: number) => {
  return api.put(`/api/admin/social/post/${postId}/status`, { status })
}

// 评论管理
export const getComments = async (params: {
  postId?: number
  userId?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/social/comments', { params })
}

export const deleteComment = async (commentId: number) => {
  return api.delete(`/api/admin/social/comment/${commentId}`)
}

// 用户社交管理
export const banUserSocial = async (userId: number, banDays: number) => {
  return api.put(`/api/admin/user/${userId}/social-ban`, { banDays })
}

// 审核记录管理
export const getAuditRecords = async (params: {
  targetType?: number
  adminId?: number
  page: number
  size: number
}) => {
  return api.get('/api/admin/audit-records', { params })
}