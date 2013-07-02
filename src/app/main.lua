require("node_modules.lua-loader.init")(function() end)
local json = require("json")
local savestate = require("lua-savestate")
local showerror = require("showerror")
local menu = require("menu")
local content = require("content")
local login = require("login")
local titlebar = require("titlebar")

local top = titlebar:getBottom()
login:init(top) titlebar:init() menu:init(top) content:init(top)  

titlebar:on("up", function ()
  content:slide("right")
end)

local accesstoken, caption
content:on("slide", function (position)
  if "right" == position then titlebar:deactivate()
  elseif accesstoken then titlebar:activate(caption) end
end)

local fetchclients
login:on("authenticated", function (userinfo, token)
  -- FIXME: wordt niet opnieuw gerenderd bij opnieuw inloggen...
  userinfo.carefarm = userinfo.carefarm or {
    name = "Boer Harms"
  }
  accesstoken = token
  menu:add("username", userinfo.name, function ()
    accesstoken = nil
    login:show()
    content:empty()
    content:slide("left")
    menu:empty()
  end)
  menu:add("zorgboerderij", userinfo.carefarm.name)
  fetchclients()
end)

savestate:init({
  selectedclient = nil
})

local listclients
fetchclients = function ()
  local url = "https://www.greenhillhost.nl/ws_zapp/getClients/"
  url = url .. "?token=" .. accesstoken
  network.request(url, "GET", function (event)
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
  local known, id = false, nil
  for i,client in ipairs(clients) do
    id = client.clientid
    if not known and id == savestate:get("selectedclient") then
      known = true
      caption = client.clientnameinformal
    end
    menu:add("client" .. id, client.clientnameinformal, setclient(id, client.clientnameinformal))
  end
  menu:remove("fetchclients")
  if known then
    setclient(savestate:get("selectedclient"), caption)()
  else
    setclient(clients[1].clientid, clients[1].clientnameinformal)()
  end
end

local fetchreports
setclient = function (id, name)
  return function ()
    caption = name
    content:empty()
    savestate:set("selectedclient", id, true)
    menu:select("client" .. id)
    fetchreports(id)
    content:slide("left")
  end
end

local listreports
fetchreports = function (id)
  local url = "https://www.greenhillhost.nl/ws_zapp/getDailyReports/"
  url = url .. "?token=" .. accesstoken
  url = url .. "&clientid=" .. id
  network.request(url, "GET", function (event)
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
