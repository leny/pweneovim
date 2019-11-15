" leny/pweneovim - init.vim (vimrc) file
" started at 20/08/2018

" ---------- Plugin configuration

call plug#begin()
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'mileszs/ack.vim'
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'raimondi/delimitmate'
Plug 'vim-scripts/gitignore'
Plug 'editorconfig/editorconfig-vim'
Plug 'terryma/vim-expand-region'
Plug 'Shougo/context_filetype.vim'
Plug 'jsfaint/gen_tags.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'branch': 'release/1.x', 'for': [ 'javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'lua', 'php', 'python', 'ruby', 'html', 'swift', 'yaml' ] }
Plug 'kshenoy/vim-signature'
Plug 'pgilad/vim-react-proptypes-snippets'
Plug 'takac/vim-hardtime'
Plug 'jszakmeister/vim-togglecursor'
Plug 'mattn/emmet-vim'
Plug 'troydm/zoomwintab.vim'
" --- Syntax plugins
Plug 'sheerun/vim-polyglot'
Plug 'martinda/Jenkinsfile-vim-syntax'
call plug#end()

" ---------- Editor configuration

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

let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

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

" ---------- Svelte files

augroup svelte_filetype
    au!
    au BufNewFile,BufRead *.svelte set ft=html
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

" ---------- ALE

let g:ale_sign_error = '●'
highlight ALEErrorSign guifg=#f2777a
highlight SpellBad guisp=#f2777a
let g:ale_sign_warning = '◇'
highlight ALEWarningSign guifg=#ffcc66
highlight SpellCap guisp=#ffcc66

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(winbufnr('$'))

    if l:counts.total == 0
        return '✓'
    endif

    let l:errors = l:counts.error + l:counts.style_error
    let l:warnings = l:counts.total - l:errors

    if l:errors > 0 && l:warnings > 0
        return '◇ ●'
    endif

    if l:errors > 0
        return '●'
    endif

    if l:warnings > 0
        return '◇'
    endif
endfunction

" ---------- Lightline

let g:lightline = {
    \ 'active': {
        \ 'left': [
            \ [ 'mode', 'paste' ],
            \ [ 'readonly', 'filename', 'modified' ]
        \ ],
        \ 'right': [
            \ [ 'lineinfo' ],
            \ [ 'ale' ],
            \ [ 'filetype' ],
        \ ]
    \ },
    \ 'inactive': {
        \ 'left': [
            \ [ 'filename', 'modified' ]
        \ ],
        \ 'right': [
            \ [ 'ale' ]
        \ ]
    \ },
    \ 'component_function' : {
        \ 'ale': 'LinterStatus'
    \ },
    \ 'separator': {
        \ 'left': '',
        \ 'right': ''
    \ },
    \ 'subseparator': {
        \ 'left': '|',
        \ 'right': '|'
    \ }
\ }

" refresh lightline when buffer is saved
augroup Lightline
    au!
    au BufWritePost * call lightline#update()
    au User ALELint call lightline#update()
augroup END

" ---------- fzf

let g:fzf_layout = { 'down': '~20%' }

nnoremap <c-p> :GFiles<CR>
nnoremap <c-o> :Files<CR>
nnoremap <c-b> :Buffers<CR>

" ---------- Region expanding configuration

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" ---------- neosnippets

let g:neosnippet#snippets_directory = '~/.config/nvim/snips'

" ---------- coc

" use <tab> for trigger completion and navigate next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> grn <Plug>(coc-rename)
nmap <silent> gcc <Plug>(coc-codeaction)
vmap <silent> gcv <Plug>(coc-codeaction-selected)
nmap <silent> gfi <Plug>(coc-diagnostic-info)
nmap <silent> gfj <Plug>(coc-diagnostic-next)
nmap <silent> gfk <Plug>(coc-diagnostic-prev)
nmap <silent> gff <Plug>(coc-fix-current)

command! -nargs=0 Tsc :call CocAction('runCommand', 'tsserver.watchBuild')

inoremap <silent><expr> <c-space> coc#refresh()
imap <silent> <C-x><C-o> <Plug>(coc-complete-custom)

" ---------- Prettier

let g:prettier#exec_cmd_async = 1

nnoremap gp :Prettier<CR>

" ---------- zoomwintab

nnoremap gz :ZoomWinTabToggle<CR>

" ---------- gen_tags.vim

let g:loaded_gentags#gtags=1

" ---------- Hardtime

let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h", "j", "k", "l"]
let g:list_of_visual_keys = ["h", "j", "k", "l"]
let g:list_of_insert_keys = []
let g:hardtime_timeout = 500
let g:hardtime_ignore_quickfix = 1

" ---------- debugging syntax highlighting

map gsy :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
