local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-lua/plenary.nvim" },
  { "vague2k/vague.nvim" },
  { "echasnovski/mini.pick" },
  { "nvim-treesitter/nvim-treesitter",        branch = "main" },
  { "chomosuke/typst-preview.nvim" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "L3MON4D3/LuaSnip" },
  { "nvim-telescope/telescope.nvim" },
  { "windwp/nvim-autopairs" },
  { "akinsho/bufferline.nvim" },
  { "christianchiarulli/lualine.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "hrsh7th/cmp-nvim-lsp",                   branch = "main", },
  { "hrsh7th/cmp-nvim-lua" },
  { "numToStr/Comment.nvim" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "kyazdani42/nvim-web-devicons" },
  { "lvimuser/lsp-inlayhints.nvim" },
  -- { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "RRethy/vim-illuminate" },
  { "mhartington/formatter.nvim" },
  { "lewis6991/gitsigns.nvim" },
  { "tpope/vim-fugitive" },
  { "ray-x/lsp_signature.nvim" }
})
