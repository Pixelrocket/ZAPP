local json = require("json")

local state = {
  data = {
    selectedclient = nil
  }
}

state.path = system.pathForFile("state.json", system.DocumentsDirectory)

function state:save()
  local file = io.open(self.path, "w")
  local datastring = json.encode(self.data)
  file:write(datastring)
  io.close(file)
end

function state:load()
  local file = io.open(self.path, "r")
  if not file then return self:save() end
  local datastring = file:read("*a")
  self.data = json.decode(datastring)
  io.close(file)
end

return state