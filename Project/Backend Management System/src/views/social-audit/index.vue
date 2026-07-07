<template>
  <div class="social-audit">
    <h1>评价与社交管理</h1>
    
    <el-tabs v-model="activeTab">
      <el-tab-pane label="待审核动态" name="pending">
        <div class="search-bar">
          <el-input v-model="postSearch" placeholder="搜索动态内容" style="width: 300px; margin-right: 10px;">
            <template #append>
              <el-button @click="searchPendingPosts"><el-icon><Search /></el-icon></el-button>
            </template>
          </el-input>
          <el-button @click="refreshPendingPosts">刷新</el-button>
        </div>
        
        <el-table :data="pendingPostList" style="width: 100%; margin-top: 20px;">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="userId" label="用户ID" width="100" />
          <el-table-column prop="content" label="内容">
            <template #default="scope">
              <div v-html="highlightSensitiveWords(scope.row.content)"></div>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="发布时间" width="180" />
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button v-if="canModerateSocial" size="small" type="success" @click="approvePost(scope.row)">通过</el-button>
              <el-button v-if="canModerateSocial" size="small" type="danger" @click="rejectPost(scope.row)">驳回</el-button>
              <el-text v-if="!canModerateSocial" type="info">只读</el-text>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="pendingPage"
          v-model:page-size="pendingPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="pendingTotal"
          @size-change="handlePendingSizeChange"
          @current-change="handlePendingCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
      
      <el-tab-pane label="已审核动态" name="approved">
        <div class="search-bar">
          <el-select v-model="postStatus" placeholder="状态" style="width: 150px; margin-right: 10px;">
            <el-option label="已通过" :value="1" />
            <el-option label="已驳回" :value="2" />
            <el-option label="已删除" :value="3" />
          </el-select>
          <el-input v-model="approvedPostSearch" placeholder="搜索动态内容" style="width: 300px; margin-right: 10px;">
            <template #append>
              <el-button @click="searchApprovedPosts"><el-icon><Search /></el-icon></el-button>
            </template>
          </el-input>
        </div>
        
        <el-table :data="approvedPostList" style="width: 100%; margin-top: 20px;">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="userId" label="用户ID" width="100" />
          <el-table-column prop="content" label="内容" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="getStatusType(scope.row.status)">
                {{ getStatusName(scope.row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="发布时间" width="180" />
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="viewPost(scope.row)">查看</el-button>
              <el-button v-if="canModerateSocial" size="small" type="danger" @click="deletePost(scope.row)">删除</el-button>
              <el-button v-if="canModerateSocial" size="small" type="warning" @click="blockPost(scope.row)">屏蔽</el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="approvedPage"
          v-model:page-size="approvedPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="approvedTotal"
          @size-change="handleApprovedSizeChange"
          @current-change="handleApprovedCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>

      <el-dialog v-model="postDetailVisible" title="动态详情" width="700px">
        <template v-if="selectedPost">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="动态ID">{{ selectedPost.id }}</el-descriptions-item>
            <el-descriptions-item label="用户ID">{{ selectedPost.userId }}</el-descriptions-item>
            <el-descriptions-item label="用户名">{{ selectedPost.username || '-' }}</el-descriptions-item>
            <el-descriptions-item label="状态">{{ getStatusName(selectedPost.status) }}</el-descriptions-item>
            <el-descriptions-item label="发布时间">{{ selectedPost.createTime || '-' }}</el-descriptions-item>
            <el-descriptions-item label="点赞数">{{ selectedPost.likeCount ?? 0 }}</el-descriptions-item>
            <el-descriptions-item label="评论数">{{ selectedPost.commentCount ?? 0 }}</el-descriptions-item>
            <el-descriptions-item label="来源">{{ selectedPost.source || '-' }}</el-descriptions-item>
            <el-descriptions-item label="内容" :span="2">
              <div style="white-space: pre-wrap; word-break: break-word;">{{ selectedPost.content || '-' }}</div>
            </el-descriptions-item>
          </el-descriptions>
        </template>
      </el-dialog>
      
      <el-tab-pane label="评论管理" name="comments">
        <div class="search-bar">
          <el-input v-model="postId" placeholder="帖子ID" style="width: 150px; margin-right: 10px;" />
          <el-input v-model="userId" placeholder="用户ID" style="width: 150px; margin-right: 10px;" />
          <el-button @click="searchComments">查询</el-button>
        </div>
        
        <el-table :data="commentList" style="width: 100%; margin-top: 20px;">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="postId" label="帖子ID" width="100" />
          <el-table-column prop="userId" label="用户ID" width="100" />
          <el-table-column prop="content" label="评论内容" />
          <el-table-column prop="createTime" label="评论时间" width="180" />
          <el-table-column label="操作" width="100">
            <template #default="scope">
              <el-button v-if="canModerateSocial" size="small" type="danger" @click="deleteComment(scope.row)">删除</el-button>
              <el-text v-else type="info">只读</el-text>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="commentPage"
          v-model:page-size="commentPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="commentTotal"
          @size-change="handleCommentSizeChange"
          @current-change="handleCommentCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
      
      <el-tab-pane label="用户社交管理" name="user-social" v-if="hasPermission(['super', 'admin'])">
        <div class="search-bar">
          <el-input v-model="socialUserSearch" placeholder="搜索用户名" style="width: 300px; margin-right: 10px;">
            <template #append>
              <el-button @click="searchSocialUsers"><el-icon><Search /></el-icon></el-button>
            </template>
          </el-input>
        </div>
        
        <el-table :data="socialUserList" style="width: 100%; margin-top: 20px;">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="username" label="用户名" />
          <el-table-column prop="socialStatus" label="社交状态" width="120">
            <template #default="scope">
              <el-tag :type="scope.row.socialStatus === 0 ? 'success' : 'danger'">
                {{ scope.row.socialStatus === 0 ? '正常' : '禁言' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button size="small" @click="viewUserSocialInfo(scope.row)">查看</el-button>
              <el-button v-if="canModerateSocial" size="small" :type="scope.row.socialStatus === 0 ? 'danger' : 'success'" @click="toggleUserSocialStatus(scope.row)">
                {{ scope.row.socialStatus === 0 ? '禁言' : '解禁' }}
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-pagination
          v-model:current-page="socialUserPage"
          v-model:page-size="socialUserPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="socialUserTotal"
          @size-change="handleSocialUserSizeChange"
          @current-change="handleSocialUserCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>

      <el-dialog v-model="socialUserDetailVisible" title="用户社交信息" width="700px">
        <template v-if="selectedSocialUser">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="用户ID">{{ selectedSocialUser.id }}</el-descriptions-item>
            <el-descriptions-item label="用户名">{{ selectedSocialUser.username || '-' }}</el-descriptions-item>
            <el-descriptions-item label="社交状态">
              <el-tag :type="selectedSocialUser.socialStatus === 0 ? 'success' : 'danger'">
                {{ selectedSocialUser.socialStatus === 0 ? '正常' : '禁言' }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="禁言到期">{{ selectedSocialUser.banUntil || '-' }}</el-descriptions-item>
            <el-descriptions-item label="发帖数">{{ selectedSocialUser.postCount ?? 0 }}</el-descriptions-item>
            <el-descriptions-item label="评论数">{{ selectedSocialUser.commentCount ?? 0 }}</el-descriptions-item>
            <el-descriptions-item label="最近活跃">{{ selectedSocialUser.lastActiveTime || '-' }}</el-descriptions-item>
            <el-descriptions-item label="手机号">{{ selectedSocialUser.phone || '-' }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="2">
              <div style="white-space: pre-wrap; word-break: break-word;">{{ selectedSocialUser.note || '无' }}</div>
            </el-descriptions-item>
          </el-descriptions>
        </template>
      </el-dialog>
      
      <el-tab-pane label="审核记录" name="audit-records">
        <div class="search-bar">
          <el-select v-model="targetType" placeholder="目标类型" style="width: 150px; margin-right: 10px;">
            <el-option label="动态" :value="1" />
            <el-option label="评论" :value="2" />
          </el-select>
          <el-date-picker
            v-model="auditDateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            style="width: 300px; margin-right: 10px;"
          />
          <el-button @click="searchAuditRecords">查询</el-button>
        </div>
        
        <el-table :data="auditRecordList" style="width: 100%; margin-top: 20px;">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="adminId" label="管理员ID" width="100" />
          <el-table-column prop="targetType" label="目标类型" width="100">
            <template #default="scope">
              {{ scope.row.targetType === 1 ? '动态' : '评论' }}
            </template>
          </el-table-column>
          <el-table-column prop="targetId" label="目标ID" width="100" />
          <el-table-column prop="action" label="操作" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.action === 'approve' ? 'success' : 'danger'">
                {{ scope.row.action === 'approve' ? '通过' : '驳回' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="reason" label="原因" />
          <el-table-column prop="createTime" label="操作时间" width="180" />
        </el-table>
        
        <el-pagination
          v-model:current-page="auditRecordPage"
          v-model:page-size="auditRecordPageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="auditRecordTotal"
          @size-change="handleAuditRecordSizeChange"
          @current-change="handleAuditRecordCurrentChange"
          style="margin-top: 20px;"
        />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import { useUserStore } from '../../stores/user'
import { getUserList } from '../../api/user'
import {
  getPendingPosts,
  getPosts,
  auditPost,
  notifyPostAuditResult,
  updatePostStatus,
  getComments,
  deleteComment as removeComment,
  banUserSocial,
  getAuditRecords
} from '../../api/social'

const activeTab = ref('pending')
const userStore = useUserStore()
const hasPermission = (roles) => roles.includes(userStore.role)
const canModerateSocial = computed(() => ['super', 'auditor'].includes(userStore.role))

// 待审核动态相关
const pendingPostList = ref([])
const postSearch = ref('')
const pendingPage = ref(1)
const pendingPageSize = ref(10)
const pendingTotal = ref(0)

// 已审核动态相关
const approvedPostList = ref([])
const postStatus = ref('')
const approvedPostSearch = ref('')
const approvedPage = ref(1)
const approvedPageSize = ref(10)
const approvedTotal = ref(0)

// 评论相关
const commentList = ref([])
const postId = ref('')
const userId = ref('')
const commentPage = ref(1)
const commentPageSize = ref(10)
const commentTotal = ref(0)

// 用户社交管理相关
const socialUserList = ref([])
const socialUserSearch = ref('')
const socialUserPage = ref(1)
const socialUserPageSize = ref(10)
const socialUserTotal = ref(0)

// 审核记录相关
const auditRecordList = ref([])
const targetType = ref('')
const auditDateRange = ref([])
const auditRecordPage = ref(1)
const auditRecordPageSize = ref(10)
const auditRecordTotal = ref(0)
const postDetailVisible = ref(false)
const selectedPost = ref(null)
const socialUserDetailVisible = ref(false)
const selectedSocialUser = ref(null)

// 敏感词列表
const sensitiveWords = ['暴力', '色情', '政治']
const toListAndTotal = (payload) => {
  if (Array.isArray(payload)) {
    return { list: payload, total: payload.length }
  }
  return {
    list: payload?.list || [],
    total: payload?.total ?? (payload?.list?.length || 0)
  }
}

const highlightSensitiveWords = (content) => {
  let result = content
  sensitiveWords.forEach(word => {
    result = result.replace(new RegExp(word, 'g'), `<span class="highlight">${word}</span>`)
  })
  return result
}

const getStatusType = (status) => {
  const typeMap = {
    1: 'success',
    2: 'danger',
    3: 'warning',
    4: 'info'
  }
  return typeMap[status] || 'info'
}

const getStatusName = (status) => {
  const nameMap = {
    1: '已通过',
    2: '已驳回',
    3: '已删除',
    4: '已屏蔽'
  }
  return nameMap[status] || '未知'
}

const searchPendingPosts = async () => {
  try {
    const response = await getPendingPosts({
      keyword: postSearch.value?.trim() || undefined,
      page: pendingPage.value,
      size: pendingPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      pendingPostList.value = list
      pendingTotal.value = total
    } else {
      ElMessage.error(response.message || '获取待审核动态失败')
    }
  } catch (error) {
    ElMessage.error('获取待审核动态失败')
  }
}

const refreshPendingPosts = () => {
  searchPendingPosts()
  ElMessage.success('已刷新待审核动态')
}

const approvePost = (post) => {
  if (!canModerateSocial.value) {
    ElMessage.warning('仅超级管理员或审核员可操作')
    return
  }
  ElMessageBox.confirm('确定要通过该动态吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'success'
  }).then(async () => {
    const response = await auditPost(post.id, 'approve')
    if (response.code === 200) {
      ElMessage.success('动态已通过')
      searchPendingPosts()
      searchApprovedPosts()
      auditRecordPage.value = 1
      searchAuditRecords()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const rejectPost = (post) => {
  if (!canModerateSocial.value) {
    ElMessage.warning('仅超级管理员或审核员可操作')
    return
  }
  ElMessageBox.prompt('请输入驳回原因', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputPlaceholder: '请输入驳回原因'
  }).then(async ({ value }) => {
    const response = await auditPost(post.id, 'reject', value)
    if (response.code === 200) {
      try {
        const notifyRes = await notifyPostAuditResult(post.id, post.userId, 'reject', value)
        if (notifyRes?.code !== 200) {
          ElMessage.warning('驳回成功，但通知用户接口未返回成功')
        }
      } catch (e) {
        ElMessage.warning('驳回成功，通知用户功能暂未打通（已记录审核结果）')
      }
      ElMessage.success('动态已驳回')
      searchPendingPosts()
      searchApprovedPosts()
      auditRecordPage.value = 1
      searchAuditRecords()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handlePendingSizeChange = (size) => {
  pendingPageSize.value = size
  searchPendingPosts()
}

const handlePendingCurrentChange = (current) => {
  pendingPage.value = current
  searchPendingPosts()
}

const searchApprovedPosts = async () => {
  try {
    const response = await getPosts({
      status: postStatus.value || undefined,
      keyword: approvedPostSearch.value?.trim() || undefined,
      page: approvedPage.value,
      size: approvedPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      approvedPostList.value = list
      approvedTotal.value = total
    } else {
      ElMessage.error(response.message || '获取已审核动态失败')
    }
  } catch (error) {
    ElMessage.error('获取已审核动态失败')
  }
}

const viewPost = (post) => {
  selectedPost.value = { ...post }
  postDetailVisible.value = true
}

const deletePost = (post) => {
  if (!canModerateSocial.value) {
    ElMessage.warning('仅超级管理员或审核员可操作')
    return
  }
  ElMessageBox.confirm('确定要删除该动态吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'danger'
  }).then(async () => {
    const response = await updatePostStatus(post.id, 3)
    if (response.code === 200) {
      ElMessage.success('动态已删除')
      searchApprovedPosts()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const blockPost = (post) => {
  if (!canModerateSocial.value) {
    ElMessage.warning('仅超级管理员或审核员可操作')
    return
  }
  ElMessageBox.confirm('确定要屏蔽该动态吗？屏蔽后仅发布者可见', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    const response = await updatePostStatus(post.id, 4)
    if (response.code === 200) {
      ElMessage.success('动态已屏蔽')
      searchApprovedPosts()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handleApprovedSizeChange = (size) => {
  approvedPageSize.value = size
  searchApprovedPosts()
}

const handleApprovedCurrentChange = (current) => {
  approvedPage.value = current
  searchApprovedPosts()
}

const searchComments = async () => {
  try {
    const response = await getComments({
      postId: postId.value ? Number(postId.value) : undefined,
      userId: userId.value ? Number(userId.value) : undefined,
      page: commentPage.value,
      size: commentPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      commentList.value = list
      commentTotal.value = total
    } else {
      ElMessage.error(response.message || '获取评论失败')
    }
  } catch (error) {
    ElMessage.error('获取评论失败')
  }
}

const deleteComment = (comment) => {
  if (!canModerateSocial.value) {
    ElMessage.warning('仅超级管理员或审核员可操作')
    return
  }
  ElMessageBox.confirm('确定要删除该评论吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'danger'
  }).then(async () => {
    const response = await removeComment(comment.id)
    if (response.code === 200) {
      ElMessage.success('评论已删除')
      searchComments()
    } else {
      ElMessage.error(response.message || '操作失败')
    }
  }).catch(() => {
    // 取消操作
  })
}

const handleCommentSizeChange = (size) => {
  commentPageSize.value = size
  searchComments()
}

const handleCommentCurrentChange = (current) => {
  commentPage.value = current
  searchComments()
}

const searchSocialUsers = async () => {
  try {
    const response = await getUserList({
      keyword: socialUserSearch.value || undefined,
      page: socialUserPage.value,
      size: socialUserPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      socialUserList.value = list
      socialUserTotal.value = total
    } else {
      ElMessage.error(response.message || '获取用户列表失败')
    }
  } catch (error) {
    ElMessage.error('获取用户列表失败')
  }
}

const viewUserSocialInfo = (user) => {
  selectedSocialUser.value = { ...user }
  socialUserDetailVisible.value = true
}

const toggleUserSocialStatus = (user) => {
  if (!canModerateSocial.value) {
    ElMessage.warning('仅超级管理员或审核员可操作')
    return
  }
  if (user.socialStatus === 0) {
    ElMessageBox.prompt('请输入禁言天数', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      inputPlaceholder: '请输入禁言天数，0表示解禁',
      inputType: 'number'
    }).then(async ({ value }) => {
      const response = await banUserSocial(user.id, Number(value))
      if (response.code === 200) {
        ElMessage.success(`用户已禁言 ${value} 天`)
        searchSocialUsers()
      } else {
        ElMessage.error(response.message || '操作失败')
      }
    }).catch(() => {
      // 取消操作
    })
  } else {
    ElMessageBox.confirm('确定要解禁该用户吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'success'
    }).then(async () => {
      const response = await banUserSocial(user.id, 0)
      if (response.code === 200) {
        ElMessage.success('用户已解禁')
        searchSocialUsers()
      } else {
        ElMessage.error(response.message || '操作失败')
      }
    }).catch(() => {
      // 取消操作
    })
  }
}

const handleSocialUserSizeChange = (size) => {
  socialUserPageSize.value = size
  searchSocialUsers()
}

const handleSocialUserCurrentChange = (current) => {
  socialUserPage.value = current
  searchSocialUsers()
}

const searchAuditRecords = async () => {
  try {
    const response = await getAuditRecords({
      targetType: targetType.value || undefined,
      page: auditRecordPage.value,
      size: auditRecordPageSize.value
    })
    if (response.code === 200) {
      const { list, total } = toListAndTotal(response.data)
      auditRecordList.value = list
      auditRecordTotal.value = total
    } else {
      ElMessage.error(response.message || '获取审核记录失败')
    }
  } catch (error) {
    ElMessage.error('获取审核记录失败')
  }
}

const handleAuditRecordSizeChange = (size) => {
  auditRecordPageSize.value = size
  searchAuditRecords()
}

const handleAuditRecordCurrentChange = (current) => {
  auditRecordPage.value = current
  searchAuditRecords()
}

onMounted(() => {
  searchPendingPosts()
  searchApprovedPosts()
  searchComments()
  if (hasPermission(['super', 'admin'])) {
    searchSocialUsers()
  }
  searchAuditRecords()
})
</script>

<style scoped>
.social-audit {
  padding: 20px;
}

.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.highlight {
  color: red;
  font-weight: bold;
}
</style>
