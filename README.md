<!-- README.md：插件用途与使用说明 -->

# Neovim 插件说明

本配置使用 `lazy.nvim` 管理插件，Leader 键是 `,`。

## 插件用途（与 `lua/specs/*.lua` 对齐）

- UI（`ui.lua`）
  - `morhetz/gruvbox`：主题
  - `nvim-lualine/lualine.nvim`：状态栏
  - `akinsho/bufferline.nvim`：Buffer 标签栏
  - `lukas-reineke/indent-blankline.nvim`：缩进指示线
  - `hedyhli/outline.nvim`：符号大纲（侧边栏）
  - `nvim-tree/nvim-web-devicons` / `echasnovski/mini.icons`：图标支持
- 补全与片段（`cmp.lua`）
  - `hrsh7th/nvim-cmp` + `cmp-nvim-lsp`/`cmp-buffer`/`cmp-path`：补全引擎与来源
  - `L3MON4D3/LuaSnip` + `friendly-snippets`：代码片段
  - `onsails/lspkind.nvim`：补全面板图标
- LSP（`lsp.lua`）
  - `neovim/nvim-lspconfig`：LSP Server 配置
  - `williamboman/mason.nvim` + `mason-lspconfig.nvim`：LSP 安装与管理
- Treesitter（`treesitter.lua`）
  - `nvim-treesitter/nvim-treesitter`：语法高亮与折叠
- 格式化与 Lint（`format.lua`）
  - `stevearc/conform.nvim`：格式化
  - `mfussenegger/nvim-lint`：静态检查
- 搜索与导航（`search.lua`）
  - `nvim-telescope/telescope.nvim` + `plenary.nvim`：文件/内容搜索
  - `telescope-fzf-native.nvim`：搜索加速（需要 `make`）
- Git（`git.lua`）
  - `lewis6991/gitsigns.nvim`：行级变更提示与操作
- Codex（`codex.lua`）
  - `johnseth97/codex.nvim`：终端内 Codex 面板
- 其他（`misc.lua`）
  - `folke/which-key.nvim`：按键提示
  - `numToStr/Comment.nvim`：注释
  - `liuchengxu/graphviz.vim`：Graphviz 文件支持

## 使用说明（快捷键/命令）

### 通用

- `,`：Leader 键
- `,ul`：切换不可见字符显示（listchars）

### LSP

- `gd`：跳转定义
- `gD`：跳转声明
- `gi`：跳转实现
- `gr`：引用列表
- `K`：悬浮文档
- `<C-k>`：签名帮助
- `[d` / `]d`：上一条/下一条诊断
- `,e`：诊断浮窗
- `,rn`：重命名
- `,ca`：Code Action
- `,lf`：LSP 格式化（仅 attach 后）

### 补全（nvim-cmp）

- `<C-Space>`：触发补全
- `<CR>`：确认
- `<Tab>` / `<S-Tab>`：选择项或跳转片段

### 格式化（conform）

- `,f`：格式化（Conform/LSP）
- `,F`：强制格式化（超时更长）

外部格式化工具按需启用（未安装则不执行）：  
`stylua`、`ruff`/`black`、`prettier`、`shfmt`

### Lint（nvim-lint）

- `,l`：手动运行 lint

外部 lint 工具按需启用：  
`ruff`、`eslint_d`/`eslint`、`shellcheck`

### 搜索（Telescope）

- `,ff`：查找文件
- `,fg`：全文搜索（rg）
- `,fb`：Buffer 列表
- `,fh`：Help
- `,fr`：最近文件
- `:Telescope`：打开命令入口

### Git（gitsigns）

- `]c` / `[c`：下/上一个 hunk
- `,gs`：预览 hunk
- `,gr`：重置 hunk
- `,gb`：行 blame

### Bufferline

- `<C-n>` / `<C-p>`：下/上一个 buffer
- `,bd`：关闭当前 buffer
- `,1`~`,9`：跳转到指定 buffer

### Outline

- `,so`：打开/关闭符号大纲侧边栏
- `:Outline` / `:OutlineOpen` / `:OutlineClose`：命令方式

### Treesitter

- 自动启用高亮与折叠
- `:TSInstallCommon`：手动安装常用 parser（后台执行）

### Codex

- `,cx`：切换 Codex 面板
- `,cX`：打开 Codex
- `:Codex` / `:CodexToggle`：命令方式
- `Ctrl+Q`：关闭 Codex 面板

### Comment.nvim

- `gcc`：注释/取消注释当前行
- `gc`：注释/取消注释选中区域
- `gbc`：块注释当前行

### Graphviz

- 文件类型：`dot`/`gv`/`graphviz`
- 默认输出格式：`png`
