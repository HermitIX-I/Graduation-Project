import axios from 'axios'

// 创建axios实例
const api = axios.create({
  baseURL: 'http://localhost:8081', // 后端API地址
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
api.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    // FormData 必须由浏览器自动带 boundary；勿沿用实例默认的 application/json
    if (config.data instanceof FormData) {
      if (config.headers && 'Content-Type' in config.headers) {
        delete config.headers['Content-Type']
      }
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
api.interceptors.response.use(
  response => {
    return response.data
  },
  error => {
    if (error.response) {
      switch (error.response.status) {
        case 401:
          // 未授权，跳转到登录页
          localStorage.removeItem('token')
          localStorage.removeItem('role')
          localStorage.removeItem('username')
          window.location.href = '/login'
          break
        case 403:
          // 权限不足
          console.error('权限不足')
          break
        case 500:
          // 服务器错误
          console.error('服务器错误')
          break
        default:
          console.error('请求失败')
      }
    }
    return Promise.reject(error)
  }
)

export default api