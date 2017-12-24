addEventHandler("onClientPlayerWeaponFire",root,function(_, _, _, _, _, _,mine)
	if isElement(localPlayer) then
		if mine and mine.model == 1510 then -- is it a mine?
			triggerServerEvent("destroy",resourceRoot,mine) --do the action on the server
        end
    end
end)