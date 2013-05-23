local EventEmitter = require("EventEmitter")

display.setStatusBar(display.DarkStatusBar)

-- prevent scrolled content from shining through device's status bar
local statusbarshield = display.newRect(0, 0, display.contentWidth, display.topStatusBarContentHeight)
statusbarshield:setFillColor(0, 0, 0)

local titlebar = EventEmitter:new(
  display.newRect(0, 0, display.contentWidth, 0)
)
titlebar:setFillColor(0, 133, 161)

local caption = display.newText("", 0, 0, native.systemFont, 20)
caption:setTextColor(255, 255, 255)
caption.isVisible = false

local menu = display.newRect(0, 0, 0, 0)
local function highlight (bool)
  local r, g, b = 0, 133, 161
  if bool then r, g, b = 27, 161, 226 end
  menu:setFillColor(r, g, b)
  menu.highlight = bool
end
highlight(false)

local up = display.newText("<", 0, 0, native.systemFont, 20)
up:setTextColor(255, 255, 255)
up.isVisible = false

local logo = display.newImage("favicon.ico", 0, 0)
logo.width = logo.width * 3
logo.height = logo.height * 1.5

local hr = {}
hr.background = display.newRect(0, 0, display.contentWidth, 2)
hr.background:setFillColor(0, 0, 0, 255)
hr.foreground = display.newRect(0, 0, display.contentWidth, 2)
hr.foreground:setFillColor(0, 133, 161, 140)

local active = false

function menu:touch (event)
  if not active then return true end
  if "began" == event.phase then
    highlight(true)
  elseif "ended" == event.phase then
    if menu.highlight then
      titlebar:emit("menu")
    end
    highlight(false)
  elseif "canceled" == event.phase then
    highlight(false)
  elseif "moved" == event.phase then
    local distance = math.max(
      math.abs(event.x - event.xStart),
      math.abs(event.y - event.yStart)
    )
    if distance > 10 then
      highlight(false)
    end
  end
  return true
end
menu:addEventListener("touch", menu)

local function setactive (bool)
  active = bool
  up.isVisible = bool
  caption.isVisible = bool
end

function titlebar:activate (text)
  if text and "string" == type(text) then
    caption.text = text
    caption.x = 0 + caption.contentWidth / 2 + menu.width
  end
  setactive(true)
end

function titlebar:deactivate ()
  setactive(false)
end

function titlebar:getBottom()
  return self.y + self.contentHeight / 2
end

titlebar.height = 50
menu.height = titlebar.height
titlebar.y = display.topStatusBarContentHeight + titlebar.contentHeight / 2
logo.y = titlebar.y
menu.y = titlebar.y
up.y = titlebar.y
caption.y = titlebar.y
up.x = 5 + up.contentWidth / 2
logo.x = 3 + logo.contentWidth / 2 + up.x + up.contentWidth / 2
menu.width = 5 + logo.x + logo.contentWidth / 2
menu.x = menu.contentWidth / 2
hr.background.y = titlebar:getBottom()
hr.foreground.y = hr.background.y


return titlebar
