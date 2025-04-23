vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'latex' },
  callback = function()
    local cwd = vim.fn.getcwd()
    local foldername = vim.fn.fnamemodify(cwd, ':t')

    -- Create a table to hold our LaTeX commands
    local M = {}

    -- Function to insert a LaTeX figure snippet
    M.insert_latex_figure = function()
      local figure_snippet = {
        '\\begin{figure}[H]',
        '    \\centering',
        '    \\includegraphics[width=0.75\\linewidth]{example-image-a}',
        '    \\caption{CAPTION}',
        '    \\label{fig:some-fig}',
        '\\end{figure}',
      }
      -- Get the current cursor row (1-indexed)
      local row = vim.api.nvim_win_get_cursor(0)[1]
      -- Insert the snippet at the current row
      vim.api.nvim_buf_set_lines(0, row, row, false, figure_snippet)
    end

    -- Create a user command that calls the insert_latex_figure function
    vim.api.nvim_create_user_command('InsertFigure', function()
      M.insert_latex_figure()
    end, {})

    -- Alternative commands for other common LaTeX structures:

    -- Insert a section header
    M.insert_section = function()
      local section_snippet = {
        '\\section{Section Title}',
        '',
      }
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, section_snippet)
    end

    vim.api.nvim_create_user_command('InsertSection', function()
      M.insert_section()
    end, {})

    -- Insert a subsection header
    M.insert_subsection = function()
      local subsection_snippet = {
        '\\subsection{Subsection Title}',
        '',
      }
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, subsection_snippet)
    end

    vim.api.nvim_create_user_command('InsertSubsection', function()
      M.insert_subsection()
    end, {})

    -- Insert a simple equation environment
    M.insert_equation = function()
      local equation_snippet = {
        '\\begin{equation}',
        '    % your equation here',
        '\\end{equation}',
      }
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, equation_snippet)
    end

    vim.api.nvim_create_user_command('InsertEquation', function()
      M.insert_equation()
    end, {})

    -- Insert an itemize environment (for lists)
    M.insert_itemize = function()
      local itemize_snippet = {
        '\\begin{itemize}',
        '    \\item ',
        '\\end{itemize}',
      }
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, itemize_snippet)
    end

    vim.api.nvim_create_user_command('InsertItemize', function()
      M.insert_itemize()
    end, {})

    vim.api.nvim_buf_create_user_command(0, 'BuildPDF', function()
      local cmd = {
        'latexmk',
        '-xelatex',
        '-interaction=nonstopmode',
        '-jobname=' .. foldername,
        './main.tex',
      }

      local open_cmd = {
        'xdg-open',
        './' .. foldername .. '.pdf',
      }

      print '🚀 Starting LaTeX build...'
      vim.system(cmd, { text = true }, function(result)
        if result.code == 0 then
          vim.schedule(function()
            print '✅ LaTeX build successful!'
            print('📄 Opening PDF: ' .. foldername .. '.pdf')
            vim.system(open_cmd, { text = true })
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
    vim.keymap.set('n', '<leader>df', '<cmd>InsertFigure<CR>', { buffer = true, desc = 'Insert LaTeX Figure' })
    vim.keymap.set('n', '<leader>ds', '<cmd>InsertSection<CR>', { buffer = true, desc = 'Insert LaTeX Section' })
    vim.keymap.set('n', '<leader>du', '<cmd>InsertSubsection<CR>', { buffer = true, desc = 'Insert LaTeX Subsection' })
    vim.keymap.set('n', '<leader>de', '<cmd>InsertEquation<CR>', { buffer = true, desc = 'Insert LaTeX Equation' })
    vim.keymap.set('n', '<leader>di', '<cmd>InsertItemize<CR>', { buffer = true, desc = 'Insert LaTeX Itemize List' })
  end,
})
