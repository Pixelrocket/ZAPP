local titlebar = display.newRect(0, 0, display.contentWidth, 0)
titlebar:setFillColor(0, 133, 161)

titlebar.menu = display.newText("", 8, 0, native.systemFont, 16)
titlebar.menu:setTextColor(255, 255, 255)

local logo = display.newImage("favicon.ico", 0, display.topStatusBarContentHeight + 10)

titlebar.caption = display.newText("", 0, 0, native.systemFont, 20)
titlebar.caption:setTextColor(255, 255, 255)

titlebar.height = 10 + logo.contentHeight + 10
titlebar.y = logo.y
titlebar.menu.y = logo.y
titlebar.caption.y = logo.y
logo.x = titlebar.menu.x + titlebar.menu.contentWidth + 10
titlebar.caption.x = logo.x + logo.contentWidth + 20

-- prevent scrolled content from shining through device's status bar
local statusbarshield = display.newRect(0, 0, display.contentWidth, display.topStatusBarContentHeight)
statusbarshield:setFillColor(0, 0, 0)

return titlebar
