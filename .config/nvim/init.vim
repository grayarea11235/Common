set number
<<<<<<< HEAD
//colorscheme afterglow 
" colorscheme afterglow 
" colorscheme gotham256 
colorscheme happy_hacking

set tabstop=2
set expandtab
set shiftwidth=2
set autoindent
set smartindent
set cindent

nmap <C-n> :NERDTreeToggle<CR>

let g:deoplete#enable_at_startup = 1

let g:go_version_warning = 0

" let g:ale_c_cc_options = '-std=c11 -Wall `pkg-config --libs --cflags gtk+-3.0` ``pkg-config --libs --cflags glib-2.0`'
" ale_cpp_gcc_options

let g:ale_c_gcc_options = '-std=c11 -Wall -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -lglib-2.0'
let g:ale_c_parse_makefile = 1

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" ALE plugin for linting and completion
Plug 'dense-analysis/ale'

" Coc install
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Dirvish
Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

" nerdTreeTree
Plug 'scrooloose/nerdTree'

Plug 'zchee/deoplete-jedi'

" vim airline
Plug 'bling/vim-airline'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" Initialize plugin system
call plug#end()
