set nocompatible

syntax on

if has("termguicolors")
  set termguicolors
endif

let mapleader = " "   

call plug#begin('~/.vim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }   
Plug 'preservim/nerdtree'                
Plug 'junegunn/fzf', { 'do': './install --bin' } 
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'                
Plug 'jiangmiao/auto-pairs'              
Plug 'vim-airline/vim-airline'           
Plug 'wakatime/vim-wakatime'             
Plug 'sheerun/vim-polyglot'              
Plug 'neoclide/coc.nvim', {'branch': 'release'} 
Plug 'tpope/vim-fugitive'                
Plug 'tpope/vim-commentary'              
Plug 'honza/vim-snippets'                
Plug 'easymotion/vim-easymotion'         
Plug 'dense-analysis/ale'                
Plug 'puremourning/vimspector'           
Plug 'plasticboy/vim-markdown'           
Plug 'tpope/vim-abolish'                 
Plug 'itchyny/lightline.vim'             

call plug#end()

set background=dark                     
colorscheme dracula                      

set number                               
set relativenumber                       
set cursorline                           
set clipboard=unnamedplus                
set tabstop=4                            
set shiftwidth=4                         
set expandtab                            
set autoindent                           
set wrap                                 
set mouse=a                              
set lazyredraw                           
set updatetime=300                       
set timeoutlen=500                       
set incsearch                            
set ignorecase                           
set smartcase                           
set signcolumn=yes                       

let NERDTreeShowHidden=1

" Set NERDTree width
autocmd FileType nerdtree setlocal winwidth=30

" NERDTree key mappings for tabs
let g:NERDTreeQuitOnOpen = 1 " Close NERDTree after opening a file
nnoremap <Leader>t :tabnew<CR>
autocmd FileType nerdtree nmap <silent> <CR> :call NERDTreeTabsOpen()<CR>

function! NERDTreeTabsOpen()
  " Open the selected file in a new tab
  if exists("t:NERDTreeBufName")
    exec 'tabe ' . expand('%:p')
  endif
endfunction

" Quick navigation to tabs with Alt + TabNumber
for i in range(1, 9)
    execute 'nnoremap <Leader>' . i . ' :tabnext ' . i . '<CR>'
endfor

" Closeable tabs shortcut
nnoremap <Leader>q :tabclose<CR>

" Switch between tabs shortcuts
nnoremap <Leader>n :tabnext<CR>
nnoremap <Leader>p :tabprevious<CR>

" Highlighting
highlight Normal ctermbg=none            
highlight! link CocHighlightParameter NonText  
highlight CursorLine cterm=bold ctermbg=darkgray

" Plugin-specific mappings and shortcuts
nnoremap <Leader>f :Files<CR>            

" EasyMotion shortcuts
nmap <Leader><Leader>w <Plug>(easymotion-w)  
nmap <Leader><Leader>f <Plug>(easymotion-f) 
nmap <Leader><Leader>l <Plug>(easymotion-lineforward) 
nmap <Leader><Leader>h <Plug>(easymotion-linebackward) 

nmap <Leader><Leader>; <Plug>(easymotion-s)  
nnoremap s <nop>

nnoremap <Leader>r :%s///g<Left><Left>   

" Git Fugitive shortcuts
nnoremap <Leader>gs :Git<CR>         

" NERDTree key mappings
nnoremap <C-n> :NERDTreeToggle<CR>       

" Save and quit shortcuts
nnoremap <C-s> :w<CR>                    
nnoremap <C-q> :q<CR>                    

" Insert mode shortcut for exiting
inoremap jk <Esc>                        

" Copy and paste shortcuts
vnoremap <C-c> "+y                       
nnoremap <C-v> "+p                       

" Wayland clipboard fallback (requires wl-clipboard installed)
if $WAYLAND_DISPLAY != ''
    " Yank to system clipboard (visual + normal line yank)
    vnoremap <silent> "+y y:call system('wl-copy', @")<CR>:echo "Yanked to Wayland clipboard"<CR>
    nnoremap <silent> "+yy yy:call system('wl-copy', @")<CR>:echo "Yanked line to Wayland clipboard"<CR>

    " Paste from system clipboard
    nnoremap <silent> "+p :let @\" = system('wl-paste --no-newline')<CR>p
    nnoremap <silent> "+P :let @\" = system('wl-paste --no-newline')<CR>P

    " Optional: Make normal y / yy also copy to system clipboard (like unnamedplus behavior)
    " vnoremap y y:call system('wl-copy', @")<CR>
    " nnoremap yy yy:call system('wl-copy', @")<CR>

    " Fix your existing <C-c> / <C-v> to use the working + mappings
    vnoremap <C-c> "+y
    nnoremap <C-v> "+p
endif

" Tab completion in insert mode
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Documentation shortcut for Coc
nnoremap <silent> K :call CocAction('doHover')<CR>

" Navigation and fixes for Coc
nmap <silent> gd <Plug>(coc-definition)   
nmap <silent> gr <Plug>(coc-references)   
nmap <silent> [g <Plug>(coc-diagnostic-prev) 
nmap <silent> ]g <Plug>(coc-diagnostic-next) 
nnoremap <silent> <leader>rn <Plug>(coc-rename) 
nnoremap <silent> <leader>ca <Plug>(coc-codeaction) 

autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd BufWinLeave NERD_tree_1 set laststatus=2
autocmd BufWinEnter * if &filetype == 'nerdtree' | set laststatus=0 | endif
autocmd FileType gitcommit,gitrebase,gitconfig setlocal completeopt=menuone,noinsert,noselect

" Lightline configuration
let g:lightline = {
       \ 'colorscheme': 'dracula',
       \ 'active': {
       \   'left': [ [ 'mode', 'paste' ],
       \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
       \ },
       \ 'component_function': {
       \   'gitbranch': 'fugitive#head',
       \ },
       \ }
