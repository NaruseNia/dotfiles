if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'jacoborus/tender.vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'ayu-theme/ayu-vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tyrannicaltoucan/vim-quantum' 
Plug 'frenzyexists/aquarium-vim', { 'branch': 'develop' }
Plug 'adrian5/oceanic-next-vim'
Plug 'tomasiser/vim-code-dark'
Plug 'yuttie/hydrangea-vim'
Plug 'sainnhe/edge'
Plug 'sainnhe/sonokai'
Plug 'rust-lang/rust.vim'

if has("nvim")
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neovim/nvim-lspconfig'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'folke/lsp-colors.nvim'
  Plug 'nvim-lua/completion-nvim'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'windwp/nvim-autopairs'
  Plug 'neovim/nvim-lspconfig'
  Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
  Plug 'ray-x/navigator.lua'
endif

Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()
