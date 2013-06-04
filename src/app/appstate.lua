local json = require("json")

local appstate = {}
local data = {}
local path = system.pathForFile("appstate.json", system.DocumentsDirectory)

function appstate:persist()
  local file = io.open(path, "w")
  local datastring = json.encode(data)
  file:write(datastring)
  io.close(file)
end

function appstate:init(defaults)
  defaults = defaults or {}
  for k,v in pairs(defaults) do
    data[k] = v
  end

  local file = io.open(path, "r")
  if not file then return self:persist() end
  local readstring = file:read("*a")
  io.close(file)

  local readtable = json.decode(readstring)
  for k,v in pairs(readtable) do
    data[k] = v
  end
end

function appstate:get (key)
  return data[key]
end

function appstate:set (key, value, persist)
  data[key] = value
  if persist then self:persist() end
end

return appstate