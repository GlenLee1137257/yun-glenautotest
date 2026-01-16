<script lang="ts" setup>
import JsonEditorVue from 'json-editor-vue'
import {
  Button,
  Input,
  Radio,
  type RadioChangeEvent,
  RadioGroup,
} from 'ant-design-vue'
import type { BodyType } from '~/types/apis/basic'

withDefaults(
  defineProps<{
    keyName?: string
    isStressTest?: boolean
  }>(),
  {
    keyName: 'name',
    isStressTest: false,
  },
)

const current = defineModel<BodyType>('current')
const textDataSource = defineModel<string>('textDataSource')
const jsonDataSource = defineModel<object | string>('jsonDataSource')
const uploadDataSource = defineModel<object>('uploadDataSource')
const pairDataSource = defineModel<object[]>('pairDataSource', {
  default: [],
})

function handleChange(value: RadioChangeEvent) {
  textDataSource.value = ''
  jsonDataSource.value = ''
  pairDataSource.value = []
  uploadDataSource.value = []
  current.value = value.target.value
}

function handleFileUploaded(value: string) {
  uploadDataSource.value = [{ key: 'file', value }]
}
</script>

<template>
  <div>
    <RadioGroup :value="current?.toUpperCase()" @change="handleChange">
      <Radio v-if="!isStressTest" value="FORM_DATA">form-data</Radio>
      <Radio value="X_WWW_FORM_URLENCODED">x-www-form-urlencoded</Radio>
      <Radio value="JSON">json</Radio>
      <!-- <Radio v-if="!isStressTest" value="RAW">raw</Radio> -->
      <Radio v-if="!isStressTest" value="BINARY">file</Radio>
    </RadioGroup>

    <div mt>
      <template
        v-if="
          current?.toUpperCase() === 'FORM_DATA' ||
          current?.toUpperCase() === 'X_WWW_FORM_URLENCODED'
        "
      >
        <PairTable
          v-model:data-source="pairDataSource"
          :key-name="keyName"
          key-title="key"
          value-name="value"
          value-title="value"
        />
      </template>
      <template v-if="current?.toUpperCase() === 'JSON'">
        <JsonEditorVue
          v-model="jsonDataSource"
          mode="text"
          placeholder="请输入JSON内容"
          :main-menu-bar="false"
          :status-bar="false"
        />
      </template>
      <template v-if="current?.toUpperCase() === 'RAW'">
        <Input.TextArea
          v-model:value="textDataSource"
          placeholder="请输入内容"
        />
      </template>

      <template v-if="current?.toUpperCase() === 'BINARY'">
        <UploadFile
          flex="~ items-center justify-center"
          :show-url="(uploadDataSource as any)?.[0]?.value"
          @change="
            (event) => {
              event.file?.response &&
                handleFileUploaded(event.file.response.data)
            }
          "
        >
          <Button
            type="primary"
            :class="[(uploadDataSource as any)?.value && 'op-80']"
          >
            {{ uploadDataSource ? '已上传' : '点击上传' }}
          </Button>
        </UploadFile>
      </template>
    </div>
  </div>
</template>
