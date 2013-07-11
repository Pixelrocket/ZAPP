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

  local function finish ()
    local text, shade = value, 0
    if "" == text   then text, shade = hint, 153
    elseif isSecure then text = string.gsub(text, ".", "•") end
    placeholdertext.text = text
    placeholdertext:setTextColor(shade, shade, shade)
    placeholdertext.isVisible = true
    line:setColor(153, 153, 153)
    line.width = 1
    textfield = nil
  end

  local function input (event)
    local phase, target = event.phase, event.target
    if "editing" == phase then
      setvalue(target.text)
    elseif "ended" == phase or "submitted" == phase then
      finish()
      target.isVisible = false
      target:removeSelf()
      if "submitted" == phase then group:emit("submit") end
    end
  end

  local function focus ()
    line:setColor(0, 153, 204)
    line.width = 2
    -- trial and error positioning ftw ;-)
    local left, top = placeholdertext:contentToLocal(placeholdertext.x, placeholdertext.y)
    textfield = native.newTextField(-1 - left, 4 - top, width, 40)
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

