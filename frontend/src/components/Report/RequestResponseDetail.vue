<script lang="ts" setup>
import { Tabs, Divider, Tag, Empty } from 'ant-design-vue'
import { SendOutlined, InboxOutlined } from '@ant-design/icons-vue'
import JsonEditorVue from 'json-editor-vue'

const props = defineProps<{
  // 请求信息
  method: string
  path: string
  requestHeader: string
  requestQuery: string
  requestBody: string
  // 响应信息
  responseHeader: string
  responseBody: string
}>()

// 解析JSON字符串
function tryParseJson(jsonStr: string): any {
  try {
    return JSON.parse(jsonStr || '{}')
  }
  catch {
    return jsonStr || ''
  }
}

// 请求信息
const requestData = computed(() => ({
  headers: tryParseJson(props.requestHeader),
  query: tryParseJson(props.requestQuery),
  body: tryParseJson(props.requestBody),
}))

// 响应信息
const responseData = computed(() => ({
  headers: tryParseJson(props.responseHeader),
  body: tryParseJson(props.responseBody),
}))

// 格式化请求头/查询参数为键值对数组
function formatKeyValuePairs(data: any): Array<{ key: string; value: string }> {
  if (Array.isArray(data)) {
    // 如果是数组格式 [{key: "xxx", value: "yyy"}]
    return data.map(item => ({
      key: item.key || item.name || '',
      value: item.value || '',
    }))
  }
  else if (typeof data === 'object' && data !== null) {
    // 如果是对象格式 {key1: value1, key2: value2}
    return Object.entries(data).map(([key, value]) => ({
      key,
      value: String(value),
    }))
  }
  return []
}

const requestHeaders = computed(() => formatKeyValuePairs(requestData.value.headers))
const requestQueryParams = computed(() => formatKeyValuePairs(requestData.value.query))
const responseHeaders = computed(() => formatKeyValuePairs(responseData.value.headers))

// 判断是否为JSON
function isJsonData(data: any): boolean {
  return typeof data === 'object' && data !== null && !Array.isArray(data)
}

// 获取方法颜色
function getMethodColor(method: string): string {
  const colors: Record<string, string> = {
    GET: 'blue',
    POST: 'green',
    PUT: 'orange',
    DELETE: 'red',
    PATCH: 'purple',
    HEAD: 'cyan',
    OPTIONS: 'default',
  }
  return colors[method.toUpperCase()] || 'default'
}
</script>

<template>
  <div class="request-response-detail">
    <Tabs default-active-key="request">
      <!-- 请求详情 Tab -->
      <Tabs.TabPane key="request">
        <template #tab>
          <span flex="~ items-center gap-2">
            <SendOutlined />
            请求详情
          </span>
        </template>

        <div class="detail-section">
          <!-- 请求行 -->
          <div class="request-line" mb-4 p-3 bg-blue-50 rounded>
            <div flex="~ items-center gap-2">
              <Tag :color="getMethodColor(method)" style="font-weight: bold; font-size: 14px">
                {{ method }}
              </Tag>
              <code text-base font-mono>{{ path }}</code>
            </div>
          </div>

          <!-- 请求头 -->
          <div class="section-block" mb-4>
            <div class="section-title" mb-2>
              <span font-semibold>请求头 (Headers)</span>
              <span text-sm text-gray-500 ml-2>({{ requestHeaders.length }} 项)</span>
            </div>
            <div v-if="requestHeaders.length > 0" class="key-value-list">
              <div
                v-for="(item, index) in requestHeaders"
                :key="index"
                class="key-value-item"
                p-2
                border="b gray-200"
                flex="~ items-start gap-3"
              >
                <div class="key" flex-shrink-0 w-40 font-semibold text-sm text-gray-700>
                  {{ item.key }}:
                </div>
                <div class="value" flex-1 text-sm text-gray-900 break-all>
                  {{ item.value }}
                </div>
              </div>
            </div>
            <Empty
              v-else
              :image="Empty.PRESENTED_IMAGE_SIMPLE"
              description="无请求头"
              :image-style="{ height: '40px' }"
            />
          </div>

          <Divider />

          <!-- 请求查询参数 -->
          <div class="section-block" mb-4>
            <div class="section-title" mb-2>
              <span font-semibold>查询参数 (Query)</span>
              <span text-sm text-gray-500 ml-2>({{ requestQueryParams.length }} 项)</span>
            </div>
            <div v-if="requestQueryParams.length > 0" class="key-value-list">
              <div
                v-for="(item, index) in requestQueryParams"
                :key="index"
                class="key-value-item"
                p-2
                border="b gray-200"
                flex="~ items-start gap-3"
              >
                <div class="key" flex-shrink-0 w-40 font-semibold text-sm text-gray-700>
                  {{ item.key }}:
                </div>
                <div class="value" flex-1 text-sm text-gray-900 break-all>
                  {{ item.value }}
                </div>
              </div>
            </div>
            <Empty
              v-else
              :image="Empty.PRESENTED_IMAGE_SIMPLE"
              description="无查询参数"
              :image-style="{ height: '40px' }"
            />
          </div>

          <Divider />

          <!-- 请求体 -->
          <div class="section-block">
            <div class="section-title" mb-2>
              <span font-semibold>请求体 (Body)</span>
            </div>
            <div v-if="requestData.body && Object.keys(requestData.body).length > 0" class="json-viewer">
              <JsonEditorVue v-model="requestData.body" read-only :mode="'text'" />
            </div>
            <Empty
              v-else
              :image="Empty.PRESENTED_IMAGE_SIMPLE"
              description="无请求体"
              :image-style="{ height: '40px' }"
            />
          </div>
        </div>
      </Tabs.TabPane>

      <!-- 响应详情 Tab -->
      <Tabs.TabPane key="response">
        <template #tab>
          <span flex="~ items-center gap-2">
            <InboxOutlined />
            响应详情
          </span>
        </template>

        <div class="detail-section">
          <!-- 响应头 -->
          <div class="section-block" mb-4>
            <div class="section-title" mb-2>
              <span font-semibold>响应头 (Headers)</span>
              <span text-sm text-gray-500 ml-2>({{ responseHeaders.length }} 项)</span>
            </div>
            <div v-if="responseHeaders.length > 0" class="key-value-list">
              <div
                v-for="(item, index) in responseHeaders"
                :key="index"
                class="key-value-item"
                p-2
                border="b gray-200"
                flex="~ items-start gap-3"
              >
                <div class="key" flex-shrink-0 w-40 font-semibold text-sm text-gray-700>
                  {{ item.key }}:
                </div>
                <div class="value" flex-1 text-sm text-gray-900 break-all>
                  {{ item.value }}
                </div>
              </div>
            </div>
            <Empty
              v-else
              :image="Empty.PRESENTED_IMAGE_SIMPLE"
              description="无响应头"
              :image-style="{ height: '40px' }"
            />
          </div>

          <Divider />

          <!-- 响应体 -->
          <div class="section-block">
            <div class="section-title" mb-2>
              <span font-semibold>响应体 (Body)</span>
            </div>
            <div v-if="responseData.body && Object.keys(responseData.body).length > 0" class="json-viewer">
              <JsonEditorVue v-model="responseData.body" read-only :mode="'text'" />
            </div>
            <Empty
              v-else
              :image="Empty.PRESENTED_IMAGE_SIMPLE"
              description="无响应体"
              :image-style="{ height: '40px' }"
            />
          </div>
        </div>
      </Tabs.TabPane>
    </Tabs>
  </div>
</template>

<style scoped>
.request-response-detail {
  width: 100%;
}

.detail-section {
  padding: 12px;
}

.section-title {
  display: flex;
  align-items: center;
  font-size: 14px;
}

.key-value-list {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  overflow: hidden;
}

.key-value-item:last-child {
  border-bottom: none;
}

.key-value-item:hover {
  background-color: #fafafa;
}

code {
  background-color: #f5f5f5;
  padding: 4px 8px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}

.json-viewer {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  overflow: hidden;
  max-height: 500px;
}

:deep(.jse-main) {
  min-height: 200px;
}
</style>
