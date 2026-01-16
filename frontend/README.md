# 项目启动步骤

## 项目启动所需全局安装的环境及项目所用版本

1. **Node.js 版本**：18版本
2. **pnpm 版本**：8.8.0
3. **vite 版本**：5.0.10
4. **TypeScript 版本**：5.3.3

## 项目环境安装指令

1. **安装 Node.js**：请自行前往 [Node.js 官网](https://nodejs.org/) 下载并安装 Node.js 18 版本。

2. **安装 pnpm**：

   ```bash
   npm install -g pnpm@8.8.0
   ```

3. **安装 vite**：

   ```bash
   npm install -g vite@5.0.10
   ```

4. **安装 TypeScript**：

   ```bash
   npm install -g typescript@5.3.3
   ```

## 项目运行

1. **克隆项目**：

   ```bash
   git clone https://github.com/glen-autotest/glen-autotest-frontend.git
   ```

2. **安装项目依赖**：

   ```bash
   pnpm install
   ```

3. **运行项目**：

   ```bash
   npm run dev
   ```

## 项目打包以及部署到服务器

1. **打包项目**：

   ```bash
   npm run build-only
   ```

2. **将打包好的 dist 文件夹里面的内容放入你自己服务器里的 bucket 中。**
