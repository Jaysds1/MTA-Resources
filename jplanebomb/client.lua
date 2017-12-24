function bomb()
	local veh = localPlayer.vehicle
	if localPlayer.vehicle:isOnGround() then
		outputChatBox("*Air Control: Please get off the ground!",100,0,0)
		return
	end
	local x,y,z = getElementPosition(veh)
	for _,v in ipairs(Element.getAllByType("player"))do
		Projectile(localPlayer,21,x,y,z-1.9,3,v,0,0,0,0,0,-3)
	end
end

addEventHandler("onClientPlayerVehicleEnter",root,function(veh)
	if veh.model == 520 then
		toggleControl("vehicle_secondary_fire",false)
		bindKey("lctrl","down",bomb)
	end
end)
addEventHandler("onClientPlayerVehicleExit",root,function(veh)
	if veh.model == 520 then
		toggleControl("vehicle_secondary_fire",true)
		unbindKey("lctrl","down",bomb)
	end
end)