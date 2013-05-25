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
  transition.to(tableview, {
    time = 250,
    x = slide[leftorright],
    onComplete = function ()
      self:emit("slide", leftorright)
    end
  })
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

  -- desired behaviour:
  -- * start scrolling or sliding only when moved more than a certain threshold
  -- * no sliding while scrolling; no scrolling while sliding
  -- * only scrolling if in left position
  -- * when sliding, snap back to current position if not slided further than a certain threshold
  -- * when in right position, sliding to the left will do the nice sliding; any other movement,
  --   including tapping, will snap it back to the left position

  local leftorright = "left"
  if event.x > event.xStart then leftorright = "right" end

  if "began" == event.phase then
    slide.sliding = false
    slide.scrolling = false
    widgettouch(view, event)
  elseif "moved" == event.phase then
    if not slide.sliding
    and not slide.scrolling
    and "left" == slide.position then
      local ydistance = math.abs(event.y - event.yStart)
      if ydistance > slide.startthreshold then
        slide.scrolling = true
      end
    end
    if not slide.scrolling
    and not slide.sliding then
      local xdistance = math.abs(event.x - event.xStart)
      if slide.position ~= leftorright
      and xdistance > slide.startthreshold then
        slide.sliding = true
      end
    end
    if slide.scrolling then
      widgettouch(view, event)
    elseif slide.sliding
    and tableview.x >= slide.left
    and tableview.x <= slide.right then
      tableview.x = tableview.x + (event.x - slide.prevx)
    end
  elseif "ended" == event.phase or "canceled" == event.phase then
    if slide.sliding then
      local xdistance = math.abs(event.x - event.xStart)
      if xdistance > slide.swipethreshold then
        content:slide(leftorright)
      else
        content:slide(slide.position)
      end
    elseif "right" == slide.position then
      content:slide("left")
    end
    slide.sliding = false
    slide.scrolling = false
    widgettouch(view, event)
  end

  slide.prevx = event.x
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
