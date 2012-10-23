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
set cindent
set tabstop=4
set shiftwidth=4

":> Status
set ruler		" show the cursor position all the time in statusline
set laststatus=2
let g:Powerline_symbols = 'fancy'

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

":> Highlight insert mode
au InsertEnter * set cursorline
au InsertLeave * set nocursorline
set ttimeoutlen=100

":> Miscellaneous
syntax on
set autowrite
set mouse=a
set backspace=indent,eol,start
set runtimepath=./.vimlocal,~/.vim,$VIMRUNTIME
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

"display for :set list 
set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,



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
map <C-v> "+gP
imap <C-v> <C-o>"+gP 
vmap <C-c> "+y
map \[ :set paste<CR>
map \] :set nopaste<CR>
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


" ============================================
""		Function_Define
" --------------------------------------------

""""Making Parenthesis And Brackets Handling Easier 
inoremap ( ()<Esc>:call BC_AddChar(")")<CR>i
inoremap {<CR> {<CR>}<Esc>:call BC_AddChar("}")<CR><Esc>kA<CR>
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
vnoremap +$ <Esc>`>a$<Esc>`<i$<Esc>
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
autocmd FileType java nmap <F3> :JavaSearchContext<CR>
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd BufRead *.java set makeprg=ant\ -find\ 'build.xml'
autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#]]

":> Python
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
let python_highlight_all = 1
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif 
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

":> JFlex
augroup filetype
	  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

":> Latex
autocmd BufRead *.tex set iskeyword+=:
autocmd BufRead *.tex :TTarget pdf
autocmd BufRead *.tex let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode -output-directory ./tmp $*'
autocmd Filetype tex setlocal nofoldenable
autocmd Filetype tex :Tlist
let tlist_tex_settings   = 'latex;s:sections;g:graphics'

":> Markdown
au BufNewFile,BufRead *.md set ft=md

":> YAML
au BufNewFile,BufRead *.yaml,*.yml    setf yaml

" ============================================
""		Plugin_Config
" --------------------------------------------

" minibufexpl
let g:miniBufExplMapWindowNavVim = 1 

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

set dictionary+=/usr/share/dict/words

":> EasyMotion
let g:EasyMotion_leader_key = '<Leader>' 


" ============================================
""		Cscope_Config
" --------------------------------------------
if has("cscope")

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out  
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

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
Bundle 'gmarik/vundle' 
" let Vundle manage Vundle

Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'minibufexpl.vim'
Bundle 'git://git.wincent.com/command-t.git'

Bundle 'msanders/snipmate.vim.git'
Bundle 'scrooloose/nerdcommenter.git'

"Bundle 'vim-scripts/LaTeX-Suite-aka-Vim-LaTeX.git'
Bundle 'ervandew/supertab.git'
Bundle 'sukima/xmledit.git'
Bundle 'godlygeek/tabular.git'
Bundle 'vim-scripts/matchit.zip.git'
Bundle 'vim-scripts/minibufexpl.vim.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'majutsushi/tagbar.git'
Bundle 'vim-scripts/LargeFile.git'

Bundle 'myusuf3/numbers.vim.git'
Bundle 'Lokaltog/vim-powerline.git'
Bundle 'scrooloose/syntastic'

Bundle 'fs111/pydoc.vim.git'
Bundle 'mitechie/pyflakes-pathogen.git'
Bundle 'vim-scripts/pep8.git'
Bundle 'sontek/rope-vim.git'

Bundle 'hughbien/md-vim'
Bundle 'avakhov/vim-yaml'
filetype plugin indent on     " required!
