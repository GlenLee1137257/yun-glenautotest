<script lang="ts" setup>
import { Button, Form, Input, message } from 'ant-design-vue'
import type { AfterFetchContext } from '@vueuse/core'
import type { IBasic } from '~/types/apis/basic'

const formModel = reactive({
  identifier: '',
  credential: '',
  username: '',
  identityType: 'phone',
})

const router = useRouter()
// const globalConfigStore = useGlobalConfigStore()

const { post } = useCustomFetch(`/account-service/api/v1/account/register`, {
  immediate: false,
  afterFetch(ctx: AfterFetchContext<IBasic<any>>) {
    if (ctx.data && ctx.data.code === 0) {
      formModel.identifier = ''
      formModel.credential = ''
      formModel.username = ''
      router.push('/login')
      message.success('注册成功')
    }
    return ctx
  },
})
const validateIdentifier = (identifier: string) => {
  const phoneRegExp = /^1\d{10}$/
  const emailRegExp = /^\w+([+.-]\w+)*@\w+([.-]\w+)*\.\w+([.-]\w+)*$/
  const isPhone = phoneRegExp.test(identifier)
  const isEmail = emailRegExp.test(identifier)
  return {
    isValid: isPhone || isEmail || identifier.length > 0, // Allow any non-empty identifier
    identityType: isPhone ? 'phone' : (isEmail ? 'mail' : 'phone'),
  }
}

const addAccount = async () => {
  if (
    formModel.identifier.trim() === '' ||
    formModel.credential.trim() === ''
  ) {
    message.error('用户名和密码不能为空')
    return
  }

  const { isValid, identityType } = validateIdentifier(formModel.identifier)
  if (isValid) {
    formModel.identityType = identityType
    await post(formModel).execute()
  } else {
    message.error('账号格式不正确，请输入有效的手机号或邮箱')
  }
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
          <h3 class="text-center text-3xl font-bold tracking-tight">注册</h3>
          <p class="text-center text-sm text-gray-500 dark:text-gray-400">
            确认你的用户名账号密码
          </p>
        </div>
        <div class="p-6 space-y-4">
          <Form class="space-y-4" layout="vertical" :model="formModel">
            <Form.Item label="用户名">
              <Input v-model:value="formModel.username" class="text-sm py-2!" />
            </Form.Item>
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
            <Form.Item class="flex flex-col items-center p-6 space-y-4">
              <Button class="m-2" type="primary" @click="addAccount"
                >注册</Button
              >
              <Button class="m-2" type="primary" @click="router.push('/login')"
                >登录</Button
              >
            </Form.Item>
          </Form>
        </div>
      </div>
    </div>
  </div>
</template>
