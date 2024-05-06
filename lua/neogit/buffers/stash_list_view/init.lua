local Buffer = require("neogit.lib.buffer")
local config = require("neogit.config")
local CommitViewBuffer = require("neogit.buffers.commit_view")

local ui = require("neogit.buffers.stash_list_view.ui")

---@class StashListBuffer
---@field stashes StashEntry[]
local M = {}
M.__index = M

--- Gets all current stashes
function M.new(stashes)
  local instance = {
    stashes = stashes,
  }

  setmetatable(instance, M)
  return instance
end

function M:close()
  self.buffer:close()
  self.buffer = nil
end

--- Creates a buffer populated with output of `git stash list`
--- and supports related operations.
function M:open()
  self.buffer = Buffer.create {
    name = "NeogitStashView",
    filetype = "NeogitStashView",
    kind = config.values.stash.kind,
    context_higlight = true,
    -- Define the available mappings here. `git stash list` has the same options
    -- as `git log` refer to git-log(1) for more info.
    mappings = {
      n = {
        ["q"] = function()
          self:close()
        end,
        ["<esc>"] = function()
          self:close()
        end,
        ["<enter>"] = function()
          -- Still looking for how to view a stash
          CommitViewBuffer.new(self.buffer.ui:get_commit_under_cursor()):open()
        end,
      }
    },
    after = function()
      vim.cmd([[setlocal nowrap]])
    end,
    render = function()
      return ui.View(self.stashes)
    end,
  }
end

return M
