local widget = require("widget")
local rowcaption = require("rowcaption")

local on = {
  slide = nil
}

local function emit (event, ...)
  if "function" == type(on[event]) then
    on[event](...)
  end
end

local content = {
  textcolor = {r = 0, g = 0, b = 0}
}

function content:on(event, listener)
  on[event] = listener
end

local slide = {
  left = 0,
  right = display.contentWidth * 2 / 3,
  position = "left",
  startthreshold = 5,
  swipethreshold = 75
}

local tableview = widget.newTableView({
  left = slide[slide.position],
  width = display.contentWidth,
  height = display.contentHeight,
  onRowRender = rowcaption(content)
})

function content:slide(leftorright)
  if tableview.x == slide[leftorright] then return end
  slide.position = leftorright
  tableview.x = slide[leftorright]
  emit("slide", leftorright)
end

-- FIXME; can break on any new widget version,
-- but for now probably a better solution than keeping a fork of the widget library.
-- The problem is that the TableView widget uses up all touch hook points for its
-- implementation of table scrolling and row selecting & swiping, and doesn't
-- provide any possibility for touch extension through its API.
-- The tableview[2] part is the dirty hack here.
local view = tableview[2]
local widgettouch = view.touch
function view:touch (event)

  local direction = "left"
  if event.x > event.xStart then direction = "right" end
  if direction ~= slide.position then

    local distance = math.abs(event.x - event.xStart)
    if "moved" == event.phase then
      if distance > slide.startthreshold then
        tableview.x = tableview.x + (event.x - slide.prevx)
      end
    elseif "ended" == event.phase or "canceled" == event.phase then
      if distance > slide.swipethreshold then
        content:slide(direction)
      else
        content:slide(slide.position)
      end
    end

  end
  slide.prevx = event.x

  widgettouch(view, event)
  return true
end


function content:setTop(y)
  tableview.y = y
end

function content:add (id, text)
  self[id] = text
  tableview:insertRow({
    id = id
  })
end

return content