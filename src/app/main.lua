local menu = require("menu")
local content = require("content")
local titlebar = require("titlebar")

local top = titlebar.y + titlebar.contentHeight / 2
menu.tableview.y = top
content.tableview.y = top

menu:add("username", "Wouter Scherphof")
menu:add("zorgboerderij", "Boer Harms")
menu:add("logout", "Uitloggen")
menu:add("client1", "Jan")
menu:add("client2", "Piet")
menu:add("client3", "Klaas")

titlebar.menu.text = "<"
function titlebar.menu:touch (event)
  if "began" == event.phase then
    content.tableview:switchposition()
  end
  return true
end
titlebar.menu:addEventListener("touch", titlebar.menu)

titlebar.caption.text = "Jan"

content:add("report2", "27 mei: De eerste aardbeien geplukt!")
content:add("report1", "26 mei: Jan heeft vandaag alle kazen gedraaid")

for i = 1, 50 do
  content.tableview:insertRow({})
end

