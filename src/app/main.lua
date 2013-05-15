local widget = require("widget")

local function rowcaption (items)
  return function (event)
    local row = event.row
    local text = items[row.id] or "table row " .. row.index
    local rowtext = display.newText(row, text, 0, 0, native.systemFont, 14)
    rowtext.x = 10 + row.x - row.contentWidth / 2 + rowtext.contentWidth / 2
    rowtext.y = row.contentHeight / 2
    rowtext:setTextColor(items.textcolor.r, items.textcolor.g, items.textcolor.b)
  end
end

local menuitems = {
  textcolor = {r = 200, g = 200, b = 200}
}
local menutable = widget.newTableView({
  width = display.contentWidth / 3 * 2,
  height = display.contentHeight,
  backgroundColor = {0, 133, 161, 180},
  noLines = true,
  onRowRender = rowcaption(menuitems)
})

local contentitems = {
  textcolor = {r = 0, g = 0, b = 0}
}
local contenttable = widget.newTableView({
  left = 40,
  width = display.contentWidth,
  height = display.contentHeight,
  onRowRender = rowcaption(contentitems)
})

-- stack titlebar on top of tableviews, to prevent table top row lines from displaying over titlebar
local titlebar = display.newRect(0, 0, display.contentWidth, 0)
titlebar:setFillColor(0, 133, 161)
local titletext = display.newText("Jan", 0, 0, native.systemFont, 20)
titletext:setTextColor(255, 255, 255)
local logo = display.newImage("favicon.ico", 10, display.topStatusBarContentHeight + 10)
titlebar.y = logo.y
titlebar.height = 10 + logo.contentHeight + 10
titletext.x = logo.x + logo.contentWidth + 20
titletext.y = logo.y

-- now position tableviews just below the titlebar
local top = titlebar.y + titlebar.contentHeight / 2
menutable.y = top
contenttable.y = top

-- prevent scrolled tableview content from shining through device's status bar
local statusbarshield = display.newRect(0, 0, display.contentWidth, display.topStatusBarContentHeight)
statusbarshield:setFillColor(0, 0, 0)


local transparent = {0, 0, 0, 0}
local rowcolortransparent = {
  default = transparent,
  over = transparent
}
local function addmenuitem (id, text)
  menuitems[id] = text
  menutable:insertRow({
    id = id,
    lineColor = transparent,
    rowColor = rowcolortransparent
  })
end

local function addcontentitem (id, text)
  contentitems[id] = text
  contenttable:insertRow({
    id = id
  })
end

addmenuitem("username", "Wouter Scherphof")
addmenuitem("zorgboerderij", "Boer Harms")
addmenuitem("logout", "Uitloggen")
addmenuitem("client1", "Jan")
addmenuitem("client2", "Piet")
addmenuitem("client3", "Klaas")

addcontentitem("report2", "27 mei: De eerste aardbeien geplukt!")
addcontentitem("report1", "26 mei: Jan heeft vandaag alle kazen gedraaid")

for i = 1, 50 do
  contenttable:insertRow({})
end

