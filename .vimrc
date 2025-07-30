" ~/.vimrc

" ---------------------------------------------------------------------------
" Basic Settings
" ---------------------------------------------------------------------------

" Enable line numbers
set number

" Enable relative line numbers (useful for movement commands)
set relativenumber

" Enable the mouse
set mouse=a

" Use 24-bit colors if possible
set termguicolors

" Enable syntax highlighting
syntax on

" Enable filetype detection and plugin loading
filetype plugin indent on

" Automatically indent new lines
set autoindent
set smartindent

" Set tab width to 4 spaces (adjust as you prefer)
set tabstop=4
set shiftwidth=4
set expandtab

" Show hidden characters (tabs, newlines, etc.)
"set list
"set listchars=tab:>-,eol:$,trail:-,space:.

" ---------------------------------------------------------------------------
" Cursor Appearance
" ---------------------------------------------------------------------------

" Make the cursor a full block in normal mode
let &t_SI .= "\<Esc>[5 q" "Use full block cursor
let &t_EI .= "\<Esc>[2 q" "Use default cursor when leaving insert mode

" ---------------------------------------------------------------------------
" Color Scheme and Appearance
" ---------------------------------------------------------------------------

" Enable syntax highlighting if supported
if has("syntax")
  syntax on
endif

" Set a color scheme (you can try others)
" Try these other color schemes to see what you like:
"   desert, evening, morning, murphy, peachpuff, slate, tokyonight, etc.
" Use the command `:colorscheme <name>` to quickly test color schemes.
colorscheme murphy

" Enable true color support (if your terminal supports it)
if (has("termguicolors"))
  set termguicolors
endif

" Set background to dark (or light, depending on your preference)
set background=dark

" Show the current mode in the command line
set showmode

" ---------------------------------------------------------------------------
" UI Improvements
" ---------------------------------------------------------------------------

" Show the command you are typing
set showcmd

" Highlight search results
set hlsearch
set incsearch

" Ignore case when searching, unless the search string contains uppercase characters
set ignorecase
set smartcase

" Show matching brackets when the cursor is over them
set showmatch
set mat=2
" set matshow=1

" Automatically close brackets and parentheses
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" Display a ruler
set ruler

" Always show the status line
set laststatus=2

" Show relative line numbers, but absolute line number on current line
augroup NumberToggle
  autocmd!
  autocmd WinEnter,FocusGained,BufWinEnter * set relativenumber number
  autocmd WinLeave,FocusLost,BufWinLeave   * set norelativenumber number
augroup END

" ---------------------------------------------------------------------------
" Key Mappings (Optional)
" ---------------------------------------------------------------------------

" Example: Map <leader>w to save the current file
" nnoremap <leader>w :w<CR>

" Leader key is comma by default
let mapleader=","

" Quick save
nnoremap <leader>s :w!<CR>

" Quick quit
nnoremap <leader>q :q!<CR>

" Switch to current file in NERDTree
nnoremap <silent> <leader>n :NERDTreeFind<CR>

" Make Y behave like other caps commands
nnoremap Y y$

" ---------------------------------------------------------------------------
" Plugin Settings (Example, requires a plugin manager)
" ---------------------------------------------------------------------------

" If you use a plugin manager (like vim-plug, Vundle, etc.), you can add plugin-specific settings here.
" For example, if you install the NERDTree plugin, you could add the following:
" let NERDTreeShowHidden=1  " Show hidden files in NERDTree
