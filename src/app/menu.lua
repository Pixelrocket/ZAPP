local widget = require("widget")
local rowcaption = require("rowcaption")

local menu = {}
local items = {}

local tableview

function menu:init (top)
  tableview = widget.newTableView({
    left = 0,
    top = top,
    width = display.contentWidth - 75,
    height = display.contentHeight - top,
    backgroundColor = {0, 133, 161, 180},
    noLines = true,
    onRowRender = rowcaption(items, 200, 200, 200, "Roboto-Regular"),
    onRowTouch = function (event)
      if "release" == event.phase
      and items[event.row.id].action then
        items[event.row.id].action()
      end
    end
  })
end

local nocolor = {
  default = {0, 0, 0, 0},
  over = {0, 0, 0, 0}
}
local actioncolor = {
  default = {0, 0, 0, 0},
  over = {51, 181, 229, 225}
}

function menu:add (id, text, actionorcategory)
  if items[id] then return end
  local isCategory, action = false, nil
  if "function" == type(actionorcategory) then action = actionorcategory end
  if "boolean"  == type(actionorcategory) then isCategory = actionorcategory end
  local rowHeight = 40
  if isCategory then rowHeight = 40 * .8 end
  local rowColor = nocolor
  if action then rowColor = actioncolor end
  items[id] = {text = text, action = action}
  tableview:insertRow({
    id = id,
    rowColor = rowColor,
    isCategory = isCategory,
    rowHeight = rowHeight
  })
end

function menu:remove (id)
  local item = items[id] or {}
  if item.index then -- don't upset the TableViewWidget with a non-existing row
    tableview:deleteRow(item.index)
  end
end

return menu
