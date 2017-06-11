local engineKey,lightsKey = get("@engineKey"),get("@lightKey")
thisResource = thisResource or getThisResource()
resourceRoot = resourceRoot or getResourceRootElement()

--Create functions for the engine state and light state
function changeEngineState(source)
    if not source:isInVehicle() then return end
	local sourceVehicle = source:getOccupiedVehicle()
	sourceVehicle.engineState = not sourceVehicle.engineState
end
function changeLightsState(source)
    if not source:isInVehicle() then return end
	local sourceVehicle = source:getOccupiedVehicle()
	sourceVehicle.overrideLights = 2/sourceVehicle.overrideLights
end

addEventHandler ( "onPlayerVehicleEnter",root,function( veh, driver, jacker )
    if driver ~= 0 or jacker then return end --Check if it's not the driver or if the vehicle is being jacked
	veh.engineState = true
end)
addEventHandler ( "onPlayerVehicleExit",root,function( veh, driver, jacker )
    if driver ~= 0 or jacker then return end --Check if it's not the driver or if the vehicle is being jacked
	veh.engineState = false
	veh.overrideLights = 1
end)

--Key Bindings
addEventHandler ( "onResourceStart",resourceRoot,function(res)
	if res~= thisResource then return end
	for _,p in ipairs(getElementsByType("player")) do
		bindKey(p,engineKey, "down", changeEngineState )
		bindKey(p,lightsKey, "down", changeLightsState )
	end
end)
addEventHandler("onResourceStop",resourceRoot,function(res)
	if res~= thisResource then return end
	for _,p in ipairs(getElementsByType("player")) do
		unbindKey(p,engineKey, "down", changeEngineState )
		unbindKey(p,lightsKey, "down", changeLightsState )
	end
end)
addEventHandler ( "onPlayerJoin",root,function()
	bindKey (source,engineKey, "down", changeEngineState)
	bindKey(source,lightsKey, "down", changeLightsState)
end)
addEventHandler ( "onPlayerQuit",root,function()
	unbindKey (source,engineKey, "down", changeEngineState)
	unbindKey(source,lightsKey, "down", changeLightsState)
end)