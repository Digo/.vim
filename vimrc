" Who: Di Wang (diwang@cs.cmu.edu)
" What: .vimrc
" -------------------------------------------

" ============================================
"" Table of Contents:	
""		Basic_Config 
""		Key_Mapping
""		Function_Define
"" 		FileType_Config
"" 		Plugin_Config
""		Plug_Config
" --------------------------------------------


" ============================================
""		Basic_Configuration
" --------------------------------------------

":> Be Vim
set nocompatible

":> Indent
set autoindent
"set cindent
set smartindent
set tabstop=4
set shiftwidth=4

":> Status
set ruler		" show the cursor position all the time in statusline
set laststatus=2
"let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
"let g:airline#extensions#tabline#enabled = 1

":> LastLine
set scrolloff=3 "always away from edge
set display+=lastline

":> Auto-complete
set showcmd		" display incomplete commands
set wildmenu	" show possible command when pressing <TAB>
set sps=best,10 " only show 10 best spell suggestions

":> Search
set incsearch wrapscan  "do incremental searching
set ignorecase smartcase
set showmatch
set hlsearch

":> History
set history=500		" keep 500 lines of command line history
" keep record of editing information for cursor restore and more
set viminfo='10,\"100,:20,%,n~/.viminfo 
set backup
set backupdir=~/.vim/.backup

":> Color
set background=dark
set t_Co=256
highlight PMenu ctermbg=Red 
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

":> Highlight insert mode
"au InsertEnter * set cursorline
"au InsertLeave * set nocursorline
"set ttimeoutlen=100

":> Line number
"set rnu "use relative line number in vim 7.4
set number

":> Miscellaneous
syntax on
set synmaxcol=255 ""for slow long xml lines 
"set lazyredraw "" for slow scrolling. Seems faster nowadays
set autowrite "" save the file when switch buffers
set mouse=a
set backspace=indent,eol,start
set runtimepath=./.vimlocal,~/.vim,$VIMRUNTIME
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set encoding=UTF-8

"display for :set list 
"set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,

"gvim
"if has('gui_running')
    "colorscheme desert
"endif

filetype plugin indent on

" ============================================
""		Key_Mapping
" --------------------------------------------

":> VIMRC 
"source $MYVIMRC 
nmap <Leader>s :source $MYVIMRC<ENTER>
"opens $MYVIMRC for editing
nmap <Leader>v :e $MYVIMRC<ENTER	 

":> Copy-and-Paste
map \[ :set paste<CR>
map \] :set nopaste<CR>
map <C-v> \["+gp\]
imap <C-v> <ESC>\["+gp\]
vmap <C-c> "+y
""paste and replace multiple times
xnoremap p pgvy	

":> Save File
map <F4> :w<CR>
imap <F4> <ESC>:w<CR>
""force save current file
cmap w!! w !sudo tee % >/dev/null

" quick exit, also ZZ
map Q :qa<CR>

":> Replace
"For local replace
nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>
"For global replace 
nnoremap gR gD:%s/<C-R>///gc<left><left><left>]

":> Toggles
nmap <F2>   :TlistToggle<CR>
map <F6> :setlocal spell! spelllang=en_us<CR>
nnoremap <silent> <F10> :TagbarToggle<CR>

" indent all 
map \= migg=G'i
" search for visual-mode selected text
vmap / y/<C-R>"<CR>
map <Leader>ig :set list lcs=tab:\¦\ 

" control + vim direction key to navigate windows
noremap <C-J>     <C-W>j
noremap <C-K>     <C-W>k
noremap <C-H>     <C-W>h
noremap <C-L>     <C-W>l

"" remove search highlight
nnoremap <Leader><space> :noh<cr>

" ============================================
""		Function_Define
" --------------------------------------------

""""Making Parenthesis And Brackets Handling Easier 
inoremap ( ()<Esc>:call BC_AddChar(")")<CR>i
inoremap {<CR> {<CR>}<Esc>:call BC_AddChar("}")<CR><Esc>kA<CR>
inoremap {}  {}<Esc>:call BC_AddChar("}")<CR>i
inoremap [ []<Esc>:call BC_AddChar("]")<CR>i
inoremap " ""<Esc>:call BC_AddChar("\"")<CR>i
" jump out of parenthesis
inoremap <C-k> <Esc>:call search(BC_GetChar(), "W")<CR>a

function! BC_AddChar(schar)
 if exists("b:robstack")
 let b:robstack = b:robstack . a:schar
 else
 let b:robstack = a:schar
 endif
endfunction

function! BC_GetChar()
 let l:char = b:robstack[strlen(b:robstack)-1]
 let b:robstack = strpart(b:robstack, 0, strlen(b:robstack)-1)
 return l:char
endfunction

"Add brackets for selected texts
vnoremap +( <Esc>`>a)<Esc>`<i(<Esc>
vnoremap +[ <Esc>`>a]<Esc>`<i[<Esc>
vnoremap +{ <Esc>`>a}<Esc>`<i{<Esc>
vnoremap +" <Esc>`>a"<Esc>`<i"<Esc>

"Restore cursor to file position in previous editing session
autocmd BufReadPost * 
    \if line("'\"") > 0 && line("'\"") <= line("$") 
        \|exe "normal g`\"" 
    \|endif

"tempory setting 
au BufRead,BufNewFile *.c,*.cpp,*.py 2match Underlined /.\%81v/

" ============================================
""		FileType_Config
" --------------------------------------------

":> JAVA
let java_highlight_functions="style"
let java_allow_cpp_keywords=1
let java_comment_strings=1
let java_highlight_java_lang_ids=1
"eclim:
let g:EclimJavaSearchSingleResult="edit"
"autocmd FileType java nmap <F3> :JavaSearchContext<CR>
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd BufRead *.java set makeprg=ant\ -find\ 'build.xml'
autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#]]

":> Python
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4
"au FileType python set omnifunc=pythoncomplete#Complete
au FileType python map <buffer> <S-e> :w<CR>:!/usr/bin/env python3 % <CR>
let g:python_highlight_all = 1
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave  * if pumvisible() == 0|pclose|endif
autocmd BufWritePre  *.py :%s/\s\+$//e
au FileType ipynb set foldlevelstart=1

":> JFlex
augroup filetype
	  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

":> Latex
autocmd BufRead *.tex set iskeyword+=:
let tlist_tex_settings   = 'latex;s:sections;g:graphics'
"autocmd Filetype tex :Tlist
autocmd Filetype tex vnoremap +$ <Esc>`>a$<Esc>`<i$<Esc>
autocmd Filetype tex inoremap $ $$<Esc>:call BC_AddChar("$")<CR>i
autocmd FileType tex :NoMatchParen
au FileType tex setlocal nocursorline " cursorline is slow on tex
au FileType tex set dictionary+=/usr/share/dict/words


"vimtex pdf viewer
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

" This adds a callback hook that updates Skim after compilation
let g:vimtex_latexmk_callback_hooks = ['UpdateSkim']
function! UpdateSkim(status)
  if !a:status | return | endif

  let l:out = b:vimtex.out()
  let l:tex = expand('%:p')
  let l:cmd = [g:vimtex_view_general_viewer, '-r']
  if !empty(system('pgrep Skim'))
	call extend(l:cmd, ['-g'])
  endif
  if has('nvim')
	call jobstart(l:cmd + [line('.'), l:out, l:tex])
  elseif has('job')
	call job_start(l:cmd + [line('.'), l:out, l:tex])
  else
	call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
  endif
endfunction


":> Markdown
au BufNewFile,BufRead *.md set ft=md
let g:vim_markdown_folding_disabled=1

":> YAML
au BufNewFile,BufRead *.yaml,*.yml    setf yaml

":> wsdd
au BufNewFile,BufRead *.wsdd    setf xml

":> cuda
au BufNewFile,BufRead *.cu set filetype=cuda
au BufNewFile,BufRead *.cuh set filetype=cuda

":> XML formatter
command XmlLint :exec "silent 1,$!xmllint --format --recover - 2>/dev/null"

":> json formatter
command Mjson :exec "silent 1,$!python -mjson.tool 2>/dev/null"


" ============================================
""		Plug_Config
" --------------------------------------------

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"fancy start screen
Plug 'mhinz/vim-startify'

Plug 'fholgado/minibufexpl.vim'

Plug 'scrooloose/nerdcommenter'

Plug 'andymass/vim-matchup'
Plug 'vim-scripts/LargeFile'

Plug 'junegunn/vim-easy-align'

Plug 'majutsushi/tagbar', {'on': ['TagbarToggle', 'Tagbar']}
Plug 'vim-scripts/taglist.vim', {'on': ['TlistToggle', 'Tlist']}

Plug 'lervag/vimtex'
Plug 'szymonmaszke/vimpyter'
Plug 'antoinemadec/python-syntax'

Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'

"adds a diff option for swap file 
Plug 'chrisbra/Recover.vim'

Plug 'airblade/vim-gitgutter'

"auto complete
Plug 'maralla/completor.vim'

Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTree']}
"always load the vim-devicons as the very last one
Plug 'ryanoasis/vim-devicons'

call plug#end()

" ============================================
""		Plugin_Config
" --------------------------------------------

" nerdtree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" taglist.vim
let g:Tlist_GainFocus_On_ToggleOpen = 0
let g:Tlist_Exit_OnlyWindow         = 1
let g:Tlist_Show_One_File           = 1
let g:Tlist_Enable_Fold_Column      = 0
let g:Tlist_Auto_Update             = 1
let g:tlist_ant_settings            = 'ant;p:Project;t:Target'
let tlist_make_settings             = 'make;m:makros;t:targets'

" tagbar
let g:tagbar_sort = 0

":> Bash-Support
let g:BASH_AuthorName = 'Di Wang'
let g:BASH_Email      = 'diwang@cs.cmu.edu'

":> gist
let g:gist_post_private = 1

":> EasyAlign 
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


""> completor
set complete-=i
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
let g:completor_complete_options = 'menuone,noselect'
""pip install jedi
let g:completor_python_binary = '~/opt/anaconda3/bin/python'

""> colorscheme
colorscheme gruvbox
