return {
  'jaller698/esp32.nvim',
  name = 'esp32.nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  opts = {
    build_dir = 'build',
  },
  config = function(_, opts)
    require('esp32').setup(opts)
  end,
  keys = {
    {
      '<leader>Es',
      function()
        vim.cmd 'EspSetup'
      end,
      desc = 'ESP32: Setup ESP-IDF environment',
    },
    {
      '<leader>EP',
      function()
        require('esp32').pick 'project'
      end,
      desc = 'ESP32: Pick & Build Project',
    },
    {
      '<leader>Eb',
      function()
        require('esp32').command 'build'
      end,
      desc = 'ESP32: Build Project',
    },
    {
      '<leader>EM',
      function()
        require('esp32').pick 'monitor'
      end,
      desc = 'ESP32: Monitor',
    },
    {
      '<leader>Em',
      function()
        require('esp32').command 'monitor'
      end,
      desc = 'ESP32: Monitor',
    },
    {
      '<leader>EF',
      function()
        require('esp32').pick 'flash'
      end,
      desc = 'ESP32: Pick & Flash',
    },
    {
      '<leader>Ef',
      function()
        require('esp32').command 'flash'
      end,
      desc = 'ESP32: Flash',
    },
    {
      '<leader>Ec',
      function()
        require('esp32').command 'menuconfig'
      end,
      desc = 'ESP32: Configure',
    },
    {
      '<leader>EC',
      function()
        require('esp32').command 'clean'
      end,
      desc = 'ESP32: Clean',
    },
    { '<leader>Rr', ':ESPReconfigure<CR>', desc = 'ESP32: Reconfigure project' },
    { '<leader>Ri', ':ESPInfo<CR>', desc = 'ESP32: Project Info' },
  },
}
