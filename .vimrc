


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
  " Mac�ł̓f�t�H���g��'iskeyword'��cp932�ɑΉ�������Ă��Ȃ��̂ŏC��
  set iskeyword=@,48-57,_,128-167,224-235
endif

" font setting(based on kaoriya)
if has('win32')
  set guifont=Consolas:h9:cSHIFTJIS
  set linespace=1
  " �ꕔ��UCS�����̕��������v�����Č��߂�
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('xfontset')
  " UNIX�p (xfontset���g�p)
  set guifontset=a14,r14,k14
endif

if has('multi_byte_ime') || has('xim')
  " IME ON���̃J�[�\���̐F��ݒ�(�ݒ��:��)
  augroup CursorIMColor
	  au!
	  au ColorScheme * highlight CursorIM guibg=Purple guifg=NONE
  augroup END
  " �}�����[�h�E�������[�h�ł̃f�t�H���g��IME��Ԑݒ�
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIM�̓��͊J�n�L�[��ݒ�:
    " ���L�� s-space ��Shift+Space�̈Ӗ���kinput2+canna�p�ݒ�
    "set imactivatekey=s-space
  endif
  " �}�����[�h�ł�IME��Ԃ��L�������Ȃ��ꍇ�A���s�̃R�����g������
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
" CVS��.�Ŏn�܂�t�@�C���͕\�����Ȃ�
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
  autocmd VimEnter,WinEnter * match IdeographicSpace /�@/
augroup END
" TODO: check the value's effect
" let g:solarized_termtrans = 1
colorscheme solarized
" }}}


" functions {{{
" test safequit{{{
" 
" " ex�R�}���h
" nnoremap ZZ :<C-u>SafeQuit<CR>
" nnoremap ZQ :<C-u>SafeQuit!<CR>
" 
" function! s:safeQuit(bang)
"   " �Ō�̃^�u&�Ō�̃E�B���h�E�łȂ���ΏI��
"   if !(tabpagenr('$') == 1 && winnr('$') == 1)
"     execute 'quit'.a:bang
"     return
"   endif
" 
"   " �I�����邩�ǂ����m�F
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
