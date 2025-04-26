nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>sv :vsplit<CR><C-w>l
nnoremap <leader>sh :split<CR><C-w>j

nnoremap <leader>sc :close<CR>

nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tN :tabnext<CR>
nnoremap <leader>tp :tabprevious<CR>

for i in range(1, 9)
    execute 'nnoremap <silent> <leader>' . i . ' :' . i . 'tabnext<CR>'
endfor

nnoremap <Esc> :nohlsearch<CR>
nnoremap <C-n> :NERDTreeToggle<CR>

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles?<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fr :Rg<CR>
nnoremap <leader>fh :History<CR>

nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gr :Gread<CR>

nmap <Leader><Leader>w <Plug>(easymotion-w)
nmap <Leader><Leader>b <Plug>(easymotion-b)
nmap <Leader><Leader>f <Plug>(easymotion-f)
nmap <Leader><Leader>l <Plug>(easymotion-lineforward)
nmap <Leader><Leader>j <Plug>(easymotion-j)
nmap <Leader><Leader>k <Plug>(easymotion-k)
nmap <Leader><Leader>s <Plug>(easymotion-s2)

inoremap jk <Esc>
inoremap kj <Esc>

nnoremap <leader><space> :nohlsearch<CR>

nnoremap <leader>w :w<CR>

nnoremap <leader>sr :%s///g<Left><Left>

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap J mzJ`z

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <leader>ca <Plug>(coc-codeaction-cursor)
vmap <leader>ca <Plug>(coc-codeaction-selected)
nmap <leader>cf <Plug>(coc-fix-current)

nmap <leader>crn <Plug>(coc-rename)

nmap <leader>an <Plug>(ale_next_wrap)
nmap <leader>ap <Plug>(ale_previous_wrap)
nmap <leader>ad :ALEDetail<CR>
nmap <leader>af :ALEFix<CR>
