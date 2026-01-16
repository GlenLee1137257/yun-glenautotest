<script lang="ts" setup>
import { Form, Input, Select, Tooltip, message } from 'ant-design-vue'
import { type IUIElement, defaultWithIUIElement } from '~/types/apis/ui'
import type { IDict } from '../../../types/apis/dict'
import type { IUIConstantSelectOptions } from '~/types/apis/ui-case'
import type { IBasic } from '~/types/apis/basic'
import type { AfterFetchContext } from '@vueuse/core'
import type NewOrEditBodyVue from '~/components/NewOrEdit/NewOrEditBody.vue'
import type { ComponentExposed } from 'vue-component-type-helpers'

const formModel = ref<IUIElement>({ ...defaultWithIUIElement })
const bodyRef = ref<ComponentExposed<typeof NewOrEditBodyVue>>()

const router = useRouter()

const { post: fetchCreateUIElement } = useCustomFetch(
  '/engine-service/api/v1/ui_element/save',
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '创建成功！')
        router.push('/ui-automation/elements')
      }
      return ctx
    },
  },
)

const { post: fetchUpdateUIElement } = useCustomFetch(
  '/engine-service/api/v1/ui_element/update',
  {
    immediate: false,
    afterFetch(ctx: AfterFetchContext<IBasic>) {
      if (ctx.data && ctx.data.code === 0) {
        message.success(ctx.data.msg ?? '更新成功！')
        router.push('/ui-automation/elements')
      }
      return ctx
    },
  },
)

const { data: locationTypeData } = useCustomFetch<IDict[]>(
  '/engine-service/api/v1/dict/list?category=ui_location_type',
  {
    initialData: [],
    afterFetch(ctx: AfterFetchContext<IBasic<IUIConstantSelectOptions>>) {
      if (ctx.data && ctx.data.code === 0) {
        return {
          data: ctx.data.data.ui_location_type,
          response: ctx.response,
        }
      }
      return {
        data: {},
        response: ctx.response,
      }
    },
  },
)

function handleSave() {
  if (bodyRef.value?.isEditState) {
    fetchUpdateUIElement(formModel.value).execute()
  } else if (
    !formModel.value.name ||
    !formModel.value.description ||
    !formModel.value.locationType ||
    !formModel.value.locationExpress ||
    formModel.value.moduleId === -1
  ) {
    message.error('请填写完整信息')
  } else {
    fetchCreateUIElement(formModel.value).execute()
  }
}
</script>

<template>
  <div>
    <NewOrEditBody ref="bodyRef" v-model:form-model="formModel">
      <Form :model="formModel" layout="vertical" px-36>
        <Form.Item label="元素名称" name="name">
          <Input v-model:value="formModel.name" />
        </Form.Item>

        <Form.Item label="定位类型" name="locationType">
          <Select v-model:value="formModel.locationType">
            <Select.Option
              v-for="item in locationTypeData"
              :key="item.id"
              :value="item.value"
            >
              <Tooltip :title="item.remark">
                {{ item.name }}
              </Tooltip>
            </Select.Option>
          </Select>
        </Form.Item>

        <Form.Item label="定位表达式" name="locationExpress">
          <Input v-model:value="formModel.locationExpress" />
        </Form.Item>

        <FormItemModules v-model:module-id="formModel.moduleId" />

        <Form.Item label="元素描述" name="description">
          <Input.TextArea v-model:value="formModel.description" />
        </Form.Item>
      </Form>
    </NewOrEditBody>
    <NewOrEditFooter name="UI 元素" @save="handleSave" />
  </div>
</template>
