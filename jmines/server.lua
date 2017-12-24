addCommandHandler("amine",function(source)
	if isElement(source) then
		local x,y,z = getElementPosition(source)
		local landmine = Object( 1510, x,y,z - .999, 0, 0, 3.18 ) --create mine
		landmine:setData("owner",source) --set creator
		landmine:setData("team", source.team) --set team
		-- setElementData(landmine,"number",
		
		local landmineCol = ColShape.Sphere( x,y,z, 3 ) --create mine sensor
		landmineCol:setData("type","mine") --set data type to mine
		landmineCol:setData("lm",landmine) --set it's data parent to the mine created
		landmine:setData("col", landmineCol) --set mine's sensor
		
		triggerEvent("onColShapeHit",landmineCol,source,source.dimension) --Fix to rmine if player didn't move in colshape
	end
end)

addCommandHandler("rmine",function(source)
	if isElement(source) then
		local lmCol = source:getData("sourceMine") --get current mine sensor
		local landmine = lmCol:getData("lm") --get current mine
		if source == landmine:getData("owner") then --check owner and destroy everything related to the mine
			landmine:destroy()
			lmCol:destroy()
			source:removeData("sourceMine")
		end
	end
end)

addEventHandler("onColShapeHit",root,function(hitElement)
	if hitElement.type == "player" or hitElement.type == "vehicle" then --did a player enter the sensor?
		if source:getData("type") == "mine" then --is the sensor for a mine?
			if hitElement.type == "vehicle" then hitElement = hitElement.occupant end --get occupant in car
			hitElement:setData("sourceMine",source) --set current mine sensor
			local landmine = source:getData("lm") --ge current mine
			if hitElement.team ~= landmine:getData("team") then --is player on the same team as creator
				local x,y,z = getElementPosition(source)
				createExplosion (x,y,z,8,landmine:getData("owner")) --explode and destroy everything related to the mine
				landmine:destroy()
				source:destroy()
				hitElement:removeData("sourceMine")
			end
		end
	end
end)

addEvent("destroy",true)
addEventHandler("destroy",root,function(mine)
	local lmCol = mine:getData("col") --get mine sensor
	if not lmCol then return end
	local x,y,z = getElementPosition(mine)
    createExplosion(x,y,z,8,mine:getData("owner")) --explode and destroy everything related to the mine
	mine:destroy()
	lmCol:destroy()
end)