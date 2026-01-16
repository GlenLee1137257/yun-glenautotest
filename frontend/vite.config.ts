import { URL, fileURLToPath } from 'node:url'

import { defineConfig } from 'vite'
import Vue from '@vitejs/plugin-vue'

import UnoCSS from 'unocss/vite'
import VueRouter from 'unplugin-vue-router/vite'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { VueRouterAutoImports } from 'unplugin-vue-router'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    Vue({
      script: {
        defineModel: true,
      },
    }),
    UnoCSS(),
    VueRouter({
      dts: './src/types/vue-router.d.ts',
      routesFolder: 'src/views',
      extensions: ['.vue'],
      importMode: 'async',
    }),
    AutoImport({
      dts: './src/types/auto-import.d.ts',
      imports: ['vue', 'pinia', '@vueuse/core', VueRouterAutoImports],
      dirs: ['./src/composables', './src/stores', './src/utils'],
    }),
    Components({
      dts: './src/types/components.d.ts',
    }),
  ],
  resolve: {
    alias: {
      '~': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: {
    proxy: {
      '/account-service': {
        target: 'http://192.168.117.237:8000',
        changeOrigin: true,
      },
      '/engine-service': {
        target: 'http://192.168.117.237:8000',
        changeOrigin: true,
      },
      '/data-service': {
        target: 'http://192.168.117.237:8000',
        changeOrigin: true,
      },
      '/server-api': {
        target: 'http://192.168.117.237:8000',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/server-api/, ''),
      },
    },
  },
})
