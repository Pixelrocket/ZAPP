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
      timer.performWithDelay(1000, function ()
        self:emit("authenticated", userinfo, accesstoken)
        self:hide()
      end)
    end
  }) form:insert(button)
  top = top + 48
  local tableview = widget.newTableView({
    left = 16, top = top + 4, width = width - 32, height = height - top - 4 - 16,
    onRowRender = function (event)
      local row = event.row
      local text = display.newText(row, row.id, 0, 0, row.id, 18)
      text.x = 4 + row.x - row.contentWidth / 2 + text.contentWidth / 2
      text.y = row.contentHeight / 2
      text:setTextColor(0, 0, 0)
    end
  }) form:insert(tableview)
  for _,font in ipairs(native.getFontNames()) do
    tableview:insertRow({
      id = font
    })
  end
end

local function slide (time, x, alpha)
  transition.to(form, {
    time = time,
    transition = easing.outExpo,
    x = x
  })
  for _,field in pairs(fields) do
    transition.to(field, {
      time = time,
      transition = easing.outExpo,
      x = field.basex + x
    })
  end
  transition.to(shade, {
    time = time,
    transition = easing.outExpo,
    alpha = alpha
  })
end

function login:show ()
  slide(400, 0, 1)
end

function login:hide ()
  slide(1200, form.contentWidth, 0)
end

return login
