return { 
    "EdenEast/nightfox.nvim", 
    lazy = false,
    name = "nightfox", 
    priority = 1000,
    config = function()
        vim.cmd.colorscheme "nightfox"
    end
}
