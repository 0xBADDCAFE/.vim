" TODO:
" - on mac settings(i.e. transparency).
" - folder existing check.
" - Make togglable setting to scroll arrow key.
" FIXME:
" BUGS:
" Note:
" Experimental:

" ready for settings{{{

" if CUI on windows, not set encoding.
if has('win32') && has('gui_running')
  " needs to set before :syntax on and filetype, plugin on.
  set encoding=utf-8
endif
" enable below sentence if I will need.
" source $VIMRUNTIME\delmenu.vim
" set langmenu=ja_JP.utf-8
" source $VIMRUNTIME\menu.vim
scriptencoding utf-8

syntax on
filetype plugin indent on
" not use menu and do fast.
let g:did_install_default_menus = 1

" for load vimrc
augroup vimrc_loading
  autocmd!
augroup END
" }}}


" set options {{{
" When I check option detail, use K key (on windows).
" common settings=======================================================
set autoindent
set background=dark
set backspace=indent,eol,start
set backup
set browsedir=last              " It effect :browse [cmd]
set clipboard+=unnamed
set diffopt=filler,iwhite,horizontal
set expandtab
set formatoptions+=mM
set helplang=ja
set hidden
set history=50
set hlsearch
set ignorecase
set incsearch
set linespace=0
set list
if &encoding == 'utf-8'
  set listchars=tab:‣\ ,trail:_
else
  set listchars=tab:/.,trail:_
endif
set mouse=a
set nomousefocus
set mousehide
set number
set ruler
set showcmd
set showmatch
set smartcase
set smartindent
set smarttab
" Hack #198
set splitbelow
set splitright
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tags& tags+=./tags;tags;
set title
set noundofile
set whichwrap=b,s,h,l,<,>,[,],~
set virtualedit=block
set wildmenu
set wildmode=longest:list,full
set wrapscan
if has('kaoriya')
  set fileencodings=guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213,euc-jp
  set formatexpr=autofmt#japanese#formatexpr()
else
  set fileencodings=utf-8,sjis,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,euc-jisx0213,euc-jp
endif
if exists('+breakindent')
  set wrap
  set breakindent
else
  set nowrap
endif
" about appearance(or having-number options)============================
set laststatus=2
set showtabline=2
set softtabstop=2
set cmdheight=1
set foldcolumn=1
set scrolloff=5
set sidescroll=1
set sidescrolloff=10
set tabstop=4
set shiftwidth=2
set nrformats=hex,alpha
set textwidth=0
if has('gui_running')
  set lines=48
  set columns=84
  " don't want gui parts
  set guioptions=
endif
" with path=============================================================
set runtimepath+=~/.vim/runtime/
set backupdir=~/.vim/bkfiles
set viminfo& viminfo+=n~/.viminfo
if executable('jvgrep')
  set grepprg=jvgrep\ -irR\ --color=never
endif
if has('unix')
  set backupskip=/tmp/*,/private/tmp/*
endif

cd $HOME
" }}}


" Env-dependent settings {{{
" IME Settings{{{
if has('multi_byte_ime') || has('xim')
  set iminsert=0
  set imsearch=0
  augroup CursorIMColor
    au!
    au ColorScheme * highlight def link CursorIM Search
  augroup END
  if has('xim') && has('GUI_GTK')
    " set starting XIM input keybind:
    " set imactivatekey=s-space
  endif
  " start insert mode with no IME input.
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif
" }}}
"
" these are almost taken kaoriya settings.{{{
if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

" font setting(based on kaoriya)
if has('win32')
  set guifont=Consolas:h10:cSHIFTJIS
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya') && has('gui_running')
    set ambiwidth=auto
  endif
elseif has('gui_macvim')
  set guifont=Monaco:h12
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif
" }}}
" }}}


" maps and abbreviations{{{
" bind maps
noremap Q gq
" kill <F1> to open help.
noremap <F1> <nop>
noremap! <F1> <nop>
noremap j gj
noremap k gk
noremap gj j
noremap gk k
nnoremap <Up>    3<C-y>
nnoremap <Down>  3<C-e>
nnoremap <Left>  3zh
nnoremap <Right> 3zl
nnoremap Y y$
inoremap <C-U> <C-G>u<C-U>
" Experimental: Wrap fold with <CR>.
nnoremap <silent> <CR> :<C-u>silent! normal! za<CR><CR>

" command maps
nnoremap <silent> ,ee :<C-u>e ~/.vim/.vimrc<CR>
nnoremap <silent> ,es :<C-u>sp ~/.vim/.vimrc<CR>
nnoremap <silent> ,ev :<C-u>vs ~/.vim/.vimrc<CR>
nnoremap <silent> ,et :<C-u>tabe ~/.vim/.vimrc<CR>
nnoremap <silent> ,r :<C-u>source $MYVIMRC<CR>
nnoremap <silent> <F3> :let &ts=(&ts*2 > 16 ? 2 : &ts*2)<cr>:echo "tabstop: " . &ts<cr>
nnoremap B :ls<CR>:b
nnoremap : q:i
" It doesn't work incsearch.
"   nnoremap / q/i

" abbreviations
" When I use :w! command, it maybe explicitly.
" It also define in autocmd section.
" cnoreabbrev w up
" }}}


" autocmds{{{
augroup vimrc_loading
  autocmd CmdWinEnter * nnoremap <buffer><silent> q :<C-u>quit<CR>
  autocmd CmdWinEnter * nnoremap <buffer><silent> <ESC> :<C-u>quit<CR>
  autocmd CmdWinEnter * inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
  autocmd CmdWinEnter * inoremap <buffer><silent> <C-r><C-w> <C-c><C-r><C-w><C-f>i
  " autocmd CmdWinEnter * inoreabbrev <buffer> w up
  autocmd CmdWinEnter * setlocal backspace-=eol
  autocmd CmdWinEnter * setlocal completeopt+=longest
  autocmd CmdwinLeave * setlocal completeopt-=longest
  autocmd CmdWinLeave * setlocal backspace+=eol
augroup END

augroup vimrc_loading
  autocmd FileType qf nnoremap <buffer> p <CR>zz<C-W>p
  autocmd FileType qf nnoremap <buffer> <S-CR> <CR>
  autocmd FileType qf nnoremap <buffer> j j
  autocmd FileType qf nnoremap <buffer> k k
augroup END

" Experimental: smart lcd
augroup vimrc_loading
  autocmd BufReadPost * if @# == '' && getcwd() == $HOME | cd %:p:h | endif
augroup END

" " binary XXD editing mode
" " FIXME: if enable these sentences, doesn't work Autodate.
" augroup BinaryXXD
"   autocmd!
"   autocmd BufReadPre  *.bin let &binary =1
"   autocmd BufReadPost * if &binary | silent %!xxd -g 1
"   autocmd BufReadPost * set ft=xxd | endif
"   autocmd BufWritePre * if &binary | %!xxd -r | endif
"   autocmd BufWritePost * if &binary | silent %!xxd -g 1
"   autocmd BufWritePost * set nomod | endif
" augroup END

if exists('+transparency')
  augroup hack234
    autocmd!
    " TODO: on mac settings
    if has('win32')
      autocmd FocusGained * set transparency=248
      autocmd FocusLost * set transparency=192
    endif
  augroup END
endif
" }}}


" setting values{{{
" TODO: consider another smart way.
let $DATE = strftime('%Y%m%d')
" netrw is always tree view.
let g:netrw_liststyle = 3
" CVSと.で始まるファイルは表示しない
let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+'
" }}}


" colorscheme and highlightings{{{
" COLOR VALUES-----------------{{{ "
" -------------------------------- "
" SOLARIZED HEX     16/8 TERMCOL   "
" --------- ------- ---- --------- "
" base03    #002b36  8/4 brblack   "
" base02    #073642  0/4 black     "
" base01    #586e75 10/7 brgreen   "
" base00    #657b83 11/7 bryellow  "
" base0     #839496 12/6 brblue    "
" base1     #93a1a1 14/4 brcyan    "
" base2     #eee8d5  7/7 white     "
" base3     #fdf6e3 15/7 brwhite   "
" yellow    #b58900  3/3 yellow    "
" orange    #cb4b16  9/3 brred     "
" red       #dc322f  1/1 red       "
" magenta   #d33682  5/5 magenta   "
" violet    #6c71c4 13/5 brmagenta "
" blue      #268bd2  4/4 blue      "
" cyan      #2aa198  6/6 cyan      "
" green     #859900  2/2 green     "
" -----------------------------}}} "

augroup highlightIdeographicSpace
  autocmd!
  autocmd VimEnter,ColorScheme * highlight def link IdeographicSpace Visual
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END
" }}}


" commands & functions {{{
"
" bdelete/bwipeout without break window layout.
command! BDelete b#|bd#
command! BWipeout enew|bw#
command! W setl wrap! wrap?
"
" These are util functions almost taken from deris/config/.vimrc
" check https://github.com/deris/Config/blob/master/.vimrc
"
" LetAndMkdir{{{
" use:
" " call s:LetAndMkdir('&backupdir', $DOTVIM.'/backup')
"
" function! s:LetAndMkdir(variable, path) 
"   try
"     if !isdirectory(a:path)
"       call mkdir(a:path, 'p')
"     endif
"   catch
"     echohl WarningMsg
"     echom '[error]' . a:path . 'is exist and is not directory, but is file or something.'
"     echohl None
"   endtry
" 
"   execute printf("let %s = a:path", a:variable)
" endfunction "}}}
"
" PromptAndMakeDirectory{{{
" use:
" augroup AutoMkdir
"   autocmd!
"   autocmd BufNewFile * call PromptAndMakeDirectory()
" augroup END
" 
" function! PromptAndMakeDirectory()
"   let dir = expand("<afile>:p:h")
"   if !isdirectory(dir) && confirm("Create a new directory [".dir."]?", "&Yes\n&No") == 1
"     call mkdir(dir, "p")
"     " Reset fullpath of the buffer in order to avoid problems when using autochdir.
"     file %
"   endif
" endfunction
" }}}
"
" SafeQuit{{{
" " use:
" nnoremap ZZ :<C-u>SafeQuit<CR>
" nnoremap ZQ :<C-u>SafeQuit!<CR>
" 
" function! s:safeQuit(bang)
"   " 最後のタブ&最後のウィンドウでなければ終了
"   if !(tabpagenr('$') == 1 && winnr('$') == 1)
"     execute 'quit'.a:bang
"     return
"   endif
" 
"   " 終了するかどうか確認
"   echohl WarningMsg
"   let l:input = input('Are you sure to quit vim?[y/n]: ')
"   echohl None
"   redraw!
" 
"   if l:input ==? 'y'
"     execute 'quit'.a:bang
"   endif
" endfunction
" 
" command! -bang SafeQuit call s:safeQuit('<bang>')
" }}}
" }}}


" plugin setting file
source ~/.vim/.vimrc.bundle

" vim: ft=vim:et:sw=2:sts=2:fdm=marker :
