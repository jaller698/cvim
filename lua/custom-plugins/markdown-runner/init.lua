local M = {}

local function run_python_code(code_block, callback)
  local output = ''
  vim.system({ 'python3' }, { stdin = { table.concat(code_block, '\n') } }, function(result)
    if result.code ~= 0 then
      output = 'Error executing Python code: ' .. result.stderr
    elseif result.stdout ~= '' then
      output = result.stdout
    else
      return
    end
    callback(output)
  end)
end

local function run_lua_code(code_block, callback)
  local output = ''
  local success, result = pcall(function()
    return load(table.concat(code_block, '\n'))()
  end)

  if not success then
    output = 'Error executing Lua code: ' .. result
  elseif type(result) == 'string' then
    output = result
  elseif type(result) == 'table' then
    output = table.concat(result, '\n')
  end

  callback(output)
end

local function run_c_code(code_block, callback)
  -- compile the C code to a temporary file
  local temp_file = vim.fn.tempname() .. '.c'
  local file = io.open(temp_file, 'w')
  local output = ''
  if not file then
    print 'Error creating temporary file for C code.'
    return
  end
  file:write(table.concat(code_block, '\n'))
  file:close()
  -- compile the C code
  local temp_bin_file = vim.fn.tempname() .. '.out'
  local c_compiler = vim.fn.executable 'gcc' == 1 and 'gcc' or 'clang'
  local compile_cmd = { c_compiler, temp_file, '-o', temp_bin_file }
  vim.system(compile_cmd, {}, function(result)
    if result.code ~= 0 then
      output = 'Error compiling C code: ' .. result.stderr
      return
    end
    -- run the compiled C code
    local run_cmd = { temp_bin_file }
    vim.system(run_cmd, {}, function(result)
      output = result.stdout
      if output == '' then
        output = ''
      end
      -- add return code to output
      output = output .. '\nReturn code: ' .. result.code
      callback(output)
    end)
  end)
end

local function run_cpp_code(code_block, callback)
  -- compile the C++ code to a temporary file
  local temp_file = vim.fn.tempname() .. '.cpp'
  local file = io.open(temp_file, 'w')
  local output = ''
  if not file then
    print 'Error creating temporary file for C++ code.'
    return
  end
  file:write(table.concat(code_block, '\n'))
  file:close()
  -- compile the C code
  local temp_bin_file = vim.fn.tempname() .. '.out'
  local cpp_compiler = vim.fn.executable 'g++' == 1 and 'g++' or 'clang++'
  local compile_cmd = { cpp_compiler, temp_file, '-o', temp_bin_file }
  vim.system(compile_cmd, {}, function(result)
    if result.code ~= 0 then
      output = 'Error compiling C++ code: ' .. result.stderr
      return
    end
    -- run the compiled C++ code
    local run_cmd = { temp_bin_file }
    vim.system(run_cmd, {}, function(result)
      output = result.stdout
      if output == '' then
        output = ''
      end
      -- add return code to output
      output = output .. '\nReturn code: ' .. result.code
      callback(output)
    end)
  end)
end

local function run_rust_code(code_block, callback)
  -- compile the Rust code to a temporary file
  local temp_file = vim.fn.tempname() .. '.rs'
  local file = io.open(temp_file, 'w')
  local output = ''
  if not file then
    print 'Error creating temporary file for Rust code.'
    return
  end
  file:write(table.concat(code_block, '\n'))
  file:close()
  -- compile the Rust code
  local temp_bin_file = vim.fn.tempname() .. '.out'
  local compile_cmd = { 'rustc', temp_file, '-o', temp_bin_file }
  vim.system(compile_cmd, {}, function(result)
    if result.code ~= 0 then
      output = 'Error compiling Rust code: ' .. result.stderr
      callback(output)
      return
    end
    -- run the compiled Rust code
    local run_cmd = { temp_bin_file }
    vim.system(run_cmd, {}, function(result)
      output = result.stdout
      if output == '' then
        output = ''
      end
      -- add return code to output
      output = output .. '\nReturn code: ' .. result.code
      callback(output)
    end)
  end)
end

local function run_bash_code(code_block, callback)
  local output = ''
  vim.system({ 'bash' }, { stdin = { table.concat(code_block, '\n') } }, function(result)
    if result.code ~= 0 then
      output = 'Error executing Bash code: ' .. result.stderr
    elseif result.stdout ~= '' then
      output = result.stdout
    else
      return
    end
    callback(output)
  end)
end

local function run_javascript_code(code_block, callback)
  local output = ''
  vim.system({ 'node' }, { stdin = { table.concat(code_block, '\n') } }, function(result)
    if result.code ~= 0 then
      output = 'Error executing JavaScript code: ' .. result.stderr
    elseif result.stdout ~= '' then
      output = result.stdout
    else
      return
    end
    callback(output)
  end)
end

local function run_typescript_code(code_block, callback)
  local output = ''
  vim.system({ 'ts-node' }, { stdin = { table.concat(code_block, '\n') } }, function(result)
    if result.code ~= 0 then
      output = 'Error executing TypeScript code: ' .. result.stderr
    elseif result.stdout ~= '' then
      output = result.stdout
    else
      return
    end
    callback(output)
  end)
end

local function run_go_code(code_block, callback)
  -- compile the Go code to a temporary file
  local temp_file = vim.fn.tempname() .. '.go'
  local file = io.open(temp_file, 'w')
  local output = ''
  if not file then
    print 'Error creating temporary file for Go code.'
    return
  end
  file:write(table.concat(code_block, '\n'))
  file:close()
  -- compile the Go code
  local temp_bin_file = vim.fn.tempname() .. '.out'
  local compile_cmd = { 'go', 'build', '-o', temp_bin_file, temp_file }
  vim.system(compile_cmd, {}, function(result)
    if result.code ~= 0 then
      output = 'Error compiling Go code: ' .. result.stderr
      return
    end
    -- run the compiled Go code
    local run_cmd = { temp_bin_file }
    vim.system(run_cmd, {}, function(result)
      output = result.stdout
      if output == '' then
        output = ''
      end
      -- add return code to output
      output = output .. '\nReturn code: ' .. result.code
      callback(output)
    end)
  end)
end

local function run_elixir_code(code_block, callback)
  local output = ''
  -- trim code_block from empty lines
  for i = #code_block, 1, -1 do
    if code_block[i]:match '^%s*$' then
      table.remove(code_block, i)
    else
      break
    end
  end

  vim.system({ 'iex' }, { stdin = { table.concat(code_block, '\n') } }, function(result)
    if result.code ~= 0 then
      output = 'Error executing Elixir code: ' .. result.stderr
    elseif result.stdout ~= '' then
      output = result.stdout
    else
      return
    end
    callback(output)
  end)
end

local function run_dart_code(code_block, callback)
  local output = ''
  -- first create a temporary Dart programming
  local dart_project_name = 'temp_dart_project'
  local tmp_dir = '/tmp/dart_projects' .. vim.fn.rand()
  -- ensure the temporary directory existing_rplugins
  vim.fn.mkdir(tmp_dir, 'p')
  local dart_project_path = tmp_dir .. '/' .. dart_project_name
  local dart_create = { 'dart', 'create', '--template', 'console', '--force', dart_project_path }
  vim.system(dart_create, {}, function(result)
    if result.code ~= 0 then
      output = 'Error creating Dart project: ' .. result.stderr
      callback(output)
      return
    end
    -- write the code block to the main.dart file
    local dart_file = dart_project_path .. '/bin/main.dart'
    local file = io.open(dart_file, 'w')
    if not file then
      output = 'Error creating Dart file.'
      callback(output)
      return
    end
    file:write(table.concat(code_block, '\n'))
    file:close()
    -- run the Dart code
    local dart_run_cmd = { 'dart', 'run', dart_file }
    vim.system(dart_run_cmd, {}, function(result)
      if result.code ~= 0 then
        output = 'Error executing Dart code: ' .. result.stderr
      elseif result.stdout ~= '' then
        output = result.stdout
      else
        output = ''
      end
      callback(output)
    end)
  end)
end

function M.run_block()
  -- 1. Detect current code block
  -- 2. Extract language and code
  -- 3. Run code and capture output
  -- 4. Insert output below
  local current_line = vim.api.nvim_get_current_line()
  -- Check if the currebt line is starting line
  local start_line = vim.fn.search('^```', 'bnW')
  if start_line == 0 and current_line:match '^```' then
    start_line = vim.fn.line '.'
  end
  local end_line = vim.fn.search('^```', 'W')
  if end_line == 0 and current_line:match '^```' then
    end_line = vim.fn.line '.'
  end
  if start_line == 0 or end_line == 0 or start_line >= end_line then
    if start_line == 0 then
      print 'No starting code block found.'
    elseif end_line == 0 then
      print 'No ending code block found.'
    elseif start_line >= end_line then
      print 'Starting code block is after the ending code block.'
    end
    return
  end

  local code_block = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- print('Detected code block from line ' .. start_line .. ' to ' .. end_line)
  -- look at the first line of the code block to determine the language
  local language = nil
  if #code_block > 0 then
    local first_line = code_block[1]
    if first_line:match '^```%s*(%S+)' then
      language = first_line:match '^```%s*(%S+)'
      -- Remove the language line from the code block
      table.remove(code_block, 1)
    end
  else
    print 'Code block is empty.'
    return
  end

  if not language then
    print 'No language specified in code block.'
    return
  end

  -- remove starting and ending lines from the code block
  if code_block[1]:match '^```' then
    table.remove(code_block, 1) -- remove starting line
  end
  if code_block[#code_block]:match '^```' then
    table.remove(code_block, #code_block) -- remove ending line
  end
  local shell_path = vim.o.shell or '/bin/sh'
  local shell = vim.fn.fnamemodify(shell_path, ':t')

  local function insert_output(output)
    vim.schedule(function()
      -- Remove existing output block if present
      local output_block_start = vim.fn.search('^```' .. shell, 'nW')
      if output_block_start ~= 0 then
        local output_block_end = vim.fn.search('^```*$', 'nW')
        if output_block_end ~= 0 then
          vim.api.nvim_buf_set_lines(0, output_block_start - 1, output_block_end, false, {})
        end
      end
      if output ~= '' then
        local output_lines = vim.split(output, '\n')
        local output_block = { '```' .. shell }
        for _, line in ipairs(output_lines) do
          if line ~= '' then
            table.insert(output_block, '>> ' .. line)
          end
        end
        table.insert(output_block, '```')
        vim.api.nvim_buf_set_lines(0, end_line, end_line, false, output_block)
      end
    end)
  end

  -- 5. Run the code block using the specified language
  local output = ''
  if language == 'lua' then
    run_lua_code(code_block, insert_output)
  elseif language == 'python' then
    run_python_code(code_block, insert_output)
  elseif language == 'cpp' or language == 'c++' then
    run_cpp_code(code_block, insert_output)
  elseif language == 'c' then
    run_c_code(code_block, insert_output)
  elseif language == 'rust' then
    run_rust_code(code_block, insert_output)
  elseif language == 'sh' or language == 'bash' then
    run_bash_code(code_block, insert_output)
  elseif language == 'javascript' or language == 'js' then
    run_javascript_code(code_block, insert_output)
  elseif language == 'typescript' or language == 'ts' then
    run_typescript_code(code_block, insert_output)
  elseif language == 'go' then
    run_go_code(code_block, insert_output)
  elseif language == 'elixir' then
    run_elixir_code(code_block, insert_output)
  elseif language == 'dart' then
    run_dart_code(code_block, insert_output)
  else
    print('Unsupported language: ' .. language)
    return
  end
end

-- Define user command to run block
function M.setup()
  vim.api.nvim_create_user_command('RunBlock', M.run_block, {
    desc = 'Run the current code block and display output',
    nargs = 0,
  })
end

return M
