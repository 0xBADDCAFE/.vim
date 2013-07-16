


" TODO: folder existing check.

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
" about visual=========================================================
set columns=80
set laststatus=2
set lines=48
set showtabline=2
set cmdheight=1
set foldcolumn=1
set scrolloff=5
set tabstop=4
set shiftwidth=4
set nrformats-=octal
set textwidth=0

set guioptions-=e
set guioptions-=m
set guioptions-=T
" with path============================================================
set backupdir=$VIM/bkfiles
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
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap gj j
nnoremap gk k
nnoremap Y y$
inoremap <C-U> <C-G>u<C-U>

" command maps
nnoremap <silent> ,e :<C-u>edit ~/.vim/.vimrc<CR>
nnoremap <silent> ,r :<C-u>source ~/.vim/.vimrc<CR>
nnoremap B :ls<CR>:b
nnoremap : q:i
" It doesn't work incsearch.
" 	nnoremap / q/i
" [Experimental] Wrap fold with <CR>.
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
" Light Solarized color.
augroup SpKeyColLight
  autocmd!
  autocmd colorscheme * highlight SpecialKey guifg=#073642 guibg=NONE "solarized base02
  autocmd colorscheme * highlight NonText guifg=#073642 guibg=NONE "solarized base02
augroup END
augroup hilightIdeographicSpace
  autocmd!
  autocmd Vimenter,ColorScheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=#073642
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END
" TODO: check the value's effect
" let g:solarized_termtrans = 1
colorscheme solarized
" }}}


" functions {{{
" test safequit{{{
" 
" " exコマンド
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
" 
" }}}
" }}}


" plugin setting file
source ~/.vim/.vimrc.bundle

let &cpo=s:cpo_save
unlet s:cpo_save
" vim:ft=vim:fdm=marker:
