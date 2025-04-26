colorscheme dracula

let g:copilot_enabled = 1

let g:lightline = {
    \ 'colorscheme': 'dracula',
    \ 'active': {
    \ 'left': [[ 'mode', 'paste' ],
    \          [ 'gitbranch', 'readonly', 'filename', 'modified' ]],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'fileformat', 'fileencoding', 'filetype' ]]
    \  },
    \ 'component_function': {
    \    'gitbranch': 'fugitive#head'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

let g:airline_powerline_fonts = 0

let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let NERDTreeMinimalUI=1
let NERDTreeIgnore=['\.git$', '\.pyc$', '\.swp$', '\.DS_Store$', '__pycache__']
let NERDTreeSortOrder=['^__\.py$', '\/$']
let NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹", "Staged"    : "✚", "Untracked" : "✭",
    \ "Renamed"   : "➜", "Unmerged"  : "═", "Deleted"   : "✖",
    \ "Dirty"     : "✗", "Clean"     : "✔︎", "Ignored"   : "☒",
    \ "Unknown"   : "?"
    \ }
autocmd FileType nerdtree setlocal nolist
autocmd FileType nerdtree setlocal winwidth=35

let g:webdevicons_enable_nerdtree = 1

if executable('fd')
  let g:fzf_find_command = 'fd --type f --hidden --follow --exclude .git'
  let g:fzf_command_prefix = ''
endif

if executable('rg')
  let g:fzf_grep_command = 'rg --files --hidden --glob "!.git" --color=never'
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)
endif

autocmd CursorHold * silent call CocActionAsync('highlight')

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'python': ['flake8', 'mypy'],
\   'go': ['golint', 'go vet'],
\   'rust': ['cargo', 'clippy'],
\   'vue': ['eslint', 'vls'],
\   'json': ['jsonlint'],
\   'yaml': ['yamllint'],
\   'markdown': ['markdownlint'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint', 'prettier'],
\   'typescript': ['eslint', 'prettier'],
\   'python': ['isort', 'black'],
\   'go': ['gofmt', 'goimports'],
\   'rust': ['rustfmt'],
\   'json': ['prettier'],
\   'yaml': ['prettier'],
\   'markdown': ['prettier'],
\}

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '▲'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
