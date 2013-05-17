local menu = require("menu")
local content = require("content")
local titlebar = require("titlebar")

local top = titlebar.y + titlebar.contentHeight / 2
menu:setTop(top)
content:setTop(top)

titlebar:on("menu", function ()
  content:slide("right")
end)

content:on("slide", function (position)
  if "left" == position then titlebar:activate() end
  if "right" == position then titlebar:deactivate() end
end)

menu:add("username", "Wouter Scherphof")
menu:add("zorgboerderij", "Boer Harms")
menu:add("logout", "Uitloggen")
menu:add("client1", "Jan")
menu:add("client2", "Piet")
menu:add("client3", "Klaas")

titlebar:activate("Jan")

content:add("report2", "27 mei: De eerste aardbeien geplukt!")
content:add("report1", "26 mei: Jan heeft vandaag alle kazen gedraaid")


