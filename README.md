.vim
====

Vim KaoriYaを想定した設定。
一応Terminalなどの切り分けもしてある。
動作確認: Vim KaoriYa Windows(32/64bit), MSYS, Cygwin
設定予定: MacVim Kaoriya

使う
----

1. $HOME辺りに`git clone`する。
2. `:e $MYVIMRC`($HOMEに.vimrcが無いならば作る)

  ```VimL
  source ~/.vim/.vimrc
  ```
  
  また変更予定のない環境依存のPATH設定などもここで行う。

3. gvimrc\_local.vim, vimrc\_local.vimを＄VIMに投げ込む。

  これらが読まれることにより、設定が書き換えられデフォルトの
  システムg/vimrcは読まない。

  gvimrc_local.vimには何も設定しない。これはvimrcより後に
  読まれるため意図しない設定書き換えを防ぐため。
  システムgvimrc中の設定は基本的に.vim/.vimrc内へ織り込んである。
  
  vimrc_local.vimにはシステムvimrcの中から、汎用的な設定を
  取り除いたものが書かれている。
  ここでいう汎用的な設定とは`set`や`map`, `colorscheme`のようなもので、
  - 使用者の目の届かないところで変更されるべきでない
  - 他の同様の設定と一元で管理する
  
  といった理由で.vim/.vimrcへ記載する。
