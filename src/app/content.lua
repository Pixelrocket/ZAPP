local widget = require("widget")
local EventEmitter = require("EventEmitter")
local rowcaption = require("rowcaption")

local content = EventEmitter:new({
  textcolor = {r = 0, g = 0, b = 0}
})

local slide = {
  left = 0,
  right = display.contentWidth - 75,
  position = "left",
  startthreshold = 10,
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
  self:emit("slide", leftorright)
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

  if "began" == event.phase then
    slide.sliding = false
  end

  local direction = "left"
  if event.x > event.xStart then direction = "right" end
  if direction ~= slide.position then

    local distance = math.abs(event.x - event.xStart)
    if "moved" == event.phase then
      if distance > slide.startthreshold
      and tableview.x >= slide.left
      and tableview.x <= slide.right then
        tableview.x = tableview.x + (event.x - slide.prevx)
        slide.sliding = true
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

  if not slide.sliding then
    if slide.position == "right" then
      if event.xStart >= slide.right
      and "ended" == event.phase then
        content:slide("left")
      end
    else
      widgettouch(view, event)
    end
  end

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
