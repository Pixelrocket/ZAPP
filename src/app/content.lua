local widget = require("widget")
local rowcaption = require("rowcaption")

local content = {
  textcolor = {r = 0, g = 0, b = 0}
}

local slide = {
  left = 0,
  right = display.contentWidth * 2 / 3,
  position = "left",
  startthreshold = 5,
  swipethreshold = 75
}

local tableview = widget.newTableView({
  left = slide.left,
  width = display.contentWidth,
  height = display.contentHeight,
  onRowRender = rowcaption(content)
})
content.tableview = tableview

function tableview:position(leftorright)
  if self.x == slide[leftorright] then return end
  slide.position = leftorright
  self.x = slide[leftorright]
end

function tableview:restoreposition()
  self:position(slide.position)
end

function tableview:switchposition()
  local leftorright = "left"
  if slide.position == "left" then leftorright = "right" end
  self:position(leftorright)
end

-- FIXME; can break on any new widget version,
-- but for now probably a better solution than keeping a fork of the widget library
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
        tableview:switchposition()
      else
        tableview:restoreposition()
      end
    end

  end
  slide.prevx = event.x

  widgettouch(view, event)
  return true
end

function content:add (id, text)
  self[id] = text
  self.tableview:insertRow({
    id = id
  })
end

return content
