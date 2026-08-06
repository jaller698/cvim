return {
  {
    'atiladefreitas/dooing',
    cmd = 'Dooing',
    config = function()
      require('dooing').setup {
        -- your custom config here (optional)
      }
    end,
  },

  {
    'atiladefreitas/bloocky',
    config = function()
      require('bloocky').setup
      {

          -- First day of the week: "sunday" | "monday"
          week_start = "monday",

          -- Visible hour range in the day and week views
          hours = {
              start = 6,     -- first hour shown (05:00)
              ["end"] = 23,  -- last hour shown (22:00)
          },

          -- Bring tasks from other plugins into the calendar
          integrations = {
              dooing = {
                  enabled = true,   -- show Dooing todos on their due date
                  show_done = true, -- also show completed todos
              },
          },

          keymaps = {
              toggle = "<leader>tb",
          },
      }
    end,
  },
}
