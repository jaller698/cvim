return {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    },
    config = function()
        require("telescope").load_extension("lazygit")

        -- Define an augroup and autocmd here
        vim.api.nvim_create_augroup("LazyGitAutoCmd", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", {
            group = "LazyGitAutoCmd",
            pattern = "*",
            callback = function()
                require('lazygit.utils').project_root_dir()
            end,
        })
    end,
}

