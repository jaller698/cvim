local function count_tex_words()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Ensure 'tex' filetype resolves to 'latex' treesitter parser
  pcall(vim.treesitter.language.register, 'latex', 'tex')

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    vim.notify('Treesitter parser not found for filetype: ' .. vim.bo[bufnr].filetype, vim.log.levels.ERROR)
    return
  end

  local tree = parser:parse()[1]
  if not tree then
    return
  end

  -- List of environments to ignore completely
  local excluded_envs = {
    table = true,
    tabular = true,
    tabularx = true,
    longtable = true,
    figure = true,
    ['figure*'] = true,
    ['table*'] = true,
  }

  local word_count = 0

  local function traverse(node)
    local ntype = node:type()

    if ntype:find 'comment' then
      return
    end

    if ntype == 'environment' or ntype == 'generic_environment' then
      local node_text = vim.treesitter.get_node_text(node, bufnr)
      local env_name = node_text:match '^\\begin%s*%{([^%}]+)%}'
      if env_name and excluded_envs[env_name] then
        return
      end
    end

    if ntype == 'command_name' then
      return
    end

    if ntype == 'text' then
      local text = vim.treesitter.get_node_text(node, bufnr)
      for _ in text:gmatch "[%w%-']+" do
        word_count = word_count + 1
      end
      return
    end

    -- Recurse through all child nodes
    for child in node:iter_children() do
      traverse(child)
    end
  end

  traverse(tree:root())
  vim.notify('Word count: ' .. word_count, vim.log.levels.INFO)
end

-- Create the :TexWordCount command
vim.api.nvim_create_user_command('TexWordCount', count_tex_words, {})

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

    M.insert_latex_table = function(rows, cols)
      rows = tonumber(rows) or 3
      cols = tonumber(cols) or 3

      -- Build alignment spec (e.g., "|c|c|c|")
      local align = '|' .. string.rep('c|', cols)

      local table_snippet = {
        '\\begin{table}[H]',
        '    \\centering',
        '    \\begin{tabular}{' .. align .. '}',
        '        \\hline',
      }

      -- Header row
      local header_cells = {}
      for c = 1, cols do
        table.insert(header_cells, 'Header ' .. c)
      end
      table.insert(table_snippet, '        ' .. table.concat(header_cells, ' & ') .. ' \\\\')
      table.insert(table_snippet, '        \\hline')

      -- Data rows
      for r = 1, rows do
        local row_cells = {}
        for c = 1, cols do
          table.insert(row_cells, string.format('Cell %d,%d', r, c))
        end
        table.insert(table_snippet, '        ' .. table.concat(row_cells, ' & ') .. ' \\\\')
      end

      -- Footer closing
      table.insert(table_snippet, '        \\hline')
      table.insert(table_snippet, '    \\end{tabular}')
      table.insert(table_snippet, '    \\caption{CAPTION}')
      table.insert(table_snippet, '    \\label{tab:some-table}')
      table.insert(table_snippet, '\\end{table}')

      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, table_snippet)
    end

    -- User command supporting argument parsing or UI prompt
    vim.api.nvim_create_user_command('InsertTable', function(opts)
      local args = vim.split(vim.trim(opts.args), '%s+')
      local rows, cols

      if #args == 1 and args[1]:find 'x' then
        local r, c = args[1]:match '(%d+)x(%d+)'
        rows, cols = tonumber(r), tonumber(c)
      elseif #args >= 2 then
        rows, cols = tonumber(args[1]), tonumber(args[2])
      end

      -- Prompt user if dimensions weren't provided in the command line
      if not rows or not cols then
        vim.ui.input({ prompt = 'Table dimensions (e.g., 5x5 or 5 5): ', default = '3x3' }, function(input)
          if not input or input == '' then
            return
          end
          local r, c = input:match '(%d+)%s*[x%s]%s*(%d+)'
          if r and c then
            M.insert_latex_table(r, c)
          else
            vim.notify('Invalid format. Use ROWSxCOLS (e.g. 5x5)', vim.log.levels.ERROR)
          end
        end)
      else
        M.insert_latex_table(rows, cols)
      end
    end, { nargs = '*' })

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
      local foldername = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

      local cmd = {
        'podman',
        'run',
        '--rm',
        '-v',
        vim.fn.getcwd() .. ':/work:z',
        '-w',
        '/work',
        'ghcr.io/jaller698/latex:latest',
        '-jobname=' .. foldername,
      }

      local open_cmd = {
        'xdg-open',
        './' .. foldername .. '.pdf',
      }

      print '🚀 Starting LaTeX build (containerized)...'
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
    end, { desc = 'Build LaTeX document in container and open PDF' })

    vim.keymap.set('n', '<leader>dp', '<cmd>BuildPDF<CR>', { buffer = true, desc = 'Build and view PDF' })
    vim.keymap.set('n', '<leader>df', '<cmd>InsertFigure<CR>', { buffer = true, desc = 'Insert LaTeX Figure' })
    vim.keymap.set('n', '<leader>ds', '<cmd>InsertSection<CR>', { buffer = true, desc = 'Insert LaTeX Section' })
    vim.keymap.set('n', '<leader>du', '<cmd>InsertSubsection<CR>', { buffer = true, desc = 'Insert LaTeX Subsection' })
    vim.keymap.set('n', '<leader>de', '<cmd>InsertEquation<CR>', { buffer = true, desc = 'Insert LaTeX Equation' })
    vim.keymap.set('n', '<leader>di', '<cmd>InsertItemize<CR>', { buffer = true, desc = 'Insert LaTeX Itemize List' })
    vim.keymap.set('n', '<leader>dC', '<cmd>TexWordCount<CR>', { buffer = true, desc = 'Count words in current Tex document (rendered)' })
    vim.keymap.set('n', '<leader>dt', '<cmd>InsertTable<CR>', { buffer = true, desc = 'Insert LaTeX Table' })
  end,
})
