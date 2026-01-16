import { defineConfig, presetAttributify, presetUno } from 'unocss'

export default defineConfig({
  presets: [presetUno(), presetAttributify()],
  shortcuts: [
    { 'transition-base': 'transition transition-300' },
    {
      'pointer-base': 'cursor-pointer c-white hover:c-#1677ff active:c-#0958d9',
    },
  ],
})
