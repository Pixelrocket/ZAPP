local EventEmitter = require("lua-events").EventEmitter
local showerror = require("showerror")
local json = require("json")
local TextField = require("textfield")

local login = EventEmitter:new()

local uid, pwd

local function authenticate (uidval, pwdval)
  uidval, pwdval = uidval or uid:value(), pwdval or pwd:value()
  local url = "https://www.greenhillhost.nl/ws_zapp/getCredentials/"
  url = url .. "?frmUsername=" .. uidval
  url = url.. "&frmPassword=" .. pwdval
  native.setKeyboardFocus(nil)
  network.request(url, "GET", function (event)
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
    login:hide()
  end)
end

local sendbutton

local function createform (width)
  local group = display.newGroup()

  uid = TextField:new(width, "Gebruikersnaam", "next")
  group:insert(uid)

  pwd = TextField:new(width, "Wachtwoord", "go", true)
  group:insert(pwd)
  pwd.y = uid.y + 48

  local testbutton = require("widget").newButton({
    label = "Dev: inloggen default account",
    left = 0, top = pwd.y + 52 + 48, width = width, height = 40,
    font = "Roboto-Regular", fontSize = 18,
    isEnabled = true,
    onRelease = function ()
      authenticate("averschuur", "huurcave-4711")
    end
  }) group:insert(testbutton)

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
      authenticate()
    end
  end)

  sendbutton:on("release", function ()
    authenticate()
  end)

  return group
end

local group, showtitle = display.newGroup()

function login:init(titlebar)
  if group.numChildren > 0 then return end

  local top = titlebar:getBottom()
  local width, height = display.viewableContentWidth, display.viewableContentHeight - top
  local bg = display.newRect(group, 0, 0, width, height) bg:setFillColor(255, 255, 255)
  group.y = top

  showtitle = function () titlebar:setcaption("Inloggen") end
  showtitle()

  sendbutton = titlebar:addbutton("send", "6_social_send_now.png")
  sendbutton:hide()

  local form = createform(width - 32) group:insert(form)
  form.x, form.y = 16, 16
end

function login:show ()
  showtitle()
  local time = 400
  group.alpha = 1
  transition.from(group, {
    time = time,
    transition = easing.outExpo,
    x = group.contentWidth
  })
end

function login:hide ()
  sendbutton:hide()
  local time = 1200
  transition.to(group, {
    time = time,
    transition = easing.outExpo,
    alpha = 0,
    onComplete = function ()
      uid:reset()
      pwd:reset()
    end
  })
end

return login
