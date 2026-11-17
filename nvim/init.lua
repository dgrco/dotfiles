vim.loader.enable()

-- must be set before plugins load or they bind the wrong leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.guicursor = ''
vim.o.winborder = 'rounded'
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
-- scheduled because setting it synchronously slows startup
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = 'split'
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- INDENT: per-filetype widths, matching each language's formatter default
-- guess-indent and .editorconfig still override these for existing files
local indent_by_filetype = {
  c = 4,
  cpp = 4,
  cs = 4,
  rust = 4,
  python = 4,
  sql = 4,
  java = 4,
  go = { width = 4, tabs = true },
  javascript = 2,
  javascriptreact = 2,
  typescript = 2,
  typescriptreact = 2,
  html = 2,
  css = 2,
  scss = 2,
  lua = 2,
  json = 2,
  jsonc = 2,
  yaml = 2,
  toml = 2,
  xml = 2,
  markdown = 2,
  sh = 2,
  bash = 2,
  zsh = 2,
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.tbl_keys(indent_by_filetype),
  desc = 'Set per-filetype indentation',
  callback = function(args)
    local indent = indent_by_filetype[args.match]
    if type(indent) == 'number' then indent = { width = indent } end
    vim.bo[args.buf].shiftwidth = indent.width
    vim.bo[args.buf].tabstop = indent.width
    vim.bo[args.buf].softtabstop = indent.width
    vim.bo[args.buf].expandtab = not indent.tabs
  end,
})

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set({ 'n', 'i', 'v' }, '<F1>', '<Nop>', { desc = 'Disable F1 help' })
-- avoids wiping the line when reaching for <C-y> to accept a completion
vim.keymap.set('i', '<C-u>', '<Nop>', { silent = true })

vim.keymap.set('n', '<A-j>', '<cmd>move .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>move .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

vim.keymap.set('n', '<leader>|', '<cmd>vsplit<CR>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>_', '<cmd>split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = false,
  virtual_text = false,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr) vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false } end,
  },
}
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local kind = ev.data.kind
    if ev.data.spec.name ~= 'nvim-treesitter' or (kind ~= 'install' and kind ~= 'update') then return end
    if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
    vim.cmd 'TSUpdate'
  end,
})

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'NMAC427/guess-indent.nvim',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'lewis6991/gitsigns.nvim',
  gh 'folke/which-key.nvim',
  gh 'dgrco/slabaster.nvim',
  gh 'folke/todo-comments.nvim',
  gh 'nvim-mini/mini.nvim',
  gh 'windwp/nvim-autopairs',
  gh 'stevearc/oil.nvim',
  gh 'nvim-lua/plenary.nvim',
  gh 'sindrets/diffview.nvim',
  gh 'NeogitOrg/neogit',
  gh 'ibhagwan/fzf-lua',
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'stevearc/conform.nvim',
  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
}

vim.cmd.colorscheme 'slabaster-hearth'
-- stops completed snippets from leaving their placeholder highlighted
vim.api.nvim_set_hl(0, 'SnippetTabstop', {})

require('guess-indent').setup {}
require('todo-comments').setup { signs = false }
require('nvim-autopairs').setup {}

require('gitsigns').setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'
    local function map(mode, keys, func, desc) vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc }) end
    local function visual_range() return { vim.fn.line '.', vim.fn.line 'v' } end

    -- keep ]c/[c-style behavior in diff mode, where vim's own hunk motions are better
    map('n', ']h', function()
      if vim.wo.diff then return vim.cmd.normal { ']c', bang = true } end
      gitsigns.nav_hunk 'next'
    end, 'Next hunk')
    map('n', '[h', function()
      if vim.wo.diff then return vim.cmd.normal { '[c', bang = true } end
      gitsigns.nav_hunk 'prev'
    end, 'Previous hunk')

    map('n', '<leader>hs', gitsigns.stage_hunk, 'Stage hunk')
    map('n', '<leader>hr', gitsigns.reset_hunk, 'Reset hunk')
    map('v', '<leader>hs', function() gitsigns.stage_hunk(visual_range()) end, 'Stage selection')
    map('v', '<leader>hr', function() gitsigns.reset_hunk(visual_range()) end, 'Reset selection')
    map('n', '<leader>hS', gitsigns.stage_buffer, 'Stage buffer')
    map('n', '<leader>hR', gitsigns.reset_buffer, 'Reset buffer')
    map('n', '<leader>hp', gitsigns.preview_hunk, 'Preview hunk')
    map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, 'Blame line')
    map('n', '<leader>hd', gitsigns.diffthis, 'Diff against index')
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle line [B]lame')
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Inner hunk')
  end,
}

require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  win = { padding = { 1, 4 }, border = 'rounded', col = vim.o.columns },
  layout = { width = { min = 20, max = 50 }, spacing = 6 },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>l', group = '[L]SP' },
    { '<leader>?', group = 'Help' },
    { '<leader>n', group = '[N]eogit' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>G', group = '[G]it' },
    { 'gr', group = 'LSP Actions' },
  },
}

-- aa/ii instead of the defaults so they don't shadow the builtin treesitter incremental selection
require('mini.ai').setup { mappings = { around_next = 'aa', inside_next = 'ii' }, n_lines = 500 }
require('mini.surround').setup()
require('mini.splitjoin').setup()
require('mini.trailspace').setup()
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

require('oil').setup()
vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })

local neogit = require 'neogit'
neogit.setup {
  graph_style = 'unicode',
  integrations = { diffview = true, fzf_lua = true },
}
vim.keymap.set('n', '<leader>ns', neogit.open, { desc = '[N]eogit [S]tatus' })
vim.keymap.set('n', '<leader>nc', function() neogit.open { 'commit' } end, { desc = '[N]eogit [C]ommit' })
vim.keymap.set('n', '<leader>nl', function() neogit.open { 'log' } end, { desc = '[N]eogit [L]og' })
vim.keymap.set('n', '<leader>np', function() neogit.open { 'push' } end, { desc = '[N]eogit [P]ush' })
vim.keymap.set('n', '<leader>nP', function() neogit.open { 'pull' } end, { desc = '[N]eogit [P]ull' })
vim.keymap.set('n', '<leader>nb', function() neogit.open { 'branch' } end, { desc = '[N]eogit [B]ranch' })
vim.keymap.set('n', '<leader>nd', function() neogit.open { 'diff' } end, { desc = '[N]eogit [D]iff' })

local fzf = require 'fzf-lua'
fzf.setup {
  'telescope',
  winopts = { preview = { layout = 'vertical' } },
  file_ignore_patterns = { 'node_modules', '%.git/', 'dist/', 'build/', '.cache', 'target/', 'out', 'bin', 'obj' },
}
vim.keymap.set('n', '<leader>f', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>g', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>b', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>r', fzf.oldfiles, { desc = 'Recent files' })
vim.keymap.set({ 'n', 'v' }, '<leader>.', fzf.grep_cword, { desc = 'Grep word under cursor' })
vim.keymap.set('n', '<leader>/', fzf.blines, { desc = 'Search current buffer' })
vim.keymap.set('n', '<leader>,', function() fzf.grep_curbuf { search = vim.fn.expand '<cword>' } end, { desc = 'Grep word in buffer' })
vim.keymap.set('v', '<leader>,', function() fzf.grep_curbuf { search = require('fzf-lua.utils').get_visual_selection() } end, { desc = 'Grep selection in buffer' })
vim.keymap.set('n', '<leader>sg', fzf.lgrep_curbuf, { desc = '[S]earch [G]rep buffer' })
vim.keymap.set('n', '<leader>st', fzf.treesitter, { desc = '[S]earch [T]reesitter symbols' })
vim.keymap.set('n', '<leader>sj', fzf.jumps, { desc = '[S]earch [J]umplist' })
vim.keymap.set('n', '<leader>sm', fzf.marks, { desc = '[S]earch [M]arks' })
vim.keymap.set('n', '<leader>sq', fzf.quickfix, { desc = '[S]earch [Q]uickfix' })
vim.keymap.set('n', '<leader>w', fzf.lsp_live_workspace_symbols, { desc = 'Workspace symbols' })
vim.keymap.set('n', '<leader>s/', fzf.lines, { desc = '[S]earch open buffers' })
vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sD', fzf.diagnostics_workspace, { desc = '[S]earch workspace [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader>sn', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim config' })
vim.keymap.set('n', '<leader>Gs', fzf.git_status, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>Gb', fzf.git_branches, { desc = '[G]it [B]ranches' })
vim.keymap.set('n', '<leader>Gk', fzf.git_hunks, { desc = '[G]it hunks in repo' })
vim.keymap.set('n', '<leader>Gc', fzf.git_commits, { desc = '[G]it [C]ommits' })
vim.keymap.set('n', '<leader>GC', fzf.git_bcommits, { desc = '[G]it buffer [C]ommits' })
vim.keymap.set('n', '<leader>GB', fzf.git_blame, { desc = '[G]it buffer [B]lame' })
vim.keymap.set('n', '<leader>Gh', '<cmd>DiffviewFileHistory %<CR>', { desc = '[G]it file [H]istory' })
vim.keymap.set('n', '<leader>GH', '<cmd>DiffviewFileHistory<CR>', { desc = '[G]it repo [H]istory' })
vim.keymap.set('n', '<leader>?h', fzf.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>?k', fzf.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>?t', fzf.builtin, { desc = 'fzf-lua builtins' })

local function jump_to_reference(forward)
  local client = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/documentHighlight' })[1]
  if not client then return end
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  local response = client:request_sync('textDocument/documentHighlight', params, 500, 0)
  if not response or response.err or not response.result then return end

  local positions = {}
  for _, highlight in ipairs(response.result) do
    local row = highlight.range.start.line
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ''
    table.insert(positions, { row + 1, vim.str_byteindex(line, client.offset_encoding, highlight.range.start.character, false) })
  end
  table.sort(positions, function(a, b) return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2]) end)
  if #positions == 0 then return end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local function after_cursor(pos) return pos[1] > cursor[1] or (pos[1] == cursor[1] and pos[2] > cursor[2]) end
  local function before_cursor(pos) return pos[1] < cursor[1] or (pos[1] == cursor[1] and pos[2] < cursor[2]) end
  local target = forward and positions[1] or positions[#positions]
  for i = 1, #positions do
    local pos = forward and positions[i] or positions[#positions + 1 - i]
    if (forward and after_cursor(pos)) or (not forward and before_cursor(pos)) then
      target = pos
      break
    end
  end
  vim.cmd "normal! m'"
  vim.api.nvim_win_set_cursor(0, target)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local function map(keys, func, desc, mode) vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = desc }) end
    map('grr', fzf.lsp_references, 'References')
    map('gri', fzf.lsp_implementations, 'Implementation')
    map('grd', fzf.lsp_definitions, 'Definition')
    map('grt', fzf.lsp_typedefs, 'Type definition')
    map('grD', vim.lsp.buf.declaration, 'Declaration')
    map('grn', vim.lsp.buf.rename, 'Rename')
    map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
    map('gO', fzf.lsp_document_symbols, 'Document symbols')
    map('gW', fzf.lsp_workspace_symbols, 'Workspace symbols')
    map('grc', fzf.lsp_incoming_calls, 'Incoming calls')
    map('grC', fzf.lsp_outgoing_calls, 'Outgoing calls')
    map('grf', fzf.lsp_finder, 'Definition, references, implementations')
    map(']]', function() jump_to_reference(true) end, 'Next reference')
    map('[[', function() jump_to_reference(false) end, 'Previous reference')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle inlay [H]ints')
    end
  end,
})

local function uses_native_typescript(root)
  if vim.fn.executable(vim.fs.joinpath(root, 'node_modules/.bin/tsgo')) == 1 then
    return true
  end
  local manifest = vim.fs.joinpath(root, 'node_modules/typescript/package.json')
  if vim.fn.filereadable(manifest) == 0 then
    return false
  end
  local version = vim.version.parse(vim.json.decode(table.concat(vim.fn.readfile(manifest), '\n')).version)
  return version ~= nil and version.major >= 7
end

local stock_typescript = {}
for _, name in ipairs { 'ts_ls', 'tsc' } do
  stock_typescript[name] = vim.lsp.config[name]
  assert(type(stock_typescript[name].root_dir) == 'function', 'nvim-lspconfig changed ' .. name .. '.root_dir, update typescript_config')
end

-- wraps lspconfig's own config so upstream fixes still apply. the root comes from ts_ls because
-- its root_dir has no side effects, while tsc's spawns binaries and warns when none is TS 7+.
-- cmd must come from the same load as root_dir: tsc caches the binary root_dir finds for cmd,
-- and nvim reloads lsp/tsc.lua on every resolve, which would give cmd an empty cache
local function typescript_config(server, want_native)
  local stock = stock_typescript[server]
  return {
    cmd = stock.cmd,
    root_dir = function(bufnr, on_dir)
      stock_typescript.ts_ls.root_dir(bufnr, function(root)
        if uses_native_typescript(root) == want_native then
          stock.root_dir(bufnr, on_dir)
        end
      end)
    end,
  }
end

---@type table<string, vim.lsp.Config>
local servers = {
  clangd = {},
  gopls = {},
  basedpyright = {},
  rust_analyzer = {},
  tailwindcss = {},
  docker_compose_language_service = {},
  dockerls = {},
  ts_ls = typescript_config('ts_ls', false),
  roslyn_ls = {},
}
require('mason').setup {}
local ensure_installed = vim.tbl_keys(servers)
table.insert(ensure_installed, 'prettierd')
require('mason-tool-installer').setup { ensure_installed = ensure_installed }
for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

-- not in mason: the TS 7 binary comes from each project's node_modules
vim.lsp.config('tsc', typescript_config('tsc', true))
vim.lsp.enable 'tsc'

local prettier = { 'prettierd', 'prettier', stop_after_first = true }
require('conform').setup {
  notify_on_error = false,
  default_format_opts = { lsp_format = 'fallback' },
  formatters_by_ft = {
    javascript = prettier,
    javascriptreact = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    vue = prettier,
    svelte = prettier,
    css = prettier,
    scss = prettier,
    less = prettier,
    html = prettier,
    json = prettier,
    jsonc = prettier,
    yaml = prettier,
    markdown = prettier,
    graphql = prettier,
    cs = { 'csharpier' },
  },
}
vim.keymap.set({ 'n', 'v' }, '<leader>lf', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })

require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = false },
    list = { selection = { preselect = true } },
    menu = { auto_show = false, max_height = 10, draw = { columns = { { 'label' }, { 'kind' } } } },
  },
  sources = { default = { 'lsp', 'path' } },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}

local treesitter = require 'nvim-treesitter'
treesitter.install { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

local function treesitter_try_attach(buf, language)
  if vim.treesitter.language.add(language) then vim.treesitter.start(buf, language) end
end

local available_parsers = treesitter.get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, language = args.buf, vim.treesitter.language.get_lang(args.match)
    if not language then return end
    if not vim.tbl_contains(treesitter.get_installed 'parsers', language) and vim.tbl_contains(available_parsers, language) then
      treesitter.install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      treesitter_try_attach(buf, language)
    end
  end,
})
