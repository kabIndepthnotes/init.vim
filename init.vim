" The main idea behind this vimrc
" No more bloat. Treat this as if it was a program. Use minimalised and
" focused programs here
" vimwiki side
" webdev side
" general
"
" COPYRIGHT: GPL-3.0-only
"
" People who's code I used/inspiration
" Hans Pinckaers
" https://medium.com/@hanspinckaers/setting-up-vim-as-an-ide-for-python-773722142d1d
" Tim Pope
" https://github.com/tpope
" Gilles Castel (ultisnips)
" https://castel.dev/
" Greg Hurell
" https://github.com/wincent
"
" Structure:
" PLUGS
" AUTOCOMMANDS
" SET CALLS
" FUNCTIONS
" PLUG SETTINGS
"
" TODO:
" Adding figures for math pages
" LSP for less writing and quicker workflow
" Treesitter for syntax highlighting
" Use native plugin of neovim

" PLUGS

call plug#begin()
" wiki plugins
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'KeitaNakamura/tex-conceal.vim' , { 'for': ['markdown', 'vimwiki'] }
Plug 'vimwiki/vimwiki'
Plug 'michal-h21/vim-zettel'
Plug 'mattn/calendar-vim'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'  " make statusline awesome
"Plug 'vim-airline/vim-airline-themes'  " themes for statusline 
Plug 'ap/vim-css-color'
Plug 'sirver/ultisnips'

" Tpope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
call plug#end()

" AUTOCOMMANDS

augroup CPT " This is for the encrypted files, ending .cpt, I use the program ccencrypt, and copied this from online
  au!
  au BufReadPre  *.cpt setl bin viminfo= noswapfile
  au BufReadPost *.cpt let $CPT_PASS = inputsecret("Password: ")
  au BufReadPost *.cpt silent 1,$!ccrypt -cb -E CPT_PASS
  au BufReadPost *.cpt set nobin
  au BufWritePre *.cpt norm! mk
  au BufWritePre *.cpt set bin
  au BufWritePre *.cpt silent! 1,$!ccrypt -e -E CPT_PASS
  au BufWritePost *.cpt silent! u
  au BufWritePost *.cpt set nobin
  au BufWritePost *.cpt norm! `k
augroup END

augroup markdown
    autocmd!
    "autocmd BufWritePost *.md call MyPandocCompilerWithDebug() " Adds a autowrite command that :todo: could be improved with asyncrun()
    " ColorEquation are to add easy colorized math equations from display
    " math.
    autocmd Filetype pandoc nnoremap <leader>c <Cmd>call MyPandocOpenZathura()<cr>
    " TODO make all the numbers fall into 1
    autocmd Filetype pandoc nnoremap <leader>1 <Cmd>call ColorEquation1()<cr>
    autocmd Filetype pandoc nnoremap <leader>2 <Cmd>call ColorEquation(2)<cr>
    autocmd Filetype pandoc nnoremap <leader>3 <Cmd>call ColorEquation(3)<cr>
    autocmd Filetype pandoc nnoremap <leader>4 <Cmd>call ColorEquation(4)<cr>
    autocmd Filetype pandoc nnoremap <leader>5 <Cmd>call ColorEquation(5)<cr>
    autocmd Filetype pandoc nnoremap <leader>6 <Cmd>call ColorEquation(6)<cr>
    autocmd Filetype pandoc nnoremap <leader>7 <Cmd>call ColorEquation(7)<cr>
    autocmd Filetype pandoc nnoremap <leader>8 <Cmd>call ColorEquation(8)<cr>
    autocmd Filetype pandoc nnoremap <leader>9 <Cmd>call ColorEquation(9)<cr>
    autocmd Filetype pandoc nnoremap <leader>0 <Cmd>call ColorEquationReset()<cr>
    "autocmd Filetype pandoc inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
    "autocmd Filetype pandoc nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
	" autocmd BufEnter *.md set spell
augroup END

augroup vimwiki2
    " Autowrite, silent exec vimwiki2 html
    autocmd!
    "autocmd BufWritePost *.viki,*.wiki silent! :Vimwiki2HTML
    autocmd BufEnter *.viki,*.wiki nnoremap <leader>c <Cmd>Vimwiki2HTML<cr>
    autocmd BufEnter *.viki,*.wiki nnoremap <leader>p <Cmd>call PandocToggle()<cr>
    autocmd BufEnter *.viki,*.wiki set autowriteall
    "autocmd TextChanged,TextChangedI *.viki,*.wiki silent write
augroup END

augroup pico
    autocmd!
    autocmd BufEnter *.p8,*.png set filetype=lua " for sytax highlighting
augroup END

augroup ccstuff
    autocmd!
    autocmd Filetype c nnoremap <leader>r <Cmd>call Ccompile()<cr>
    autocmd Filetype c nnoremap <leader>e <Cmd>call CRun()<cr>
augroup END

" check a filename of a wiki file and if there is not a date format then
" automatically move it to a date format.
"
augroup html
	  autocmd!
	  autocmd Filetype html set expandtab
		autocmd Filetype html set tabstop=2
		autocmd Filetype html set softtabstop=2
		autocmd Filetype html set shiftwidth=2
augroup END

augroup tsv
	autocmd!
	autocmd Filetype tsv set list
augroup END

" options

" SET CALLS 

syntax on "turn colour on

" path to your python 
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'

filetype plugin indent on
set fileformat=unix
"set shortmess+=c

set mouse=a  "add mouse support for all editor modes bar hit-enter and more-prompt
set number  " always show current line number
set ignorecase "set smartcase  "K : this ignorescase when no case is specified, but if it is then 
set wrapscan  " begin search from top of file when nothing is found anymore

set inccommand=nosplit "when you use :%s this will preview the changes in realtime
set hlsearch  " highlight search and search while typing
set incsearch

set fillchars+=vert:\  " remove chars from seperators

set backup writebackup
" backup directory
set backupdir=~/Documents/vimtmp//,.
set directory=~/Documents/vimtmp//,.

set breakindent  " preserve horizontal whitespace when wrapping
set linebreak  " wrap words
set wrap  
set scrolloff=3 " keep three lines between the cursor and the edge of the screen

set undodir=~/.vim/undodir
set undofile  " save undos
set undolevels=10000  " maximum number of changes that can be undone
set undoreload=100000  " maximum number lines to save for undo on a buffer reload

set noshowcmd
set splitright  " i prefer splitting right and below
set splitbelow " might change
set viminfo='20,<1000  
set foldcolumn=0

highlight Pmenu ctermfg=Black guibg=Black guifg=gray
highlight PmenuSel ctermfg=Black guibg=gray guifg=yellow

"set pumheight=20
set completeopt=menuone,noselect,noinsert
set foldlevelstart=1
set termguicolors
highlight Conceal guibg=Black

"FUNCTIONS

" This is for pushing todos to a later date rather than forgetting them
" because you can't do them today.
" This runs a bash script that gives the name of a vimwiki file in a few days.
" Then it edits the file and pastes the "todo task" onto the page.
" TODO make this shorter and more concise
function! SRSTODOSHORT() abort " the postpone feature I used with roam and roam toolkit
    let page = system("$HOME/myScripts/myTodoShort")
    execute "edit " . page
    norm! gg
    norm! p
endfunction

function! SRSTODOMEDIUM() abort
    let page = system("$HOME/myScripts/myTodoMedium")
    execute "edit " . page
    norm! gg
    norm! p
endfunction

function! SRSTODOLONG() abort
    let page = system("$HOME/myScripts/myTodoLong")
    execute "edit " . page
    norm! gg
    norm! p
endfunction

function! MyTexCompile() abort
    w
    execute "!pdflatex " . expand('%')
endfunction

function! GroffCompile() abort
    execute "!groffCompile " . expand('%:t:r')
endfunction


" Inspired by https://betterexplained.com/articles/colorized-math-equations/
" This makes it easy to color latex equations for better understanding and
" notes.
" TODO make simpler, possibly with ultisnips
function! ColorEquation1() abort
    if (&ft=='pandoc')
        norm! yy
        norm! I\color{c1} 
        norm! jm'
        /\$\$
        norm! pI<!--
        norm! A-->
        norm! I\color{c1} 
    endif
endfunction

function! ColorEquation(number) abort
    if (&ft=='pandoc')
        norm! yy
        let previousNumber = a:number - 1
        let tagCommand = "normal!  I\\color{c". a:number. "}"
        execute tagCommand
        norm! jm'
        execute "/\color{c" . previousNumber . "}"
        norm! pI<!--
        norm! A-->
        execute tagCommand
    endif
endfunction

" function! ColorEquation3()
"     norm! yy
"     norm! I\color{c3} 
"     /\\color{c2}
"     norm! n
"     norm! o
"     norm! pI<!--
"     norm! A-->
"     norm! I\color{c3} 
" endfunction


function! ColorEquationReset() abort
    if (&ft=='pandoc')
        norm! I\color{default}
    endif
endfunction

" TODO fix config so that this is not necessary
function! PandocToggle() abort
    if (&ft=='vimwiki')
        :set filetype=pandoc
    elseif (&ft=='pandoc')
        :set filetype=vimwiki
    endif
endfunction

function! FZFVimwiki() abort
    :FZF ~/Documents/vimwiki/
endfunction

function! FindFiles() abort
    :NV<cr>
endfunction

function! Ccompile() abort
    if (&ft=='c')
        execute "!make " . expand('%:t:r')
    endif
endfunction

function! CRun() abort
    if (&ft=='c')
        execute "!./" . expand('%:t:r')
    endif
endfunction

function! MyZettel() abort
    VimwikiIndex 1
    norm :ZettelNew
endfunction


"MAPS
" easy split movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l



" mapping Esc
cnoremap <Esc> <C-c>
inoremap <c-c> <ESC>
nnoremap <C-z> <Esc>  " disable terminal ctrl-z

let mapleader = ','
let maplocalleader = "\\"
"my change
nnoremap <leader>ev <Cmd>edit $MYVIMRC<CR>
nnoremap <leader>sv <Cmd>source $MYVIMRC<CR>

nnoremap <space> <Cmd>nohl<CR>

"yank a line TODO save cursor position
nnoremap yo ^y$

nnoremap <C-f> <Cmd>FZF ~/Documents/vimwiki/<cr>
nnoremap <C-g> <Cmd>NV<cr>

vnoremap <C-c> "+y
nnoremap <C-v> "+p

nnoremap <leader>l <Cmd>bn<cr>
nnoremap <leader>h <Cmd>bp<cr>

"vimwiki "zettelkasten
"nnoremap <leader>o :Rg :
"nnoremap <C-f> :call CopyToClipBoardPaste()<cr>

nnoremap <leader>z <Cmd>VimwikiIndex 1<cr> :ZettelNew 

nnoremap <leader>g1 <Cmd>call SRSTODOSHORT()<cr>
nnoremap <leader>g2  <Cmd>call SRSTODOMEDIUM()<cr>
nnoremap <leader>g3  <Cmd>call SRSTODOLONG()<cr>
command! -nargs=1 MRG execute "Rg" string(<q-args>) "~/Documents/vimwiki/"

let g:ruby_host_prog = '/home/kabilan/.gem/ruby/3.0.0/bin/neovim-ruby-host'

" PLUG settings
"VIMTEX vimtex
set conceallevel=1
"let g:tex_flavor  = 'latex'
"let g:tex_conceal = 'abdmg'
"let g:vimtex_fold_manual = 1
""let g:vimtex_latexmk_continuous = 0
"let g:vimtex_compiler_progname = 'nvr'
"let g:vimtex_view_method='zathura'
"let g:vimtex_quickfix_mode=0
"let g:vimtex_complete_enabled=0

"vimwiki
"let g:vimwiki_list = [{"path": ‘your_wiki_place”, "path_html": ‘wiki_html_location’, "syntax": 'markdown', "ext": '.mkd', "css_file": ‘location of designated css’, "custom_wiki2html": ‘link to the custom converter, i.e. misaka_md2html.py', "auto_export": 1}]
"

let g:vimwiki_global_ext=0
let g:vimwiki_key_mappings =
    \ {
    \   'all_maps': 1,
    \   'global': 1,
    \   'headers': 1,
    \   'text_objs': 1,
    \   'table_format': 1,
    \   'table_mappings': 1,
    \   'lists': 1,
    \   'links': 1,
    \   'html': 1,
    \   'mouse': 1,
    \ }

let g:vimwiki_list = [
            \ {'path': '~/Documents/vimwiki/', 'path_html': '~/Documents/vimwiki_html/',
            \ 'template_path': '$HOME/Documents/indepthnotesWiki/',
            \ 'template_default': 'template',
            \ 'template_ext': '.html'}]


let g:tex_conceal_frac=1
let g:vimwiki_use_calendar=1
let g:vimwiki_table_mappings = 0
"let g:vimwiki_folding = 'list:quick'

" vim-zettel zettelkasten
let g:zettel_format = "%title___%d%m%y_%H%M"
let g:disable_front_matter = 1


let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

"pandoc
let g:myPandocStart = 1
function! MyPandocCompilerToggle() abort
    let g:myPandocStart = !g:myPandocStart
endfunction
function! MyPandocCompiler() abort
    if g:myPandocStart == 1
        silent execute "!pandoc " . expand('%:t') . " -o " . expand('%:t:r') .  ".pdf "
    endif
endfunction


function! MyPandocCompilerWithDebug() abort
    if g:myPandocStart == 1
        execute "!pandoc " . expand('%') . " -o " . expand('%:r') .  ".pdf"
    endif
endfunction

function! MyPandocOpenZathura() abort
    exec "!zathura " . expand('%:r') . ".pdf &" 
endfunction


function! MyPandocMakeToLatex() abort
    %s/<!--//g "uncomment the math environments
    %s/-->//g "uncomment the math environments
endfunction

function! CopyToClipBoardPaste() abort
   "exec "!cp -p \"`ls -dtr1 \"$HOME/Pictures/screenshots\"/* | tail -1`\" \"" . expand('%:p:h') . "\" "
   exec "!cp -p \"`ls -dtr1 \"$HOME/Pictures/screenshots\"/* | tail -1`\" \"" . "$HOME/Documents/vimwiki/figures" . "\" "
   norm! i{{file:~/Documents/vimwiki/figures/
   norm! o
   "exec ".!ls | grep ". expand('%:p:h') ." | sed -n '$p'"
   exec ".!ls ". "$HOME/Documents/vimwiki/figures" . "| grep \.png | sed -n '$p' "
   norm! kJx
   norm! A}}
endfunction

function! MyPandocMathToAnkiMath() abort
    let a = ['\)','\(']
    %s/\$/\=reverse(a)[0]/g
endfunction

" function! MyPandocCheatSheetToAnkiImport()
" endfunction
