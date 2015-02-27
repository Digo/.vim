" ===========================================
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
""		Cscope_Config
""		Vundle_Config
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
set tabstop=2
set shiftwidth=2

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
"" colorscheme from He Kun
"colorscheme hk
"colorscheme gruvbox
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

":> Highlight insert mode
"au InsertEnter * set cursorline
"au InsertLeave * set nocursorline
"set ttimeoutlen=100

":> Line number
set rnu "use relative line number in vim 7.4

":> Miscellaneous
syntax on
set synmaxcol=255 ""for slow long xml lines 
set autowrite
set mouse=a
set backspace=indent,eol,start
set runtimepath=./.vimlocal,~/.vim,$VIMRUNTIME
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

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
nmap <Leader>s :source $MYVIMRC
"opens $MYVIMRC for editing
nmap <Leader>v :e $MYVIMRC	 

":> Copy-and-Paste
map \[ :set paste<CR>
map \] :set nopaste<CR>
map <C-v> \["+gp\]
imap <C-v> <ESC>\["+gp\]
vmap <C-c> "+y
""paste and replace multiple times
xnoremap p pgvy	

":> Save File
map <F3> :w<CR>
imap <F3> <ESC>:w<CR>
""force save current file
cmap w!! w !sudo tee % >/dev/null

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
autocmd FileType python set tabstop=2|set shiftwidth=2|set expandtab
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python map <buffer> <S-e> :w<CR>:!/uPylintsr/bin/env python % <CR>
let python_highlight_all = 1
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif 
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
autocmd BufWritePre *.py :%s/\s\+$//e
let g:pymode_folding = 0
let g:pymode_lint_cwindow = 0
let g:pymode_lint_write = 0
let g:pymode_rope = 1
let g:pymode_lint_on_write = 0 

":> JFlex
augroup filetype
	  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

":> Latex
autocmd BufRead *.tex set iskeyword+=:
"autocmd BufRead *.tex :TTarget pdf
"autocmd BufRead *.tex let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode -output-directory ./tmp $*'
"autocmd Filetype tex setlocal nofoldenable
let tlist_tex_settings   = 'latex;s:sections;g:graphics'
"autocmd Filetype tex :Tlist
autocmd Filetype tex vnoremap +$ <Esc>`>a$<Esc>`<i$<Esc>
autocmd Filetype tex inoremap $ $$<Esc>:call BC_AddChar("$")<CR>i
autocmd Filetype tex set tw=79
autocmd FileType tex :NoMatchParen
" cursorline is slow on tex
au FileType tex setlocal nocursorline


":> Markdown
au BufNewFile,BufRead *.md set ft=md

":> YAML
au BufNewFile,BufRead *.yaml,*.yml    setf yaml

":> wsdd
au BufNewFile,BufRead *.wsdd    setf xml

":> XML formatter
command XmlLint :exec "silent 1,$!xmllint --format --recover - 2>/dev/null"

":> json formatter
command Mjson :exec "silent 1,$!python -mjson.tool 2>/dev/null"

":> Git Gutter
highlight clear SignColumn

" ============================================
""		Plugin_Config
" --------------------------------------------

" minibufexpl (only for old plugin)
"let g:miniBufExplMapWindowNavVim = 1 

" taglist.vim
let g:Tlist_GainFocus_On_ToggleOpen=0
let g:Tlist_Exit_OnlyWindow=1
let g:Tlist_Show_One_File=1
let g:Tlist_Enable_Fold_Column=0
let g:Tlist_Auto_Update=1
let g:tlist_ant_settings = 'ant;p:Project;t:Target'
let tlist_make_settings  = 'make;m:makros;t:targets'

" supertab
let g:SuperTabDefaultCompletionType="context"
let g:SuperTabLongestHighlight=1
let g:SuperTabRetainCompletionDuration="completion"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']

set dictionary+=/usr/share/dict/words

":> EasyMotion
let g:EasyMotion_leader_key = '<Leader>' 

":> Bash-Support
let g:BASH_AuthorName   = 'Di Wang'
let g:BASH_Email        = 'diwang@cs.cmu.edu'
"let g:BASH_Company      = 'CMU'

":> syntastic
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_mode_map = { 'mode': 'passive',
						   \ 'active_filetypes': [],
						   \ 'passive_filetypes': [] }

":> Rainbow Parentheses Improved
au FileType c,cpp,objc,objcpp,python call rainbow#load()

":> LanguageTool
let g:languagetool_jar='~/usr/LanguageTool-2.4/languagetool-commandline.jar'

" ============================================
""		Cscope_Config
" --------------------------------------------
if has("cscope")

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0


	let parent=1
	let local_cscope = "cscope.out"
	while !filereadable(local_cscope) && parent<=8
		let parent = parent+1
		let local_cscope = "../". local_cscope
	endwhile
	
    " add any cscope database in current directory or its parent
    if filereadable(local_cscope)
		echomsg "sourcing " . local_cscope
        cs add local_cscope 
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif

	unlet parent local_cscope

	" show msg when any other cscope db added
	set cscopeverbose  

    """"""""""""" cscope/vim key mappings
    " The following maps all invoke one of the following cscope search types:
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    
	nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

	""show todo list
	command TODO cs find t TODO 
endif




" ============================================
""		Vundle_Config
" --------------------------------------------

" NOTE: comments after Bundle command are not allowed.
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle
Bundle 'gmarik/vundle' 

Bundle 'tpope/vim-fugitive'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'fholgado/minibufexpl.vim'

Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"
Bundle "honza/vim-snippets"

Bundle 'scrooloose/nerdcommenter.git'
Bundle 'kien/ctrlp.vim'

Bundle 'ervandew/supertab.git'
Bundle 'godlygeek/tabular.git'
Bundle 'vim-scripts/matchit.zip.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'majutsushi/tagbar.git'
Bundle 'vim-scripts/LargeFile.git'

"Bundle 'myusuf3/numbers.vim.git' "use rnu
"Bundle 'Lokaltog/vim-powerline.git'
Bundle 'scrooloose/syntastic'

"Python
"Bundle 'fs111/pydoc.vim.git'
"Bundle 'mitechie/pyflakes-pathogen.git'
"Bundle 'vim-scripts/pep8.git'
"Bundle 'sontek/rope-vim.git'
Bundle 'klen/python-mode.git'
Bundle 'ivanov/vim-ipython'
Bundle 'davidhalter/jedi-vim'

Bundle 'hughbien/md-vim'
Bundle 'avakhov/vim-yaml'
Bundle 'sukima/xmledit.git'

Bundle 'taglist.vim'
"Bundle 'vim-scripts/bash-support.vim'
Bundle 'airblade/vim-gitgutter.git'

"Bundle 'Yggdroot/indentLine.git'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
"Bundle 'coot/atp_vim'

Bundle 'oblitum/rainbow'
"Bundle 'morhetz/gruvbox'
Bundle 'bling/vim-airline'
Bundle 'nanotech/jellybeans.vim'

Bundle 'derekwyatt/vim-scala'

Bundle 'dpelle/vim-LanguageTool'

Bundle 'chrisbra/Recover.vim'
Bundle 'kovisoft/slimv'
Bundle 'elzr/vim-json'

Bundle 'Valloric/YouCompleteMe'

filetype plugin indent on     " required!


"" reset from indentLine and fugitive plugins

colorscheme jellybeans
set concealcursor=nc
