local widget = require("widget")
local rowcaption = require("rowcaption")

local menu = {
  textcolor = {r = 200, g = 200, b = 200},
  linecolor = {0, 0, 0, 0},
  rowcolor = {
    default = {0, 0, 0, 0},
    over    = {0, 0, 0, 0}
  }
}

local tableview = widget.newTableView({
  width = display.contentWidth - 75,
  height = display.contentHeight,
  backgroundColor = {0, 133, 161, 180},
  noLines = true,
  onRowRender = rowcaption(menu)
  onRowRender = rowcaption(menu),
  onRowTouch = function (event)
    if "release" == event.phase
    and menu[event.row.id].action then
      menu[event.row.id].action()
    end
  end
})

function menu:setTop(y)
  tableview.y = y
end

function menu:add (id, text)
  self[id] = text
function menu:add (id, text, action)
  if self[id] then return end
  self[id] = {text = text, action = action}
  tableview:insertRow({
    id = id,
    lineColor = self.linecolor,
    rowColor = self.rowcolor
  })
end

return menu
