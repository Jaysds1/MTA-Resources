--Create Tab Panel
local SaveTab = GuiTabPanel(302, 224, 375, 339, false)
SaveTab:setAlpha(1)
SaveTab:setVisible(false)

--Create HomePage
local hompage = GuiTab("Homepage", SaveTab)
GuiStaticImage(33, 10, 73, 64, "mtalogo.png", false, hompage)
GuiStaticImage(104, 6, 217, 67, "save.png", false, hompage)
GuiLabel(15, 248, 13, 16, "Hi,", false, hompage)
GuiLabel(31, 249, 190, 14, localPlayer.name, false, hompage)
local memo = GuiMemo(25, 80, 299, 150, "Hi,\nWelcome to the new Save Panel.\n\nTo start saving, Please click on one of the tabs above.\n\n-Jaysds1\n(Bringing MTA to the next level)", false, hompage)
memo:setReadOnly(true)
local copy = GuiLabel(8, 276, 265, 33, "Copyright (c) 2011-2017 All Rights Are Reserved With MTA & JQuonProjects(formly JWorld137)", false, hompage)
copy:setHorizontalAlign("left",true)

--Create Re-Usable Elements
local x = GuiEdit(23, 21, 161, 27, "X", false)
x:setReadOnly(true)
x.visible = false
local y = GuiEdit(23, 52, 161, 27, "Y", false)
y:setReadOnly(true)
y.visible = false
local z = GuiEdit(23, 83, 161, 27, "Z", false)
z:setReadOnly(true)
z.visible = false
local getPos = GuiButton(205, 53, 130, 29, "Get Position", false)
getPos.visible = false
local rot = GuiEdit(23, 128, 161, 27, "Optional: Rotation", false)
rot:setReadOnly(true)
rot.visible = false
local getRot = GuiButton(204, 128, 130, 29, "Get Rotation", false)
getRot.visible = false
local model = GuiEdit(22, 20, 50, 27, "Model", false)
model.visible = false
local getMP = GuiButton(213, 77, 130, 29, "Get Model & Position", false)
getMP.visible = false
local rotX = GuiEdit(22, 132, 161, 27, "Rotation X", false)
rotX:setReadOnly(true)
rotX.visible = false
local rotY = GuiEdit(22, 162, 161, 27, "Rotation Y", false)
rotY:setReadOnly(true)
rotY.visible = false
local rotZ = GuiEdit(21, 191, 161, 27, "Rotation Z", false)
rotZ:setReadOnly(true)
rotZ.visible = false
local done = GuiButton(205, 239, 130, 29, "Done", false)
done.visible = false


local function changeTab(g,x,y,w,h,p)
	g:setParent(p)
	g:setPosition(x,y,false)
	g:setSize(w,h,false)
	if not g.visible then
		g:setVisible(true)
	end
end


--Spawn Tab
local spawnTB = GuiTab("Spawn", SaveTab)
changeTab(x, 23, 21, 161, 27, spawnTB)
changeTab(y, 23, 52, 161, 27, spawnTB)
changeTab(z, 23, 83, 161, 27, spawnTB)
changeTab(getPos, 205, 53, 130, 29, spawnTB)
changeTab(rot, 23, 128, 161, 27,spawnTB)
changeTab(getRot,204, 128, 130, 29,spawnTB)
local skin1 = GuiEdit(24, 162, 161, 27, "Skin", false, spawnTB)
skin1:setReadOnly(true)
skin1:setMaxLength(3)
local int = GuiEdit(24, 194, 161, 27, "Interior", false, spawnTB)
int:setReadOnly(true)
int:setMaxLength(2)
local dim = GuiEdit(25, 225, 161, 27, "Optional: Dimension", false, spawnTB)
local team = GuiEdit(24, 257, 161, 27, "Optional: The Team", false, spawnTB)
local getInt = GuiButton(204, 195, 130, 29, "Get Interior", false, spawnTB)
local getSkin = GuiButton(204, 161, 130, 29, "Get Skin ID", false, spawnTB)
changeTab(done,205, 239, 130, 29, spawnTB)
local preview1 = GuiEdit(23, 288, 329, 23, "Format: spawnPlayer(source,x,y,z,rot,skin,int,dim,team)", false, spawnTB)
preview1:setReadOnly(true)

--Marker Tab
local markerTB = GuiTab("Marker", SaveTab)
local MType = GuiEdit(23, 117, 161, 27, "Types: checkpoint, ring, cylinder, arrow, corona", false, markerTB)
local MSize = GuiEdit(22, 151, 50, 27, "Size", false, markerTB)
local MRed = GuiEdit(78, 151, 50, 27, "Red", false, markerTB)
local MGreen = GuiEdit(135, 152, 50, 27, "Green", false, markerTB)
local MBlue = GuiEdit(191, 154, 50, 27, "Blue", false, markerTB)
local MAlpha = GuiEdit(245, 155, 50, 27, "Alpha", false, markerTB)
local MVisible = GuiEdit(22, 192, 161, 27, "visibleTo = getRootElement", false, markerTB)
GuiEdit(23, 272, 313, 26, "This is the format: createMarker(x,y,z,type,s,r,g,b)", false, markerTB)
GuiLabel(191, 125, 151, 16, "Type in the type of marker", false, markerTB)
local note = GuiLabel(297, 147, 72, 60, "0-255 for the \"Red, Green, Blue, Alpha\"", false, markerTB)
note:setVerticalAlign("center")
note:setHorizontalAlign("center", true)
local note1 = GuiLabel(183, 190, 115, 73, " <If you type anything in here, then the whole script is going to be Server-sided.", false, markerTB)
note1:setVerticalAlign("center")
note1:setHorizontalAlign("center", true)

--Vehicle Tab	
local vehicleTB = GuiTab("Vehicle", SaveTab)
changeTab(model, 22, 20, 50, 27, vehicleTB)
changeTab(rotX, 22, 132, 161, 27, vehicleTB)
changeTab(rotY, 22, 162, 161, 27, vehicleTB)
changeTab(rotZ, 21, 191, 161, 27, vehicleTB)
local plateNum = GuiEdit(21, 219, 161, 27, "Plate", false, vehicleTB)
plateNum:setMaxLength(8)
GuiEdit(22, 266, 316, 26, "The format: createVehicle(model,x,y,z,rx,ry,rz,p#)", false, vehicleTB)
local reminder = GuiLabel(195, 7, 160, 29, "Reminder: You have to be in a vehicle to save.", false, vehicleTB)
reminder:setColor(125, 0, 0)
reminder:setHorizontalAlign("left", true)
changeTab(getMP, 213, 77, 130, 29,vehicleTB)

--Ped Tab
local pedTB = GuiTab("Ped", SaveTab)
GuiEdit(20, 251, 255, 28, "The Format: createPed(model,x,y,z,rot)", false, pedTB)

--Object Tab
local objectTB = GuiTab("Object", SaveTab)
GuiEdit(27, 259, 312, 27, "The Format: createObject(model,x,y,z,rx,ry,rz)", false, objectTB)

addEventHandler("onClientGUIClick", guiRoot, function(b)
	if(b~="left")then return end
	if(source==getPos)then
		if(source.parent==spawnTB or source.parent == markerTB or source.parent == objectTB)then
			local xx, yy, zz = localPlayer.position
			x:setText(xx)
			y:setText(yy)
			z:setText(zz)
		end
	elseif(source==getRot)then
		if(source.parent==spawnTB or source.parent == pedTB)then
			rot:setText(localPlayer.rotation)
		elseif(source.parent==vehicleTB)then
			local rx, ry, rz = localPlayer.vehicle.rotation
			rotX:setText(rx)
			rotY:setText(ry)
			rotZ:setText(rz)
		elseif(source.parent == objectTB)then
			local rx, ry, rz = localPlayer.rotation
			rotX:setText(rx)
			rotY:setText(ry)
			rotZ:setText(rz)
		end
	elseif(source==getInt)then
		if(source.parent==spawnTB)then
			int:setText(localPlayer.interior)
		end
	elseif(source==getSkin)then
		if(source.parent==spawnTB)then
			skin1:setText(localPlayer.model)
		end
	elseif(source==done)then
		if(source.parent == spawnTB)then
			triggerServerEvent("savePlayer",x.text, y.text, z.text)
		elseif(source.parent == markerTB)then
			triggerServerEvent("saveMarker",x.text, y.text, z.text)
		elseif(source.parent==vehicleTB)then
			triggerServerEvent("saveVehicle",model.text, x.text, y.text)
		elseif(soiurce.parent==pedTB)then
			triggerServerEvent("savePed",guiGetText(model2), guiGetText(x4), guiGetText(y4))
		elseif(source.parent==objectTB)then
			triggerServerEvent("saveObject",guiGetText(model3), guiGetText(x5), guiGetText(y5))
		end
	elseif(source==model)then
		getMP:setText("Get Position")
	elseif(source==getMP)then
		local xx, yy, zz
		if(source.parent == vehicleTB)then
			local veh = localPlayer.vehicle
			xx,yy,zz = veh.position
			if model.text == "Model" then
				model:setText(veh.model)
			end
		elseif(source.parent == pedTB)then
			xx, yy, zz = localPlayer.position
			if model.text == "Model" then
			  model:setText(localPlayer.model)
			end
		end
		x:setText(xx)
		y:setText(yy)
		z:setText(zz)
	end
end)
addEventHandler("onClientGUITabSwitched",root,function(tb)
	if(source==spawnTB)then
		changeTab(x,23, 21, 161, 27, spawnTB)
		changeTab(y,23, 52, 161, 27, spawnTB)
		changeTab(z,23, 83, 161, 27, spawnTB)
		changeTab(getPos,205, 53, 130, 29, spawnTB)
		changeTab(rot, 23, 128, 161, 27,spawnTB)
		changeTab(getRot,204, 128, 130, 29,spawnTB)
		changeTab(done,205, 239, 130, 29, spawnTB)
		rot.text = "Optional: Rotation"
	elseif(source==markerTB)then
		changeTab(x, 23, 21, 161, 27, markerTB)
		changeTab(y, 23, 50, 161, 27, markerTB)
		changeTab(z, 23, 80, 161, 27, markerTB)
		changeTab(getPos,205, 47, 130, 29, markerTB)
		changeTab(done, 28, 231, 130, 29, markerTB)
	elseif(source==vehicleTB)then
		changeTab(x, 23, 50, 161, 27, vehicleTB)
		changeTab(y, 23, 77, 161, 27, vehicleTB)
		changeTab(z, 23, 104,161, 27, vehicleTB)
		changeTab(rotX, 22, 132, 161, 27, vehicleTB)
		changeTab(rotY, 22, 162, 161, 27, vehicleTB)
		changeTab(rotZ, 21, 191, 161, 27, vehicleTB)
		changeTab(getRot, 213, 159, 130, 29, vehicleTB)
		changeTab(model, 22, 20, 50, 27, vehicleTB)
		changeTab(getMP, 213, 77, 130, 29,vehicleTB)
		changeTab(done, 214, 218, 130, 29, vehicleTB)
		getMP:setText("Get Model & Position")
	elseif(source.parent == pedTB)then
		changeTab(model, 23, 15, 50, 27, pedTB)
		changeTab(x, 22, 42, 161, 27, pedTB)
		changeTab(y, 22, 69, 161, 27, pedTB)
		changeTab(z, 21, 96, 161, 27, pedTB)
		changeTab(rot, 20, 125, 161, 27, pedTB)
		changeTab(getMP, 216, 71, 130, 29, false, pedTB)
		changeTab(getRot, 216, 125, 130, 29, pedTB)
		changeTab(done, 118, 187, 130, 29, pedTB)
		rot.text = "Rotation"
		getMP1:setText("Get Model & Position")
	elseif(source.parent == objectTB)then
		changeTab(model, 25, 28, 50, 27, objectTB)
		changeTab(x, 25, 55, 161, 27, objectTB)
		changeTab(y, 25, 82, 161, 27, objectTB)
		changeTab(z, 26, 110, 161, 27, objectTB)
		changeTab(rotX, 26, 143, 161, 27, objectTB)
		changeTab(rotY, 27, 171, 161, 27, objectTB)
		changeTab(rotZ, 27, 199, 161, 27, objectTB)
		changeTab(getPos, 203, 83, 130, 29, objectTB)
		changeTab(getRot, 204, 171, 130, 29, objectTB)
		changeTab(done, 124, 229, 130, 29, objectTB)
	end
end)

addCommandHandler("save", function()
	local cur = not isCursorShowing()
	showCursor(cur)
	SaveTab:setVisible(cur)
end)

addCommandHandler("saveCM", function()
  local x, y, z, xx, yy, zz = getCameraMatrix()
  local cm = {x, y, z, xx, yy, zz}
  triggerServerEvent("saveCM", localPlayer, cm)
end)

addEventHandler("onClientGUIClick", guiRoot, function(b,s)
	if(b == "left" and s == "down")then
		if(source.type == "gui-edit")then
			guiSetInputEnabled(true)
		end
	elseif(guiGetInputEnabled())then
		guiSetInputEnabled(false)
	end
end)