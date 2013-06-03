local widget = require("widget")
local rowcaption = require("rowcaption")

local menu = {}
local items = {}

local tableview = widget.newTableView({
  width = display.contentWidth - 75,
  height = display.contentHeight,
  backgroundColor = {0, 133, 161, 180},
  noLines = true,
  onRowRender = rowcaption(items, 200, 200, 200),
  onRowTouch = function (event)
    if "release" == event.phase
    and items[event.row.id].action then
      items[event.row.id].action()
    end
  end
})

function menu:setTop(y)
  tableview.y = y
end

local linecolor = {0, 0, 0, 0}
local rowcolor = {
  default = {0, 0, 0, 0},
  over    = {0, 0, 0, 0}
}

function menu:add (id, text, action)
  if items[id] then return end
  items[id] = {text = text, action = action}
  tableview:insertRow({
    id = id,
    lineColor = linecolor,
    rowColor = rowcolor,
    rowHeight = 40
  })
end

function menu:remove (id)
  local item = items[id] or {}
  if item.index then -- don't upset the TableViewWidget with a non-existing row
    tableview:deleteRow(item.index)
  end
end

return menu
