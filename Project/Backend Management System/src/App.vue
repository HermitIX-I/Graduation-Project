<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup>
// App.vue 作为应用的根组件
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  font-size: 14px;
  line-height: 1.5;
  color: #303133;
  background-color: #f5f5f5;
}

#app {
  height: 100vh;
  width: 100%;
}
</style>
