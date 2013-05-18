local json = require("json")
local menu = require("menu")
local content = require("content")
local titlebar = require("titlebar")

local top = titlebar:getBottom()
menu:setTop(top)
content:setTop(top)

titlebar:on("menu", function ()
  content:slide("right")
end)

content:on("slide", function (position)
  if "left" == position then titlebar:activate() end
  if "right" == position then titlebar:deactivate() end
end)

-- TODO login GUI & webservice request
menu:add("username", "Alex Verschuur")
menu:add("zorgboerderij", "Boer Harms")
menu:add("logout", "Uitloggen")

local listclients
network.request("https://www.greenhillhost.nl/ws_zapp/getClients/", "GET", function (event)
  -- TODO GUI instead of print() for error cases
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
    listclients(clients)
  end
end)

-- TODO save selectedclient on exit
local selectedclient = nil

local setclient
listclients = function (clients)
  -- TODO GUI instead of print() for the cases where we don't get any clients
  if #clients < 1 then return print("no clients!") end
  local known = false
  for i,client in ipairs(clients) do
    local name = client.clientnameinformal
    if name == selectedclient then known = true end
    menu:add("client" .. i, name)
  end
  if known then setclient(selectedclient)
  else setclient(clients[1].clientnameinformal) end
end

setclient = function (name)
  selectedclient = name
  titlebar:activate(name)
  -- TODO client's daily reports webservice request
  content:add("report2", "27 mei: De eerste aardbeien geplukt!")
  content:add("report1", "26 mei: " .. name .. " heeft álle kazen gedraaid")
  for i=1,50 do
    content:add(i)
  end
end


