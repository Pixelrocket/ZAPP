local widget = require("widget")

local titlebar = display.newRect(0, 0, display.contentWidth, 0)
local logo = display.newImage("favicon.ico", 10, display.topStatusBarContentHeight + 10)
titlebar.height = 10 + logo.contentHeight + 10
titlebar.y = logo.y
titlebar:setFillColor(0, 133, 161)

function onRowRender (r, g, b)
  return function (event)
    local row = event.row
    local rowtext = display.newText(row, "table row " .. row.index, 0, 0, native.systemFont, 14)
    rowtext.x = 10 + row.x - row.contentWidth / 2 + rowtext.contentWidth / 2
    rowtext.y = row.contentHeight / 2
    rowtext:setTextColor(r, g, b)
    print(row, row.index)
    for k,v in pairs(row) do
      print(k,v)
    end
  end
end

local menugroup = display.newGroup()
local menutable = widget.newTableView({
  top = display.topStatusBarContentHeight + titlebar.contentHeight,
  width = display.contentWidth,
  height = display.contentHeight,
  backgroundColor = {0, 133, 161, 180},
  noLines = true,
  onRowRender = onRowRender(200, 200, 200)
})
menugroup:insert(menutable)

local contentgroup = display.newGroup()
local contenttable = widget.newTableView({
  top = display.topStatusBarContentHeight + titlebar.contentHeight,
  left = 40,
  width = display.contentWidth,
  height = display.contentHeight,
  onRowRender = onRowRender(0,0,0)
})
contentgroup:insert(contenttable)

for i = 1, 10 do
  menutable:insertRow({
    lineColor = {0, 0, 0, 0},
    rowColor = {
      default = {0, 0, 0, 0},
      over = {0, 0, 0, 0}
    }
  })
  contenttable:insertRow({})
end

