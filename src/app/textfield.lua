local EventEmitter = require("lua-events").EventEmitter

local TextField = {}

function TextField:new (width, hint, returnKey, isSecure)
  local group = EventEmitter:new(display.newGroup())
  local value, textfield = ""

  local line = display.newLine(group, 0,40, 0,44)
  line:append(width,44, width,40)
  line:setColor(153, 153, 153)

  local placeholdertext = display.newText(group, hint, 9, 8, width - 13, 40, "Roboto-Regular", 18)
  placeholdertext:setTextColor(153, 153, 153)

  local function setvalue (newvalue)
    local oldvalue = value
    value = newvalue
    if value ~= oldvalue then
      group:emit("change", hint, value)
    end
  end

  local function finish (submit)
    if textfield then
      textfield.isVisible = false
      textfield:removeSelf() textfield = nil
    end
    placeholdertext:setTextColor(0, 0, 0)
    local text = value
    if text == "" then
      text = hint
      placeholdertext:setTextColor(153, 153, 153)
    elseif isSecure then
      text = string.gsub(text, ".", "*")
    end
    placeholdertext.text = text
    placeholdertext.isVisible = true
    line:setColor(153, 153, 153)
    line.width = 1
    if submit then group:emit("submit") end
  end

  local function input (event)
    if event.phase == "began" then
      placeholdertext.text = hint
      setvalue("")
    elseif event.phase == "ended" then
      finish()
    elseif event.phase == "submitted" then
      finish(true)
    elseif event.phase == "editing" then
      placeholdertext.isVisible = false
      setvalue(textfield.text)
    end
  end

  local function focus ()
    placeholdertext:setTextColor(153, 153, 153)
    line:setColor(0, 153, 204)
    line.width = 2
    -- trial and error positioning ftw ;-)
    local left, top = placeholdertext:contentToLocal(placeholdertext.x, placeholdertext.y)
    textfield = native.newTextField(0 - left, 4 - top, width, 40)
    textfield.font = native.newFont("Roboto-Regular", 18)
    textfield.hasBackground = false
    textfield.isSecure = isSecure or false
    textfield:setReturnKey(returnKey)
    textfield:addEventListener("userInput", input)
    native.setKeyboardFocus(textfield)
    textfield.fieldgroup = group
  end

  function placeholdertext:touch (event)
    if event.phase == "ended" then
      focus()
    end
    return true
  end placeholdertext:addEventListener("touch", placeholdertext)

  function group:focus () focus() end
  function group:finish () finish() end
  function group:value () return value end
  function group:reset () value = "" finish() end

  return group
end

return TextField

