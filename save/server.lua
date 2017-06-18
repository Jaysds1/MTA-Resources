addEvent("savePlayer", true)
addEvent("saveMarker", true)
addEvent("saveVehicle", true)
addEvent("savePed", true)
addEvent("saveObject", true)
addEvent("AV", true)
addEvent("saveCM", true)

root = root or getRootElement()

function fail(fn,err)
	if(err == 1)then
		outputDebugString("Save: Cannot find or create "..fn)
	elseif(err==2)then
		outputDebugString("Save: Could not write/read "..fn)
	end
end
addEventHandler("savePlayer", root, function(...)
	local fn = "playerPositions.txt"
	local file = File(fn) or File.new(fn)
	if not file then
		return fail(fn,1)
	end
	file.pos = file.size
	if file:write(file, "spawnPlayer(", table.concat({...}, ","), ")", "\r\n-- DONE --\r\n") then
		source:outputChat("Succesfully saved to "..fn)
	else
		fail(fn,2)
	end
	file:flush()
	file:close()
end)

addEventHandler("saveMarker", root, function(...)
	local fn = "markerPositions.txt"
	local file = File(fn) or File.new(fn)
	if not file then
		return fail(fn,1)
	end
	file.pos = file.size
	if file:write("createMarker(",table.concat({...}, ","), ")", "\r\n-- DONE --\r\n") then
		outputChatBox("Succesfully saved to markerPositions.txt", source)
	else
		fail(fn,2)
	end
	file:flush()
	file:close()
end)

addEventHandler("saveVehicle", root, function(...)
	local fn = "vehiclePositions.txt"
	local file = File(fn) or File.new(fn)
	if not file then
		return fail(fn,1)
	end
    file.pos = file.size
    if file:write("createVehicle(", table.concat({...}, ","), ")", "\r\n-- DONE --\r\n") then
		source:outputChat("Succesfully saved to "..fn)
	else
		fail(fn,2)
	end
	file:flush()
	file:close()
end)

addEventHandler("savePed", getRootElement(), function(...)
  local file = fileOpen("pedPositions.txt")
	local file = File(fn) or File.new(fn)
	if not file then
		return fail(fn,1)
	end
    file.pos = file.size
    if file:write("createPed(", table.concat({...}, ","), ")", "\r\n-- DONE --\r\n") then
		source:outputChat("Succesfully saved to "..fn)
	else
		fail(fn,2)
	end
	file:flush()
	file:close()
end)

addEventHandler("saveObject", getRootElement(), function(...)
  local file = fileOpen("objectPositions.txt")
	local file = File(fn) or File.new(fn)
	if not file then
		return fail(fn,1)
	end
    file.pos = file.size
    if file:write("createObject(", table.concat({...}, ","), ")", "\r\n-- DONE --\r\n") then
		source:outputChat("Succesfully saved to "..fn)
	else
		fail(fn,2)
	end
	file:flush()
	file:close()
end)

function av()
	local fn = "allVehiclePositions.txt"
	local file = File(fn) or File.new(fn)
	if not file then
		return fail(fn,1)
	end
	
	local av
	for _,v in ipairs(Element.getAllByType("vehicle"))do
		local x,y,z = v.position
		local rx,ry,rz = v.rotation
		av += "createVehicle("..v.model..","..x..","..y..","..z..","..rx..","..ry..","..rz..","..v.plateText..")\n"
	end
	
	file.pos = file.size
	if file:write(av,"\r\n-- DONE --\r\n") then
		source:outputChat("Succesfully saved to "..fn)
	else
		fail(fn,2)
	end
	file:flush()
	file:close()
end
addEventHandler("AV", root,av)
addCommandHandler("saveAV", av)

addEventHandler("saveCM", root, function(...)
	local fn = "cameraMatrix.txt"
	local file = File(fn) or File.new(fn)
	if not file then
		return fail(fn,1)
	end
	file.pos = file.size
	if file:write("spawnPlayer(", table.concat({...}, ","), ")", "\r\n-- DONE --\r\n") then
		source:outputChat("Succesfully saved to "..fn)
	else
		fail(fn,2)
	end
	file:flush()
	file:close()
end)