<script lang="ts" setup>
import { Modal } from 'ant-design-vue'
import {
  EnvironmentFilled,
  MailFilled,
  PhoneFilled,
} from '@ant-design/icons-vue'

const [open, toggleOpen] = useToggle()
const router = useRouter()

const activeIndex = ref(0)
const globalConfig = useGlobalConfigStore()

const handleClick = () => {
  if (globalConfig.loginToken) {
    router.push('/home')
  } else {
    router.push('/login')
  }
}
</script>

<template>
  <div>
    <div class="background" top-28 />

    <!-- 顶部 -->
    <div
      sticky
      top-0
      z-9999
      bg-white
      flex="~ items-center justify-around"
      p="x y"
    >
      <div flex="~ items-center justify-center" space-x-4>
        <img src="../assets/images/icon_blue.png" h-8 w-11 />
        <span text="6 #3765B0" font="900" tracking-widest>
          滴云自动化测试平台
        </span>
      </div>
      <div
        text="4.5 #040000"
        flex
        font-normal
        children-transition-base
        children-cursor-pointer
        space-x-20
      >
        <span font-bold text="#3765B0">首页</span>
        <span
          hover="transition-base text-#3765bD active:text-#4899cf"
          @click="toggleOpen()"
        >
          联系我们

          <Modal v-model:open="open" :footer="null">
            <div flex="~ items-center justify-center">
              <img w-80 src="../assets/images/weixin_xiao_d.jpg" />
            </div>
          </Modal>
        </span>
        <span hover="transition-base text-#3765bD active:text-#4899cf">
          加入我们
        </span>
        <span
          hover="transition-base text-#3765bD active:text-#4899cf"
          @click="handleClick()"
        >
          {{ globalConfig.loginToken ? '立即体验' : '登录注册' }}
        </span>
      </div>
    </div>

    <!-- 中间介绍 -->
    <div
      flex="~ items-center justify-center relative"
      p="y-12vh"
      style="background: linear-gradient(148deg, #eeeef6, #f8f9fc)"
    >
      <div text="#3464AF">
        <h1 mb-8 text-4xl>滴云自动化测试平台</h1>
        <p my-6 font-900>平台简介</p>
        <p text-left leading-3>
          高效解决企业测试痛点,统一接口自动化、UI自动化、
        </p>
        <p text-left leading-3>
          压力测试，支持公有云和私有云，可视化测试编排，
        </p>
        <p text-left leading-3>自动生成测试报告，省时提效，保障软件质量，</p>
        <p text-left leading-3>加速交付周期，让测试变得更轻松、更高效！</p>

        <div flex="~ items-center justify-center">
          <button
            bg="#3260AD"
            outline="#527ABD"
            hover:bg="#527ABD"
            active:bg="#3765B0"
            p="x-14 y-2"
            m="t-10 r-14"
            cursor-pointer
            rounded-full
            border-none
            text-5
            text-white
            font-bold
            transition-base
            @click="handleClick()"
          >
            立即体验
          </button>
        </div>
      </div>

      <div>
        <img src="../assets/images/illustration.png" h-88 w-170 />
      </div>
    </div>

    <!-- 一些特效图 -->
    <div w-full flex="~ col items-center justify-center">
      <div
        bg="#3A66B0"
        h-10
        w-18
        rounded="lb-full rb-full"
        transform-rotate--4
      />
      <div m="l-20" h-7 w-7 rounded-full bg="#4D7EC1 op-65" />
      <div m="l-30" h-4 w-4 rounded-full bg="#3C71B8 op-35" />
    </div>

    <!-- 功能介绍 + 标题 -->
    <div flex="~ col justify-center items-center">
      <h2 text="6xl #16498F " font-900>功能介绍</h2>
      <div class="line" />
    </div>

    <!-- 接口自动化 -->
    <div flex="~ items-center justify-center" space-x-35>
      <img h-58 w-120 src="../assets/images/interface.png" />
      <div text="#3464AF">
        <h1 text="10 center" mb-8 font-900 tracking-widest>接口自动化</h1>
        <div text-5 font-bold children-leading-3>
          <p>提供一套完整的接口自动化测试解决方案，</p>
          <p>包括接口测试用例设计、数据驱动、断言验</p>
          <p>证等功能</p>
        </div>
      </div>
    </div>

    <!-- UI自动化 -->
    <div
      flex="~ items-center justify-center"
      my-10
      py-10
      space-x-35
      bg="#FBFCFE!"
    >
      <div text="#3464AF">
        <h1 text="10 center" mb-8 font-900 tracking-widest>UI自动化</h1>
        <div text-5 font-bold children-leading-3>
          <p>模拟用户真实操作来测试软件系统的界面功</p>
          <p>能，支持多种主流浏览器，满足不同环境下</p>
          <p>的测试需求</p>
        </div>
      </div>
      <img h-58 w-120 src="../assets/images/ui.png" />
    </div>

    <!-- 压力测试 -->
    <div my-10 flex="~ items-center justify-center" space-x-35>
      <img h-58 w-120 src="../assets/images/stress.png" />
      <div text="#3464AF">
        <h1 text="10 center" mb-8 font-900 tracking-widest>压力测试</h1>
        <div text-5 font-400 children-leading-3>
          <p>支持各种压测脚本和策略，灵活的场</p>
          <p>景设置，实时监控和告警，多种协议</p>
          <p>支持，详细的测试报告</p>
        </div>
      </div>
    </div>

    <!-- 图片展示 -->
    <div p="y-20" style="background: linear-gradient(148deg, #eeeef6, #f8f9fc)">
      <!-- 使用场景介绍 + 标题 -->
      <div flex="~ col justify-center items-center">
        <h2 text="6xl #16498F " font-900>使用场景介绍</h2>
        <div class="line" />
      </div>

      <div flex="~ items-center justify-center">
        <ResizeableContainer
          v-model:active-index="activeIndex"
          :active="0"
          title="接口自动化测试"
          image-src="a.png"
        />
        <ResizeableContainer
          v-model:active-index="activeIndex"
          :active="1"
          title="UI自动化测试"
          image-src="b.png"
        />
        <ResizeableContainer
          v-model:active-index="activeIndex"
          :active="2"
          title="可视化压力测试"
          image-src="c.png"
        />
        <ResizeableContainer
          v-model:active-index="activeIndex"
          :active="3"
          title="可视化压测报告"
          image-src="d.png"
        />
      </div>
    </div>

    <!-- 加入我们 -->
    <div p="y-20" flex="~ col items-center justify-center" space-y-10>
      <div text="#3A66B0 center" font-900 tracking-1 flex="~ col">
        <span text-7xl>想 加 入 吗</span>
        <span text-4xl m="t-1 ">我们需要你的加入</span>
      </div>

      <div
        p="x-8 y-4"
        rounded-full
        text-4
        font-900
        space-x-4
        style="
          box-shadow:
            0px 6px 43px 0px rgba(39, 77, 160, 0.73),
            0px -1px 8px 0px rgba(43, 82, 163, 0.28);
        "
        flex="~ items-center justify-between"
      >
        <div bg="#E1EAEF" p="x-8 y" rounded-full text="#606B7C">
          请输入您的联系方式
        </div>
        <span text="#3A68B1" p="x-8">在此点击加入我们&nbsp;&nbsp;→</span>
      </div>
    </div>

    <!-- 底部 -->
    <div
      bg="#373B40"
      p="y-10"
      flex="~ items-center justify-center"
      text-white
      space-x-20
    >
      <div space="y-6" flex="~ col items-start">
        <div flex="~ items-center justify-center" space-x-2>
          <img src="../assets/images/logo.jpg" h-10 w-12 />
          <span text-7 font-900 tracking="0.8">滴云自动化测试平台</span>
        </div>
        <ul mr-4 list-none text-4 children-list-none space-y-3>
          <li><PhoneFilled rotate-90 />&nbsp;&nbsp;+880 1234 4567</li>
          <li><MailFilled />&nbsp;&nbsp;example@email.com</li>
          <li><EnvironmentFilled />&nbsp;&nbsp;广州市天河区柯木塱</li>
        </ul>
      </div>

      <div flex="~ items-start" mt-10 space-x-20>
        <div font-800 flex="~ col items-start justify-center">
          <span text-4>快速链接</span>
          <ul mt-6 list-none p-0 text-3 text-4 children-list-none space-y-3>
            <li>Android</li>
            <li>iOS</li>
            <li>Windows</li>
          </ul>
        </div>

        <div font-800 flex="~ col items-start justify-center">
          <span text-4>常见问题</span>
          <ul mt-6 list-none p-0 text-3 text-4 children-list-none space-y-3>
            <li>注册登录</li>
            <li>账号/密码</li>
            <li>发票售后</li>
            <li>投诉举报</li>
          </ul>
        </div>

        <div font-800 flex="~ col items-start justify-center">
          <span text-4>产品服务</span>
          <ul mt-6 list-none p-0 text-3 text-4 children-list-none space-y-3>
            <li>帮助中心</li>
            <li>官方博客</li>
          </ul>
        </div>

        <div font-800 flex="~ col items-start justify-center">
          <span text-4>产品服务</span>
          <ul mt-6 list-none p-0 text-3 text-4 children-list-none space-y-3>
            <li>联系方式</li>
            <li>加入我们</li>
            <li>公司地址</li>
            <li>公众号</li>
          </ul>
        </div>
      </div>
    </div>

    <div flex items-center justify-center bg="#373B40" pb-10 c-white>
      <span>
        Copyright © 2026 Glen AutoTest Platform
        <a c-white underline-none href="https://beian.miit.gov.cn/"
          >粤ICP备15092968号</a
        >
        Terms
      </span>
    </div>
  </div>
</template>

<style scoped>
.background {
  z-index: 999;
  width: 100%;
  height: 1007px;
  position: absolute;
  background-size: cover;
  pointer-events: none;
  background: url('../assets/images/background.png') no-repeat center;
}

.line {
  margin-bottom: 100px;
  width: 35vw;
  height: 2px;
  background-image: linear-gradient(
    to right,
    transparent,
    #3260ad,
    transparent
  );
}
</style>
