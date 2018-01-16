local screenWidth, screenHeight = guiGetScreenSize()
local jhsWin,loc
local sign,OutsideIn,OutsideOut,InsideIn,InsideOut,goInt,close,finish -- Buttons
local houseName,housePrice,intNum,dimNum --Edits
local signMem,OInMem,OOutMem,IOutMem,IInMem,goIntMem --Memos

addEvent("accessToJHouse",true)
addEventHandler("accessToJHouse",root,function(cmd,houseIDs)
	jhsWin = GuiWindow(screenWidth/8 - 305/2, screenHeight/2 - 500/2, 305, 500, "JHouse: House Creation Panel", false)
	jhsWin:setSizable(false)
	
	--Labals
	loc=GuiLabel(50, 45, 200, 13,"Location: NIL,NIL", false,jhsWin)
	addEventHandler("onClientRender",root,function()
		x,y,z = getElementPosition(localPlayer)
		loc.text = "Location: "..getZoneName(x,y,z,false)..","..getZoneName(x,y,z,true))
	end)
	GuiLabel(50, 65, 71, 16, "House Name: ", false,jhsWin)
	GuiLabel(50, 85, 61, 16, "House Price:", false,jhsWin)
	GuiLabel(130, 185, 46, 13, "Outside:", false,jhsWin)
	GuiLabel(130, 315, 46, 13, "Interior:", false,jhsWin)
	GuiLabel(50, 105, 46, 13, "Interior:", false,jhsWin)
	GuiLabel(50, 125, 51, 16, "Dimension:", false,jhsWin)
	
	--Buttons
	sign = GuiButton(120, 145, 75, 23, "Place Sign", false,jhsWin)
	OutsideIn = GuiButton(120, 205, 75, 23, "Place In", false,jhsWin)
	OutsideOut = GuiButton(120, 235, 75, 23, "Place Out", false,jhsWin)
	InsideOut = GuiButton(120, 335, 75, 23, "Place Out", false,jhsWin)
	InsideIn = GuiButton(120, 365, 75, 23, "Place In", false,jhsWin)
	goInt = GuiButton(120, 275, 75, 23, "Go Interior", false,jhsWin)
	close = GuiButton(260, 25, 31, 23, "X", false,jhsWin)
	finish = GuiButton(120, 435, 75, 23, "Finish", false,jhsWin)
	
	--Edits
	houseName = GuiEdit(120, 65, 113, 20, "House Name", false,jhsWin)
	housePrice = GuiEdit(120, 85, 113, 20, "House Price", false,jhsWin)
	intNum = GuiComboBox (100, 105,130, 70, "House Numbers", false,jhsWin)
	for i=0,2 do
		intNum:addItem(tostring(i))
	end
	dimNum = GuiEdit(110, 125, 51, 20,localPlayer.dimension, false,jhsWin)
	dimN = tonumber(dimNum.text)
	addEventHandler("onClientMouseEnter",guiRoot,function()
		if source == sign then
			if not isElement(signMem)then
				signMem = GuiMemo(10, 145, 111, 111, "This would place a sign showing that the house is on Sale.", false,jhsWin)
			end
		elseif source == OutsideIn then
			if not isElement(OInMem)then
				OInMem = GuiMemo(190, 205, 111, 111, "This would be where the player has to enter to go into the house.", false,jhsWin)
			end
		elseif source == OutsideOut then
			if not isElement(OOutMem)then
				OOutMem = GuiMemo(10, 225, 111, 111, "This is where the player would be after coming out of the house.", false,jhsWin)
			end
		elseif source == InsideOut then
			if not isElement(IOutMem)then
				IOutMem = GuiMemo(10, 325, 111, 111, "This is where the player would need to stand/go to come out of the house.", false,jhsWin)
			end
		elseif source == InsideIn then
			if not isElement(IInMem)then
				IInMem = GuiMemo(190, 365, 117, 111, "This is where the player is going to stand/go after entering the marker from outside.", false,jhsWin)
			end
		elseif source == goInt then
			if not isElement(goIntMem)then
				goIntMem = GuiMemo(190, 275, 111, 100, "Click on this to go into the interior.", false,jhsWin)
			end
		end
	end)
	addEventHandler("onClientMouseLeave",guiRoot,function()
		if source == sign then
			if isElement(signMem)then
				signMem:destroy()
			end
		elseif source == OutsideIn then
			if isElement(OInMem)then
				OInMem:destroy()
			end
		elseif source == OutsideOut then
			if isElement(OOutMem)then
				OOutMem:destroy()
			end
		elseif source == InsideOut then
			if isElement(IOutMem)then
				IOutMem:destroy()
			end
		elseif source == InsideIn then
			if isElement(IInMem)then
				IInMem:destroy()
			end
		elseif source == goInt then
			if isElement(goIntMem)then
				goIntMem:destroy()
			end
		end
	end)
	addEventHandler("onClientGUIClick",guiRoot,function()
		if source.type == "gui-edit" then
			source.text = ""
			guiSetInputEnabled(true)
		else
			guiSetInputEnabled(false)
		end
		if source == close then
			open()
		elseif source == sign then
			triggerServerEvent("JW.Services",localPlayer,"create","sale")
		elseif source == OutsideIn then
			triggerServerEvent("JW.Services",localPlayer,"create","outIn")
		elseif source == OutsideOut then
			triggerServerEvent("JW.Services",localPlayer,"create","outOut")
		elseif source == goInt then
			int = tonumber(intNum:getItemText(intNum:getSelected()))+1
			if not int then outputChatBox("Please select an house number!",100,0,0) return end
			local x1,y1,z1 = getElementPosition(localPlayer)
			triggerServerEvent("JW.Services",localPlayer,"tourHouse",int,x1,y1,z1,dimN)
		elseif source == InsideOut then
			if localPlayer.interior == 0 then outputChatBox("You aren't in the interior!",100,0,0) return end
			triggerServerEvent("JW.Services",localPlayer,"create","intOut")
		elseif source == InsideIn then
			if localPlayer.interior == 0 then outputChatBox("You aren't in the interior!",100,0,0) return end
			triggerServerEvent("JW.Services",localPlayer,"create","intIn")
		elseif source == finish then
			local houseNme,housePrce = houseName.text, housePrice.text
			if houseNme ~= "" and housePrce~="" and dimN then
				outputChatBox("Saving house, please wait...",0,100,0)
				triggerServerEvent("JW.Services",localPlayer,"storedb",houseNme,tonumber(housePrce),tonumber(int),dimN)
			end
		end
	end)
	jhsWin.visible = false
	outputChatBox("The JHouse Panel is ready now, type in '/"..cmd.."'")
	addCommandHandler(cmd,open)
end)

function open()
	if not jhsWin.visible then
		jhsWin.visible = true
		showCursor(true,false)
	else
		jhsWin.visible = false
		showCursor(false)
	end
end

local pickup = false

local clientGUI = GuiWindow(screenWidth/2 - 298/2, screenHeight/2 - 274/2, 298, 274, "Jhousing: Client GUI", false)
clientGUI:setSizable(false)

local hName=GuiLabel(60, 35, 171, 16, "House Name: Nil", false,clientGUI)
local hPrice=GuiLabel(60, 65, 171, 16, "House Price: Nil", false,clientGUI)
local hOwner=GuiLabel(60, 95, 171, 16, "Owner: Nil", false,clientGUI)
local hMessage=GuiLabel(60, 200, 171, 16, "", false,clientGUI)

local buyHouse = GuiButton(40, 125, 75, 23, "Buy", false,clientGUI)
buyHouse.enabled = false
local sellHouse = GuiButton(180, 125, 75, 23, "Sell", false,clientGUI)
sellHouse.enabled = false
local tourHouse = GuiButton(110, 175, 75, 23, "Tour It", false,clientGUI)
tourHouse.enabled = false
local guestHouse = GuiButton(154, 175, 101, 23, "Guest Key", false, clientGUI)
guestHouse.enabled = false
local closeWin = GuiButton(270, 25, 31, 23, "X", false,clientGUI)

local guestWin = GuiWindow(screenWidth/2 - 294/2, screenHeight/2 - 161/2, 294, 161, "MainWindow", false)
guestWin:setSizable(false)

GuiLabel(70, 45, 141, 16, "Please enter the Guest Key!", false, guestWin)

local key = GuiEdit(70, 65, 151, 20, "", false, guestWin)
	
local enter = GuiButton(110, 95, 75, 23, "Enter", false,guestWin)
local close2 = GuiButton(240, 15, 31, 23, "X", false,guestWin)

addEventHandler("onClientGUIClick",guiRoot,function()
	if source == buyHouse then
		if localPlayer.money<pickup:getData("housePrice") then
			hMessage.text = "You don't have enough money!"
			Timer(hMessage:setText,7000,1,"")
			return
		end
		triggerServerEvent("JW.Services",localPlayer,"buyHouse",pickup:getData("ID"),pickup:getData("housePrice"))
	elseif source == sellHouse then
		triggerServerEvent("JW.Services",localPlayer,"sellHouse",pickup:getData("ID"),pickup:getData("housePrice"))
		sellHouse.enabled = false
		buyHouse.enabled = true
		tourHouse.enabled = true
	elseif source == tourHouse then
		if not localPlayer.onGround then hMessage.text = "Please stay on the ground to go into the house!" return end
		local x1,y1,z1 = getElementPosition(localPlayer)
		triggerServerEvent("JW.Services",localPlayer,"tourHouse",pickup:getData("Int"),x1,y1,z1,pickup:getData("Dim"))
	elseif source == closeWin then
		pickup = false
		showCursor(false)
		hName.text = "House Name: Nil"
		hPrice.text = "House Price: Nil"
		hMessage.text = ""
		buyHouse.enabled = false
		sellHouse.enabled = false
		if isElement(tourHouse) then
			tourHouse.enabled = false
		end
		if isElement(guestHouse)then
			guestHouse.enabled = false
		end
		clientGUI.visible = false
	elseif source == guestHouse then
		local butText = source.text
		if butText=="Enter as Guest" then
			guestWin.visible = true
		elseif butText == "Create GuestKey" then
			localPlayer:setData("Pickup",pickup)
			triggerServerEvent("JW.Services",localPlayer,"giveRandomKey")
		elseif butText=="Delete GuestKey" then
			pickup:setData("GuestKey",false)
			outputChatBox("House GuestKey cleared!",0,100,0)
		end
	elseif source==enter then
		triggerServerEvent("JW.Services",localPlayer,"guestEnter",key.text,pickup:getData("GuestKey"),pickup:getData("Int"),pickup:getData("Dim"))
	elseif source==close2 then
		guestWin.visible = false
	end
end)
clientGUI.visible = false
guestWin.visible = false

addEvent("clientHousing",true)
addEventHandler("clientHousing",root,function(source,accName,tour,guest)
	clientGUI.visible = true
	showCursor(true)
	pickup = source
	hName.text = "House Name: "..pickup:getData("houseName")
	hPrice.text = "House Price: "..pickup:getData("housePrice")
	local owner = pickup:getData("Owner")
	hOwner.text = "Owner: "..owner
	if owner=="No One" then
		buyHouse.enabled = true
		tourHouse.enabled = true
	elseif owner==accName then
		sellHouse.enabled = true
		if isElement(guestHouse) then
			guestHouse.enabled = true
			if pickup:getData("GuestKey")then
				guestHouse.text = "Delete GuestKey"
			else
				guestHouse.text = "Create GuestKey"
			end
		end
	else
		if isElement(guestHouse) then
			if pickup:getData("GuestKey")then
				guestHouse.enabled = true
				guestHouse.text = "Enter as Guest"
			end
		end
		hMessage.text = "This house isn't for sale!"
	end
	
	if tour=="false" and guest=="false" then
		if isElement(tourHouse) and isElement(guestHouse)then
			tourHouse:destroy()
			guestHouse:destroy()
		end
	elseif tour=="true" and guest=="false" then
		if isElement(guestHouse)then
			guestHouse:destroy()
		end
	elseif tour=="false" and guest=="true" then
		if isElement(tourHouse)then
			tourHouse:destroy()
		end
		guestHouse:setPosition(110,175,false)
	elseif tour=="true" and guest=="true" then
		tourHouse:setPosition(40,175,false)
	end
end)