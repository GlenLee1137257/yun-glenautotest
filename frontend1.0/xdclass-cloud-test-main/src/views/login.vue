<script lang="ts" setup>
import { Button, Form, Input, message } from 'ant-design-vue'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'

const formModel = reactive({
  identifier: '',
  credential: '',
  identityType: 'phone',
})

const router = useRouter()
const globalConfigStore = useGlobalConfigStore()
// const permissionStore = usePermissionStore()

const { post } = useCustomFetch(`/account-service/api/v1/account/login`, {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
    if (ctx.data && ctx.data.code === 0) {
      message.success('登录成功')
      globalConfigStore.setLoginToken(ctx.data.data.tokenValue as string)
      router.push('/')
      // permissionStore.fetchUserRole()
    }
    return ctx
  },
})

const checkIdentifierType = () => {
  const isPhone = /^1[3-9]\d{9}$/.test(formModel.identifier)
  formModel.identityType = isPhone ? 'phone' : 'mail'
}
</script>

<template>
  <div
    class="min-h-screen w-full flex items-center justify-center bg-gray-100 dark:bg-gray-800"
  >
    <div class="grid gap-19 lg:grid-cols-1">
      <div
        b="~ solid gray-100"
        p="x-20 y-8"
        class="mx-auto max-w-md w-full border border rounded-lg bg-white shadow-sm space-y-4"
      >
        <div class="flex flex-col px-20 space-y-1.5">
          <h3 class="text-center text-3xl font-bold tracking-tight">登录</h3>
          <p class="text-center text-sm text-gray-500 dark:text-gray-400">
            确认你的账号密码
          </p>
        </div>
        <div class="p-6 space-y-4">
          <Form class="space-y-4" layout="vertical" :model="formModel">
            <Form.Item label="账号">
              <Input
                v-model:value="formModel.identifier"
                class="text-sm py-2!"
              />
            </Form.Item>
            <Form.Item label="密码">
              <Input.Password
                v-model:value="formModel.credential"
                class="text-sm py-1.5!"
              />
            </Form.Item>
            <Form.Item
              class="flex flex-col items-center justify-between p-6 space-y-4"
            >
              <Button
                class="m-2"
                type="primary"
                @click="checkIdentifierType(), post({ ...formModel }).execute()"
                >登录</Button
              >
              <Button
                class="m-2"
                type="primary"
                @click="router.push('/register')"
                >注册</Button
              >
            </Form.Item>
          </Form>
        </div>
      </div>
    </div>
  </div>
</template>
