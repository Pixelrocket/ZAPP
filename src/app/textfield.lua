local EventEmitter = require("lua-events").EventEmitter

local TextField = {}

local font = "Roboto-Regular"

function TextField:new (width, hint, returnKey, isSecure)
  local group = EventEmitter:new(display.newGroup())
  local value, textfield = ""

  local line = display.newLine(group, 1,40, 1,44)
  line:append(width,44, width,40)
  line:setColor(153, 153, 153)

  local placeholdertext = display.newText(group, hint, 9, 8, width - 13, 40, font, 18)
  placeholdertext:setTextColor(153, 153, 153)

  local function setvalue (newvalue)
    local oldvalue = value
    value = newvalue
    if value ~= oldvalue then
      group:emit("change", hint, value)
    end
    placeholdertext.isVisible = false
  end

  local function finish (submit)
    if textfield then
      textfield.isVisible = false
      textfield:removeSelf() textfield = nil
    end
    local text = value
    if "" == text then
      text = hint
      placeholdertext:setTextColor(153, 153, 153)
    elseif isSecure then
      text = string.gsub(text, ".", "•")
    end
    placeholdertext.text = text
    placeholdertext:setTextColor(0, 0, 0)
    placeholdertext.isVisible = true
    line:setColor(153, 153, 153) line.width = 1
    if submit then group:emit("submit") end
  end

  local function input (event)
    local phase = event.phase
    if     "editing"   == phase then
      setvalue(textfield.text)
    elseif "ended"     == phase then
      finish()
    elseif "submitted" == phase then
      finish(true)
    end
  end

  local function focus ()
    line:setColor(0, 153, 204) line.width = 2
    -- trial and error positioning ftw ;-)
    local left, top = placeholdertext:contentToLocal(placeholdertext.x, placeholdertext.y)
    textfield = native.newTextField(0 - left, 4 - top, width, 40)
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
  function group:finish () finish() end
  function group:value () return value end
  function group:reset () setvalue("") finish() end

  return group
end

return TextField

