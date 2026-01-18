<script setup lang="ts">
const router = useRouter()
const globalConfig = useGlobalConfigStore()

onMounted(() => {
  if (globalConfig.isLogin) {
    router.push('/home')
  } else {
    router.push('/login')
  }
})
</script>

<template>
  <div class="loading-container">
    <div class="spinner" />
  </div>
</template>

<style scoped>
.loading-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background: #f5f5f5;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #e0e0e0;
  border-top-color: #3765b0;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
