<!-- eslint-disable unicorn/prefer-string-replace-all -->
<script lang="ts" setup>
import { TabPane, Tabs } from 'ant-design-vue'
import { objectDeserializer } from '../../utils/internal'
import type { BodyType } from '~/types/apis/basic'

const props = withDefaults(
  defineProps<{
    keyName?: string
    isStressTest?: boolean
  }>(),
  {
    keyName: 'key',
    isStressTest: false,
  },
)

const bodyType = defineModel<BodyType>('bodyType', { required: true })

const activeKey = ref<'head' | 'body' | 'query' | string>('head')
const headDataSource = ref<object[]>([])
const queryDataSource = ref<object[]>([])
const restDataSource = ref<object[]>([])

const textDataSource = ref<string>('')
const jsonDataSource = ref<object>({})
const pairDataSource = ref<object[]>([])
const uploadDataSource = ref<object>([])

function serialize() {
  let body = '',
    query = '',
    header = '',
    rest = ''

  if (queryDataSource.value.length > 0) {
    query = objectSerializer(queryDataSource.value).replace(
      /"name":/g,
      `"${props.keyName}":`,
    )
  }

  if (restDataSource.value.length > 0) {
    rest = objectSerializer(restDataSource.value)
  }

  if (bodyType.value) {
    if (
      bodyType.value.toUpperCase() === 'FORM_DATA' ||
      bodyType.value.toUpperCase() === 'X_WWW_FORM_URLENCODED'
    ) {
      body = objectSerializer(pairDataSource.value).replace(
        /"name":/g,
        `"${props.keyName}":`,
      )
    } else if (bodyType.value.toUpperCase() === 'JSON') {
      if (typeof jsonDataSource.value === 'string') {
        body = (jsonDataSource.value as string).replace(/\s/g, '')
      } else {
        body = objectSerializer(jsonDataSource.value)
      }
    } else if (bodyType.value.toUpperCase() === 'BINARY') {
      body = objectSerializer(uploadDataSource.value)
    } else {
      body = textDataSource.value
    }
  }

  if (headDataSource.value.length > 0) {
    header = objectSerializer(headDataSource.value).replace(
      /"name":/g,
      `"${props.keyName}":`,
    )
  }

  return {
    query,
    header,
    rest,
    body,
  }
}

function deserialize({
  query,
  header,
  rest,
  body,
  bodyType,
}: {
  query: string
  header: string
  rest: string
  body: string
  bodyType: BodyType
}) {
  if (query) {
    queryDataSource.value = objectDeserializer(
      query.replace(new RegExp(`"${props.keyName}":`, 'g'), `"name":`),
    )
  } else {
    queryDataSource.value = []
  }
  if (header) {
    headDataSource.value = objectDeserializer(
      header.replace(new RegExp(`"${props.keyName}":`, 'g'), `"name":`),
    )
  } else {
    headDataSource.value = []
  }
  if (rest) {
    restDataSource.value = objectDeserializer(rest)
  } else {
    restDataSource.value = []
  }

  if (bodyType) {
    if (
      bodyType.toUpperCase() === 'FORM_DATA' ||
      bodyType.toUpperCase() === 'X_WWW_FORM_URLENCODED'
    ) {
      pairDataSource.value = objectDeserializer(
        body.replace(new RegExp(`"${props.keyName}":`, 'g'), `"name":`),
      )
    } else if (bodyType.toUpperCase() === 'JSON') {
      jsonDataSource.value = objectDeserializer(body, false)
    } else if (bodyType.toUpperCase() === 'BINARY') {
      uploadDataSource.value = objectDeserializer(body, false)
    } else {
      textDataSource.value =
        body.includes('{') || body.includes('[') ? JSON.parse(body) : body
    }
  }
}

defineExpose({
  serialize,
  deserialize,
})
</script>

<template>
  <Tabs v-model:active-key="activeKey">
    <slot name="head" />
    <TabPane key="head" tab="请求头">
      <PairTable
        v-model:data-source="headDataSource"
        key-name="name"
        key-title="请求头名称"
        value-name="value"
        value-title="请求头内容"
      />
    </TabPane>
    <TabPane key="body" tab="请求体">
      <RequestBody
        v-model:current="bodyType"
        v-model:text-data-source="textDataSource"
        v-model:pair-data-source="pairDataSource"
        v-model:json-data-source="jsonDataSource"
        v-model:upload-data-source="uploadDataSource"
        key-name="name"
        :is-stress-test="isStressTest"
      />
    </TabPane>
    <TabPane key="query" tab="查询参数">
      <PairTable
        v-model:data-source="queryDataSource"
        key-name="name"
        key-title="查询参数名称"
        value-name="value"
        value-title="查询参数内容"
      />
    </TabPane>
    <!-- <TabPane v-if="!isStressTest" key="rest" tab="Rest参数">
      <PairTable
        v-model:data-source="restDataSource"
        key-name="name"
        key-title="Rest参数名称"
        value-name="value"
        value-title="Rest参数内容"
      />
    </TabPane> -->

    <slot name="foot" />
  </Tabs>
</template>
