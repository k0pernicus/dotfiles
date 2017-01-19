" LET AND SET

set hlsearch 	  " Highlight search results
set noerrorbells  " No beeps
set nojoinspaces  " Prevents bad practices using space
set number			"	Add line number
set shiftwidth=2  " Indentation amout using < and >
set showcmd 	  " Show (partial) command in status line
set showmatch 	  " Show matching brackets
set tabstop=2 	  " Render TABs

autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4

" CONFIG

let g:ctrlp_working_path_mode = 'ra'
let g:rustfmt_autosave = 1

" DEOPLETE
let g:deoplete#enable_at_startup = 1

" FUNCTIONS

" Function to close old buffers
function! CloseHiddenBuffers()
   let visible = {}
   for t in range(1, tabpagenr('$'))
       for b in tabpagebuflist(t)
           let visible[b] = 1 
       endfor
   endfor
	 for b in range(1, bufnr('$'))
       if bufexists(b) && !has_key(visible, b)
           execute 'bwipeout' b
       endif
   endfor
endfun

" Beautiful solution to overlight characters after the 80th character (same
" line)
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Markdown
let g:markdown_fenced_languages = [ 
	\ 'bash=sh',
  \ 'ocaml',
	\ 'rust',
	\ ]

" VIM-PLUG

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'trevordmiller/nova-vim'
Plug 'majutsushi/tagbar'
Plug 'mhartington/oceanic-next'
Plug 'neomake/neomake'
Plug 'plasticboy/vim-markdown'
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim', { 'for': [ 'rust' ], 'do': 'cargo install rustfmt' } 
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'slashmili/alchemist.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'

call plug#end()

" TAGBAR
nmap <F8> :TagbarToggle<CR>

" COLORS

if (has("termguicolors"))
   set termguicolors
 endif

 " Theme
 syntax enable
 colorscheme nova 
 " set background=dark

" enable italics, disabled by default
let g:oceanic_next_terminal_italic = 1

" enable bold, disabled by default
let g:oceanic_next_terminal_bold = 1

" RACER
set hidden
let g:racer_cmd = "/home/antonin/.cargo/bin/racer"

" NEOMAKE
let g:neomake_rust_cargo_maker = {
    \ 'exe': 'cargo',
    \ 'args': ['build'],
    \ 'append_file': 0,
    \ 'errorformat': '%Eerror%m,%Z\ %#-->\ %f:%l:%c',
  \ }
let g:neomake_rust_enabled_makers = ['cargo']
autocmd! BufWritePost *.rs Neomake cargo
