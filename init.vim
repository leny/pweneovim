" leny/pweneovim - init.vim (vimrc) file
" started at 20/08/2018
" started at 15/08/2022

" ---------- Plugins installations

" -------------------- Plugin system checking

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" -------------------- Plugins

call plug#begin()

" --- LSP
Plug 'neovim/nvim-lspconfig'
" --- CMP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" --- Snippets
Plug 'rafamadriz/friendly-snippets'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'folke/trouble.nvim'

" --- Telescope
" - needs brew install ripgrep
" - needs brew install fd
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

Plug 'editorconfig/editorconfig-vim'

Plug 'terryma/vim-expand-region'

Plug 'troydm/zoomwintab.vim'

Plug 'mattn/emmet-vim'

Plug 'airblade/vim-gitgutter'

Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': [ 'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'lua', 'php', 'python', 'ruby', 'html', 'swift', 'yaml' ] }

Plug 'nvim-lualine/lualine.nvim'

Plug 'mileszs/ack.vim'

Plug 'windwp/nvim-autopairs'

Plug 'tpope/vim-surround'

Plug 'takac/vim-hardtime'

Plug 'chentoast/marks.nvim'

call plug#end()

" ---------- Editor configuration

set encoding=utf-8
set fileencodings=utf-8

set nobackup
set noswapfile
set history=250
set hidden
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set foldmethod=syntax
set ignorecase
set smartcase
set modelines=0
set showmatch
set nrformats=hex,alpha
set nowrap
set fileformat=unix
set fileformats=unix,dos
set foldlevel=250
set noshowmode
set updatetime=2000
set smartindent
set ttimeoutlen=0 " cf. https://github.com/wincent/terminus/issues/9#issuecomment-363775121
set scrolloff=4
set sidescrolloff=5
set sidescroll=1
set nopaste
set hlsearch

" ---------- tmux/cursor tweak

" let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1 " (apparently ignored)

" ---------- Color Scheme

syntax on

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

colorscheme tomorrow-night-eighties
set termguicolors

" ---------- Leader configuration

let mapleader="\<Space>"

" ---------- Autocommands

augroup Save
    au!
    au FocusLost * :wa
    au BufLeave * :wa
    au BufWritePre * :%s/\s\+$//e " (Whitespace cleaning)
augroup END

" --- Highlight cursorline on active buffer
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" --- Switch relative/absolute line numbers on focus/blur
augroup RelativeNumber
    au!
    au WinLeave,InsertEnter * setlocal norelativenumber
    au BufEnter,WinEnter,InsertLeave * setlocal relativenumber
augroup END

" --- Update
augroup CheckTime
    au!
    au CursorHold,CursorHoldI * checktime
augroup END

" --- Preserve folding while creating folds in insert mode
augroup PreserveFolding
    au!
    au InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
    au InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
augroup END

" --- Fix for pastemode issue - cf. https://github.com/neovim/neovim/issues/7994
augroup FixNoPasteIssue
    au!
    au InsertLeave * set nopaste
augroup END

" ---------- Remappings

" --- Remap :W when I mean to :w.
command! W w

" --- Remap :w!! to 'save with sudo'
cmap w!! w !sudo tee % > /dev/null

" --- This unsets the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>

" --- Quicker escape mode
inoremap jj <ESC>
inoremap jk <ESC>
inoremap kk <ESC>
inoremap kj <ESC>
inoremap ;; ;<ESC>

" --- Remaps goto match
nnoremap <tab> %
vnoremap <tab> %

" --- Disable arrows in normal mode
nnoremap <up> <nop>
nnoremap <down> <nop>
" nnoremap <left> <nop> " (remapped below)
" nnoremap <right> <nop> " (remapped below)

" --- Disable Arrow keys in Insert mode
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" --- Handle double-space in Insert mode
inoremap <space><space> <space><space><left>

" --- Use arrows to move stuffs in normal/visual mode
nmap <left> <<
nmap <right> >>
vmap <left> <gv
vmap <right> >gv

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" --- prevent entering ex mode accidentally
nnoremap Q <Nop>

" --- disable K man command
nnoremap K <nop>

" --- Fix 'go to mark' behavior with ` as a dead key
nnoremap ' `

" --- misc shortcuts
nnoremap <leader><leader>! Bi!<esc>
nnoremap <leader><leader>; A;<esc>
nnoremap <leader><leader>, A,<esc>
nnoremap <leader><leader>. A.<esc>

" --- search selected text in visual mode
vnoremap // y/\V<C-R>"<CR>

" ---------- Splits Configuration

set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-W>: <C-W>_

" ---------- Invisibles chars configuration

nmap <leader>l :set list!<CR> " Toggle invisible chars
set listchars=trail:·,tab:··,eol:¬,nbsp:░ " Customize chars used for invisibles
set list

" ---------- Toggle Wrap

nmap <leader>W :set wrap!<CR>

" ---------- Copy/paste behavior

" map paste, yank and delete to named register so the content
" will not be overwritten
nnoremap d "xd
vnoremap d "xd
nnoremap y "xy
vnoremap y "xy
nnoremap p "xp
vnoremap p "xp

" ---------- Reload neovim config

nmap <Leader>s :source ~/.config/nvim/init.vim

" -------------------- Plugins configurations

" ---------- Ack

let g:ackprg='ag --vimgrep'

" ---------- LSP Configuration

" ! needs npm install -g typescript typescript-language-server
" ! needs npm i -g vscode-langservers-extracted
" ! needs npm install -g graphql-language-service-cli

lua << EOF

local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

local lspconfig = require('lspconfig')

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

require('lspconfig').tsserver.setup {}
require('lspconfig').eslint.setup{}
require('lspconfig').graphql.setup{}

require('luasnip.loaders.from_vscode').lazy_load()

EOF

let g:lsp_diagnostics_echo_cursor = 1

nnoremap gh <cmd>lua vim.lsp.buf.hover()<cr>

" ---------- CMP Configuration

lua << EOF

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Insert}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 3},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = true}),

    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
})

EOF

" ---------- Treesitter Configuration

lua <<EOF

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

EOF

" ---------- Telescope Configuration

lua <<EOF
require('telescope').load_extension('file_browser')
require('telescope').setup {
    extensions = {
        file_browser = {
            hijack_netrw = true,
            dir_icon = "",
        }
    }
}
EOF

nnoremap <c-p> <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <c-o> <cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>
nnoremap <c-b> <cmd>lua require('telescope.builtin').buffers()<cr>

" ---------- expand region

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" ---------- zoomwintab

nnoremap gz :ZoomWinTabToggle<CR>

" ---------- Prettier

let g:prettier#exec_cmd_async = 1

nnoremap gp :Prettier<CR>

" ---------- LuaLine

lua << END
require('lualine').setup {
    options = { section_separators = '', component_separators = '' },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {
            {
                'diagnostics',
                sections = { 'error', 'warn' },
                symbols = {error = '●', warn = '◇', info = '†', hint = '‡'},
                always_visible = true,
            }
        },
        lualine_c = {'filename'},
        lualine_x = {'encoding'},
        lualine_y = {'filetype'},
        lualine_z = {'location'}
    },
}
END

" ---------- Autopairs

lua << EOF
require("nvim-autopairs").setup {}
EOF

" ---------- Trouble

lua << EOF
require("trouble").setup {
  icons = false,
  fold_open = "v",
  fold_closed = ">",
  indent_lines = false,
  signs = {
      error = '●', 
      warning = '◇', 
      information = '†', 
      hint = '‡',
  },
  use_diagnostic_signs = false,
  auto_preview = false,
}
EOF

nnoremap gt :TroubleToggle document_diagnostics<CR>
nnoremap gr :TroubleToggle workspace_diagnostics<CR>

" ---------- Hardtime

let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h", "j", "k", "l"]
let g:list_of_visual_keys = ["h", "j", "k", "l"]
let g:list_of_insert_keys = []
let g:hardtime_timeout = 500
let g:hardtime_ignore_quickfix = 1