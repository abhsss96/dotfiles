
" Enable Vim-Plug plugin manager
call plug#begin()

" Fuzzy Finder (FZF)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Dracula theme for Vim
Plug 'dracula/vim', { 'as': 'dracula' }

" FZF integration for Vim
Plug 'junegunn/fzf.vim'

" Ruby support for Vim
Plug 'vim-ruby/vim-ruby'

" Vim Airline for a lightweight statusline
Plug 'vim-airline/vim-airline'

" Themes for Vim Airline
Plug 'vim-airline/vim-airline-themes'

" Highlight last yanked text
Plug 'machakann/vim-highlightedyank'

" Git integration for Vim
Plug 'tpope/vim-fugitive'

" Rails support for Vim
Plug 'tpope/vim-rails'

" RSpec support for Vim
Plug 'thoughtbot/vim-rspec'

" Open URLs in a browser
Plug 'tyru/open-browser.vim'

" Surrounding text manipulation
Plug 'tpope/vim-surround'

" NERDTree file explorer
Plug 'preservim/nerdtree'

" NERDTree Git plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" Devicons for NERDTree
Plug 'ryanoasis/vim-devicons'

" CSS Color Preview
Plug 'ap/vim-css-color'

" Commenting shortcuts
Plug 'tpope/vim-commentary'

" Split and join blocks of code
Plug 'AndrewRadev/splitjoin.vim'

" Vim Fixkey for function key mappings
Plug 'drmikehenry/vim-fixkey'

" Emmet for fast HTML & CSS
Plug 'mattn/emmet-vim'

" GitGutter shows git diff in the gutter
Plug 'airblade/vim-gitgutter'

" JavaScript support
Plug 'pangloss/vim-javascript'

" TypeScript support
Plug 'leafgarland/typescript-vim'

" JSX and TypeScript support
Plug 'peitalin/vim-jsx-typescript'

" Styled Components support
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" GraphQL support
Plug 'jparise/vim-graphql'

" Elixir support
Plug 'elixir-editors/vim-elixir'

" Database support
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

" Optional LSP and related plugins (commented out)
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
" Plug 'nvim-tree/nvim-web-devicons'
" Plug 'pwntester/octo.nvim'

" End of Vim-Plug section
call plug#end()


" Other customsation starts here
set tags=./tags;

set encoding=UTF-8
" mostly does the right thing
set smartindent
" turns off tab character
set expandtab
" left size numbering, some people prefer relativenumber, but with easy motion this is irrelevent
set number
" 2 spaces for tabs and shifts
set tabstop=2 shiftwidth=2
" makes backspace work like most other apps
set backspace=2
" scroll offset, keeps 2 lines above the cursor
set scrolloff=2

" Automatically read files modified outside of Vim
set autoread

" Automatically save files before many actions
set autowrite

" Highlight search results, while the pattern is being typed
set hlsearch incsearch

" Searches are case insensitive by default. If the search pattern includes a
" capital letter, it becomes case sensitive
set ignorecase smartcase

" Always show the status line
set laststatus=2

" Tabs and trailing whitespace are visible
set list listchars=tab:»\ ,trail:·,nbsp:·
" Don't make a file backup when overwriting a file
set nobackup nowritebackup

" Don't keep a swap file. Previous file versions can be recovered from Git. If
" the file isn't tracked by Git, it's either not important or I will be sad.
set noswapfile

" Give the number gutter plenty of room so the width is consistent when crossing
" numbers with more digits, e.g. 99->100, 999->1000
set numberwidth=5

" `relativenumber` followed by `number` will show the absolute number at the
" cursor location's line, and relative numbers for all other lines
" set relativenumber number

" Show line and column number of cursor position
set ruler

"GIT GUTTER 

highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0
nmap ) <Plug>(GitGutterNextHunk)
nmap ( <Plug>(GitGutterPrevHunk)
" Start scrolling when the cursor is 2 lines from the bottom/top of screen.
" Think of it like context in Grep or Ag.
" set scrolloff=2


" When spell checking, support programming terms
set spelllang=en,programming

set background=light

set pastetoggle=<f5>
" Make it obvious where 80 characters is
set textwidth=80 colorcolumn=+1

" Quicker window movement

" nnoremap <C-J> <C-W>j
" nnoremap <C-K> <C-W>k
" nnoremap <C-H> <C-W>h
" nnoremap <C-L> <C-W>l

let g:user_emmet_leader_key=','

let g:airline#extensions#tabline#enabled = 1

" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }
let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.8, 'relative': v:true, 'yoffset': 1.0 } }

let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"



" Basic vim features 
set number
" syntax on
filetype plugin indent on
filetype on
filetype indent on

autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType eruby setlocal expandtab shiftwidth=2 tabstop=2
" autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))

syntax enable

set nocompatible
colorscheme dracula

nnoremap <silent><leader>1 :source ~/.vimrc \| :PlugInstall<CR>
nnoremap <C-p> :GFiles<Cr>
nnoremap <C-P> :Files<Cr>
nnoremap <C-g> :Ag<Cr>
nnoremap <C-f> :Ag!<Cr>
"nnoremap <C-G> :Rg<Cr>
"nnoremap <C-F> :Rg!<Cr>
nnoremap <LEADER>k :Ag <C-R><C-W><CR>
nnoremap <silent><leader>l :Buffers<CR>
noremap <silent> <C-n> :e.<CR>

nmap <silent> <leader>m :History<CR>

map <Leader>t :vert term ++close<cr>
tmap <Leader>t <c-w>:vert term ++close<cr>

set foldmethod=indent
set foldopen+=jump



"  This moves up and down visual lines, not real lines.
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

"  This allows you to capitalize J and K such that they move 5 lines in either
"  direction.
vnoremap // y/<C-R>"<CR>"
nmap ; :

nmap J 5j
nmap K 5k
xmap J 5j

" nmap <silent> <A-Up> :wincmd k<CR>
" nmap <silent> <A-Down> :wincmd j<CR>
" nmap <silent> <A-Left> :wincmd h<CR>
" nmap <silent> <A-Right> :wincmd l<CR>

"let g:tmux_navigator_no_mappings = 1
" let g:tmux_navigator_save_on_switch = 1
" Disable tmux navigator when zooming the Vim pane
"let g:tmux_navigator_disable_when_zoomed = 1
" If the tmux window is zoomed, keep it zoomed when moving from Vim to another pane
" let g:tmux_navigator_preserve_zoom = 1

"noremap <silent> <A-Left> :<C-U>TmuxNavigateLeft<cr>
"noremap <silent> <A-Down> :<C-U>TmuxNavigateDown<cr>
"noremap <silent> <A-Up> :<C-U>TmuxNavigateUp<cr>
" noremap <silent> <A-Right> :<C-U>TmuxNavigateRight<cr>
"noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>
" next/prev quicklist item

map <c-b> :cprevious<CR>
nmap <c-n> :cnext<CR>

hi CursorLine   cterm=NONE ctermbg=235
hi CursorColumn cterm=NONE ctermbg=235
nnoremap x :set cursorline! cursorcolumn!

let mapleader = "\<Space>"


" toggle paste in cmd only
nnoremap <Leader>p :set invpaste<CR>
" quickfix list for breakpoints
nmap <Leader>i :Ag binding.pry<CR>

" …also, Insert Mode as bpry<space>
iabbr bpry require'pry';binding.pry
" And admit that the typos happen:
iabbr bpry require'pry';binding.pry

" Add the pry debug line with \bp (or <Space>bp, if you did: map <Space> <Leader> )
map <Leader>bp require'pry';binding.pry<esc>:w<cr>
" Alias for one-handed operation:
map <Leader><Leader>p <Leader>bp

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

"Nerd tree configurations
let g:NERDTreeShowHidden=1
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeQuitOnOpen=0

nnoremap <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree and put the cursor back in the other window.
" autocmd VimEnter * NERDTree | wincmd p
"

" Highlight the current line, only for the buffer with focus
augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" Automatically rebalance windows on Vim resize
autocmd VimResized * :wincmd =

" Set up undo file in home directory
if isdirectory($HOME . '/.vim/undo') == 0
  :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
endif
set undofile undodir=~/.vim/undo/

if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <A-Left> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <A-Down> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <A-Up> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <A-Right> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <A-Left> <C-w>h 
  map <A-Down> <C-w>j
  map <A-Up> <C-w>k
  map <A-Right> <C-w>l
endif

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p


let g:coc_global_extensions = ['coc-solargraph']
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" NERDTree 

let g:NERDTreeGitStatusWithFlags = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:NERDTreeGitStatusNodeColorization = 1
let g:NERDTreeColorMapCustom = {
    \ "Staged"    : "#0ee375",  
    \ "Modified"  : "#d9bf91",  
    \ "Renamed"   : "#51C9FC",  
    \ "Untracked" : "#FCE77C",  
    \ "Unmerged"  : "#FC51E6",  
    \ "Dirty"     : "#FFBD61",  
    \ "Clean"     : "#87939A",   
    \ "Ignored"   : "#808080"   
    \ }                         


let g:NERDTreeIgnore = ['^node_modules$']


nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

nmap <leader>do <Plug>(coc-codeaction)

nmap <leader>rn <Plug>(coc-rename)

" shift+arrow selection
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

vmap <C-c> y<Esc>i
vmap <C-x> d<Esc>i
map <C-v> pi
imap <C-v> <Esc>pi

let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
