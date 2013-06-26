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
    onRowRender = rowcaption(items, 200, 200, 200, "Roboto-Regular", 18, 10),
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

local function insertRow (id, options, text, action)
  if items[id] then return end
  items[id] = {text = text, action = action}
  tableview:insertRow({
    id = id,
    rowColor = options.rowColor,
    isCategory = options.isCategory,
    rowHeight = options.rowHeight
  })
end

function menu:add (id, text, action)
  local options = {
    rowColor = nocolor,
    isCategory = false,
    rowHeight = 40
  }
  if action then options.rowColor = actioncolor end
  insertRow(id, options, text, action)
end

function menu:addcategory (id, text)
  local options = {
    rowColor = nocolor,
    isCategory = true,
    rowHeight = 40 * .8
  }
  insertRow(id, options, text)
end

function menu:remove (id)
  local item = items[id] or {}
  if item.index then -- don't upset the TableViewWidget with a non-existing row
    tableview:deleteRow(item.index)
  end
end

return menu
