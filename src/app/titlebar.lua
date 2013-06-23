local EventEmitter = require("lua-events").EventEmitter
local widget = require("widget")

display.setStatusBar(display.DarkStatusBar)

-- prevent scrolled content from shining through device's status bar
local statusbarshield = display.newRect(0, 0, display.contentWidth, display.topStatusBarContentHeight)
statusbarshield:setFillColor(0, 0, 0)


local titlebar = EventEmitter:new(
  display.newRect(0, 0, display.contentWidth, 48)
)
titlebar:setFillColor(0, 133, 161)

local caption = display.newText("", 0, 0, native.systemFont, 20)
caption:setTextColor(255, 255, 255)

local up = widget.newButton({
  width = titlebar.width, height = titlebar.height,
  defaultFile = "default.png", overFile = "over.png",
  onRelease = function ()
    titlebar:emit("up")
  end
})

local caret = display.newText("<", 0, 0, native.systemFont, 20)
caret:setTextColor(255, 255, 255)

local logo = display.newImage("favicon.ico", 0, 0)
logo.height = 32
logo.width = 32

local hr = {}
hr.background = display.newRect(0, 0, display.contentWidth, 2)
hr.background:setFillColor(0, 0, 0, 255)
hr[1] = display.newRect(0, 0, display.contentWidth, 1)
hr[1]:setFillColor(0, 133, 161, 200)
hr[2] = display.newRect(0, 0, display.contentWidth, 1)
hr[2]:setFillColor(0, 133, 161, 140)

local function setactive (bool)
  caret.isVisible = bool
  caption.isVisible = bool
  up:setEnabled(bool)
end

function titlebar:activate (text)
  if text and "string" == type(text) then
    caption.text = text
    caption.x = 0 + caption.contentWidth / 2 + up.contentWidth
  end
  setactive(true)
end

function titlebar:deactivate ()
  setactive(false)
end

function titlebar:getBottom()
  return self.y + self.contentHeight / 2
end

titlebar.y = display.topStatusBarContentHeight + titlebar.contentHeight / 2
logo.y = titlebar.y
up.y = titlebar.y
caret.y = titlebar.y
caption.y = titlebar.y
caret.x = 5 + caret.contentWidth / 2
logo.x = 3 + logo.contentWidth / 2 + caret.x + caret.contentWidth / 2
up.width = 5 + logo.x + logo.contentWidth / 2
up.x = up.contentWidth / 2
hr.background.y = titlebar:getBottom() - hr.background.contentHeight / 2
hr[1].y = hr.background.y - hr[1].contentHeight / 2
hr[2].y = hr[1].y + hr[1].contentHeight

titlebar:deactivate()

return titlebar
