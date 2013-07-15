require("node_modules.lua-loader.init")(function() end)
local json = require("json")
local escape = require("socket.url").escape
local savestate = require("lua-savestate")
local showerror = require("showerror")
local widget = require("widget")
local menu = require("menu")
local content = require("content")
local login = require("login")
local titlebar = require("titlebar")

display.setStatusBar(display.HiddenStatusBar)

local top = titlebar:getBottom()
titlebar:init()
titlebar:setcaption("Inloggen")
login:init(top, titlebar:addbutton("send", "6_social_send_now.png"))
menu:init(top)
content:init(top)  

local caption
content:on("slide", function (position)
  if "right" == position then titlebar:deactivate()
  else titlebar:activate(caption) end
end)

local loggingin
titlebar:on("up", function ()
  if loggingin then
    login:hide()
  else
    content:slide("right")
  end
end)

login:on("show", function ()
  loggingin = true
  content:slide("left")
  titlebar:activate("Inloggen")
end)

login:on("hide", function ()
  loggingin = false
  titlebar:activate(caption)
end)

local accesstoken, fetchclients
login:on("authenticated", function (userinfo, token)
  accesstoken = token
  menu:empty()
  menu:add("username", userinfo.name, function ()
    native.showAlert("ZilliZ", "Wilt u met een ander account inloggen?", {"Annuleren", "OK"}, function (event)
      if "clicked" == event.action and 2 == event.index then
        login:show()
      end
    end)
  end)
  fetchclients()
  login:hide()
end)

savestate:init({
  selectedclient = nil
})

local spinner = widget.newSpinner()
spinner.x = (display.viewableContentWidth - spinner.contentWidth) / 2
spinner.y = (display.viewableContentHeight - spinner.contentHeight) / 2
spinner.isVisible = false

local listclients
fetchclients = function ()
  local url = "https://www.greenhillhost.nl/ws_zapp/clients/index.cfm"
  url = url .. "?token=" .. escape(accesstoken)
  spinner:start()
  spinner.isVisible = true
  network.request(url, "GET", function (event)
    spinner.isVisible = false
    spinner:stop()
    local clients = {}
    if event.isError
    or event.status ~= 200 then
      local msg = "Het is niet gelukt om een netwerkverbinding te maken"
      msg = msg .. "\nfetchclients " .. event.status
      showerror(msg)
    else
      clients = json.decode(event.response) or clients
    end
    listclients(clients)
  end)
end

local setclient
listclients = function (clients)
  menu:addcategory("clients", "CLIËNTEN")
  if #clients < 1 then
    menu:add("fetchclients", "Cliënten...", fetchclients)
    content:slide("right")
    return print("no clients!")
  end
  local savedclient, clientset = savestate:get("selectedclient")
  for _,client in ipairs(clients) do
    local id, name  = client.clientid, client.clientnameinformal
    menu:add("client" .. id, name, setclient(id, name))
    if id == savedclient then
      setclient(id, name)()
      clientset = true
    end
  end
  menu:remove("fetchclients")
  if not clientset then
    setclient(clients[1].clientid, clients[1].clientnameinformal)()
  end
end

local fetchreports
setclient = function (id, name)
  return function ()
    caption = name
    content:empty()
    fetchreports(id)
    savestate:set("selectedclient", id, true)
    menu:select("client" .. id)
    content:slide("left")
  end
end

local listreports
fetchreports = function (id)
  local url = "https://www.greenhillhost.nl/ws_zapp/dailyReports/index.cfm"
  url = url .. "?token=" .. escape(accesstoken)
  url = url .. "&clientid=" .. escape(id)
  spinner:start()
  spinner.isVisible = true
  network.request(url, "GET", function (event)
    spinner.isVisible = false
    spinner:stop()
    local reports = {}
    if event.isError
    or event.status ~= 200 then
      local msg = "Het is niet gelukt om een netwerkverbinding te maken"
      msg = msg .. "\nfetchreports " .. event.status
      showerror(msg)
    else
      reports = json.decode(event.response) or reports
    end
    listreports(reports)
  end)
end

listreports = function (reports)
  for i,report in ipairs(reports) do
    -- print("\n")
    -- for k,v in pairs(report) do
    --   print(k,v)
    -- end
    if report.dossiermap == "Dagrapportage" then
      local name
      local function addpart (part)
        if not part then return end
        if name then name = name .. " " .. part
        else name = part end
      end
      for _,field in ipairs({"employeefirstname", "employeeinfix", "employeelastname"}) do
        addpart(report[field])
      end
      content:add("report" .. i, {
        what = report.cdo_dossier,
        who = name,
        when = report.cdo_date_added_ts
      })
    end
  end
end
