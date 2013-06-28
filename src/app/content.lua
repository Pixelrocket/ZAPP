local widget = require("widget")
local slider = require("slider")
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

local content, tableview = {}

function content:init (top)
  tableview = widget.newTableView({
    left = 0,
    top = top,
    width = display.viewableContentWidth,
    height = display.viewableContentHeight - top,
    onRowRender = rowrender
  })

  -- FIXME; can break on any new widget version,
  -- but for now probably a better solution than keeping a fork of the widget library.
  -- The problem is that the TableView widget uses up all touch hook points for its
  -- implementation of table scrolling and row selecting & swiping, and doesn't
  -- provide any possibility for touch extension through its API.
  -- The tableview[2] part is the dirty hack here.
  local view = tableview[2]
  self = slider:new(self, view, {moveobject = tableview})
end

function content:add (id, report, action)
  if items[id] then return end
  items[id] = {report = report, action = action}
  for _,match in ipairs({"\n", "\r", "\t", "  ", "  "}) do
    report.what = string.gsub(report.what, match, " ")
  end

  local rowHeight, probe -- precalculate the value we need to pass to inserRow()
  -- room for report heading
  probe = display.newText("", 0, 0, font, fontsize.small)
  rowHeight = probe.contentHeight
  display.remove(probe)
  -- room for report text
  probe = display.newText(report.what, 0, 0, font, fontsize.large)
  local availablewidth = tableview.contentWidth - 2 * margin.width
  if availablewidth >= probe.contentWidth then
    rowHeight = rowHeight + probe.contentHeight
  else -- multiline
    rowHeight = rowHeight + probe.contentHeight * math.ceil(probe.contentWidth / (availablewidth * .95) )
  end
  display.remove(probe)
  rowHeight = rowHeight + 2 * margin.height + margin.spacing

  tableview:insertRow({
    id = id,
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
