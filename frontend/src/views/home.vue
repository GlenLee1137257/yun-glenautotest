<script lang="ts" setup>
import { Card, Row, Col, Statistic, Tag, List, Avatar, Empty, Spin, Button } from 'ant-design-vue'
import {
  UsbOutlined,
  AppstoreOutlined,
  ApartmentOutlined,
  CodeSandboxOutlined,
  CheckCircleOutlined,
  CloseCircleOutlined,
  SyncOutlined,
  ProjectOutlined,
  EnvironmentOutlined,
  RocketOutlined,
  ClockCircleOutlined,
  BarChartOutlined,
  ThunderboltOutlined,
  UserOutlined,
  TeamOutlined,
  CodeOutlined,
  ReloadOutlined,
} from '@ant-design/icons-vue'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'

const router = useRouter()
const globalConfigStore = useGlobalConfigStore()

// 统计数据
const statistics = ref({
  apiCaseCount: 0,
  uiCaseCount: 0,
  stressCaseCount: 0,
  reportCount: 0,
  projectCount: 0,
  environmentCount: 0,
  todayExecuteCount: 0,
  successRate: 0,
})

// 加载状态
const loading = ref(true)
const recentLoading = ref(true)

// 快捷入口配置
const quickActions = [
  {
    title: '接口自动化',
    icon: UsbOutlined,
    color: '#1890ff',
    bgColor: '#e6f7ff',
    path: '/interface-automation/case',
    description: '管理和执行接口测试用例',
  },
  {
    title: 'UI自动化',
    icon: AppstoreOutlined,
    color: '#52c41a',
    bgColor: '#f6ffed',
    path: '/ui-automation/case',
    description: '管理和执行UI测试用例',
  },
  {
    title: '性能测试',
    icon: ApartmentOutlined,
    color: '#faad14',
    bgColor: '#fffbe6',
    path: '/stress-test/manager',
    description: '执行性能测试用例',
  },
  {
    title: '测试报告',
    icon: CodeSandboxOutlined,
    color: '#722ed1',
    bgColor: '#f9f0ff',
    path: '/report/stress',
    description: '查看测试报告详情',
  },
]

// 最近执行记录（模拟数据）
const recentExecutions = ref<any[]>([])

// 加载统计数据
const { execute: fetchStatistics } = useCustomFetch('/engine-service/api/v1/dashboard/statistics', {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
    if (ctx.data && ctx.data.code === 0) {
      statistics.value = {
        apiCaseCount: ctx.data.data.apiCaseCount || 0,
        uiCaseCount: ctx.data.data.uiCaseCount || 0,
        stressCaseCount: ctx.data.data.stressCaseCount || 0,
        reportCount: ctx.data.data.reportCount || 0,
        projectCount: ctx.data.data.projectCount || 0,
        environmentCount: ctx.data.data.environmentCount || 0,
        todayExecuteCount: ctx.data.data.todayExecuteCount || 0,
        successRate: ctx.data.data.successRate || 0,
      }
    }
    return ctx
  },
})

async function loadStatistics() {
  try {
    loading.value = true
    const projectId = globalConfigStore.config.projectId
    
    if (!projectId) {
      loading.value = false
      return
    }

    await fetchStatistics()
  } catch (error) {
    console.error('加载统计数据失败:', error)
  } finally {
    loading.value = false
  }
}

// 加载最近执行记录
const { execute: fetchRecentExecutions } = useCustomFetch('/engine-service/api/v1/dashboard/recent-executions', {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
    if (ctx.data && ctx.data.code === 0) {
      // 如果后端返回空数组，使用模拟数据
      if (!ctx.data.data || ctx.data.data.length === 0) {
        recentExecutions.value = [
          {
            id: 1,
            caseName: '用户登录接口测试',
            type: '接口自动化',
            status: 'success',
            statusText: '成功',
            executeTime: '2分钟前',
            duration: '1.2s',
          },
          {
            id: 2,
            caseName: '商品列表页UI测试',
            type: 'UI自动化',
            status: 'success',
            statusText: '成功',
            executeTime: '15分钟前',
            duration: '23.5s',
          },
          {
            id: 3,
            caseName: '订单接口性能测试',
            type: '性能测试',
            status: 'running',
            statusText: '执行中',
            executeTime: '20分钟前',
            duration: '-',
          },
          {
            id: 4,
            caseName: '支付流程测试',
            type: '接口自动化',
            status: 'failed',
            statusText: '失败',
            executeTime: '1小时前',
            duration: '5.8s',
          },
          {
            id: 5,
            caseName: '首页加载性能测试',
            type: 'UI自动化',
            status: 'success',
            statusText: '成功',
            executeTime: '2小时前',
            duration: '18.3s',
          },
        ]
      } else {
        recentExecutions.value = ctx.data.data
      }
    }
    return ctx
  },
})

async function loadRecentExecutions() {
  try {
    recentLoading.value = true
    await fetchRecentExecutions()
  } catch (error) {
    console.error('加载最近执行记录失败:', error)
    // 出错时使用模拟数据
    recentExecutions.value = [
      {
        id: 1,
        caseName: '用户登录接口测试',
        type: '接口自动化',
        status: 'success',
        statusText: '成功',
        executeTime: '2分钟前',
        duration: '1.2s',
      },
    ]
  } finally {
    recentLoading.value = false
  }
}

// 跳转到快捷入口
function handleQuickAction(path: string) {
  router.push(path)
}

// 打开帮助文档
function openHelpDoc(url: string) {
  window.open(url, '_blank')
}

// 获取状态图标
function getStatusIcon(status: string) {
  switch (status) {
    case 'success':
      return CheckCircleOutlined
    case 'failed':
      return CloseCircleOutlined
    case 'running':
      return SyncOutlined
    default:
      return ClockCircleOutlined
  }
}

// 获取状态颜色
function getStatusColor(status: string) {
  switch (status) {
    case 'success':
      return '#52c41a'
    case 'failed':
      return '#ff4d4f'
    case 'running':
      return '#1890ff'
    default:
      return '#d9d9d9'
  }
}

// 获取Tag颜色
function getStatusTagColor(status: string) {
  switch (status) {
    case 'success':
      return 'success'
    case 'failed':
      return 'error'
    case 'running':
      return 'processing'
    default:
      return 'default'
  }
}

// 自动刷新定时器
const refreshInterval = ref<number | null>(null)
const autoRefreshEnabled = ref(true)
const refreshIntervalSeconds = ref(30) // 默认30秒刷新一次

// 手动刷新所有数据
function refreshAllData() {
  loadStatistics()
  loadRecentExecutions()
}

// 启动自动刷新
function startAutoRefresh() {
  if (refreshInterval.value) {
    clearInterval(refreshInterval.value)
  }
  
  if (autoRefreshEnabled.value && refreshIntervalSeconds.value > 0) {
    refreshInterval.value = window.setInterval(() => {
      refreshAllData()
    }, refreshIntervalSeconds.value * 1000)
  }
}

// 停止自动刷新
function stopAutoRefresh() {
  if (refreshInterval.value) {
    clearInterval(refreshInterval.value)
    refreshInterval.value = null
  }
}

// 切换自动刷新状态
function toggleAutoRefresh() {
  autoRefreshEnabled.value = !autoRefreshEnabled.value
  if (autoRefreshEnabled.value) {
    startAutoRefresh()
  } else {
    stopAutoRefresh()
  }
}

onMounted(() => {
  loadStatistics()
  loadRecentExecutions()
  
  // 启动自动刷新
  if (autoRefreshEnabled.value) {
    startAutoRefresh()
  }
})

onUnmounted(() => {
  stopAutoRefresh()
})
</script>

<template>
  <div class="home-container">
    <!-- 欢迎横幅 -->
    <Card class="welcome-card" :bordered="false">
      <div class="welcome-content">
        <div class="welcome-left">
          <h1 class="welcome-title">👋 欢迎使用 Glen 云测平台</h1>
          <p class="welcome-subtitle">
            一站式自动化测试解决方案 · 提升测试效率 · 保障产品质量
          </p>
          <div class="welcome-info">
            <span class="welcome-badge">
              <ProjectOutlined />
              当前项目: {{ globalConfigStore.config.projectDatas?.find(p => p.id === globalConfigStore.config.projectId)?.name || '默认项目' }}
            </span>
            <span class="welcome-badge welcome-refresh" @click="refreshAllData" :class="{ 'refreshing': loading || recentLoading }">
              <ReloadOutlined :spin="loading || recentLoading" />
              刷新数据
            </span>
          </div>
        </div>
        <div class="welcome-right">
          <RocketOutlined class="welcome-icon" />
        </div>
      </div>
    </Card>

    <!-- 统计卡片 -->
    <Spin :spinning="loading">
      <Row :gutter="[16, 16]" class="statistics-row">
        <Col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <Card :bordered="false" class="stat-card stat-card-primary">
            <Statistic
              title="接口用例"
              :value="statistics.apiCaseCount"
              :value-style="{ color: '#1890ff', fontWeight: 600 }"
            >
              <template #prefix>
                <div class="stat-icon stat-icon-primary">
                  <UsbOutlined />
                </div>
              </template>
            </Statistic>
          </Card>
        </Col>
        <Col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <Card :bordered="false" class="stat-card stat-card-success">
            <Statistic
              title="UI用例"
              :value="statistics.uiCaseCount"
              :value-style="{ color: '#52c41a', fontWeight: 600 }"
            >
              <template #prefix>
                <div class="stat-icon stat-icon-success">
                  <AppstoreOutlined />
                </div>
              </template>
            </Statistic>
          </Card>
        </Col>
        <Col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <Card :bordered="false" class="stat-card stat-card-warning">
            <Statistic
              title="性能测试用例"
              :value="statistics.stressCaseCount"
              :value-style="{ color: '#faad14', fontWeight: 600 }"
            >
              <template #prefix>
                <div class="stat-icon stat-icon-warning">
                  <ApartmentOutlined />
                </div>
              </template>
            </Statistic>
          </Card>
        </Col>
        <Col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <Card :bordered="false" class="stat-card stat-card-purple">
            <Statistic
              title="测试报告"
              :value="statistics.reportCount"
              :value-style="{ color: '#722ed1', fontWeight: 600 }"
            >
              <template #prefix>
                <div class="stat-icon stat-icon-purple">
                  <CodeSandboxOutlined />
                </div>
              </template>
            </Statistic>
          </Card>
        </Col>
        <Col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <Card :bordered="false" class="stat-card">
            <Statistic
              title="项目数量"
              :value="statistics.projectCount"
              :value-style="{ fontWeight: 600 }"
            >
              <template #prefix>
                <div class="stat-icon">
                  <ProjectOutlined />
                </div>
              </template>
            </Statistic>
          </Card>
        </Col>
        <Col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <Card :bordered="false" class="stat-card">
            <Statistic
              title="环境数量"
              :value="statistics.environmentCount"
              :value-style="{ fontWeight: 600 }"
            >
              <template #prefix>
                <div class="stat-icon">
                  <EnvironmentOutlined />
                </div>
              </template>
            </Statistic>
          </Card>
        </Col>
        <Col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <Card :bordered="false" class="stat-card">
            <Statistic
              title="今日执行"
              :value="statistics.todayExecuteCount"
              :value-style="{ fontWeight: 600 }"
            >
              <template #prefix>
                <div class="stat-icon">
                  <ThunderboltOutlined />
                </div>
              </template>
            </Statistic>
          </Card>
        </Col>
        <Col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <Card :bordered="false" class="stat-card">
            <Statistic
              title="成功率"
              :value="statistics.successRate"
              suffix="%"
              :precision="1"
              :value-style="{
                color: statistics.successRate >= 90 ? '#52c41a' : statistics.successRate >= 70 ? '#faad14' : '#ff4d4f',
                fontWeight: 600
              }"
            >
              <template #prefix>
                <div class="stat-icon" :style="{ 
                  color: statistics.successRate >= 90 ? '#52c41a' : statistics.successRate >= 70 ? '#faad14' : '#ff4d4f'
                }">
                  <BarChartOutlined />
                </div>
              </template>
            </Statistic>
          </Card>
        </Col>
      </Row>
    </Spin>

    <!-- 快捷入口 -->
    <Card title="🚀 快捷入口" class="quick-actions-card" :bordered="false">
      <Row :gutter="[16, 16]">
        <Col
          v-for="action in quickActions"
          :key="action.path"
          :xs="24"
          :sm="12"
          :md="12"
          :lg="6"
          :xl="6"
        >
          <div
            class="quick-action-item"
            @click="handleQuickAction(action.path)"
          >
            <div class="quick-action-icon" :style="{ backgroundColor: action.bgColor }">
              <component :is="action.icon" :style="{ color: action.color, fontSize: '32px' }" />
            </div>
            <div class="quick-action-content">
              <h3 class="quick-action-title">{{ action.title }}</h3>
              <p class="quick-action-desc">{{ action.description }}</p>
            </div>
          </div>
        </Col>
      </Row>
    </Card>

    <!-- 最近活动和系统概览 -->
    <Row :gutter="[16, 16]">
      <Col :xs="24" :lg="14">
        <Card title="📊 最近执行记录" :bordered="false" class="recent-card">
          <template #extra>
            <Button type="link" size="small" @click="router.push('/report/stress')">
              查看全部 →
            </Button>
          </template>
          <List
            v-if="recentExecutions.length > 0"
            :data-source="recentExecutions"
            :loading="recentLoading"
            class="recent-list"
          >
            <template #renderItem="{ item }">
              <List.Item class="recent-list-item">
                <List.Item.Meta>
                  <template #avatar>
                    <Avatar
                      :style="{
                        backgroundColor: getStatusColor(item.status),
                      }"
                    >
                      <template #icon>
                        <component :is="getStatusIcon(item.status)" />
                      </template>
                    </Avatar>
                  </template>
                  <template #title>
                    <div class="recent-item-title">
                      <span class="recent-item-name">{{ item.caseName }}</span>
                      <Tag
                        :color="getStatusTagColor(item.status)"
                        class="recent-item-tag"
                      >
                        {{ item.statusText }}
                      </Tag>
                    </div>
                  </template>
                  <template #description>
                    <div class="recent-item-desc">
                      <span class="recent-item-type">
                        <CodeOutlined style="margin-right: 4px" />
                        {{ item.type }}
                      </span>
                      <span class="recent-item-time">
                        <ClockCircleOutlined style="margin-right: 4px" />
                        {{ item.executeTime }}
                      </span>
                      <span class="recent-item-duration">
                        耗时: {{ item.duration }}
                      </span>
                    </div>
                  </template>
                </List.Item.Meta>
              </List.Item>
            </template>
          </List>
          <Empty v-else description="暂无执行记录" />
        </Card>
      </Col>
      <Col :xs="24" :lg="10">
        <Card title="📚 帮助文档" :bordered="false" class="features-card">
          <div class="features-list">
            <div class="feature-item" @click="openHelpDoc('https://gitee.com/li-guanbiao/yun-glenautotest/wikis/%E4%BA%91%E6%B5%8B%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3/%E6%8E%A5%E5%8F%A3%E8%87%AA%E5%8A%A8%E5%8C%96%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3')">
              <div class="feature-icon" style="background: #e6f7ff; color: #1890ff">
                <UsbOutlined />
              </div>
              <div class="feature-content">
                <h4>接口自动化</h4>
                <p>查看接口自动化测试帮助文档</p>
              </div>
            </div>
            <div class="feature-item" @click="openHelpDoc('https://gitee.com/li-guanbiao/yun-glenautotest/wikis/%E4%BA%91%E6%B5%8B%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3/UI%E8%87%AA%E5%8A%A8%E5%8C%96%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3')">
              <div class="feature-icon" style="background: #f6ffed; color: #52c41a">
                <AppstoreOutlined />
              </div>
              <div class="feature-content">
                <h4>UI自动化</h4>
                <p>查看UI自动化测试帮助文档</p>
              </div>
            </div>
            <div class="feature-item" @click="openHelpDoc('https://gitee.com/li-guanbiao/yun-glenautotest/wikis/%E4%BA%91%E6%B5%8B%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3/%E6%80%A7%E8%83%BD%E6%B5%8B%E8%AF%95%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3')">
              <div class="feature-icon" style="background: #fffbe6; color: #faad14">
                <ApartmentOutlined />
              </div>
              <div class="feature-content">
                <h4>性能测试</h4>
                <p>查看性能测试帮助文档</p>
              </div>
            </div>
          </div>
        </Card>
      </Col>
    </Row>
  </div>
</template>

<style scoped>
.home-container {
  padding: 0;
  min-height: 100%;
}

/* 欢迎卡片 */
.welcome-card {
  margin-bottom: 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);
  overflow: hidden;
}

.welcome-card :deep(.ant-card-body) {
  padding: 32px;
}

.welcome-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: #fff;
}

.welcome-left {
  flex: 1;
}

.welcome-title {
  color: #fff;
  font-size: 28px;
  font-weight: 700;
  margin: 0 0 12px 0;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.welcome-subtitle {
  color: rgba(255, 255, 255, 0.9);
  font-size: 15px;
  margin: 0 0 16px 0;
  line-height: 1.6;
}

.welcome-info {
  display: flex;
  gap: 12px;
}

.welcome-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.welcome-refresh {
  cursor: pointer;
  transition: all 0.3s;
}

.welcome-refresh:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-1px);
}

.welcome-refresh.refreshing {
  opacity: 0.7;
  cursor: not-allowed;
}

.welcome-right {
  display: flex;
  align-items: center;
  justify-content: center;
}

.welcome-icon {
  font-size: 80px;
  color: rgba(255, 255, 255, 0.25);
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}

/* 统计卡片 */
.statistics-row {
  margin-bottom: 20px;
}

.stat-card {
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  border: 1px solid #f0f0f0;
  overflow: hidden;
  position: relative;
}

.stat-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, transparent, #d9d9d9, transparent);
  transition: all 0.3s;
}

.stat-card-primary::before {
  background: linear-gradient(90deg, transparent, #1890ff, transparent);
}

.stat-card-success::before {
  background: linear-gradient(90deg, transparent, #52c41a, transparent);
}

.stat-card-warning::before {
  background: linear-gradient(90deg, transparent, #faad14, transparent);
}

.stat-card-purple::before {
  background: linear-gradient(90deg, transparent, #722ed1, transparent);
}

.stat-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
  transform: translateY(-4px);
  border-color: transparent;
}

.stat-card :deep(.ant-card-body) {
  padding: 24px;
}

.stat-icon {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  border-radius: 12px;
  background: #f5f5f5;
  color: #595959;
  margin-right: 16px;
}

.stat-icon-primary {
  background: #e6f7ff;
  color: #1890ff;
}

.stat-icon-success {
  background: #f6ffed;
  color: #52c41a;
}

.stat-icon-warning {
  background: #fffbe6;
  color: #faad14;
}

.stat-icon-purple {
  background: #f9f0ff;
  color: #722ed1;
}

.stat-card :deep(.ant-statistic-title) {
  color: #8c8c8c;
  font-size: 14px;
  margin-bottom: 8px;
}

.stat-card :deep(.ant-statistic-content) {
  display: flex;
  align-items: center;
}

/* 快捷入口 */
.quick-actions-card {
  margin-bottom: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.quick-actions-card :deep(.ant-card-head) {
  border-bottom: 2px solid #f0f0f0;
}

.quick-actions-card :deep(.ant-card-head-title) {
  font-size: 16px;
  font-weight: 600;
}

.quick-action-item {
  display: flex;
  align-items: center;
  padding: 24px;
  border: 2px solid #f0f0f0;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  background: #fff;
  height: 100%;
}

.quick-action-item:hover {
  border-color: #1890ff;
  box-shadow: 0 6px 20px rgba(24, 144, 255, 0.15);
  transform: translateY(-4px);
}

.quick-action-icon {
  width: 72px;
  height: 72px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20px;
  flex-shrink: 0;
  transition: all 0.3s;
}

.quick-action-item:hover .quick-action-icon {
  transform: scale(1.1) rotate(5deg);
}

.quick-action-content {
  flex: 1;
  min-width: 0;
}

.quick-action-title {
  font-size: 17px;
  font-weight: 600;
  margin: 0 0 6px 0;
  color: #262626;
}

.quick-action-desc {
  font-size: 13px;
  color: #8c8c8c;
  margin: 0;
  line-height: 1.5;
}

/* 最近执行记录 */
.recent-card {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  height: 100%;
}

.recent-card :deep(.ant-card-head) {
  border-bottom: 2px solid #f0f0f0;
}

.recent-card :deep(.ant-card-head-title) {
  font-size: 16px;
  font-weight: 600;
}

.recent-list {
  /* 移除高度限制和滚动条，让内容自然展开 */
}

.recent-list-item {
  padding: 16px 0;
  transition: all 0.3s;
  border-radius: 8px;
  margin: 0 -8px;
  padding-left: 8px;
  padding-right: 8px;
}

.recent-list-item:hover {
  background: #fafafa;
}

.recent-item-title {
  display: flex;
  align-items: center;
  gap: 8px;
}

.recent-item-name {
  font-weight: 500;
  color: #262626;
}

.recent-item-tag {
  font-size: 12px;
}

.recent-item-desc {
  display: flex;
  align-items: center;
  gap: 16px;
  font-size: 13px;
  color: #8c8c8c;
  margin-top: 4px;
}

.recent-item-type,
.recent-item-time,
.recent-item-duration {
  display: flex;
  align-items: center;
}

/* 特性卡片 */
.features-card {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  height: 100%;
}

.features-card :deep(.ant-card-head) {
  border-bottom: 2px solid #f0f0f0;
}

.features-card :deep(.ant-card-head-title) {
  font-size: 16px;
  font-weight: 600;
}

.features-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.feature-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 16px;
  border-radius: 12px;
  background: #fafafa;
  transition: all 0.3s;
  cursor: pointer;
}

.feature-item:hover {
  background: #e6f7ff;
  transform: translateX(4px);
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.15);
}

.feature-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  flex-shrink: 0;
}

.feature-content h4 {
  font-size: 15px;
  font-weight: 600;
  margin: 0 0 4px 0;
  color: #262626;
}

.feature-content p {
  font-size: 13px;
  color: #8c8c8c;
  margin: 0;
  line-height: 1.5;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .welcome-card :deep(.ant-card-body) {
    padding: 24px;
  }
  
  .welcome-title {
    font-size: 22px;
  }
  
  .welcome-subtitle {
    font-size: 14px;
  }
  
  .welcome-right {
    display: none;
  }
  
  .quick-action-item {
    padding: 20px;
  }
  
  .quick-action-icon {
    width: 56px;
    height: 56px;
  }
  
  .stat-card :deep(.ant-card-body) {
    padding: 20px;
  }
}

</style>
