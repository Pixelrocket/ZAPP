local widget = require("widget")
local Slider = require("coronasdk-slider")
local timeago = require("lua-timeago")

timeago.setlanguage("nederlands")
timeago.setstyle("short")

local items = {}

local margin = {
  width = 16,
  height = 8,
  spacing = 0
}
local fontsize = {
  small = 12,
  large = 15
}
local font = "Roboto-Light"

local function rowrender (event)
  local row = event.row
  local item = items[row.id]
  item.index = row.index -- needed as the prameter for TableViewWidget:deleteRow()
  local report = item.report

  local whenago = timeago.parse(report.when)
  local whentext = display.newText(row, whenago, 0, 0, font, fontsize.small)
  whentext.x = margin.width + row.x - row.contentWidth / 2 + whentext.contentWidth / 2
  whentext.y = margin.height + whentext.contentHeight / 2
  whentext:setTextColor(150, 150, 150)

  local whotext = display.newText(row, report.who, 0, 0, font, fontsize.small)
  whotext.x = row.x + row.contentWidth / 2 - whotext.contentWidth / 2 - margin.width
  whotext.y = whentext.y
  whotext:setTextColor(150, 150, 150)

  local textwidth = row.contentWidth - 2 * margin.width
  local textheight = row.contentHeight - whentext.contentHeight - 2 * margin.height - margin.spacing
  local whattext = display.newText(row, report.what, 0, 0, textwidth, textheight, font, fontsize.large)
  whattext.x = margin.width + row.x - row.contentWidth / 2 + whattext.contentWidth / 2
  whattext.y = margin.spacing + whentext.y + whentext.contentHeight / 2 + whattext.contentHeight / 2
  whattext:setTextColor(0, 0, 0)
end

local content, group, tableview = {}, display.newGroup(), nil

function content:init (top)
  if tableview then return end
  tableview = widget.newTableView({
    left = 0,
    top = top,
    width = display.viewableContentWidth,
    height = display.viewableContentHeight - top,
    backgroundColor = {239, 255, 235},
    onRowRender = rowrender
  }) group:insert(tableview)
  -- FIXME; can break on any new widget version,
  -- but for now probably a better solution than keeping a fork of the widget library.
  -- The problem is that the TableView widget uses up all touch hook points for its
  -- implementation of table scrolling and row selecting & swiping, and doesn't
  -- provide any possibility for touch extension through its API.
  -- The tableview[2] part is the dirty hack here.
  local view = tableview[2]
  self = Slider:new(self, view, {moveobject = tableview})
end

local nocolor = {
  default = {0, 0, 0, 0},
  over = {0, 0, 0, 0}
}

-- precalculate the value we need to pass to inserRow()
local rowHeight = 2 * margin.height + margin.spacing
local probe = display.newText("", 0, 0, font, fontsize.small)
rowHeight = rowHeight + probe.contentHeight -- room for report heading
probe:removeSelf() probe = nil

function content:add (id, report, action)
  if items[id] then return end
  items[id] = {report = report, action = action}
  for _,match in ipairs({"\n", "\r", "\t", "  ", "  "}) do
    report.what = string.gsub(report.what, match, " ")
  end

  local rowHeight = rowHeight 
  probe = display.newText(report.what, 0, 0, group.contentWidth - 2 * margin.width, 0, font, fontsize.large)
  rowHeight = rowHeight + probe.contentHeight -- room for report text
  probe:removeSelf() probe = nil

  tableview:insertRow({
    id = id,
    rowColor = nocolor,
    rowHeight = rowHeight
  })
end

function content:empty ()
  tableview:deleteAllRows()
  for k in pairs(items) do
    items[k] = nil
  end
end

return content
