local function login ()
	-- activeer de widget
	local widget = require "widget"
	-- maak de achtergrond
	local _H = display.contentHeight
	local _W = display.contentWidth
	local background = display.newImageRect("background.png",_W,_H)
	background:setReferencePoint(display.CenterReferencePoint)
	background.x = _W/2
	background.y = _H/2
	-- toon tekst
	local _heightBase = 300
	local _heightDiff = 30
	local _textIndent = 130
	local textUsername = display.newText("gebruikersnaam",0,_heightBase,nil,14)
	textUsername:setReferencePoint(display.CenterRightReferencePoint)
	textUsername.x = _textIndent;
	local textPassword = display.newText("wachtwoord",0,_heightBase+_heightDiff,nil,14)
	textPassword:setReferencePoint(display.CenterRightReferencePoint)
	textPassword.x = _textIndent;
	-- creer de inputvelden
	local _textIndent = 300
	local usernameField = native.newTextField(_textIndent,_heightBase,140,24)
	usernameField:setReferencePoint(display.CenterRightReferencePoint)
	usernameField.x = _textIndent
	local passwordField = native.newTextField(_textIndent,_heightBase+_heightDiff,140,24)
	passwordField:setReferencePoint(display.CenterRightReferencePoint)
	passwordField.x = _textIndent
	--maak inloggen knop
	local loginButton = widget.newButton{
		label = "inloggen",
		fontSize = 10
	}
	loginButton.x = 0
	loginButton.y = 400
	loginButton:setReferencePoint(display.CenterRightReferencePoint)
	loginButton.x = _textIndent;
end

return login