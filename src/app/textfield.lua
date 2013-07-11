local EventEmitter = require("lua-events").EventEmitter

local TextField = {}

local font = "Roboto-Regular"

function TextField:new (width, hint, returnKey, isSecure)
  local group = EventEmitter:new(display.newGroup())
  local value = ""

  local line = display.newLine(group, 1,40, 1,44)
  line:append(width,44, width,40)
  line:setColor(153, 153, 153)

  local placeholdertext = display.newText(group, hint, 9, 8, width - 13, 40, font, 18)
  placeholdertext:setTextColor(153, 153, 153)

  local function setvalue (newvalue)
    local oldvalue = value
    value = newvalue
    if value ~= oldvalue then
      group:emit("change", value)
    end
    if "" == value then
      placeholdertext.text = hint
      placeholdertext:setTextColor(153, 153, 153)
      placeholdertext.isVisible = true
    else
      placeholdertext.isVisible = false
    end
  end

  local function finish ()
    if "" ~= value then
      local text = value
      if isSecure then text = string.gsub(value, ".", "•") end
      placeholdertext.text = text
      placeholdertext:setTextColor(0, 0, 0)
    end
    placeholdertext.isVisible = true
    line:setColor(153, 153, 153)
    line.width = 1
  end

  local prev
  local function input (event)
    local phase = event.phase
    if "editing" == phase then
      setvalue(event.text)
    elseif "ended" == phase
    and "ended" ~= prev and "submitted" ~= prev then
      finish()
      event.target:removeSelf()
    elseif "submitted" == phase
    and "ended" ~= prev and "submitted" ~= prev then
      finish()
      event.target:removeSelf()
      group:emit("submit")
    end
    prev = phase
  end

  local function focus ()
    setvalue("")
    line:setColor(0, 153, 204)
    line.width = 2
    -- trial and error positioning ftw ;-)
    local left, top = placeholdertext:contentToLocal(placeholdertext.x, placeholdertext.y)
    local textfield = native.newTextField(-1 - left, 4 - top, width, 40)
    textfield.font = native.newFont(font, 18)
    textfield.hasBackground = false
    textfield.isSecure = isSecure or false
    textfield:setReturnKey(returnKey)
    textfield:addEventListener("userInput", input)
    native.setKeyboardFocus(textfield)
  end

  local function touch (event)
    if "ended" == event.phase then focus() end
    return true
  end placeholdertext:addEventListener("touch", touch)

  function group:focus () focus() end
  function group:value () return value end
  function group:reset () setvalue("") finish() end

  return group
end

return TextField

