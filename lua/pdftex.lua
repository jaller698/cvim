vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'latex' },
  callback = function()
    local cwd = vim.fn.getcwd()
    local foldername = vim.fn.fnamemodify(cwd, ':t')

    vim.api.nvim_buf_create_user_command(0, 'BuildPDF', function()
      local cmd = {
        'latexmk',
        '-xelatex',
        '-interaction=nonstopmode',
        '-jobname=' .. foldername,
        './main.tex',
      }

      -- Run in background
      vim.system(cmd, { text = true }, function(result)
        if result.code == 0 then
          vim.schedule(function()
            print '✅ LaTeX build successful!'
            vim.cmd('!open ' .. foldername .. '.pdf')
          end)
        else
          vim.schedule(function()
            print '❌ LaTeX build failed:'
            print(result.stderr or 'Unknown error.')
          end)
        end
      end)
    end, { desc = 'Build LaTeX document with folder name and open PDF' })

    vim.keymap.set('n', '<leader>dp', '<cmd>BuildPDF<CR>', { buffer = true, desc = 'Build and view PDF' })
  end,
})
