local nnoremap = require("keymap").nnoremap
local wk = require("which-key")

return {
  "ThePrimeagen/harpoon",
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    wk.register({ j = { name = "jump" } }, { prefix = "<leader>" })

    nnoremap("<leader>ja", mark.add_file, { desc = "Add file to harpoon" })
    nnoremap("<leader>jm", ui.toggle_quick_menu, { desc = "Toggle harpoon menu" })

    -- Set keys
    local keys = { "q", "w", "e", "r", "t", "y" }

    for i, k in pairs(keys) do
      nnoremap("<leader>j" .. k, function()
        ui.nav_file(i)
      end, { desc = "Harpoon: Navigate to file " .. i })
    end
  end,
}
