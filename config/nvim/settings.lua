local o = vim.opt
local g = vim.g
local a = vim.api
local k = vim.keymap

-- Leader Key
g.mapleader = " "
g.maplocalleader = " "

-- Line Numbers
o.number = true
o.numberwidth = 4
o.relativenumber = true

-- Netrw
g.netrw_keepdir = 1
g.netrw_banner = 0
g.netrw_localcopydircmd = "cp -r"

-- Indentation
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Window behaviour
o.splitright = true
o.splitbelow = true

-- Others
o.wrap = false
o.scrolloff = 8
o.termguicolors = true
o.conceallevel = 0
o.concealcursor = ""
o.laststatus = 3

-- Theme
vim.cmd.colorscheme("tokyonight-storm")

-- Comments
require("ts_context_commentstring").setup({
  enable_autocmd = false,
})
require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

-- Telescope
require("telescope").setup({
  defaults = {
    initial_mode = "normal",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    path_display = { "truncate" },
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.5,
      },
      width = 0.9,
      height = 0.9,
      preview_cutoff = 80,
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "-H", "-E", ".git" },
    },
  },
})

-- Treesitter
-- require("nvim-treesitter.configs").setup({
--   highlight = {
--     enable = true,
--     additional_vim_regex_highlighting = false,
--   },
-- })

-- require('gitblame').setup {
--   enabled = false,
-- }

-- LSP
local servers = {
  -- pyright = {},
  rust_analyzer = {},
  ts_ls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

require("mason").setup({
  PATH = "prepend",   -- "skip" seems to cause the spawning error
})
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
})
-- require("neodev").setup()
require("fidget").setup({}) -- Notifications

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("mason-lspconfig").setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = nil,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    })
  end,
})

-- Completion
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup()

-- -- Copilot (Disable suggestions, then add to cmp)
-- require("copilot").setup({
--   suggestion = { enabled = false },
--   panel = { enabled = false },
-- })
-- require("copilot_cmp").setup()
require("supermaven-nvim").setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-l>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    -- ["<Tab>"] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_locally_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end, { "i", "s" }),
    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif luasnip.locally_jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end, { "i", "s" }),
  }),
  sources = {
    -- { name = "copilot", group_index = 2 },
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer",  keyword_length = 5 },
  },
  experimental = {
    ghost_text = {},
  },
})

require("noice").setup({})
require("lualine").setup({})

-- cmp on command
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})

-- Markdown Preview
-- require("render-markdown").setup({})


-- Formatting
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { { "prettier", "prettierd" } },
    javascriptreact = { { "prettier", "prettierd" } },
    typescript = { { "prettier", "prettierd" } },
    typescriptreact = { { "prettier", "prettierd" } },
    python = { "isort", "black" },
    scss = { "prettier" },
    css = { "prettier" },
    nix = { "nixfmt" },
  },
  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_format = "fallback",
  -- },
})

-- Diagnostic settings
vim.diagnostic.config({
	underline = true,
	virtual_text = false,
	signs = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		style = "minimal",
		source = "always",
	},
})

-- LazyDev configuration
-- require("lazydev").setup({
--   library = {
--     -- Library paths can be absolute
--     "~/projects/my-awesome-lib",
--     -- Or relative, which means they will be resolved from the plugin dir.
--     "lazy.nvim",
--     "luvit-meta/library",
--     -- It can also be a table with trigger words / mods
--     -- Only load luvit types when the `vim.uv` word is found
--     { path = "luvit-meta/library", words = { "vim%.uv" } },
--     -- always load the LazyVim library
--     "LazyVim",
--     -- Only load the lazyvim library when the `LazyVim` global is found
--     { path = "LazyVim", words = { "LazyVim" } },
--     -- Load the wezterm types when the `wezterm` module is required
--     -- Needs `justinsgithub/wezterm-types` to be installed
--     { path = "wezterm-types", mods = { "wezterm" } },
--   },
--   -- always enable unless `vim.g.lazydev_enabled = false`
--   -- This is the default
--   enabled = function()
--     return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
--   end,
-- })
--

require("toggleterm").setup()
require("tmux").setup()

local Terminal = require("toggleterm.terminal").Terminal
local hpm = Terminal:new({
	cmd = "pnpm hpm",
	dir = "~/development/huddler/workspace1",
	hidden = true,
	direction = "float",
	display_name = "Huddler Package Manager",
})

k.set("n", "<leader>h", function()
	hpm:toggle()
end, { noremap = true, silent = true })
k.set("t", "<esc>", [[<C-\><C-n><C-W>w]])


require('csvview').setup({
  -- Your configuration options here
})

-- Sonarlint
-- require('sonarlint').setup({
--   server = {
--     cmd = {
--       'sonarlint-language-server',
--       -- Ensure that sonarlint-language-server uses stdio channel
--       '-stdio',
--       '-analyzers',
--       -- paths to the analyzers you need, using those for python and java in this example
--       vim.fn.expand(vim.fn.stdpath("data").."\\mason\\share\\sonarlint-analyzers\\sonarjs.jar"),
--       vim.fn.expand(vim.fn.stdpath("data").."\\mason\\share\\sonarlint-analyzers\\sonarhtml.jar"),
--     }
--   },
--   filetypes = {
--     'typescript',
--     'typescriptreact',
--   }
-- })


-- Create an augroup to manage related autocommands

a.nvim_create_augroup('CsvViewGroup', { clear = true })

-- Define an autocommand that runs CsvViewEnable when a CSV file is opened

a.nvim_create_autocmd('FileType', {
  group = 'CsvViewGroup',
  pattern = 'csv',
  callback = function()
    vim.cmd('CsvViewEnable')
  end,
})
