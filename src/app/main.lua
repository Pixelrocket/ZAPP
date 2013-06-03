local json = require("json")
local menu = require("menu")
local content = require("content")
local titlebar = require("titlebar")
local login = require("login")

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

local showerror

-- TODO login GUI & webservice request
menu:add("username", "Alex Verschuur")
menu:add("zorgboerderij", "Boer Harms")
menu:add("login", "Uitloggen", login)

local listclients
local function fetchclients ()
  network.request("https://www.greenhillhost.nl/ws_zapp/getClients/", "GET", function (event)
    local clients = {}
    if event.isError
    or event.status ~= 200 then
      showerror("Het is niet gelukt om een netwerkverbinding te maken")
    else
      -- TODO pcall
      clients = json.decode(event.response)
    end
    listclients(clients)
  end)
end
fetchclients()

-- TODO save selectedclient on exit
local selectedclient = nil

local setclient
listclients = function (clients)
  if #clients < 1 then
    menu:add("fetchclients", "Cliënten...", fetchclients)
    content:slide("right")
    return print("no clients!")
  end
  local known = false
  for i,client in ipairs(clients) do
    local name = client.clientnameinformal
    if name == selectedclient then known = true end
    menu:add("client" .. i, name)
  end
  menu:remove("fetchclients")
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
  content:slide("left")
end

showerror = function (message)
  native.showAlert("ZAPP", message, {"OK"},
    function (event)
      if "clicked" == event.action then
        native.requestExit()
        print("requestExit")
      end
    end)
end


