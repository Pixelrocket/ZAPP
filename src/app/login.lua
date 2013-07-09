local EventEmitter = require("lua-events").EventEmitter
local showerror = require("showerror")
local json = require("json")
local TextField = require("textfield")

local login = EventEmitter:new()

local authenticating
local function authenticate (uid, pwd)
  -- appears to get called twice from userInput submit
  -- (on device, not in the simulator)
  -- which is crazy, but must be dealt with
  if authenticating then return end
  local url = "https://www.greenhillhost.nl/ws_zapp/getCredentials/"
  url = url .. "?frmUsername=" .. uid
  url = url.. "&frmPassword=" .. pwd
  authenticating = true
  network.request(url, "GET", function (event)
    authenticating = false
    if event.isError
    or event.status ~= 200 then
      return showerror("Het is niet gelukt om u in te loggen via het netwerk")
    end

    local credentials = json.decode(event.response)[1]
    if #(credentials.token or "") ~= 32 then
      return showerror("Het is niet gelukt om u in te loggen via het netwerk")
    end
    if (credentials.noofclients or 0) < 1 then
      return showerror("Er zijn nog geen cliënten gekoppeld aan uw account")
    end
    local name
    local function addpart (part)
      if not part then return end
      if name then name = name .. " " .. part
      else name = part end
    end
    for _,field in ipairs({"firstname", "infix", "lastname"}) do
      addpart(credentials[field])
    end
    local email = credentials.emailaddress
    login:emit("authenticated", {name = name, email = email}, credentials.token)
  end)
end

local function createform (width, sendbutton)
  local group = display.newGroup()

  local uid = TextField:new(width, "Gebruikersnaam", "next")
  group:insert(uid)

  local pwd = TextField:new(width, "Wachtwoord", "go", true)
  group:insert(pwd)
  pwd.y = uid.y + 48

  local function newvalue ()
    if #uid:value() > 0 and #pwd:value() > 0 then
      sendbutton:show()
    else
      sendbutton:hide()
    end
  end
  uid:on("change", newvalue)
  pwd:on("change", newvalue)

  uid:on("submit", function ()
    if #uid:value() < 1 then
      uid:focus()
    else
      pwd:focus()
    end
  end)
  pwd:on("submit", function ()
    if #pwd:value() < 1 then
      pwd:focus()
    elseif #uid:value() < 1 then
      uid:focus()
    else
      authenticate(uid:value(), pwd:value())
    end
  end)

  sendbutton:on("release", function ()
    pwd:emit("submit")
  end)

  login:on("hide", function ()
    native.setKeyboardFocus(nil)
    sendbutton:hide()
    uid:reset()
    pwd:reset()
  end)

  return group
end

local group = display.newGroup()

function login:init(top, sendbutton)
  if group.numChildren > 0 then return end

  local width, height = display.viewableContentWidth, display.viewableContentHeight - top
  local bg = display.newRect(group, 0, 0, width, height)
  bg:setFillColor(239, 255, 235)
  group.y = top

  local form = createform(width - 32, sendbutton)
  group:insert(form)
  form.x, form.y = 16, 16

  sendbutton:hide()
end

function login:show ()
  local time = 400
  group.alpha = 1
  transition.from(group, {
    time = time,
    transition = easing.outExpo,
    x = group.contentWidth
  })
end

function login:hide ()
  local time = 1200
  transition.to(group, {
    time = time,
    transition = easing.outExpo,
    alpha = 0
  })
  self:emit("hide")
end

return login
