local EventEmitter = require("lua-events").EventEmitter
local widget = require("widget")

local login = EventEmitter:new()

local fields = {
  uid = nil,
  pwd = nil
}

local function input (event)
  if event.phase == "began" then
  elseif event.phase == "ended" then
  elseif event.phase == "ended" or event.phase == "submitted" then
  elseif event.phase == "editing" then
  end
end

local shade, form
function login:init(top)
  local width, height = display.viewableContentWidth, display.viewableContentHeight - top
  shade = display.newRect(0, top, width, height) shade:setFillColor(0, 0, 0)
  form = display.newGroup()
  local bg = display.newRect(form, 0, top, width, height) bg:setFillColor(255, 255, 255)
  top = top + 16
  fields.uid = native.newTextField(16, top + 4, width - 32, 40) fields.uid:addEventListener("userInput", input)
  fields.uid.text = "Gebruikersnaam"
  fields.uid.basex = fields.uid.x
  fields.uid:setReturnKey("next")
  top = top + 48
  fields.pwd = native.newTextField(16, top + 4, width - 32, 40) fields.pwd:addEventListener("userInput", input)
  fields.pwd.text = "Wachtwoord"
  fields.pwd.basex = fields.pwd.x
  fields.pwd:setReturnKey("go")
  top = top + 48
  local button = widget.newButton({
    label = "Inloggen",
    left = width - 16 - 96, top = top + 4, width = 96, height = 40,
    font = "Roboto-Regular", fontSize = 14,
    onRelease = function ()
      for k,v in pairs(fields) do
        print(k,v)
      end
      -- TODO: check credentials from textFields on the server,
      -- which on success will presumably return some userinfo object,
      -- and a token providing access to the user's resources on the server
      login:emit("authenticated", userinfo, accesstoken)
    end
  }) form:insert(button)
  top = top + 48
  local tableview = widget.newTableView({
    left = 16, top = top + 4, width = width - 32, height = height - top - 4 - 16,
    onRowRender = function (event)
      local row = event.row
      local text = display.newText(row, row.id, 0, 0, native.systemFont, 12)
      text.x = 4 + row.x - row.contentWidth / 2 + text.contentWidth / 2
      text.y = row.contentHeight / 2
      text:setTextColor(0, 0, 0)
    end
  }) form:insert(tableview)
  for _,font in ipairs(native.getFontNames()) do
    tableview:insertRow({
      id = font,
      rowHeight = 20
    })
  end
end

local time = 400
local function slide (values)
  transition.to(form, {
    time = time,
    transition = easing.outExpo,
    x = values.x
  })
  for _,field in pairs(fields) do
    transition.to(field, {
      time = time,
      transition = easing.outExpo,
      x = field.basex + values.x
    })
  end
  transition.to(shade, {
    time = time,
    transition = easing.outExpo,
    alpha = values.alpha
  })
end

function login:show ()
  slide({x = 0, alpha = 1})
end

function login:hide ()
  timer.performWithDelay(1000, function ()
    slide({x = form.contentWidth, alpha = 0})
  end)
end

return login
