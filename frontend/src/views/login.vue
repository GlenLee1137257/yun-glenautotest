<script lang="ts" setup>
import { Button, Form, Input, message } from 'ant-design-vue'
import {
  UserOutlined,
  PhoneOutlined,
  MailOutlined,
  MessageOutlined,
  LockOutlined,
  RocketOutlined,
  CodeOutlined,
  BugOutlined,
  ThunderboltOutlined
} from '@ant-design/icons-vue'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'

const formModel = reactive({
  identifier: '',
  credential: '',
  identityType: 'phone',
})

const router = useRouter()
const globalConfigStore = useGlobalConfigStore()

const { post, isFetching } = useCustomFetch(`/account-service/api/v1/account/login`, {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
    if (ctx.data && ctx.data.code === 0) {
      message.success('登录成功')
      globalConfigStore.setLoginToken(ctx.data.data.tokenValue as string)
      router.push('/home')
    }
    return ctx
  },
})

const checkIdentifierType = () => {
  const isPhone = /^1[3-9]\d{9}$/.test(formModel.identifier)
  const isEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formModel.identifier)
  formModel.identityType = isPhone ? 'phone' : (isEmail ? 'mail' : 'phone')
}

const handleLogin = () => {
  if (!formModel.identifier || !formModel.credential) {
    message.warning('请输入账号和密码')
    return
  }
  checkIdentifierType()
  post({ ...formModel }).execute()
}

// 技术栈列表，用于背景动画
const floatingTechs = [
  'Spring Boot 3', 'Vue 3', 'Selenium 4', 'JMeter 5.5', 
  'Java 17', 'MySQL', 'Redis', 'MyBatis Plus',
  'TypeScript', 'Vite', 'Pinia', 'Kafka', 
  'Nacos', 'MinIO', 'Docker'
]
</script>

<template>
  <div class="login-container">
    <!-- 动态背景 -->
    <div class="animated-background">
      <div class="gradient-orb orb-1"></div>
      <div class="gradient-orb orb-2"></div>
      <div class="gradient-orb orb-3"></div>
    </div>
    
    <!-- 网格背景 -->
    <div class="grid-pattern"></div>

    <!-- 独立悬浮技术栈层 -->
    <div class="floating-tech-layer">
      <div v-for="(tech, index) in floatingTechs" :key="index" 
           class="floating-tech"
           :style="{
             left: `${(index * 9) % 90 + 5}%`,
             top: `${(index * 17) % 50 + 50}%`,
             animationDelay: `${index * -3}s`,
             animationDuration: `${25 + (index % 5) * 5}s`
           }">
        {{ tech }}
      </div>
    </div>
    
    <div class="content-wrapper">
      <!-- 顶部：品牌信息 -->
      <div class="top-section">
        <div class="brand-section">
          <div class="logo-wrapper">
            <div class="logo-glow">
              <CodeOutlined class="logo-icon" />
            </div>
            <h1 class="brand-title">
              <span class="brand-name">Glen</span>
              <span class="brand-subtitle">云测平台</span>
            </h1>
          </div>
          <p class="brand-tagline">专业的自动化测试解决方案</p>
        </div>
      </div>

      <!-- 中间：登录表单 -->
      <div class="center-section">
        <div class="login-form-card">
          <div class="form-header">
            <h2>欢迎回来</h2>
            <p>登录您的账户以继续</p>
          </div>

          <Form layout="vertical" :model="formModel" class="login-form">
            <Form.Item label="账号" required>
              <Input
                v-model:value="formModel.identifier"
                placeholder="请输入手机号或邮箱"
                size="large"
                class="custom-input"
                @press-enter="handleLogin"
              >
                <template #prefix>
                  <UserOutlined />
                </template>
              </Input>
            </Form.Item>
            
            <Form.Item label="密码" required>
              <Input.Password
                v-model:value="formModel.credential"
                placeholder="请输入密码"
                size="large"
                class="custom-input"
                @press-enter="handleLogin"
              >
                <template #prefix>
                  <LockOutlined />
                </template>
              </Input.Password>
            </Form.Item>
            
            <Form.Item class="form-actions">
              <Button
                type="primary"
                size="large"
                block
                :loading="isFetching"
                class="login-button"
                @click="handleLogin"
              >
                <span v-if="!isFetching">立即登录</span>
                <span v-else>登录中...</span>
              </Button>
              
              <div class="register-hint">
                <span>还没有账号？</span>
                <a @click="router.push('/register')" class="register-link">立即注册</a>
              </div>
            </Form.Item>
          </Form>
        </div>
      </div>
    </div>
    
    <!-- 底部：开发者信息 (简约风格) -->
    <div class="bottom-section">
      <div class="resume-minimal">
        <div class="resume-row">
          <div class="info-tag">
            <UserOutlined class="tag-icon" /> <span>Glen 李冠标</span>
          </div>
          <div class="info-divider"></div>
          <div class="info-tag">
            <PhoneOutlined class="tag-icon" /> <span>+86 13432898570</span>
          </div>
          <div class="info-divider"></div>
          <div class="info-tag">
            <MailOutlined class="tag-icon" /> <span>Glenlee1137257@163.com</span>
          </div>
          <div class="info-divider"></div>
          <div class="info-tag">
            <MessageOutlined class="tag-icon" /> <span>Glenlee11372570922</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 底部版权 -->
    <div class="footer">
      <span>Copyright © 2026 Glen云测平台</span>
    </div>
  </div>
</template>

<style scoped>
.login-container {
  min-height: 100vh;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  position: relative;
  overflow-x: hidden;
  overflow-y: auto;
  background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 50%, #2563eb 100%);
}

.animated-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  z-index: 1;
}

.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.4;
  animation: float 20s infinite ease-in-out;
}

.orb-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #0f172a, #1e3a8a);
  top: -100px;
  left: -100px;
  animation-delay: 0s;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #1e40af, #2563eb);
  bottom: -50px;
  right: -50px;
  animation-delay: 5s;
}

.orb-3 {
  width: 350px;
  height: 350px;
  background: linear-gradient(135deg, #1e3a8a, #3b82f6);
  top: 50%;
  right: 10%;
  animation-delay: 10s;
}

@keyframes float {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(30px, -30px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
}

/* 悬浮技术栈独立层 */
.floating-tech-layer {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  z-index: 1;
  pointer-events: none;
}

/* 悬浮技术栈动画 */
.floating-tech {
  position: absolute;
  color: rgba(255, 255, 255, 0.2);
  font-size: 22px;
  font-weight: 800;
  white-space: nowrap;
  pointer-events: none;
  user-select: none;
  animation: techFloat linear infinite;
}

@keyframes techFloat {
  0% {
    transform: translateY(0) rotate(0deg);
    opacity: 0;
  }
  15% {
    opacity: 0.35;
  }
  85% {
    opacity: 0.35;
  }
  100% {
    transform: translateY(-800px) rotate(25deg);
    opacity: 0;
  }
}

.grid-pattern {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: 
    linear-gradient(rgba(255, 255, 255, 0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.05) 1px, transparent 1px);
  background-size: 50px 50px;
  z-index: 1;
}

.content-wrapper {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 90%;
  max-width: 1200px;
  gap: 40px;
  padding: 40px 20px;
  flex: 1;
  justify-content: center;
}

.top-section {
  width: 100%;
  display: flex;
  justify-content: center;
  animation: fadeInUp 0.6s ease-out;
}

.brand-section {
  text-align: center;
}

.center-section {
  width: 100%;
  display: flex;
  justify-content: center;
  animation: fadeInUp 0.8s ease-out 0.2s both;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
}

.logo-glow {
  width: 64px;
  height: 64px;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.logo-icon {
  font-size: 32px;
  color: white;
}

.brand-title {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin: 0;
}

.brand-name {
  font-size: 36px;
  font-weight: 800;
  color: white;
  letter-spacing: -1px;
}

.brand-subtitle {
  font-size: 18px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
}

.brand-tagline {
  color: rgba(255, 255, 255, 0.8);
  font-size: 16px;
  margin-top: 8px;
}

.login-form-card {
  width: 100%;
  max-width: 450px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 24px;
  padding: 48px;
  box-shadow: 
    0 20px 60px rgba(0, 0, 0, 0.3),
    inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

.form-header {
  text-align: center;
  margin-bottom: 40px;
}

.form-header h2 {
  font-size: 32px;
  font-weight: 800;
  color: #ffffff;
  margin-bottom: 8px;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.form-header p {
  color: rgba(255, 255, 255, 0.8);
  font-size: 15px;
}

.login-form {
  width: 100%;
}

:deep(.ant-form-item-label > label) {
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.custom-input {
  height: 48px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #ffffff;
  transition: all 0.3s ease;
}

.custom-input:hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.3);
}

.custom-input:focus,
:deep(.ant-input-affix-wrapper-focused) {
  background: rgba(255, 255, 255, 0.2);
  border-color: #60a5fa;
  box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.2);
}

.custom-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

:deep(.ant-input-affix-wrapper-lg) {
  padding: 10px 16px;
}

:deep(.ant-input-affix-wrapper .anticon) {
  color: rgba(255, 255, 255, 0.6);
}

:deep(.ant-input-affix-wrapper input) {
  color: #ffffff;
}

:deep(.ant-input-affix-wrapper input::placeholder) {
  color: rgba(255, 255, 255, 0.5);
}

.form-actions {
  margin-top: 32px;
  margin-bottom: 0;
}

.login-button {
  height: 52px;
  border-radius: 12px;
  font-size: 16px;
  font-weight: 700;
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  border: none;
  box-shadow: 0 8px 20px rgba(37, 99, 235, 0.4);
  transition: all 0.3s ease;
}

.login-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 28px rgba(37, 99, 235, 0.5);
}

.register-hint {
  margin-top: 20px;
  text-align: center;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.register-link {
  color: #2563eb;
  font-weight: 600;
  cursor: pointer;
  transition: color 0.3s ease;
}

.register-link:hover {
  color: #3b82f6;
}

/* 底部开发者信息简约样式 */
.bottom-section {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 900px;
  padding: 0 20px 30px;
  animation: fadeInUp 1s ease-out 0.6s both;
}

.resume-minimal {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  padding: 16px 24px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.resume-row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  justify-content: center;
  gap: 16px;
}

.info-tag {
  display: flex;
  align-items: center;
  gap: 8px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 12px;
}

.tag-icon {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.info-divider {
  width: 1px;
  height: 12px;
  background: rgba(255, 255, 255, 0.2);
}

.tech-row {
  display: flex;
  gap: 20px;
  opacity: 0.7;
}

.tech-item {
  font-size: 11px;
  color: #fff;
  letter-spacing: 1px;
  text-transform: uppercase;
  font-weight: 600;
}

.footer {
  position: relative;
  z-index: 2;
  color: rgba(255, 255, 255, 0.4);
  font-size: 11px;
  font-weight: 500;
  text-align: center;
  padding-bottom: 20px;
  margin-top: auto;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .resume-row {
    flex-direction: column;
    gap: 8px;
  }
  .info-divider {
    display: none;
  }
  .tech-row {
    gap: 12px;
    flex-wrap: wrap;
    justify-content: center;
  }
  .login-form-card {
    padding: 32px 24px;
  }
  .brand-name {
    font-size: 28px;
  }
  .form-header h2 {
    font-size: 24px;
  }
}
</style>
