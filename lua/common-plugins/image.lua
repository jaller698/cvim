return {
  '3rd/image.nvim',
  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  cond = function()
    return not vim.g.neovide -- Do not try to use image.nvim in neovide, it does not yet support it
  end,
  ft = { 'markdown', 'vimwiki' },
  opts = {
    processor = 'magick_cli',
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = true,
        download_remote_images = true,
        only_render_image_at_cursor = true,
        floating_windows = true, -- if true, images will be rendered in floating markdown windows
        filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
      },
    },
    window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
  },
}
