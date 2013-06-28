local EventEmitter = require("lua-events").EventEmitter
local widget = require("widget")

local login = EventEmitter:new()

local group
function login:init(top)
  group = display.newGroup()
  local width, height = display.viewableContentWidth, display.viewableContentHeight - top
  local rect = display.newRect(group, 0, top, width, height)
  rect:setFillColor(100, 100, 100, 100)
  local line = display.newLine(group, -5, rect.y - rect.contentHeight / 2, -5, rect.y + rect.contentHeight / 2)
  line:setColor(0, 0, 0, 100)
  line.width = 10
  local button = widget.newButton({
    label = "inloggen",
    left = 16, top = top + 16,
    width = 96, height = 48,
    font = "Roboto-Regular", fontSize = 14,
    onRelease = function ()
      -- TODO: check credentials from textFields on the server,
      -- which on success will presumably return some userinfo object,
      -- and a token providing access to the user's resources on the server
      login:emit("authenticated", userinfo, accesstoken)
    end
  })
  group:insert(button)
end

function login:show ()
  transition.to(group, {
    time = 2000,
    transition = easing.outExpo,
    x = 0
  })
end

function login:hide ()
  transition.to(group, {
    time = 2000,
    transition = easing.outExpo,
    x = group.contentWidth
  })
end

return login
