require("node_modules.lua-loader.init")(function() end)
local json = require("json")
local savestate = require("lua-savestate")

local menu = require("menu")
local content = require("content")
local titlebar = require("titlebar")
local login = require("login")
local top = titlebar:getBottom() menu:init(top) content:init(top) login:init(top) titlebar:init()

savestate:init({
  selectedclient = nil
})

titlebar:on("up", function ()
  content:slide("right")
end)

local authenticated = false
content:on("slide", function (position)
  if "right" == position then titlebar:deactivate()
  elseif authenticated then titlebar:activate(savestate:get("selectedclient")) end
end)

local fetchclients
login:on("authenticated", function (userinfo, accesstoken)
  local userinfo = userinfo or {
    displayname = "Alex Verschuur",
    carefarm = {
      displayname = "Boer Harms"
    }
  }
  authenticated = true
  menu:add("username", userinfo.displayname, function ()
    native.showAlert("ZilliZ", "Wilt u met een ander account inloggen?", {"Annuleren", "OK"},
      function (event)
        if "clicked" == event.action
        and 2 == event.index then
          authenticated = false
          login:show()
          content:empty()
          content:slide("left")
          menu:empty()
        end
      end)
  end)
  menu:add("zorgboerderij", userinfo.carefarm.displayname)
  fetchclients()
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
  menu:addcategory("clients", "CLIËNTEN")
  if #clients < 1 then
    menu:add("fetchclients", "Cliënten...", fetchclients)
    content:slide("right")
    return print("no clients!")
  end
  local known, name = false, nil
  for i,client in ipairs(clients) do
    name = client.clientnameinformal
    if not known and name == savestate:get("selectedclient") then known = true end
    menu:add("client" .. name, name, setclient(name))
  end
  menu:remove("fetchclients")
  if known then name = savestate:get("selectedclient")
  else name = clients[1].clientnameinformal end
  setclient(name)()
end

local fetchreports
setclient = function (name)
  return function ()
    content:empty()
    savestate:set("selectedclient", name, true)
    menu:select("client" .. name)
    fetchreports(name)
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
      for _,field in ipairs({"employeefirstname", "employeeinfix", "employeelastname"}) do
        addpart(report[field])
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
  native.showAlert("ZilliZ", message, {"OK"},
    function (event)
      if "clicked" == event.action then
        print("error", message)
      end
    end)
end