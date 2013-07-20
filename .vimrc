scriptencoding utf-8


" TODO: 
" - on mac settings(i.e. transparency).
" - folder existing check.
" - Make togglable setting to scroll arrow key.
" FIXME:
" BUGS:
" Note:
" Experimental:

version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim

" ready for settings{{{

" needs to set before :syntax on and filetype on, plugin on.
" set encoding=cp932

syntax on
filetype plugin indent on

" for load vimrc
augroup vimrc_loading
  autocmd!
augroup END
" }}}


" set options {{{
" common settings======================================================
set autoindent
set background=dark
set backspace=indent,eol,start
set backup
set browsedir=last 				" It effect :browse [cmd]
set clipboard+=unnamed
set fileencodings=guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213,euc-jp
if !has('kaoriya')
    set fileencodings-=guess
    set fileencodings+=sjis
endif
set formatexpr=autofmt#japanese#formatexpr()
set formatoptions+=mM
set helplang=ja
set hidden
set history=50
set hlsearch
set ignorecase
set iminsert=0
set imsearch=0
set incsearch
set list
set lcs=tab:/.,trail:_
set mouse=a
set nomousefocus
set mousehide
set number
set ruler
set showcmd
set showmatch
set smartcase
" Hack #198
set splitbelow
set splitright
set tags& tags+=tags;
set title
set whichwrap=b,s,h,l,<,>,[,],~
set nowrap
set virtualedit=block
set wildmenu
set wildmode=longest:list,full
set wrapscan
" about visual(or having-number options)===============================
set laststatus=2
set showtabline=2
set cmdheight=1
set foldcolumn=1
set scrolloff=5
set tabstop=4
set shiftwidth=4
set nrformats-=octal
set textwidth=0
if has('gui')
  set lines=48
  set columns=80

  set guioptions-=e
  set guioptions-=m
  set guioptions-=T
endif
" with path============================================================
set backupdir=~/.vim/bkfiles
if has('unix')
  set backupskip=/tmp/*,/private/tmp/*
endif
set viminfo& viminfo+=n~/.viminfo
set grepprg=jvgrep

cd $HOME
" }}}


" Env-dependent settings {{{
" these are almost taken kaoriya settings.
if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

" font setting(based on kaoriya)
if has('win32')
  set guifont=Consolas:h9:cSHIFTJIS
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif

if has('multi_byte_ime') || has('xim')
  " IME ON時のカーソルの色を設定(設定例:紫)
  augroup CursorIMColor
	  au!
	  au ColorScheme * highlight CursorIM guibg=Purple guifg=NONE
  augroup END
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIMの入力開始キーを設定:
    " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
    "set imactivatekey=s-space
  endif
  " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif
" }}}


" maps{{{
" bind maps
noremap Q gq
" kill <F1> to open help.
nnoremap <F1> <nop>
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap <Up>   <C-y>M
nnoremap <Down> <C-e>M
nnoremap <Left> zh
nnoremap <Right> zl
nnoremap Y y$
inoremap <C-U> <C-G>u<C-U>

" command maps
nnoremap <silent> ,ee :<C-u>e ~/.vim/.vimrc<CR>
nnoremap <silent> ,eh :<C-u>sp ~/.vim/.vimrc<CR>
nnoremap <silent> ,ev :<C-u>vs ~/.vim/.vimrc<CR>
nnoremap <silent> ,r :<C-u>source $MYVIMRC<CR>
nnoremap B :ls<CR>:b
nnoremap : q:i
" It doesn't work incsearch.
" 	nnoremap / q/i
" Experimental: Wrap fold with <CR>.
nnoremap <silent> <CR> :<C-u>silent! normal! za<CR><CR>
" }}}


" autocmds{{{
augroup vimrc_loading
	autocmd CmdWinEnter * nnoremap <ESC> <C-c>
	autocmd CmdWinEnter * inoremap <C-c> <ESC><C-c>
	autocmd CmdWinLeave * nunmap <ESC>
	autocmd CmdWinLeave * iunmap <C-c>
augroup END

augroup hack234
  autocmd!
  autocmd FocusGained * set transparency=248
  autocmd FocusLost * set transparency=192
augroup END
" }}}


" setting values{{{
" TODO: consider anotyer smart way.
let $DATE = strftime('%Y%m%d')
" netrw is always tree view.
let g:netrw_liststyle = 3
" CVSと.で始まるファイルは表示しない
let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+'
" 
let g:solarized_italic=0
" }}}


" colorscheme and highlightings{{{
augroup highlightIdeographicSpace
  autocmd!
  autocmd Vimenter,ColorScheme * highlight IdeographicSpace term=underline cterm=reverse gui=reverse
  autocmd VimEnter,WinEnter * match IdeographicSpace /?@/
augroup END
" }}}


" functions {{{
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

let &cpo=s:cpo_save
unlet s:cpo_save
" vim: ft=vim:et:sts=4:fdm=marker :
