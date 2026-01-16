<script lang="ts" setup>
import { Form, Input, Switch } from 'ant-design-vue'
import {
  type IApiCaseStep,
  defaultWithIApiCase,
  defaultWithIApiCaseStep,
  defaultWithIApiConstantSelectOptions,
} from '~/types/apis/api-case'
import ApiCaseStep from '~/components/NewOrEdit/ApiCaseStep.vue'
import type { ColumnsType } from 'ant-design-vue/es/table'
import type { ComponentExposed } from 'vue-component-type-helpers'

const columns: ColumnsType<any> = [
  {
    title: '序号',
    dataIndex: 'num',
    key: 'num',
    fixed: 'left',
    align: 'center',
  },
  { title: '名称', dataIndex: 'name', key: 'name', align: 'center' },
  {
    title: '描述',
    dataIndex: 'description',
    key: 'description',
    align: 'center',
  },
  { title: '路径', dataIndex: 'path', key: 'path', align: 'center' },
  { title: '等级', dataIndex: 'level', key: 'level', align: 'center' },
  {
    title: '环境 ID',
    dataIndex: 'environmentId',
    key: 'environmentId',
    align: 'center',
  },
  { title: '请求类型', dataIndex: 'method', key: 'method', align: 'center' },
  {
    title: '创建时间',
    dataIndex: 'gmtCreate',
    key: 'gmtCreate',
    width: 200,
    align: 'center',
  },
  {
    title: '修改时间',
    dataIndex: 'gmtModified',
    key: 'gmtModified',
    width: 200,
    align: 'center',
  },
  {
    title: '操作',
    dataIndex: 'operation',
    key: 'operation',
    fixed: 'right',
    width: 170,
    align: 'center',
  },
]
</script>

<template>
  <NewOrEditSteps
    info="api"
    localized-name="接口用例"
    base-api-name="api_case"
    :columns="columns"
    :default-with-step-item="defaultWithIApiCaseStep"
    :default-with-step-instance="defaultWithIApiCase"
    :default-constant-select-options="defaultWithIApiConstantSelectOptions"
  >
    <template #body-content="{ formModel }">
      <Form
        :modal="formModel"
        layout="horizontal"
        class="grid grid-cols-3 gap-4"
      >
        <Form.Item label="用例名称">
          <Input v-model:value="formModel.name" placeholder="请输入用例名称" />
        </Form.Item>

        <!-- <Form.Item label="是否同步 Session">
          <Switch v-model:checked="formModel.isSyncSession" />
        </Form.Item>

        <Form.Item label="是否同步 Cookie">
          <Switch v-model:checked="formModel.isSyncCookie" />
        </Form.Item> -->

        <FormItemModules v-model:module-id="formModel.moduleId" />

        <FormItemLevel v-model:level="formModel.level" />

        <Form.Item label="用例描述">
          <Input.TextArea
            v-model:value="formModel.description"
            placeholder="请输入用例描述"
          />
        </Form.Item>
      </Form>
    </template>

    <template
      #model-content="{ selectedStep, setStepSlotRef, constantSelectOptions }"
    >
      <ApiCaseStep
        :ref="
          (el) => setStepSlotRef(el as ComponentExposed<typeof ApiCaseStep>)
        "
        :api-constant-select-options="constantSelectOptions"
        :selected-step="selectedStep as IApiCaseStep"
      />
    </template>
  </NewOrEditSteps>
</template>
