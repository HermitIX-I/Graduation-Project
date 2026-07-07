import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: () => import('../views/login/index.vue'),
      meta: { requiresAuth: false }
    },
    {
      path: '/',
      component: () => import('../components/Layout/index.vue'),
      meta: { requiresAuth: true },
      children: [
        {
          path: '',
          name: 'Dashboard',
          component: () => import('../views/dashboard/index.vue'),
          meta: { title: '工作台', roles: ['super', 'admin'] }
        },
        {
          path: 'user-data',
          name: 'UserData',
          component: () => import('../views/user-data/index.vue'),
          meta: { title: '用户与数据管理', roles: ['super', 'admin'] }
        },
        {
          path: 'user-activity',
          name: 'UserActivity',
          component: () => import('../views/user-activity/index.vue'),
          meta: { title: '收藏与运动管理', roles: ['super', 'admin'] }
        },
        {
          path: 'content-rule',
          name: 'ContentRule',
          component: () => import('../views/content-rule/index.vue'),
          meta: { title: '内容与规则管理', roles: ['super', 'admin'] }
        },
        {
          path: 'social-audit',
          name: 'SocialAudit',
          component: () => import('../views/social-audit/index.vue'),
          meta: { title: '评价与社交管理', roles: ['super', 'admin', 'auditor'] }
        },
        {
          path: 'system-notice',
          name: 'SystemNotice',
          component: () => import('../views/system-notice/index.vue'),
          meta: { title: '系统公告与数据统计', roles: ['super', 'admin'] }
        },
        {
          path: 'admin-manage',
          name: 'AdminManage',
          component: () => import('../views/admin-manage/index.vue'),
          meta: { title: '管理员管理', roles: ['super'] }
        }
      ]
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: () => import('../views/404.vue')
    }
  ]
})

// 从localStorage中获取用户信息
const getUserInfo = () => {
  return {
    token: localStorage.getItem('token') || '',
    role: localStorage.getItem('role') || ''
  }
}

router.beforeEach((to, from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  const userInfo = getUserInfo()
  const fallbackByRole: Record<string, string> = {
    super: '/',
    admin: '/',
    auditor: '/social-audit'
  }
  
  if (requiresAuth && !userInfo.token) {
    next('/login')
  } else if (requiresAuth && to.meta.roles) {
    const roles = to.meta.roles as string[]
    if (roles.includes(userInfo.role)) {
      next()
    } else {
      next(fallbackByRole[userInfo.role] || '/login')
    }
  } else {
    next()
  }
})

export default router
