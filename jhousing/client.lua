local screenWidth, screenHeight = guiGetScreenSize()

addEvent("accessToJHouse",true)
addEventHandler("accessToJHouse",root,function(cmd,houseIDs)
	jhsWin = guiCreateWindow(screenWidth/8 - 305/2, screenHeight/2 - 500/2, 305, 500, "JHouse: House Creation Panel", false)
	guiWindowSetSizable(jhsWin, false)
	
	--Labals
	loc=guiCreateLabel(50, 45, 200, 13,"Location: NIL,NIL", false,jhsWin)
	addEventHandler("onClientRender",root,function()
		x,y,z = getElementPosition(localPlayer)
		guiSetText(loc,"Location: "..getZoneName(x,y,z,false)..","..getZoneName(x,y,z,true))
	end)
	guiCreateLabel(50, 65, 71, 16, "House Name: ", false,jhsWin)
	guiCreateLabel(50, 85, 61, 16, "House Price:", false,jhsWin)
	guiCreateLabel(130, 185, 46, 13, "Outside:", false,jhsWin)
	guiCreateLabel(130, 315, 46, 13, "Interior:", false,jhsWin)
	guiCreateLabel(50, 105, 46, 13, "Interior:", false,jhsWin)
	guiCreateLabel(50, 125, 51, 16, "Dimension:", false,jhsWin)
	
	--Buttons
	sign = guiCreateButton(120, 145, 75, 23, "Place Sign", false,jhsWin)
	OutsideIn = guiCreateButton(120, 205, 75, 23, "Place In", false,jhsWin)
	OutsideOut = guiCreateButton(120, 235, 75, 23, "Place Out", false,jhsWin)
	InsideOut = guiCreateButton(120, 335, 75, 23, "Place Out", false,jhsWin)
	InsideIn = guiCreateButton(120, 365, 75, 23, "Place In", false,jhsWin)
	goInt = guiCreateButton(120, 275, 75, 23, "Go Interior", false,jhsWin)
	close = guiCreateButton(260, 25, 31, 23, "X", false,jhsWin)
	finish = guiCreateButton(120, 435, 75, 23, "Finish", false,jhsWin)
	
	--Edits
	houseName = guiCreateEdit(120, 65, 113, 20, "House Name", false,jhsWin)
	housePrice = guiCreateEdit(120, 85, 113, 20, "House Price", false,jhsWin)
	intNum = guiCreateComboBox (100, 105,130, 70, "House Numbers", false,jhsWin)
	for i=0,2 do
		guiComboBoxAddItem(intNum,tostring(i))
	end
	dimNum = guiCreateEdit(110, 125, 51, 20,getElementDimension(localPlayer), false,jhsWin)
	dimN=guiGetText(dimNum)
	dimN = tonumber(dimN)
	addEventHandler("onClientMouseEnter",guiRoot,function()
		if source == sign then
			if not isElement(signMem)then
				signMem = guiCreateMemo(10, 145, 111, 111, "This would place a sign showing that the house is on Sale.", false,jhsWin)
			end
		elseif source == OutsideIn then
			if not isElement(OInMem)then
				OInMem = guiCreateMemo(190, 205, 111, 111, "This would be where the player has to enter to go into the house.", false,jhsWin)
			end
		elseif source == OutsideOut then
			if not isElement(OOutMem)then
				OOutMem = guiCreateMemo(10, 225, 111, 111, "This is where the player would be after coming out of the house.", false,jhsWin)
			end
		elseif source == InsideOut then
			if not isElement(IOutMem)then
				IOutMem = guiCreateMemo(10, 325, 111, 111, "This is where the player would need to stand/go to come out of the house.", false,jhsWin)
			end
		elseif source == InsideIn then
			if not isElement(IInMem)then
				IInMem = guiCreateMemo(190, 365, 117, 111, "This is where the player is going to stand/go after entering the marker from outside.", false,jhsWin)
			end
		elseif source == goInt then
			if not isElement(goIntMem)then
				goIntMem = guiCreateMemo(190, 275, 111, 100, "Click on this to go into the interior.", false,jhsWin)
			end
		end
	end)
	addEventHandler("onClientMouseLeave",guiRoot,function()
		if source == sign then
			if isElement(signMem)then
				destroyElement(signMem)
			end
		elseif source == OutsideIn then
			if isElement(OInMem)then
				destroyElement(OInMem)
			end
		elseif source == OutsideOut then
			if isElement(OOutMem)then
				destroyElement(OOutMem)
			end
		elseif source == InsideOut then
			if isElement(IOutMem)then
				destroyElement(IOutMem)
			end
		elseif source == InsideIn then
			if isElement(IInMem)then
				destroyElement(IInMem)
			end
		elseif source == goInt then
			if isElement(goIntMem)then
				destroyElement(goIntMem)
			end
		end
	end)
	addEventHandler("onClientGUIClick",guiRoot,function()
		if getElementType(source)=="gui-edit" then
			guiSetText(source,"")
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
			int = tonumber(guiComboBoxGetItemText(intNum,guiComboBoxGetSelected(intNum)))+1
			if not int then outputChatBox("Please select an house number!",100,0,0) return end
			local x1,y1,z1 = getElementPosition(localPlayer)
			triggerServerEvent("JW.Services",localPlayer,"tourHouse",int,x1,y1,z1,dimN)
		elseif source == InsideOut then
			if getElementInterior(localPlayer)==0 then outputChatBox("You aren't in the interior!",100,0,0) return end
			triggerServerEvent("JW.Services",localPlayer,"create","intOut")
		elseif source == InsideIn then
			if getElementInterior(localPlayer)==0 then outputChatBox("You aren't in the interior!",100,0,0) return end
			triggerServerEvent("JW.Services",localPlayer,"create","intIn")
		elseif source == finish then
			local houseNme = guiGetText(houseName)
			local housePrce = guiGetText(housePrice)
			if houseNme ~= "" and housePrce~="" and dimN then
				outputChatBox("Saving house, please wait...",0,100,0)
				triggerServerEvent("JW.Services",localPlayer,"storedb",houseNme,tonumber(housePrce),tonumber(int),dimN)
			end
		end
	end)
	guiSetVisible(jhsWin,false)
	outputChatBox("The JHouse Panel is ready now, type in '/"..cmd.."'")
	addCommandHandler(cmd,open)
end)

function open()
	if not guiGetVisible(jhsWin)then
		guiSetVisible(jhsWin,true)
		showCursor(true,false)
	else
		guiSetVisible(jhsWin,false)
		showCursor(false)
	end
end

local pickup = false

local clientGUI = guiCreateWindow(screenWidth/2 - 298/2, screenHeight/2 - 274/2, 298, 274, "Jhousing: Client GUI", false)
guiWindowSetSizable(clientGUI, false)

local hName=guiCreateLabel(60, 35, 171, 16, "House Name: Nil", false,clientGUI)
local hPrice=guiCreateLabel(60, 65, 171, 16, "House Price: Nil", false,clientGUI)
local hOwner=guiCreateLabel(60, 95, 171, 16, "Owner: Nil", false,clientGUI)
local hMessage=guiCreateLabel(60, 200, 171, 16, "", false,clientGUI)

local buyHouse = guiCreateButton(40, 125, 75, 23, "Buy", false,clientGUI)
guiSetEnabled(buyHouse,false)
local sellHouse = guiCreateButton(180, 125, 75, 23, "Sell", false,clientGUI)
guiSetEnabled(sellHouse,false)
local tourHouse = guiCreateButton(110, 175, 75, 23, "Tour It", false,clientGUI)
guiSetEnabled(tourHouse,false)
local guestHouse = guiCreateButton(154, 175, 101, 23, "Guest Key", false, clientGUI)
guiSetEnabled(guestHouse,false)
local closeWin = guiCreateButton(270, 25, 31, 23, "X", false,clientGUI)

local guestWin = guiCreateWindow(screenWidth/2 - 294/2, screenHeight/2 - 161/2, 294, 161, "MainWindow", false)
guiWindowSetSizable(guestWin, false)
	
guiCreateLabel(70, 45, 141, 16, "Please enter the Guest Key!", false, guestWin)

local key = guiCreateEdit(70, 65, 151, 20, "", false, guestWin)
	
local enter = guiCreateButton(110, 95, 75, 23, "Enter", false,guestWin)
local close2 = guiCreateButton(240, 15, 31, 23, "X", false,guestWin)

addEventHandler("onClientGUIClick",guiRoot,function()
	if source == buyHouse then
		if getPlayerMoney(localPlayer)<getElementData(pickup,"housePrice") then
			guiSetText(hMessage,"You don't have enough money!")
			setTimer(guiSetText,7000,1,hMessage,"")
			return
		end
		triggerServerEvent("JW.Services",localPlayer,"buyHouse",getElementData(pickup,"ID"),getElementData(pickup,"housePrice"))
	elseif source == sellHouse then
		triggerServerEvent("JW.Services",localPlayer,"sellHouse",getElementData(pickup,"ID"),getElementData(pickup,"housePrice"))
		guiSetEnabled(sellHouse,false)
		guiSetEnabled(buyHouse,true)
		guiSetEnabled(tourHouse,true)
	elseif source == tourHouse then
		if not isPedOnGround(localPlayer) then guiSetText(hMessage,"Please stay on the ground to go into the house!") return end
		local x1,y1,z1 = getElementPosition(localPlayer)
		triggerServerEvent("JW.Services",localPlayer,"tourHouse",getElementData(pickup,"Int"),x1,y1,z1,getElementData(pickup,"Dim"))
	elseif source == closeWin then
		pickup = false
		showCursor(false)
		guiSetText(hName,"House Name: Nil")
		guiSetText(hPrice,"House Price: Nil")
		guiSetText(hMessage,"")
		guiSetEnabled(buyHouse,false)
		guiSetEnabled(sellHouse,false)
		if isElement(tourHouse) then
			guiSetEnabled(tourHouse,false)
		end
		if isElement(guestHouse)then
			guiSetEnabled(guestHouse,false)
		end
		guiSetVisible(clientGUI,false)
	elseif source == guestHouse then
		local butText = guiGetText(source)
		if butText=="Enter as Guest" then
			guiSetVisible(guestWin,true)
		elseif butText == "Create GuestKey" then
			setElementData(localPlayer,"Pickup",pickup)
			triggerServerEvent("JW.Services",localPlayer,"giveRandomKey")
		elseif butText=="Delete GuestKey" then
			setElementData(pickup,"GuestKey",false)
			outputChatBox("House GuestKey cleared!",0,100,0)
		end
	elseif source==enter then
		triggerServerEvent("JW.Services",localPlayer,"guestEnter",guiGetText(key),getElementData(pickup,"GuestKey"),getElementData(pickup,"Int"),getElementData(pickup,"Dim"))
	elseif source==close2 then
		guiSetVisible(guestWin,false)
	end
end)
guiSetVisible(clientGUI,false)
guiSetVisible(guestWin,false)

addEvent("clientHousing",true)
addEventHandler("clientHousing",root,function(source,accName,tour,guest)
	
	guiSetVisible(clientGUI,true)
	showCursor(true)
	pickup = source
	guiSetText(hName,"House Name: "..getElementData(pickup,"houseName"))
	guiSetText(hPrice,"House Price: "..getElementData(pickup,"housePrice"))
	local owner = getElementData(pickup,"Owner")
	guiSetText(hOwner,"Owner: "..owner)
	if owner=="No One" then
		guiSetEnabled(buyHouse,true)
		guiSetEnabled(tourHouse,true)
	elseif owner==accName then
		guiSetEnabled(sellHouse,true)
		if isElement(guestHouse) then
			guiSetEnabled(guestHouse,true)
			if getElementData(pickup,"GuestKey")then
				guiSetText(guestHouse,"Delete GuestKey")
			else
				guiSetText(guestHouse,"Create GuestKey")
			end
		end
	else
		if isElement(guestHouse) then
			if getElementData(pickup,"GuestKey")then
				guiSetEnabled(guestHouse,true)
				guiSetText(guestHouse,"Enter as Guest")
			end
		end
		guiSetText(hMessage,"This house isn't for sale!")
	end
	
	if tour=="false" and guest=="false" then
		if isElement(tourHouse) and isElement(guestHouse)then
			destroyElement(tourHouse)
			destroyElement(guestHouse)
		end
	elseif tour=="true" and guest=="false" then
		if isElement(guestHouse)then
			destroyElement(guestHouse)
		end
	elseif tour=="false" and guest=="true" then
		if isElement(tourHouse)then
			destroyElement(tourHouse)
		end
		guiSetPosition(guestHouse,110,175,false)
	elseif tour=="true" and guest=="true" then
		guiSetPosition(tourHouse,40,175,false)
	end
end)
