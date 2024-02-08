" Nixos Neovim Configurations
" - Definitions
set relativenumber
set hidden
set nowrap
set encoding=utf-8
set pumheight=10
set fileencoding=utf-8
set ruler
set cmdheight=2
set iskeyword+=-
set mouse=a
set splitbelow
set splitright
set conceallevel=0
set tabstop=4
set softtabstop=4
set shiftwidth=4
"set expandtab
set smartindent
set autoindent
set number
set background=dark
set showtabline=1
set spellsuggest=best,9
set spelloptions=camel
set nobackup
set nowritebackup
set updatetime=200
set timeoutlen=500
set formatoptions -=cro
set clipboard=unnamedplus
set foldmethod=syntax
set nofoldenable
set autoread
set laststatus=2
set undofile
set undodir=~/.config/nvim/undo
set guifont=Cascadia\ Code:h11
set sessionoptions-=globals
set sessionoptions-=localoptions
set sessionoptions-=options
set sessionoptions-=folds
set sessionoptions-=winpos
set sessionoptions-=winsize
set sessionoptions-=buffers
set sessionoptions-=resize
" - Directives
filetype plugin indent on
syntax enable
colorscheme gruvbox
set background=dark
" - Plugin Settings
let mapleader = ";"
let g:startify_session_dir = "~/.config/nvim/sessions/"
let g:startify_change_to_vcs_root  = 1
let g:startify_change_to_dir = 0
let g:neovide_confirm_quit=1
let g:startify_session_persistence = 1
let g:startify_custom_header= 'startify#center(startify#fortune#boxed())'

autocmd BufWritePre * %s/\s\+$//e
autocmd FocusGained,BufEnter * :checktime
autocmd FocusGained,BufWritePost * :syntax sync fromstart
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
autocmd BufNewFile,BufRead *.tera :set filetype=html
autocmd VimEnter * Vista | wincmd p

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

command! -nargs=0 ShowDocs :call s:show_documentation()
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 Todo :call s:todo()
command! -nargs=* SpTerm sp | terminal <args>
command! -nargs=* VspTerm vsp | terminal <args>

map Q <NOP>
map gQ <NOP>


map <leader>vv :Vista!! <CR>
map <leader>vf :Vista focus <CR>
nmap <leader>ac <Plug>(coc-codeaction-cursor)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf  <Plug>(coc-fix-current)

tnoremap <Esc> <C-\><C-n>
nnoremap o o<Esc>
nnoremap O O<Esc>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <C-S-J> <C-W><C-S-J>
nnoremap <C-S-K> <C-W><C-S-K>
nnoremap <C-S-L> <C-W><C-S-L>
nnoremap <C-S-H> <C-W><C-S-H>

nnoremap <S-Tab> :tabnext<cr>
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gt <Plug>(coc-type-definition)
nnoremap <silent> sd :call <SID>show_documentation()<CR>
nnoremap <silent> ff :Format <CR>
nnoremap <silent> st :Todo<CR>

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap == <C-W>=

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:todo() abort
  let entries = []
  for cmd in ['git grep -niIw -e TODO -e FIXME -e BUG -- "./*"  2> /dev/null',
            \ 'grep -rniIw -e TODO -e FIXME -e BUG . 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction

let g:lightline = {'colorscheme': 'gruvbox'}
autocmd CursorHold * silent call CocActionAsync('highlight')
lua << EOF
require("rust-tools").setup({})
require("nvim-surround").setup({})
require("flutter-tools").setup({})
EOF
