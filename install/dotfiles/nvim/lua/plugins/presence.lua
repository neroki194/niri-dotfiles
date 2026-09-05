return {
  "andweeb/presence.nvim",
  config = function()
    require("presence").setup({
      auto_update = true,
      neovim_image_text = "Editing with Neovim",
      main_image = "neovim",
      debounce_timeout = 10,
      log_level = "debug", -- Enable logging
    })
  end,
}
