local widget = require("widget")
local rowcaption = require("rowcaption")

local content = {
  textcolor = {r = 0, g = 0, b = 0}
}

content.tableview = widget.newTableView({
  left = 40,
  width = display.contentWidth,
  height = display.contentHeight,
  onRowRender = rowcaption(content)
})

function content:add (id, text)
  self[id] = text
  self.tableview:insertRow({
    id = id
  })
end

return content
