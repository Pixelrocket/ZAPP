local EventEmitter = require("lua-events").EventEmitter
local widget = require("widget")

local placeholders = {}
local fields = {}

local function input (event)
  local textfield = event.target
  if event.phase == "began" then
  elseif event.phase == "ended" or event.phase == "submitted" then
    local placeholder = placeholders[textfield]
    placeholder:deactivate()
  elseif event.phase == "editing" then
  end
end

local width = display.viewableContentWidth

local function createtextfield (top, hint, returnKey)
  local group = display.newGroup()

  local line = display.newLine(group, 16,top + 44, 16,top + 48)
  line:append(width - 16,top + 48, width - 16,top + 44)
  line:setColor(153, 153, 153)

  local placeholdertext = display.newText(group, hint, 16 + 9, top + 8, width - 32 - 13, 40, "Roboto-Regular", 18)
  placeholdertext:setTextColor(153, 153, 153)

  local textfield

  function placeholdertext:touch (event)
    if event.phase == "ended" then
      line:setColor(0, 153, 204)
      line.width = 2
      textfield = native.newTextField(16, top + 4, width - 32, 40)
      textfield.font = native.newFont("Roboto-Regular", 18)
      textfield.hasBackground = false
      placeholdertext.isVisible = false
      textfield:setReturnKey(returnKey)
      textfield:addEventListener("userInput", input)
      native.setKeyboardFocus(textfield)
      placeholders[textfield] = group
    end
    return true
  end 
  placeholdertext:addEventListener("touch", text)

  function group:deactivate ()
    local text = textfield.text
    placeholders[textfield] = nil
    textfield:removeSelf()
    fields[hint] = text
    placeholdertext.text = text
    placeholdertext.isVisible = true
    line:setColor(153, 153, 153)
    line.width = 1
  end

  return group
end

local login, group = EventEmitter:new(), display.newGroup()

function login:init(top)
  if group.numChildren > 0 then return end
  local height = display.viewableContentHeight - top
  local bg = display.newRect(group, 0, top, width, height) bg:setFillColor(255, 255, 255)
  top = top + 16
  local uid = createtextfield(top, "Gebruikersnaam", "next") -- hilhorst averschuur
  group:insert(uid)
  top = top + 48
  local pwd = createtextfield(top, "Wachtwoord", "go") -- 171049 huurcave-4711
  group:insert(pwd)
  top = top + 48
  local button = widget.newButton({
    label = "Inloggen",
    left = 16, top = top + 4, width = width - 32, height = 40,
    font = "Roboto-Regular", fontSize = 18,
    onRelease = function ()
      for k,v in pairs(fields) do
        print(k,v)
      end
      -- TODO: check credentials from textFields on the server,
      -- which on success will presumably return some userinfo object,
      -- and a token providing access to the user's resources on the server
      timer.performWithDelay(500, function ()
        self:emit("authenticated", userinfo, accesstoken)
        self:hide()
      end)
    end
  }) group:insert(button)
  top = top + 48
end

function login:show ()
  local time = 400
  group.alpha = 1
  transition.from(group, {
    time = time,
    transition = easing.outExpo,
    x = group.contentWidth
  })
end

function login:hide ()
  local time = 1200
  transition.to(group, {
    time = time,
    transition = easing.outExpo,
    alpha = 0
  })
end

return login
