local titlebar = display.newRect(0, 0, display.contentWidth, 0)
titlebar:setFillColor(0, 133, 161)

titlebar.caption = display.newText("", 0, 0, native.systemFont, 20)
titlebar.caption:setTextColor(255, 255, 255)

local logo = display.newImage("favicon.ico", 10, display.topStatusBarContentHeight + 10)

titlebar.y = logo.y
titlebar.height = 10 + logo.contentHeight + 10
titlebar.caption.x = logo.x + logo.contentWidth + 20
titlebar.caption.y = logo.y

-- prevent scrolled content from shining through device's status bar
local statusbarshield = display.newRect(0, 0, display.contentWidth, display.topStatusBarContentHeight)
statusbarshield:setFillColor(0, 0, 0)

return titlebar
