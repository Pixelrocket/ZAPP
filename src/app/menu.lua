local widget = require("widget")

local items = {}

local options = {
  text = {
    r = 200, g = 200, b = 200,
    font = "Roboto-Regular", size = 18
  },
  margin = 8,
  accent = {
    r = 72, g = 212, b = 217
  }
}
local function rowrender (event)
  local row = event.row
  local item = items[row.id] or {text = "table row " .. row.index}
  item.index = row.index -- needed as the prameter for TableViewWidget:deleteRow()
  local font, size, margin = options.text.font, options.text.size, options.margin
  local r, g, b = options.text.r, options.text.g, options.text.b

  if row.isCategory then -- shrink parameters for category rows
    factor = .8
    size, r, g, b = size * factor, r * factor, g * factor, b * factor
  else -- flag to show for the selected row
    local flag = display.newGroup()
    row:insert(flag)
    local bar = display.newRect(flag, 0, 0, margin / 2, row.contentHeight)
    bar:setFillColor(options.accent.r, options.accent.g, options.accent.b)
    local overlay = display.newRect(flag, 0, 0, row.contentWidth, row.contentHeight)
    overlay:setFillColor(0, 0, 0, 50)
    flag.isVisible = false
    item.flag = flag
    function item:select (prev)
      if items[prev] and items[prev].flag then
        items[prev].flag.isVisible = false
      end
      self.flag.isVisible = true
      return row.id
    end
  end

  local rowtext = display.newText(row, item.text, 0, 0, font, size)
  rowtext.x = margin + row.x - row.contentWidth / 2 + rowtext.contentWidth / 2
  rowtext.y = row.contentHeight / 2
  rowtext:setTextColor(r, g, b)

  if row.isCategory then -- underline a category's text
    rowtext.y = rowtext.y - 2
    local hr = display.newRect(row, 0, 1 + rowtext.y + rowtext.contentHeight / 2, row.contentWidth - 3 * margin, 1)
    hr.x = margin + row.x - row.contentWidth / 2 + hr.contentWidth / 2
    hr:setFillColor(r, g, b)
  end
end

local menu, tableview = {}

function menu:init (top)
  tableview = widget.newTableView({
    left = 0,
    top = top,
    width = display.viewableContentWidth * .8,
    height = display.viewableContentHeight - top,
    backgroundColor = {0, 133, 161, 180},
    noLines = true,
    onRowRender = rowrender,
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

function menu:empty ()
  tableview:deleteAllRows()
  for k in pairs(items) do
    items[k] = nil
  end
end

local selected
function menu:select (id)
  if items[id] then
    selected = items[id]:select(selected)
  end
end

return menu
