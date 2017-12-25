Pickup(2734.2604980469,-1759.4835205078,44.059120178223,0,3,10000)

addEventHandler("onPickupSpawn",root,function()
	local pickUpType = source.type
	outputChatBox("The "..pickup(pickUpType).." pickup has spawned in "..(source:getZoneName())..","..(source:getZoneName(true)))
end)

addEventHandler("onPickupHit",root,function(thePlayer)
	-- let's load everything first before we put them in the code
	local pickUpType = source.type
	local pickUpAmmount = source.amount
	local pickUpName = pickup(pickUpType)
	if(pickUpType == 0 or 1)then
		outputChatBox("You have picked up some "..pickUpName..", your "..pickUpName.." increased by "..pickUpAmmount,thePlayer)
	elseif(pickUpType == 2)then
		outputChatBox("You have picked up a "..pickUpName,thePlayer)
		Timer(outputChatBox,7000,1,"Weapon Info: Weapon Name: "..getWeaponNameFromID(source.model).." Ammo: "..pickUpAmmount,thePlayer)
	end
end)

addEventHandler("onPickupUse",root,function(thePlayer)
	local pickUpType = source.type
	outputChatBox((thePlayer.name).." picked up a "..pickup(pickUpType).." pickup")
end)
	

function pickup(pick)
	if(pick == 0)then
		return "Health"
	elseif(pick == 1)then
		return "Armor"
	elseif(pick == 2)then
		return "Weapon"
	end
end