local EventEmitter = require("lua-events").EventEmitter
local widget = require("widget")

local height = 48
local r, g, b = 0, 133, 161
local font = "Roboto-Regular"

local titlebar = EventEmitter:new()
local up, caret, caption

function titlebar:getBottom ()
  return display.topStatusBarContentHeight + height
end

function titlebar:init ()
  display.setStatusBar(display.DarkStatusBar)
  -- prevent scrolled content from shining through device's status bar
  local statusbarshield = display.newRect(0, 0, display.contentWidth, display.topStatusBarContentHeight)
  statusbarshield:setFillColor(0, 0, 0)

  local bar = display.newRect(0, 0, display.contentWidth, height)
  bar:setFillColor(r, g, b)
  
  up = widget.newButton({
    width = bar.width, height = bar.height,
    defaultFile = "default.png", overFile = "over.png",
    onRelease = function ()
      self:emit("up")
    end
  })
  
  caret = display.newText("<", 0, 0, font, 20)

  local logo = display.newImage("logo_zilliz_kleur_laag.png", 0, 0)
  local ratio = logo.width / logo.height
  logo.height, logo.width = 20, 20 * ratio

  caption = display.newText("", 0, 0, font, 20)

  local hr = {}
  hr.background = display.newRect(0, 0, display.contentWidth, 2)
  hr.background:setFillColor(0, 0, 0, 255)
  hr[1] = display.newRect(0, 0, display.contentWidth, 1)
  hr[1]:setFillColor(r, g, b, 200)
  hr[2] = display.newRect(0, 0, display.contentWidth, 1)
  hr[2]:setFillColor(r, g, b, 140)

  bar.y = display.topStatusBarContentHeight + bar.contentHeight / 2
  for _,displayobject in ipairs({up, caret, logo, caption}) do
    displayobject.y = bar.y
  end
  caret.x = 5 + caret.contentWidth / 2
  logo.x = 3 + logo.contentWidth / 2 + caret.x + caret.contentWidth / 2
  up.width = 5 + logo.x + logo.contentWidth / 2
  up.x = up.contentWidth / 2
  hr.background.y = titlebar:getBottom() - hr.background.contentHeight / 2
  hr[1].y = hr.background.y - hr[1].contentHeight / 2
  hr[2].y = hr[1].y + hr[1].contentHeight

  titlebar:deactivate()
end

local function setactive (bool)
  local alpha, onStart, onComplete = 0, function ()
    caret.isVisible = bool
    up:setEnabled(bool)
  end
  if bool then alpha, onComplete, onStart = 1, onStart, onComplete end
  transition.to(caption, {
    time = 400,
    transition = easing.outExpo,
    alpha = alpha,
    onStart = onStart,
    onComplete = onComplete
  })
end

function titlebar:activate (text)
  if text and "string" == type(text) then
    caption.text = text
    caption.x = 2 + caption.contentWidth / 2 + up.contentWidth
  end
  setactive(true)
end

function titlebar:deactivate ()
  setactive(false)
end

return titlebar
