" There's a lot of crap here, it should be cleaned up, but meh.
" compatibility
"set nocompatible
" syntax highlight
syntax on
" colors
set t_Co=256
" map alt+arrow keys to window switchers
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
" plugins
" filetype plugin on
" filetype indent on
" indent
" set autoindent
" read open files again when changed outside vim
" set autoread
set backupdir=$HOME/.vim/backupdir
" backup
set backup
set browsedir=current
" scan the files given with the dictionary option
"set complete+=k
" keep 50 lines of command line history
set history=50
" highlight the last used search pattern
set hlsearch
" do incremental searching
set incsearch
" strings to use in list mode
"set listchars=tab:>.,eol:\$
" enable mouse
"set mouse=a
" print options
set popt=left:8pc,right:3pc
" indent steps
"set shiftwidth=1
"set tabstop=1
" smart indenting
" set smartindent
" replace stupid beep with a visual bell
"set visualbell
" wildmenu: ignore these extensions
set wildignore=*.bak,*.o,*.e,*~
set wildmenu
" key map, mathematic
map <leader>km :set keymap=mathematic<CR> 
" highligh search results
set hlsearch
" fix backspace
set backspace=indent,eol,start
" show ruler and commands
set ruler
set showcmd
" use UNIX style newlines
set ff=unix
set ffs=unix,dos
" for restore_view
set viewoptions=cursor,folds,slash,unix 
" let g:skipview_files = ['*\.vim']
" colors
:let g:colorizer_auto_color = 1
" screenshots
let ScreenShot = {'Icon':0, 'Credits':0} 
" c/c++ error marks
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat 
" load bundles
call pathogen#infect()
" be iMproved
set nocompatible
" required for bundles
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
" let Vundle manage Vundle
Bundle 'gmarik/vundle'
" Bundles here
Bundle 'joonty/vim-sauce.git'
" /Bundles
" syntax
syntax on
" Bracket highlighting, for easy programming in complex sources
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" GVIM stuff
if has('gui_running')
    set guifont=terminus
    colorscheme molokai
endif
highlight CurrentLine guibg=bg

au! BufRead,BufNewFile *.json set filetype=json 

" C IDE stuff
helptags $HOME/.vim/doc/
"
"===================================================================================
" VARIOUS PLUGIN CONFIGURATIONS
"===================================================================================
"
"-------------------------------------------------------------------------------
" c.vim
"-------------------------------------------------------------------------------
"            
" --empty --
"                         
"-------------------------------------------------------------------------------
" taglist.vim : toggle the taglist window
" taglist.vim : define the title texts for make
" taglist.vim : define the title texts for qmake
"-------------------------------------------------------------------------------
 noremap <silent> <F11>  <Esc><Esc>:Tlist<CR>
inoremap <silent> <F11>  <Esc><Esc>:Tlist<CR>

let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select                               = 1

let tlist_make_settings  = 'make;m:makros;t:targets'
let tlist_qmake_settings = 'qmake;t:SystemVariables'

if has("autocmd")
  " ----------  qmake : set filetype for *.pro  ----------
  autocmd BufNewFile,BufRead *.pro  set filetype=qmake
endif " has("autocmd")

" tagbar
nmap <F8> :TagbarToggle<CR>

" Autocomplete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
" Kill autoindent with fire, because it's annoying
filetype indent off
autocmd VimEnter * :setl noai nocin nosi inde=
