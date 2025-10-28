vim.api.nvim_create_autocmd("FileType", {
  pattern = "typescriptreact",
  callback = function()
    local ts_parsers = require("nvim-treesitter.parsers")
    if not ts_parsers.get_parser(0) then
      ts_parsers.get_parser(0, "tsx")
    end
  end,
})
