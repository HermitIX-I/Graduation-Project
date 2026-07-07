import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('token') || '',
    role: localStorage.getItem('role') || '',
    username: localStorage.getItem('username') || ''
  }),
  getters: {
    isLoggedIn: (state) => !!state.token
  },
  actions: {
    login(token: string, role: string, username: string) {
      this.token = token
      this.role = role
      this.username = username
      localStorage.setItem('token', token)
      localStorage.setItem('role', role)
      localStorage.setItem('username', username)
    },
    logout() {
      this.token = ''
      this.role = ''
      this.username = ''
      localStorage.removeItem('token')
      localStorage.removeItem('role')
      localStorage.removeItem('username')
    }
  }
})
