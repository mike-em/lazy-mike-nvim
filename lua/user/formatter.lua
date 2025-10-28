require("formatter").setup({
  filetype = {
    javascript = { require("formatter.filetypes.javascript").prettierd },
    javascriptreact = { require("formatter.filetypes.javascriptreact").prettierd },
    typescript = { require("formatter.filetypes.typescript").prettierd },
    typescriptreact = { require("formatter.filetypes.typescriptreact").prettierd },
    json = { require("formatter.filetypes.json").prettierd },
    svelte = { require("formatter.filetypes.svelte").prettierd },
    lua = { require("formatter.filetypes.lua").stylua },
    css = {
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },
    scss = {
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    }
  },
})
