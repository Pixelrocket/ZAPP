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
    transition = easing.outExpo,
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

  local function direction ()
    if event.x > event.xStart then return "right"
    else return "left" end
  end

  local distance = {}
  function distance._d (a, b) return math.abs(a - b) end
  function distance:x () return self._d(event.x, event.xStart) end
  function distance:y () return self._d(event.y, event.yStart) end

  if "began" == event.phase then
    slide.sliding, slide.scrolling = false, false
    widgettouch(view, event)

  elseif "moved" == event.phase then
    if not slide.sliding and not slide.scrolling
    and "left" == slide.position
    and distance:y() > slide.startthreshold then
      slide.scrolling = true
    end
    if not slide.scrolling and not slide.sliding
    and direction() ~= slide.position
    and distance:x() > slide.startthreshold then
      slide.sliding = true
    end

    if slide.scrolling then
      widgettouch(view, event)
    elseif slide.sliding
    and tableview.x >= slide.left and tableview.x <= slide.right then
      tableview.x = tableview.x + (event.x - slide.prevx)
    end

  elseif "ended" == event.phase or "canceled" == event.phase then
    if slide.sliding then
      if distance:x() > slide.swipethreshold then
        content:slide(direction())
      else
        content:slide(slide.position)
      end
    elseif "right" == slide.position then
      content:slide("left")
    end
    slide.sliding, slide.scrolling = false, false
    widgettouch(view, event)
  end

  slide.prevx = event.x
  return true
end


function content:setTop(y)
  tableview.y = y
end

function content:add (id, text)
  if self[id] then return end
  self[id] = {text = text}
  tableview:insertRow({
    id = id
  })
end

return content
