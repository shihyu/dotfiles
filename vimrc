set nocompatible               " be iMproved
filetype off                   " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'vim-scripts/L9'
Bundle 'vim-scripts/cscope_macros.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-scripts/Pydiction'
"Bundle 'msanders/snipmate.vim'
Bundle 'vim-scripts/xptemplate'
Bundle 'vim-scripts/taglist.vim'
Bundle 'vim-scripts/FuzzyFinder'
Bundle 'vim-scripts/AutoComplPop'
Bundle 'Shougo/neocomplcache'
Bundle 'vim-scripts/fakeclip'
Bundle 'corntrace/bufexplorer'
Bundle 'tpope/vim-surround'
Bundle 'c9s/gsession.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'kevinw/pyflakes-vim'

filetype on
filetype plugin on
filetype indent on

set fencs=utf-8,gbk,big5,euc-jp,utf-16le
set fenc=utf-8 enc=utf-8 tenc=utf-8
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set nobackup
set cindent
set autoindent
set showcmd
set helplang=Cn
set nofoldenable
set noswapfile
set number
set mouse=nv
set hlsearch
set incsearch
set viminfo+=h
set nocp

autocmd FileType perl set keywordprg=perldoc\ -f


"單個文件編譯
map <F5> :call Do_OneFileMake()<CR>
function Do_OneFileMake()
    set autochdir
    if expand("%:p:h")!=getcwd()
        echohl WarningMsg | echo "Fail to make! This file is not in the current dir! Press <F7> to redirect to the dir of this file." | echohl None
        return
    endif
    let sourcefileename=expand("%:t")
    if (sourcefileename=="" || (&filetype!="cpp" && &filetype!="c"))
        echohl WarningMsg | echo "Fail to make! Please select the right file!" | echohl None
        return
    endif
    let deletedspacefilename=substitute(sourcefileename,' ','','g')
    if strlen(deletedspacefilename)!=strlen(sourcefileename)
        echohl WarningMsg | echo "Fail to make! Please delete the spaces in the filename!" | echohl None
        return
    endif
    if &filetype=="c"
        if g:iswindows==1
            set makeprg=gcc\ -o\ %<.exe\ %
        else
            set makeprg=gcc\ -o\ %<\ %
        endif
    elseif &filetype=="cpp"
        if g:iswindows==1
            set makeprg=g++\ -o\ %<.exe\ %
        else
            set makeprg=g++\ -o\ %<\ %
        endif
        "elseif &filetype=="cs"
        "set makeprg=csc\ \/nologo\ \/out:%<.exe\ %
    endif
    if(g:iswindows==1)
        let outfilename=substitute(sourcefileename,'\(\.[^.]*\)
        ,'.exe','g')
        let toexename=outfilename
    else
        let outfilename=substitute(sourcefileename,'\(\.[^.]*\)
        ,'','g')
        let toexename=outfilename
    endif
    if filereadable(outfilename)
        if(g:iswindows==1)
            let outdeletedsuccess=delete(getcwd()."\\".outfilename)
        else
            let outdeletedsuccess=delete("./".outfilename)
        endif
        if(outdeletedsuccess!=0)
            set makeprg=make
            echohl WarningMsg | echo "Fail to make! I cannot delete the ".outfilename | echohl None
            return
        endif
    endif
    execute "silent make"
    set makeprg=make
    execute "normal :"
    if filereadable(outfilename)
        if(g:iswindows==1)
            execute "!".toexename
        else
            execute "!./".toexename
        endif
    endif
    execute "copen"
endfunction

"進行make的設置
map <F6> :call Do_make()<CR>
function Do_make()
    set autochdir
    set makeprg=make
    execute "silent make"
    execute "copen"
endfunction

map <F7> :call Do_makei_clean()<CR>
function Do_makei_clean()
    set autochdir
    execute "silent make clean"
endfunction

"單檔gcc compile
nmap <C-c><C-c> :call Compile_gcc()<CR>
function Compile_gcc()
    if &filetype=="c"
        set autochdir
        execute "w"
        execute "!gcc -Wall % -o %:r.out"
    elseif &filetype=="cpp"
        set autochdir
        execute "w"
        execute "!g++ -Wall % -o %:r.out"
    endif
endfunction

"單檔RUN
nmap <C-r><C-r> :call Run_gcc()<CR>
function Run_gcc()
    if &filetype=="c" 
        set autochdir
        execute "! ./%:r.out"
    elseif &filetype=="cpp" 
        set autochdir
        execute "! ./%:r.out"
    elseif  &filetype=="python"
        set autochdir
        execute "w"
        execute "! python ./%:r.py"
    endif
endfunction


imap <F8> <C-R>=strftime("%c")<CR>
nnoremap <F12> :TlistToggle<CR>
nmap <leader>p  :NERDTreeToggle<CR>

"nmap <F5> ^W_^W\|
"nmap <F6> ^W=
"imap <F5> <ESC>^W_^W\|a
"imap <F6> <ESC>^W=a
"nmap gF ^Wf

if has("gdb")
    set splitright              
    set previewheight=60
    set asm=0
    set gdbprg=gdb
    nmap <silent><LEADER>g :run macros/gdb_mappings.vim<cr>
    nmap <silent> <C-V> :bel 8 split gdb-variables<CR>
    let g:vimgdb_debug_file = ""
    run macros/gdb_mappings.vim 
endif
syntax on

colorscheme evening
hi Normal ctermfg=grey ctermbg=black
hi Visual ctermfg=green ctermbg=black
hi Search term=reverse cterm=standout ctermfg=green  ctermbg=yellow
hi IncSearch term=reverse cterm=standout ctermfg=green ctermbg=yellow
hi PmenuSel ctermbg=Green ctermfg=Yellow


"python
let g:pydiction_location = '~/.vim/bundle/Pydiction/complete-dict'


