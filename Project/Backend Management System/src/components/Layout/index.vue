<template>
  <div class="layout">
    <!-- 侧边栏 -->
    <el-aside width="200px" class="aside">
      <div class="logo">
        <h1>健康管理系统</h1>
      </div>
      <el-menu
        :default-active="activeMenu"
        class="el-menu-vertical-demo"
        router
        @select="handleSelect"
      >
        <el-menu-item index="/" v-if="hasPermission(['super', 'admin'])">
          <el-icon><House /></el-icon>
          <span>工作台</span>
        </el-menu-item>
        <el-menu-item index="/user-data" v-if="hasPermission(['super', 'admin'])">
          <el-icon><User /></el-icon>
          <span>用户与数据管理</span>
        </el-menu-item>
        <el-sub-menu index="/content-rule" v-if="hasPermission(['super', 'admin'])">
          <template #title>
            <el-icon><Document /></el-icon>
            <span>内容与规则管理</span>
          </template>
          <el-menu-item index="/content-rule">内容规则中心</el-menu-item>
          <el-menu-item index="/user-activity">收藏与运动管理</el-menu-item>
        </el-sub-menu>
        <el-menu-item index="/social-audit" v-if="hasPermission(['super', 'admin', 'auditor'])">
          <el-icon><ChatLineRound /></el-icon>
          <span>评价与社交管理</span>
        </el-menu-item>
        <el-menu-item index="/system-notice" v-if="hasPermission(['super', 'admin'])">
          <el-icon><Bell /></el-icon>
          <span>系统公告与数据统计</span>
        </el-menu-item>
        <el-menu-item index="/admin-manage" v-if="hasPermission(['super'])">
          <el-icon><UserFilled /></el-icon>
          <span>管理员管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    
    <!-- 主内容区 -->
    <div class="main">
      <!-- 顶栏 -->
      <el-header class="header">
        <div class="header-right">
          <el-dropdown>
            <span class="user-info">
              <el-avatar :size="32" :src="userAvatar"></el-avatar>
              <span>{{ username }}</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      
      <!-- 内容区 -->
      <el-main class="content">
        <router-view />
      </el-main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../../stores/user'
import { House, User, Document, ChatLineRound, Bell, UserFilled } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const activeMenu = ref('/')
const username = computed(() => userStore.username)
const userAvatar = ref('https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png')

const hasPermission = (roles) => {
  return roles.includes(userStore.role)
}

const handleSelect = (key) => {
  activeMenu.value = key
}

const handleLogout = () => {
  userStore.logout()
  router.push('/login')
}

onMounted(() => {
  activeMenu.value = router.currentRoute.value.path
})

watch(
  () => router.currentRoute.value.path,
  (path) => {
    activeMenu.value = path
  }
)
</script>

<style scoped>
.layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

.aside {
  background-color: #001529;
  color: #fff;
}

.logo {
  padding: 20px;
  text-align: center;
  border-bottom: 1px solid #002140;
}

.logo h1 {
  margin: 0;
  font-size: 18px;
  font-weight: bold;
}

.el-menu {
  border-right: none;
}

.main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  background-color: #fff;
  border-bottom: 1px solid #e8e8e8;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
}

.content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background-color: #f5f5f5;
}
</style>
