set nocompatible

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set up Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Vundle plugins go here
"""""""""""""""""""""""""""""
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'scrooloose/nerdtree'
Plugin 'Shougo/neocomplete.vim'
Plugin 'jnurmine/zenburn'
Plugin 'bling/vim-airline'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/denite.nvim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'rking/ag.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'honza/vim-snippets'
Plugin 'majutsushi/tagbar'
Plugin 'rust-lang/rust.vim'
Plugin 'raichoo/purescript-vim'
Plugin 'solarnz/thrift.vim'
Plugin 'godlygeek/tabular'
Plugin 'idris-hackers/idris-vim'
Plugin 'maralla/validator.vim'

" python
Plugin 'vim-scripts/indentpython.vim'
Plugin 'nvie/vim-flake8'
"Plugin 'ivanov/vim-ipython'
Plugin 'davidhalter/jedi-vim'

call vundle#end()

let python_highlight_all=1
filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoread
set showcmd
set hlsearch
set incsearch
set showmatch
set ignorecase
set smartcase
set backspace=indent,eol,start
set nostartofline
set ruler
set laststatus=2
set visualbell
set mouse=a
set number
set cursorline
set hidden

set so=7

syntax enable
colorscheme zenburn
set background=dark

if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set guioptions-=r
    set guioptions-=m
    set t_Co=256
    set guitablabel=%M\ %t
    set guifont=Input\ Mono\ Narrow\ Medium\ Condensed\ 10
endif

set encoding=utf8
set ffs=unix,dos,mac

set nobackup
set nowb
set noswapfile

set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent
set smartindent
set wrap

map j gj
map k gk

" Copy/paste
nmap <C-V> "+gP
imap <C-V> <ESC><C-V>a
vmap <C-C> "+y

" Clear search results with 'enter'
nnoremap <CR> :noh<CR><CR>

imap <C-Return> <CR><CR><C-o>k<Tab>

" NERDTree keybindings
set <F2>=<C-v><F2>
set <F3>=<C-v><F3>
map <F2> :NERDTreeToggle<CR>
map <F3> :NERDTreeFind<CR>

let NERDTreeIgnore = ['\.pyc$', '\.retry$']

let g:NERDTreeNodeDelimiter = "\u00a0"

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Start NERDTree by default. Close when NERDTree is last buffer.
autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif



" Autocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2

" Configure jedi-vim to work with neocomplete
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'



let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-s)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"



" Denite
if executable('rg')
    call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
elseif executable('ag')
    call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

nnoremap <Space>p :Denite file/rec<CR>
nnoremap <Space>/ :Denite grep<CR>
nnoremap <Space>s :Denite buffer<CR>
nnoremap <Space>* :DeniteProject grep<CR>

au FileType * setl conceallevel=0

nmap <F4> :TagbarToggle<CR>

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 0
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

"au BufNewFile,BufRead *.py
    "\ set tabstop=4
    "\ set softtabstop=4
    "\ set shiftwidth=4
    "\ set textwidth=79
    "\ set expandtab
    "\ set autoindent
    "\ set fileformat=unix

au BufNewFile,BufRead *.yml
    \ setlocal tabstop=2 |
    \ setlocal softtabstop=2 |
    \ setlocal expandtab |
    \ setlocal autoindent |
    \ setlocal fileformat=unix
