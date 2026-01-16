<script lang="ts" setup>
import { Form, Input, message } from 'ant-design-vue'
import { type IApi, defaultWithIApi } from '~/types/apis/api'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'
import type { ComponentExposed } from 'vue-component-type-helpers'
import type NewOrEditBodyVue from '~/components/NewOrEdit/NewOrEditBody.vue'
import type RequestConfigVue from '~/components/NewOrEdit/RequestConfig.vue'

const requestConfigRef = ref<ComponentExposed<typeof RequestConfigVue>>()
const formModel = ref<IApi>({ ...defaultWithIApi })

const router = useRouter()
const bodyRef = ref<ComponentExposed<typeof NewOrEditBodyVue>>()

const { post: fetchUpdate } = useCustomFetch(
  '/engine-service/api/v1/api/update',
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data?.code === 0) {
        message.success(ctx.data.msg ?? '保存成功')
        router.push('/interface-automation/manager')
      }
      return ctx
    },
  },
)

const { post: fetchCreate } = useCustomFetch(
  '/engine-service/api/v1/api/save',
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data?.code === 0) {
        message.success(ctx.data.msg ?? '创建成功')
        router.push('/interface-automation/manager')
      }
      return ctx
    },
  },
)

function handleSave() {
  // 处理数据结构
  if (!requestConfigRef.value) {
    message.error('出现内部错误，请重试！')
    return
  }

  const { body, header, query, rest } = requestConfigRef.value.serialize()
  formModel.value.body = body
  formModel.value.rest = rest
  formModel.value.query = query
  formModel.value.header = header

  if (bodyRef.value?.isEditState) {
    fetchUpdate(formModel.value).execute()
  } else if (
    !formModel.value.name ||
    !formModel.value.path ||
    !formModel.value.level ||
    !formModel.value.description ||
    formModel.value.moduleId === -1 ||
    formModel.value.environmentId === -1
  ) {
    message.warn('请填写完整信息!')
    return
  } else {
    fetchCreate(formModel.value).execute()
  }
}

function deserialize() {
  requestConfigRef.value?.deserialize({
    body: formModel.value.body,
    header: formModel.value.header,
    query: formModel.value.query,
    rest: formModel.value.rest,
    bodyType: formModel.value.bodyType,
  })
}
</script>

<template>
  <div>
    <NewOrEditBody
      ref="bodyRef"
      v-model:form-model="formModel"
      @deserialize="deserialize"
    >
      <Form
        :modal="formModel"
        layout="horizontal"
        class="grid grid-cols-3 gap-4"
      >
        <Form.Item label="接口名称">
          <Input v-model:value="formModel.name" placeholder="请输入接口名称" />
        </Form.Item>
        <FormItemMethod v-model:method="formModel.method" />
        <Form.Item label="接口地址">
          <Input v-model:value="formModel.path" placeholder="请输入接口地址" />
        </Form.Item>

        <FormItemLevel v-model:level="formModel.level" />

        <FormItemModules v-model:module-id="formModel.moduleId" />

        <FormItemEnvironment v-model:environment-id="formModel.environmentId" />

        <Form.Item label="接口描述">
          <Input.TextArea
            v-model:value="formModel.description"
            placeholder="请输入接口描述"
          />
        </Form.Item>
      </Form>
      <RequestConfig
        ref="requestConfigRef"
        v-model:body-type="formModel.bodyType"
      />
    </NewOrEditBody>

    <NewOrEditFooter name="接口" @save="handleSave" />
  </div>
</template>
