local json = require("json")
local state = require("appstate")
local menu = require("menu")
local content = require("content")
local titlebar = require("titlebar")
local login = require("login")

state:load()

-- login()

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

local listreports
local function fetchreports ()
  network.request("https://www.greenhillhost.nl/ws_zapp/getDailyReports/", "GET", function (event)
    local reports = {}
    if event.isError
    or event.status ~= 200 then
      showerror("Het is niet gelukt om een netwerkverbinding te maken")
    else
      -- TODO pcall
      reports = json.decode(event.response)
    end
    listreports(reports)
  end)
end

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
    if name == state.data.selectedclient then known = true end
    menu:add("client" .. i, name, setclient(name))
  end
  menu:remove("fetchclients")
  if known then name = state.data.selectedclient
  else name = clients[1].clientnameinformal end
  setclient(name)(true)
end

setclient = function (name)
  return function (force)
    if force or name ~= state.data.selectedclient then
      titlebar:activate(name)
      content:empty()
      -- TODO client's daily reports webservice request
      fetchreports()
      -- for i,report in ipairs(reports) do
      --   name = report.clientnameinformal
      --   if name == selectedclient then known = true end
      --   menu:add("client" .. i, name, setclient(name))
      -- end
      content:add("report2", "27 mei: De eerste aardbeien geplukt!")
      content:add("report1", "26 mei: " .. name .. " heeft álle kazen gedraaid")
      state.data.selectedclient = name
      state:save()
    end
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


