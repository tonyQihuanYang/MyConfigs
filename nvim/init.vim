"""""""" Vim Configs
let mapleader=' ' " map the leader key to space

set number
set relativenumber
set autoindent
set tabstop=2
set shiftwidth=2
set smarttab
set softtabstop=2
set mouse=a
set hidden
set clipboard=unnamedplus " Allow the use the system clipboard

"""""""" Plugins to install by vim-plug => :PlugInstall
call plug#begin()

Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'tomasiser/vim-code-dark' " Color theme for vscode
Plug 'sheerun/vim-polyglot' " syntax highlight
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Install fzf, `brew install ripgrep` so to use :rg to search word from files
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/airblade/vim-gitgutter' " Gitgutter highlight changed lines in flle
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' } " Markdown preview
Plug 'vim-test/vim-test' " Test.vim consists of a core which provides an abstraction over running any kind of tests from the command-line
call plug#end()

"""""""" Coc extensions to install
let g:coc_global_extensions = ['coc-json', 'coc-prettier', 'coc-rust-analyzer', 'coc-tsserver', 'coc-vetur', 'coc-java']


"""""""" Key Bindings
""" <<Lsp stuff>>
" Format current file (Prettier)
nnoremap <leader>lp :Prettier<CR>
" Format selected file (Prettier)
nmap <leader>lf  <Plug>(coc-format-selected)
" Remap keys for gotos
nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>lt <Plug>(coc-type-definition)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>lr <Plug>(coc-references)
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
"
""" <<Debug && Test>>
" use of vim-test
nmap <silent> <leader>dt :TestNearest<CR>
nmap <silent> <leader>dT :TestFile<CR>

""" <<Searching>>
" Search file (fzf)
nnoremap <leader>sp :Files<CR>
" Find file on NerdTree
nnoremap <leader>sf :NERDTreeFind<CR>

"""""""" Plugins configs
""" vim-polyglot
set nocompatible " enable vim-polyglot

""" vim-devicons
set encoding=UTF-8

""" Vim-code-dark setting
colorscheme codedark

""" NERDTree Setting
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <leader>b :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let NERDTreeShowHidden=1 " Show hidden files, ex .env
let NERDTreeQuitOnOpen = 0 " Close the tree after opening a file
let g:NERDTreeGitStatusWithFlags = 1 " Highlighted the editted files
let g:NERDTreeIgnore = ['^node_modules$', '^DS_Store'] " Igonre the node_modules
let g:NERDTreeWinSize = 40

""" coc.vim Setting
" use tab to select the confrim
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"n
" Prettier
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <S-Space> coc#refresh()
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
