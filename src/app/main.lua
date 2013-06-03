local json = require("json")
local menu = require("menu")
local content = require("content")
local titlebar = require("titlebar")
local login = require("login")

<<<<<<< HEAD
<<<<<<< HEAD
--login()

=======
>>>>>>> 6fa091b1f6a2cb0f7e2539a5e7099ead193eb8d9
=======
>>>>>>> 6fa091b1f6a2cb0f7e2539a5e7099ead193eb8d9
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
  local known, name = false, nil
  for i,client in ipairs(clients) do
    name = client.clientnameinformal
    if name == selectedclient then known = true end
    menu:add("client" .. i, name, setclient(name))
  end
  menu:remove("fetchclients")
  if known then name = selectedclient
  else name = clients[1].clientnameinformal end
  setclient(name)()
end

setclient = function (name)
  return function ()
    selectedclient = name
    titlebar:activate(name)
    -- TODO client's daily reports webservice request
    content:empty()
    content:add("report2", "27 mei: De eerste aardbeien geplukt!")
    content:add("report1", "26 mei: " .. name .. " heeft álle kazen gedraaid")
    content:slide("left")
  end
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


