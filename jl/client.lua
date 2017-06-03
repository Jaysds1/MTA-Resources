local screenWidth, screenHeight = guiGetScreenSize() --Get User Screen
local left,top = screenWidth/2 - 382/2,screenHeight/2 - 275/2 --X,Y position of window
local isNormal,isLogin
local pic = false

addEventHandler("onClientResourceStart",resourceRoot,function(res) --Called when resource starts
	if res~=getThisResource() then return end
	normalWin() --Create the Normal GUI Window
	local xml=XML.load("@JW.xml") --xmlLoadFile("@JW.xml") Load User Data
	if xml then
		local saveUser,savePass=xml.getAttribute("SaveUser"),xml.getAttribute("SavePass") --Get user's saved username and password
		if saveUser~="" then
			Username.setText(saveUser)--guiSetText(Username,saveUser) Set Username
		end
		if savePass~="" then
			Password.setText(savePass)--guiSetText(Password,savePass) Set Password
		end
		if xml.getAttribute("AutoLogin")=="true"then --Check if auto login is enabled
			AutoLogin.setSelected(true)
			Timer( --Call Login after 3secs
				triggerServerEvent,
				3000,1,
				"JW.Services",localPlayer,"autologin",xml.getAttribute("SaveUser"),xml.getAttribute("SavePass")
			)
		end
	else
		--Create User Data File
		xml = XML("@JW.xml","JWL")
		xml.setAttribute("SaveUser","")
		xml.setAttribute("SavePass","")
		xml.setAttribute("AutoLogin","false")
	end
	xml.saveFile()
end)

-------- Normal Login Panel ---------- 
function normalWin()
	LoginPanel = GuiWindow(left,top, 382, 275, "JW137: Login Panel", false)
	LoginPanel.setSizable(false)
	LoginPanel.SetMovable(false)
	showCursor(true)

	GuiLabel(50, 73, 71, 16, "Username:", false,LoginPanel)
	GuiLabel(50, 123, 71, 16, "Password:", false,LoginPanel)

	Login = GuiButton(50, 193, 75, 23, "Login", false,LoginPanel)
	Register = GuiButton(250, 193, 75, 23, "Register", false,LoginPanel)

	Username = GuiEdit(130, 73, 113, 20, "", false,LoginPanel)
	Password = GuiEdit(130, 123, 113, 20, "", false,LoginPanel)
	Password.setMasked(true)

	Forgot = GuiButton(150, 193, 75, 23, "Forgot?", false,LoginPanel)

	UsernameSave = GuiCheckBox(250, 73, 51, 17, "Save", false, false,LoginPanel)
	PasswordSave = GuiCheckBox(250, 123, 70, 17, "Save", false, false,LoginPanel)

	AutoLogin = GuiCheckBox(250, 95, 131, 17, "Auto-Login", false, false,LoginPanel)
	
	Masked = GuiCheckBox(300, 123, 70, 17, "Masked", true, false, LoginPanel)
	
	--Help = GuiButton(0, 15, 71, 21, "Help", false,LoginPanel)
	
	GetNick = GuiLabel(300, 75, 46, 13, "Get Nick", false,LoginPanel)

	isNormal = true
	isLogin = true
end
function RegisterPanel()
	local close = GuiButton(350, 15, 31, 23, "X", false,LoginPanel)
	elbl=GuiLabel(50, 155, 71, 16, "Email:", false,LoginPanel)
	Email = GuiEdit(130, 155, 113, 20, "", false, LoginPanel)
	Login.SetEnabled(false)
	LoginPanel.SetSize(382, 291,false)
	isLogin = false
	addEventHandler("onClientGUIClick",close,function()
		Email.destroy()
		elbl.destroy()
		close.destroy()
		LoginPanel.setSize(382, 275,false)
		Login.setEnabled(true)
		isLogin = true
	end,false)
end

---Option Windows---

function optWin(typ,reason)
	if isElement(optWindow)then
		res.setText(reason)
		if autoClose then
			autoClose.reset()
		end
		return
	end
	local optWindow = GuiWindow(screenWidth/2 - 253/2, screenHeight/2 - 222/2, 253, 222, "", false)
	optWindow.setSizable(false)

	GuiLabel(10, 25, 71, 16, typ, false,optWindow)
	res=GuiMemo(50, 45, 161, 71, reason , false,optWindow)

	local close = GuiButton(90, 145, 75, 23, "Ok", false,optWindow)
	autoClose=Timer(function()
		optWindow.destroy()
	end,5000,1)
	addEventHandler("onClientGUIClick",close,function()
		optWindow.destroy()
		autoClose.destroy()
	end,false)
end
function showOpt(typ)	
	optWind = GuiWindow(screenWidth/2 - 366/2,screenHeight/2 - 194/2,366,194,"Option Window", false)
	optWind.setSizable(false)
	local close = GuiButton(330, 25, 21, 21, "X", false,optWind)
	addEventHandler("onClientGUIClick",close,function()
		optWind.destroy()
	end)
	if typ=="forgot"then
		optWind.setText("Forgot Window")
		GuiLabel(130, 65, 111, 16, "What's your email?", false,optWind)
		local email = GuiEdit(100, 95, 140, 20, "", false,optWind)
		local done = GuiButton(150, 125, 75, 23, "Send", false,optWind)
		addEventHandler("onClientGUIClick",done,function(btn)
			if btn=="left" then
				triggerServerEvent("JW.Services",localPlayer,"email",_,_,email.getText())
			end
		end,false)
	--elseif typ=="help" then
	end
end

---Additional---
addEventHandler("onClientGUIClick",guiRoot,function(btn)
	if btn=="left" then
		guiSetInputEnabled(if source.getType()=="gui-edit" then true else false end)
		--[[if source.getType()=="gui-edit" then
			guiSetInputEnabled(true)
		else
			guiSetInputEnabled(false)
		end]]
		if(source==Login)then
			triggerServerEvent("JW.Services",localPlayer,Login.getText(),Username.getText(),Password.getText())
		elseif(source==Register)then
			if isLogin then
				RegisterPanel()
			else
				triggerServerEvent("JW.Services",localPlayer,"Register",Username.getText(),Password.getText(),Email.getText())
			end
		elseif(source==GetNick)then
			Username.setText(getPlayerName(localPlayer))
		elseif(source==Masked)then
			Password.setMasked(Masked.getSelected())
		elseif(source==Forgot)then
			showOpt("forgot")
		end
	end
end,true)

addEvent("JW.Services",true)
addEventHandler("JW.Services",root,function(typ,reason,com)
	optWin(typ,reason)
	if isElement(optWind) then
		optWind.destroy()
	end
	local xml = XML.Load("@JW.xml")
	if typ=="success" then
		removeEventHandler("onClientKey",root,lgin)
		showCursor(false)
		if isElement(pic) then
			pic.destroy()
		end
		xml.setAttribute("SaveUser",if UsernameSave.getSelected() then Username.getText() else "" end)
		--[[if UsernameSave.getSelected()then
			xml.setAttribute("SaveUser",Username.getText())
		else
			xmlNodeSetAttribute(xml,"SaveUser","")
		end]]
		xml.setAttribute("SavePass",if PasswordSave.getSelected() then Password.getText() else "" end)
		--[[if PasswordSave.getSelected()then
			xml.setAttribute("SavePass",Password.getText())
		else
			xml.setAttribute("SavePass","")
		end]]
		if AutoLogin.getSelected()then
			xml.setAttribute("AutoLogin","true")
			xml.setAttribute("SaveUser",Username.getText())
			xml.setAttribute("SavePass",Password.getText())
		else
			xml.setAttribute("AutoLogin","false")
			xml.setAttribute("SaveUser","")
			xml.setAttribute("SavePass","")
		end
		if com and com~="" then
			addCommandHandler("rauto",function()
				xml.setAttribute("AutoLogin","false")
				outputChatBox("Auto-Login removed!",0,100,0)
			end)
			Timer(removeCommandHandler,10000,1,"rauto")
		end
		xml.saveFile()
	elseif typ =="login" then
		Timer(normalWin,3000,1)
	elseif typ=="pic" then
		if reason=="true" then
			pic=guiCreateStaticImage(0,0,screenWidth,screenHeight,com,false)
		end
	end
end)

function lgin(key,release)
	if key=="enter" and release then
		triggerServerEvent("JW.Services",source,"Login",Username.getText(),Password.getText())
	end
end
addEventHandler("onClientKey",root,lgin)