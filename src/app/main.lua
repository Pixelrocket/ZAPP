require("node_modules.lua-loader.init")(function() end)
local json = require("json")

local menu = require("menu")
local content = require("content")
local titlebar = require("titlebar")

content:on("slide", function (position)
  if "left" == position then titlebar:activate() end
  if "right" == position then titlebar:deactivate() end
end)

titlebar:on("up", function ()
  content:slide("right")
end)

local savestate = require("lua-savestate")
savestate:init({
  selectedclient = nil
})

local login = require("login")
local fetchclients
login:on("authenticated", function (userinfo, accesstoken)
  userinfo = userinfo or {
    displayname = "Alex Verschuur",
    carefarm = {
      displayname = "Boer Harms"
    }
  }
  local top = titlebar:getBottom()
  -- FIXME
  local titlebar = require("titlebar")
  menu:init(top)
  content:init(top)
  menu:add("username", userinfo.displayname)
  menu:add("zorgboerderij", userinfo.carefarm.displayname)
  menu:add("login", "Uitloggen", function () login:show() end)
  fetchclients()
  login:hide()
end)

login:show()

local showerror

local listclients
fetchclients = function ()
  network.request("https://www.greenhillhost.nl/ws_zapp/getClients/", "GET", function (event)
    local clients = {}
    if event.isError
    or event.status ~= 200 then
      showerror("Het is niet gelukt om een netwerkverbinding te maken")
    else
      clients = json.decode(event.response) or clients
    end
    listclients(clients)
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
    if not known and name == savestate:get("selectedclient") then known = true end
    menu:add("client" .. i, name, setclient(name))
  end
  menu:remove("fetchclients")
  if known then name = savestate:get("selectedclient")
  else name = clients[1].clientnameinformal end
  setclient(name)(true)
end

local fetchreports
setclient = function (name)
  return function (force)
    if force or name ~= savestate:get("selectedclient") then
      titlebar:activate(name)
      content:empty()
      fetchreports(name)
      savestate:set("selectedclient", name, true)
    end
    content:slide("left")
  end
end

local listreports
fetchreports = function (client)
  -- TODO: client parameter in reports service
  network.request("https://www.greenhillhost.nl/ws_zapp/getDailyReports/", "GET", function (event)
    local reports = {}
    if event.isError
    or event.status ~= 200 then
      showerror("Het is niet gelukt om een netwerkverbinding te maken")
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
      for _,part in ipairs({
        report.employeefirstname,
        report.employeeinfix,
        report.employeelastname
      }) do
        addpart(part)
      end
      content:add("report" .. i, {
        what = report.cdo_dossier,
        who = name,
        when = report.cdo_date_added
      })
    end
  end
end

showerror = function (message)
  native.showAlert("ZAPP", message, {"OK"},
    function (event)
      if "clicked" == event.action then
        print("error", message)
      end
    end)
end