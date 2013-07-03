local EventEmitter = require("lua-events").EventEmitter
local widget = require("widget")
local showerror = require("showerror")
local json = require("json")

local login = EventEmitter:new()

local function createtextfield (width, hint, returnKey, isSecure)
  local group = EventEmitter:new(display.newGroup())
  local value, textfield = ""

  local line = display.newLine(group, 0,40, 0,44)
  line:append(width,44, width,40)
  line:setColor(153, 153, 153)

  local placeholdertext = display.newText(group, hint, 9, 8, width - 13, 40, "Roboto-Regular", 18)
  placeholdertext:setTextColor(153, 153, 153)

  local function setvalue (newvalue)
    local oldvalue = value
    value = newvalue
    if value ~= oldvalue then
      group:emit("change", hint, value)
    end
  end

  local function finish (submit)
    if not textfield then return end
    textfield.isVisible = false
    textfield:removeSelf() textfield = nil
    local text = value
    if text == "" then
      text = hint
    elseif isSecure then
      text = string.gsub(text, ".", "*")
    end
    placeholdertext.text = text
    placeholdertext.isVisible = true
    line:setColor(153, 153, 153)
    line.width = 1
    if submit then group:emit("submit") end
  end

  local function input (event)
    if event.phase == "began" then
      placeholdertext.text = hint
      setvalue("")
    elseif event.phase == "ended" then
      finish()
    elseif event.phase == "submitted" then
      finish(true)
    elseif event.phase == "editing" then
      placeholdertext.isVisible = false
      setvalue(textfield.text)
    end
  end

  local function focus ()
    line:setColor(0, 153, 204)
    line.width = 2
    -- trial and error positioning ftw ;-)
    local left, top = placeholdertext:contentToLocal(placeholdertext.x, placeholdertext.y)
    textfield = native.newTextField(0 - left, 4 - top, width, 40)
    textfield.font = native.newFont("Roboto-Regular", 18)
    textfield.hasBackground = false
    textfield.isSecure = isSecure or false
    textfield:setReturnKey(returnKey)
    textfield:addEventListener("userInput", input)
    native.setKeyboardFocus(textfield)
    textfield.fieldgroup = group
  end

  function placeholdertext:touch (event)
    if event.phase == "ended" then
      focus()
    end
    return true
  end placeholdertext:addEventListener("touch", placeholdertext)

  function group:focus () focus() end
  function group:finish () finish() end
  function group:value () return value end

  return group
end

local function createform (width)
  local group = display.newGroup()

  local caption = display.newText(group, "INLOGGEN", 9, 0, "Roboto-Regular", 14)
  caption:setTextColor(51, 181, 229)

  local line = display.newLine(group, 0,0, width,0)
  line:setColor(51, 181, 229)
  line.y = caption.y + caption.contentHeight / 2 + 4

  local uid = createtextfield(width, "Gebruikersnaam", "next") -- hilhorst averschuur
  group:insert(uid)
  uid.y = line.y

  local pwd = createtextfield(width, "Wachtwoord", "go", true) -- 171049 huurcave-4711
  group:insert(pwd)
  pwd.y = uid.y + 48

  local function authenticate (uid, pwd)
    local url = "https://www.greenhillhost.nl/ws_zapp/getCredentials/"
    url = url .. "?frmUsername=" .. uid
    url = url.. "&frmPassword=" .. pwd
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
  
  local button = widget.newButton({
    label = "Inloggen",
    left = 0, top = pwd.y + 52, width = width, height = 40,
    font = "Roboto-Regular", fontSize = 18,
    onRelease = function ()
      uid:finish() pwd:finish()
      authenticate(uid:value(), pwd:value())
    end
  }) group:insert(button)
  button.isVisible = false
  
  local testbutton = widget.newButton({
    label = "Dev: inloggen default account",
    left = 0, top = button.y + 24, width = width, height = 40,
    font = "Roboto-Regular", fontSize = 18,
    isEnabled = true,
    onRelease = function ()
      uid:finish() pwd:finish()
      authenticate("averschuur", "huurcave-4711")
    end
  }) group:insert(testbutton)

  local function newvalue ()
    if #uid:value() > 0 and #pwd:value() > 0 then
      button.isVisible = true
    else
      button.isVisible = false
    end
  end
  uid:on("change", newvalue)
  pwd:on("change", newvalue)

  uid:on("submit", function () pwd:focus() end)
  pwd:on("submit", function ()
    if #uid:value() > 0 and #pwd:value() > 0 then
      native.setKeyboardFocus(nil)
      authenticate(uid:value(), pwd:value())
    end
  end)

  return group
end

local group = display.newGroup()

function login:init(top)
  if group.numChildren > 0 then return end
  local width, height = display.viewableContentWidth, display.viewableContentHeight - top
  local bg = display.newRect(group, 0, 0, width, height) bg:setFillColor(255, 255, 255)
  group.y = top
  local form = createform(width - 32) group:insert(form)
  form.x, form.y = 16, 16
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
end

return login
