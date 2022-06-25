" Required:
if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')
  Plug 'junegunn/vim-plug',
        \ {'dir': '~/.vim/plugged/vim-plug/autoload'}

  "Plug 'tpope/vim-endwise'
  "Plug 'tpope/vim-fugitive'
  "Plug 'henrik/vim-open-url'
  "Plug 'bling/vim-airline'
  "Plug 'Shougo/deoplete.nvim'
  "Plug 'Shougo/neco-vim'
  "Plug 'Shougo/vimshell'
  "Plug 'SirVer/ultisnips'
  "Plug 'honza/vim-snippets'
  "Plug 'Shougo/neomru.vim'
  "Plug 'Shougo/unite.vim'
  "Plug 'Shougo/vimproc.vim', {'do' : 'make'}
  "Plug 'Shougo/vimfiler.vim'
  "Plug 'itchyny/lightline.vim'
  "Plug 'bronson/vim-trailing-whitespace'
  "Plug 'jwhitley/vim-matchit'
  "Plug 'thinca/vim-quickrun'
  "Plug 'tyru/open-browser.vim'
  "Plug 'soramugi/auto-ctags.vim'
  "Plug 'kana/vim-submode'
  "Plug 'rhysd/vim-clang-format'
  "Plug 'vim-scripts/gtags.vim'
  "Plug 'vim-jp/vital.vim'
  "Plug 'vim-ruby/vim-ruby', { 'for': ['rb', 'erb'] }
  "Plug 'fatih/vim-go', { 'for': ['go'] }
  "Plug 'buoto/gotests-vim', { 'for': ['go'] }
  "Plug 'moll/vim-node', { 'for': ['js'] }
  "Plug 'zchee/deoplete-go', { 'for': ['go'] }
  "Plug 'prabirshrestha/async.vim'
  "Plug 'prabirshrestha/vim-lsp'
  Plug 'dag/vim-fish'

  if has("mac")
    Plug 'zerowidth/vim-copy-as-rtf'
  endif

  "if has('nvim')
  "  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  "else
  "  "pip3 install --user pynvim
  "  Plug 'Shougo/deoplete.nvim'
  "  Plug 'roxma/nvim-yarp'
  "  "Plug 'roxma/vim-hug-neovim-rpc'
  "endif
  let g:deoplete#enable_at_startup = 1

call plug#end()

filetype plugin on
syntax enable
"------------------------------------------------------------
" * 基本の設定
"------------------------------------------------------------
" ファイル名と内容によってファイルタイプを判別し、ファイルタイププラグインを有効にする
filetype indent plugin on

" 色づけをオン
syntax on

" コマンドライン補完を便利に
set wildmenu

" タイプ途中のコマンドを画面最下行に表示
set showcmd

" 検索語を強調表示（<Esc><Esc>を押すと現在の強調表示を解除する）
set hlsearch

" 検索時に大文字・小文字を区別しない。ただし、検索後に大文字小文字が
" 混在しているときは区別する
"set ignorecase
set smartcase

" インクリメンタルサーチ
set incsearch

" オートインデント、改行、インサートモード開始直後にバックスペースキーで
" 削除できるようにする
set backspace=indent,eol,start

" オートインデント
set autoindent

" 移動コマンドを使ったとき、行頭に移動しない
set nostartofline

" 画面最下行にルーラーを表示する
set ruler

" ステータスラインを常に表示する
set laststatus=2

" バッファが変更されているとき、コマンドをエラーにするのでなく、保存する
" かどうか確認を求める
set confirm

" ビープの代わりにビジュアルベル（画面フラッシュ）を使う
set visualbell

" そしてビジュアルベルも無効化する
set t_vb=

" コマンドラインの高さを2行に
set cmdheight=2

" 行番号を表示
set number

" キーコードはすぐにタイムアウト。マッピングはタイムアウトしない
set notimeout ttimeout ttimeoutlen=200

" <F11>キーで'paste'と'nopaste'を切り替える
set pastetoggle=<F11>

" タブ文字の代わりにスペース2個を使う
set shiftwidth=2
set softtabstop=2
set expandtab
"大文字小文字を判別する
set noignorecase
"256色を有効にする
set t_Co=256

"colorschemeを設定する
"colorscheme default

"カーソル行の強調表示
"set cursorline

"スワップファイルをつくらない
set noswapfile

" 文字、改行コードを自動判別する
:set encoding=utf-8
:set fileencodings=default,euc-jp,sjis,utf-8,utf-16,utf-16le
:set fileformats=unix,dos,mac

" 履歴保存数
set history=50

set clipboard=unnamed

" 折りたたみ
set nofoldenable    " disable folding

" ctags自動保存
let g:auto_ctags = 1
let g:auto_ctags_directory_list = ['.git']
let g:auto_ctags_tags_args = ['--tag-relative=yes', '--recurse=yes', '--sort=yes']

set tags+=.git/tags
" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>

"------------------------------------------------------------
" * 基本のキーマッピング
"------------------------------------------------------------

" Yの動作をDやCと同じにする
map Y y$

" <Esc><Esc>またはCtrl-lで検索後の強調表示を解除する
nmap <Esc><Esc> :nohlsearch<CR>
nmap <C-l>      :nohlsearch<CR>

" 前後のバッファへ移動
nnoremap <C-k> :bp<CR>
nnoremap <C-j> :bn<CR>
" バッファを削除
nnoremap ,D :bd<CR>

" set numberのトグル
nnoremap tn :setl number! number?<CR>

" x削除時にヤンクしない"
nnoremap x "_x

" Ctrl+d または Ctrl+lでEsc
" inoremap <C-d> <Esc>
" vnoremap <C-l> <Esc>

" Commandモードの履歴移動
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

"タブの移動をsl shで"
nnoremap sl gt
nnoremap sh gT

" 終了
nnoremap Q  :qa<CR>
nnoremap ,S :suspend<CR>

set tabpagemax=100

"------------------------------------------------------------
" * autocmd
"------------------------------------------------------------
if has("autocmd")
  " rubyファイルの定義
  autocmd BufRead,BufNewFile {Jsfile,Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru,*.cap,*.ctl,*.etl,*.ebf} set ft=ruby
  autocmd BufRead,BufNewFile {*.ts} set ft=javascript
  autocmd FileType php setlocal sw=4 sts=4 ts=4 et
  autocmd FileType pl setlocal sw=4 sts=4 ts=4 et
  autocmd FileType t setlocal sw=4 sts=4 ts=4 et
  autocmd FileType go  setlocal sw=8 sts=8 ts=8 noet
  autocmd FileType ruby set ts=2 sw=2 expandtab
  " md as markdown, instead of modula2
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd Filetype * set formatoptions-=r
endif

"" ポップアップの操作
"" Ctrl+j, k で候補を移動
inoremap <expr><c-j> pumvisible() ? "\<C-n>" : "\<c-j>"
inoremap <expr><c-k> pumvisible() ? "\<C-p>" : "\<c-k>"
"" Ctrl+i or Tab でSnippetsを展開
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-i>"
"
"------------------------------------------------------------
" * VimFiler
"------------------------------------------------------------

" Like Textmate icons.

"nnoremap <Space> :<C-u>VimFilerBufferDir -quit<CR>
noremap <Space> :<C-u>VimFilerBufferDir -force-quit<CR>
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default=0
let g:vimfiler_enable_auto_cd = 0
let g:vimfiler_edit_action = 'tabopen'
autocmd! FileType vimfiler call s:my_vimfiler_settings()
function! s:my_vimfiler_settings()
   nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_execute)", "\<Plug>(vimfiler_edit_file)")
endfunction

"------------------------------------------------------------
" * vim-go
"------------------------------------------------------------

au FileType go nmap gi <Plug>(go-info)
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap gt <Plug>(go-test)
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
"let g:go_metalinter_autosave_enabled = ['test']
let g:go_metalinter_autosave_enabled = [
      \  'vet',
      \]
let g:go_term_mode = 'split'
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
"autocmd BufWrite,FileWritePre,FileAppendPre *.go :GoTest

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif

if executable('bingo')
      au User lsp_setup call lsp#register_server({
              \ 'name': 'bingo',
              \ 'cmd': {server_info->['bingo', '-mode', 'stdio']},
              \ 'whitelist': ['go'],
              \ })
endif

"---------------------------------------------------------------"
"vimproc"
"---------------------------------------------------------------"
"let s:vimproc_dll_path = '~/.vim/bundle/vimproc/autoload/vimproc_mac.so'

" 保存時に空白削除
" nnoremap <C-d> :FixWhitespace <CR>

"---------------------------------------------------------------"
"pt"
"" grep検索結果の再呼出
function! GetProjectDir() abort " {{{
    if exists('b:vimfiler.current_dir')
        let l:buffer_dir = b:vimfiler.current_dir
    else
        let l:buffer_dir = expand('%:p:h')
    endif

    let l:project_dir = vital#of('vital').import('Prelude').path2project_directory(l:buffer_dir, 1)
    if empty(l:project_dir) && exists('g:project_dir_pattern')
        let l:project_dir = matchstr(l:buffer_dir, g:project_dir_pattern)
    endif

    if empty(l:project_dir)
        return l:buffer_dir
    else
        return l:project_dir
    endif
endfunction " }}}

nnoremap <silent> ,g :<C-u>call <SID>unite_grep_project('-start-insert -buffer-name=search-buffer')<CR>
nnoremap <silent> ,cg :<C-u>call <SID>unite_grep_project('-buffer-name=search-buffer')<CR><C-R><C-W>
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>


function! s:unite_grep_project(...)
    let opts = (a:0 ? join(a:000, ' ') : '')
    let l:project_dir = GetProjectDir()
    if !executable('pt') && isdirectory(l:project_dir.'/.git')
        execute 'Unite '.opts.' grep/git:/:--untracked'
    else
        execute 'Unite '.opts.' grep:'.l:project_dir
    endif
endfunction


"nnoremap <silent> ,g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
if executable('pt')
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
endif

"---------------------------------------------------------------"
"unite"
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>

"------------------------------------
" clang-format
"------------------------------------
let g:clang_format#style_options = {
        \ "BasedOnStyle": "LLVM",
        \ "IndentWidth": 2,
        \ "ColumnLimit": 100,
        \ "BreakBeforeBraces": "Linux",
        \ "AllowShortFunctionsOnASingleLine": "None"}
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>
nnoremap <silent> ,cf :<C-u>ClangFormat<CR>
autocmd FileType c ClangFormatAutoEnable

command! -range GT GoTests
nnoremap <silent> ss :<C-u>GoFillStruct<CR>
" nnoremap <silent> gg :<C-u>Gbrowse<CR>
set noautochdir
"autocmd BufEnter * silent! lcd %:p:h
nnoremap <silent> qq  :<C-u>q<CR>

" current url open
nnoremap <silent> oo :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>

"------------------------------------
" lightline
"------------------------------------
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'LightlineFilename'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! LightlineModified()
  if &filetype == 'help'
    return ''
  elseif &modified
    return '+'
  elseif &modifiable
    return ''
  else
    return '-'
  endif
endfunction

function! LightlineReadonly()
  if &filetype == 'help'
    return ''
  elseif &readonly
    return 'x'
  else
    return ''
  endif
endfunction

function! LightlineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
       \ ('' != expand('%') ? expand('%') : '[No Name]') .
       \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

let g:lightline.tab = {
      \ 'active': [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
      \ }

let g:lightline.tab_component_function = {
      \ 'filename': 'LightlineTabFilename',
      \ 'modified': 'lightline#tab#modified',
      \ 'readonly': 'lightline#tab#readonly',
      \ 'tabnum': 'lightline#tab#tabnum' }

function! LightlineTabFilename(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let _ = pathshorten(expand('#'.buflist[winnr - 1].':f'))
  return _ !=# '' ? _ : '[No Name]'
endfunction


set mmp=5000
