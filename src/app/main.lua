local widget = require ("widget")

local menugroup = display.newGroup()
local contentgroup = display.newGroup()

local titlebar = display.newRect(0, display.topStatusBarContentHeight, display.contentWidth, 80)
titlebar:setFillColor(0, 133, 161)
local logo = display.newImage("logo_zilliz.png", 0, display.topStatusBarContentHeight - 7)

local contenttable = widget.newTableView({
  top = display.topStatusBarContentHeight + titlebar.contentHeight,
  width = display.contentWidth,
  height = display.contentHeight,
  onRowRender = function (event)
    local row = event.row
    local rowtext = display.newText(row, "table row " .. row.index, 0, 0, native.systemFont, 20)
    rowtext.x = 10 + row.x - row.contentWidth / 2 + rowtext.contentWidth / 2
    rowtext.y = row.contentHeight / 2
    rowtext:setTextColor( 0, 0, 0 )
    print(row, row.index)
end
})
contentgroup:insert(contenttable)

for i = 1, 10 do
  contenttable:insertRow({})
end

