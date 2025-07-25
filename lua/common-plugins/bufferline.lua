return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers', -- can be "tabs" to show tab pages instead
        numbers = 'none',
        indicator = {
          icon = '▎', -- highlights the active buffer
          style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        tab_size = 18,
        diagnostics = 'nvim_lsp', -- show LSP diagnostics in the bufferline
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = 'NeoTree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
        show_buffer_icons = true, -- enable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        enforce_regular_tabs = false,
        persist_buffer_sort = true, -- custom sorted buffers persist
        separator_style = 'thin', -- can be "thick" or a table of two characters
        always_show_bufferline = true,
        sort_by = 'insert_after_current', -- alternative: "insert_after_current", "insert_at_end", etc.
      },
    }

    -- 'æ' moves the buffer left (previous position)
    vim.keymap.set('n', 'æ', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Move buffer left' })
    -- 'ø' moves the buffer right (next position)
    vim.keymap.set('n', 'ø', '<cmd>BufferLineCycleNext<CR>', { desc = 'Move buffer right' })
    -- Additional key mappings for buffer management:
    vim.keymap.set('n', '<leader>bq', '<cmd>bdelete<CR>', { desc = 'Quit window' })
    vim.keymap.set('n', '<leader>b|', '<cmd>vsplit | b#<CR>', { desc = 'Open last buffer in a vertical split' })
    vim.keymap.set('n', '<leader>bh', '<cmd>split | b#<CR>', { desc = 'Open last buffer in a horizontal split' })
    vim.keymap.set('n', '<leader>bc', function()
      local current_buf = vim.api.nvim_get_current_buf()
      local listed_bufs = vim.tbl_filter(function(buf)
        return vim.fn.buflisted(buf)
      end, vim.api.nvim_list_bufs())
      if #listed_bufs > 1 then
        vim.cmd 'bprevious'
        vim.cmd('bdelete ' .. current_buf)
      else
        -- If it's the last buffer, create a new empty buffer instead of closing the window.
        vim.cmd 'enew'
      end
    end, { desc = 'Close current buffer' })
    vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<CR>', { desc = 'Pick a buffer' })
    vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineCloseLeft<CR>', { desc = 'Close all buffers to the left' })
    vim.keymap.set('n', '<leader>br', '<cmd>BufferLineCloseRight<CR>', { desc = 'Close all buffers to the right' })
    vim.keymap.set('n', '<leader>ba', '<cmd>BufferLineCloseOthers<CR>', { desc = 'Close all other buffers' })
  end,
}
