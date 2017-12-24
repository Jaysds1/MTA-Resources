local screenWidth, screenHeight = guiGetScreenSize()

local width = 300
local height = 300

local left = screenWidth/10.7 - width/2
local top = screenHeight/3 - height/2

local isNormal = true
local isJoin = true

thisResource = thisResource or getThisResource()

addEvent("login",true)
addEvent("JW.Service",true)

addEventHandler("onClientResourceStart",resourceRoot,function(res)
	if res~=thisResource then return end
	triggerServerEvent("JW.Service",root,"ready")
	addEventHandler("onClientRender",root,showDX)
end)

--DX
local joinName = false
local loginName = false
local quitName = false
function showDX()
	if joinName then
		dxDrawText("Joined: "..joinName,left,top,width,height,tocolor(0,100,0),1.3)
	end
	if loginName then
		dxDrawText("Logged-In: "..loginName,left,top,width,height,tocolor(0,100,0),1.3)
	end
	if quitName then
		dxDrawText("Quit: "..quitName,left,top+100,width,height,tocolor(100,0,0),1.3)
	end
end

addCommandHandler("t",function()
	local tst = GuiLabel(left,top,width,height,"Test: "..localPlayer.name,false)
	Timer(function()
		tst:destroy()
	end,7000,1)
end)

local jon,jPn
addEventHandler("onClientPlayerJoin",root,function()
	if not isJoin then return end
	local name = source.name
	if isNormal then
		if isElement(jon) then
			pn:reset()
			jon:setText("Joined: "..name)
		else
			jon = GuiLabel(left,top,width,height,"Joined: "..name,false)
			jon:setColor(0,100,0)
			jPn = Timer(function()
				jon:destroy()
			end,7000,1)
		end
	else
		joinName = name
		Timer(function()
			name = false
		end,7000,1)
	end
end)

local log,lPn
addEventHandler("login",root,function(name)
	if isJoin or isJoin~=false then return end
	if isNormal then
		if isElement(log) then
			pn:reset()
			log:setText("Logged-In: "..name)
		else
			log = GuiLabel(left,top,width,height,"Logged-In: "..name,false)
			log:setColor(0,100,0)
			lPn = Timer(function()
				log:destroy()
			end,7000,1)
		end
	else
		loginName = name
		Timer(function()
			loginName = false
		end,7000,1)
	end
end)

local lev,lv
addEventHandler("onClientPlayerQuit",root,function(reason)
	local name = source.name
	if isNormal then
		if isElement(lev)then
			lv:reset()
			lev:setText("Left: "..name.."["..reason.."]")
		else
			lev = GuiLabel(left,top+100,width,height,"Left: "..name.."["..reason.."]",false)
			lev:setColor(100,0,0)
			lv = Timer(function()
				lev:destroy()
			end,7000,1)
		end
	else
		quitName = name
		Timer(function()
			quitName = false
		end,7000,1)
	end
end)

--Checking
addEventHandler("JW.Service",root,function(guityp,typ)
	isNormal = guityp
	isJoin = typ
end)