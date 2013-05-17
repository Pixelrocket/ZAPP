local json = require("json")
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


menu:add("username", "Alex Verschuur")
menu:add("zorgboerderij", "Boer Harms")
menu:add("logout", "Uitloggen")

local selectedclient = nil

network.request("https://www.greenhillhost.nl/ws_zapp/getClients/", "GET", function (event)
  -- TODO GUI instead of print() for the cases where we don't get any clients
  if event.isError then
    print("network error")
  elseif event.status ~= 200 then
    print("unexpected status for network event:")
    for k,v in pairs(event) do
      print(k,v)
    end
  else
    -- TODO pcall
    local clients = json.decode(event.response)
    if #clients < 1 then return print("no clients!") end
    local known = false
    for i,client in ipairs(clients) do
      local name = client.clientnameinformal
      if name == selectedclient then known = true end
      menu:add("client" .. i, name)
    end
    if not known then selectedclient = clients[1].clientnameinformal end
    titlebar:activate(selectedclient)
    content:add("report2", "27 mei: De eerste aardbeien geplukt!")
    content:add("report1", "26 mei: " .. selectedclient .. " heeft vandaag alle kazen gedraaid")
  end
end)




