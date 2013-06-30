local EventEmitter = require("lua-events").EventEmitter
local widget = require("widget")

local fields = {
  uid = nil,
  pwd = nil
}

local placeholders = {}

local function input (event)
  local textfield = event.target
  if event.phase == "began" then
  elseif event.phase == "ended" or event.phase == "submitted" then
    local placeholder = placeholders[textfield]
    placeholder.text = textfield.text
    textfield.isVisible = false
    placeholder.isVisible = true
    placeholders[textfield] = nil
    textfield:removeSelf()
  elseif event.phase == "editing" then
  end
end

local width = display.viewableContentWidth

local function textfield (top, hint, returnKey)
  local group = display.newGroup()

  local line = display.newLine(group, 16,top + 44, 16,top + 48)
  line:append(width - 16,top + 48, width - 16,top + 44)
  line:setColor(153, 153, 153)

  local text = display.newText(group, hint, 16 + 4, top + 4, width - 32 - 8, 40, "Roboto-Regular", 18)
  text:setTextColor(153, 153, 153)

  function text:touch (event)
    if event.phase == "ended" then
      textfield = native.newTextField(16, top + 4, width - 32, 40)
      textfield.font = native.newFont("Roboto-Regular", 18)
      textfield.hasBackground = false
      textfield:setReturnKey(returnKey)
      textfield:addEventListener("userInput", input)
      native.setKeyboardFocus(textfield)
      placeholders[textfield] = text
      text.isVisible = false
    end
    return true
  end 
  text:addEventListener("touch", text)

  return group
end

local login, group = EventEmitter:new(), display.newGroup()

function login:init(top)
  if group.numChildren > 0 then return end
  local height = display.viewableContentHeight - top
  local bg = display.newRect(group, 0, top, width, height) bg:setFillColor(255, 255, 255)
  top = top + 16
  local uid = textfield(top, "Gebruikersnaam", "next")
  group:insert(uid)
  top = top + 48
  fields.pwd = native.newTextField(16, top + 4, width - 32, 40) fields.pwd:addEventListener("userInput", input)
  fields.pwd.text = "Wachtwoord"
  fields.pwd:setReturnKey("go")
  top = top + 48
  local button = widget.newButton({
    label = "Inloggen",
    left = width - 16 - 96, top = top + 4, width = 96, height = 40,
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
  local tableview = widget.newTableView({
    left = 16, top = top + 4, width = width - 32, height = height - top - 4 - 16,
    onRowRender = function (event)
      local row = event.row
      local text = display.newText(row, row.id, 0, 0, row.id, 14)
      text.x = 4 + row.x - row.contentWidth / 2 + text.contentWidth / 2
      text.y = row.contentHeight / 2
      text:setTextColor(0, 0, 0)
    end
  }) group:insert(tableview)
  for _,font in ipairs(native.getFontNames()) do
    tableview:insertRow({
      id = font
    })
  end
end

function login:show ()
  local time = 400
  group.alpha = 1
  transition.from(group, {
    time = time,
    transition = easing.outExpo,
    x = group.contentWidth
  })
  for _,field in pairs(fields) do
    field.alpha = 1
    field.isVisible = true
    transition.from(field, {
      time = time,
      transition = easing.outExpo,
      x = field.x + group.contentWidth
    })
  end
end

function login:hide ()
  local time = 1200
  transition.to(group, {
    time = time,
    transition = easing.outExpo,
    alpha = 0
  })
  for _,field in pairs(fields) do
    transition.to(field, {
      time = time,
      transition = easing.outExpo,
      alpha = 0,
      onComplete = function ()
        field.isVisible = false
      end
    })
  end
end

return login
