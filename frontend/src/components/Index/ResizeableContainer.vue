<script lang="ts" setup>
const props = defineProps<{
  title: string
  imageSrc: string
  active: number
}>()

const activeIndex = defineModel<number>('activeIndex')

const realImageSrc = computed(() => {
  const images = Object.fromEntries(
    Object.entries(
      import.meta.glob('../../assets/images/*.png', {
        as: 'url',
        eager: true,
      }),
    ).map(([key, value]) => [key.replace('../../assets/images/', ''), value]),
  )
  return images[props.imageSrc]
})

const isActive = computed(() => {
  return activeIndex.value === props.active
})
</script>

<template>
  <div
    b="~ solid #3A66B0"
    p="t-5 "
    :class="[isActive ? 'px-4 bg-#F2F9FF ' : 'px-2 bg-white']"
    transition="all 300"
    relative
    h-200px
    min-w-38
    cursor-pointer
    rounded-xl
    @mouseenter="activeIndex = active"
    @mouseleave="activeIndex = 0"
  >
    <p text="3.8 #16498F" :class="[isActive && 'text-5!']">{{ title }}</p>
    <div
      v-show="isActive"
      h="1.2"
      absolute
      left-4
      top-12
      w-12
      rounded-full
      bg="#3A66B0"
    />
    <div flex="~ items-center justify-center">
      <img
        text-center
        :src="realImageSrc"
        transition="all 300"
        :class="isActive ? 'h-30 w-60' : 'h-30 w-30'"
      />
    </div>
  </div>
</template>
