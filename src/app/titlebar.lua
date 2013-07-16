local EventEmitter = require("lua-events").EventEmitter
local widget = require("widget")

local width = display.viewableContentWidth
local height = 48
local r, g, b = 194, 229, 242
local font = "Roboto-Regular"

local titlebar = EventEmitter:new()

function titlebar:getBottom ()
  return height
end

local group, up, caret, caption = display.newGroup()

function titlebar:init ()
  if group.numChildren > 0 then return end

  local bar = display.newRect(group, 0, 0, width, height)
  bar:setFillColor(r, g, b)
  
  up = widget.newButton({
    width = bar.width, height = bar.height,
    defaultFile = "button-default.png", overFile = "button-over.png",
    onRelease = function ()
      self:emit("up") return true
    end
  }) group:insert(up)

  caret = display.newImage(group, "1_navigation_previous_item.png", 0, 0)
  caret.height, caret.width = 20, 20

  local logo = display.newImage(group, "Icon-ldpi.png", 0, 0)
  local ratio = logo.width / logo.height
  logo.height, logo.width = 24, 24 * ratio

  caption = display.newText(group, "", 0, 0, font, 18)
  caption:setTextColor(0, 0, 0, 200)

  local hr = {}
  hr.background = display.newRect(group, 0, 0, width, 2)
  hr.background:setFillColor(0, 0, 0, 255)
  hr[1] = display.newRect(group, 0, 0, width, 1)
  hr[1]:setFillColor(r, g, b, 200)
  hr[2] = display.newRect(group, 0, 0, width, 1)
  hr[2]:setFillColor(r, g, b, 140)

  bar.y = bar.contentHeight / 2
  for _,displayobject in ipairs({up, caret, logo, caption}) do
    displayobject.y = bar.y
  end
  caret.x = -3 + caret.contentWidth / 2
  logo.x = -3 + logo.contentWidth / 2 + caret.x + caret.contentWidth / 2
  up.width = 5 + logo.x + logo.contentWidth / 2
  up.x = up.contentWidth / 2
  hr.background.y = titlebar:getBottom() - hr.background.contentHeight / 2
  hr[1].y = hr.background.y - hr[1].contentHeight / 2
  hr[2].y = hr[1].y + hr[1].contentHeight

  titlebar:deactivate()
end

function titlebar:setcaption (text, options)
  if text and "string" == type(text) then
    caption.text = text
    caption.x = caption.contentWidth / 2 + up.contentWidth
  end
  options = options or {}
  transition.to(caption, {
    time = 400,
    transition = easing.outExpo,
    alpha = (options.alpha or 1),
    onStart = options.onStart,
    onComplete = options.onComplete
  })
end

local function setactive (bool, text)
  local alpha, onStart, onComplete = 0, function ()
    caret.isVisible = bool
    up:setEnabled(bool)
  end
  if bool then alpha, onComplete, onStart = 1, onStart, onComplete end
  titlebar:setcaption(text, {alpha = alpha, onStart = onStart, onComplete = onComplete})
end

function titlebar:activate (text)
  setactive(true, text)
end

function titlebar:deactivate ()
  setactive(false)
end

function titlebar:addbutton (name, imagepath)
  local api = EventEmitter:new()
  local buttongroup = display.newGroup()

  local button = widget.newButton({
    width = height, height = height,
    defaultFile = "button-default.png", overFile = "button-over.png",
    onPress = function ()
      api:emit("press") return true
    end,
    onRelease = function ()
      api:emit("release") return true
    end
  }) buttongroup:insert(button)

  local image = display.newImage(buttongroup, imagepath)
  image.x, image.y = button.x, button.y
  image.width, image.height = button.width * 5 / 6, button.height * 5 / 6

  group:insert(buttongroup)
  buttongroup.x = width - buttongroup.contentWidth

  function api:show ()
    buttongroup.isVisible = true
  end

  function api:hide ()
    buttongroup.isVisible = false
  end

  function api:bounds ()
    local bounds = image.contentBounds
    local res = {
      left = bounds.xMin,
      top = bounds.yMin,
      width = bounds.xMax - bounds.xMin,
      height = bounds.yMax - bounds.yMin
    }
    res.left = res.left + res.width / 6
    res.top = res.top + res.height / 6
    res.width = res.width * 4 / 6
    res.height = res.height * 4 / 6
    return res
  end

  return api
end

return titlebar
