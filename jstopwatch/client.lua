local milli,sec,min,hour,handled = 0,0,0,0,false
local pedplayer, stopWin, t, startT, stopT, resetT

addEventHandler("onClientResourceStart",resourceRoot,function()
	--Create Window, Label, Button, and Checkbox
	local screenWidth, screenHeight = guiGetScreenSize()
	stopWin = GuiWindow((screenWidth/1 - 302/1),(screenHeight/1 - 172/1), 302, 172, "Stop Watch", false)
	stopWin.sizable = false
	
	timer = GuiLabel(20, 45, 271, 41, hour.."hour(s) :"..min.."min(s) :"..sec.."sec(s) :"..milli.."ms", false,stopWin)
	startT = GuiButton(10, 105, 75, 23, "Start", false,stopWin)
	stopT = GuiButton(210, 105, 75, 23, "Stop", false, stopWin)
	resetT = GuiButton(110, 105, 75, 23, "Reset", false, stopWin)
	local closeW = GuiButton(260, 25, 31, 23,"X", false, stopWin)
	local auto = GuiCheckBox(10, 25, 71, 17, "Automatic", false, false, stopWin)
	
	--Disable stop and reset button
	stopT.enabled = false
	resetT.enabled = false
	addEventHandler("onClientGUIClick",guiRoot,function(btn,rls)
		if(btn=="left")then
			if(source==startT)then
				addEventHandler("onClientPreRender",root,sTime) --watch time vars
				t = Timer(function()
					milli = milli + 50
				end,50,0) --start an infinite timer
				startT.enabled = false --disable start
				stopT.enabled = true --enable stop and reset buttons
				resetT.enabled = true
			elseif(source==resetT)then --reset time and text
				milli = 0
				sec = 0
				min = 0
				hour = 0
				timer.text = hour.."hour(s) :"..min.."min(s) :"..sec.."sec(s) :"..milli.."ms"
			elseif(source==stopT)then
				t:destroy() --destroy timer
				handled = false
				removeEventHandler("onClientPreRender",root,sTime)
				stopT.enabled = false --disable stop button
				startT.enabled = true --enable start and reset buttons
				resetT.enabled = true
			elseif(source==closeW)then --stop and close everything related
				handled = false
				removeEventHandler("onClientPreRender",root,sTime)
				stopWin.visible = false
				showCursor(false)
			elseif(source==auto)then
				if(auto.selected)then --is auto checked
					outputChatBox("Please click on a player to time.(You could click on your self if you want)")
					--disable every button
					startT.enabled = false
					stopT.enabled  = false
					resetT.enabled = false
					closeW.enabled = false
					addEventHandler("onClientClick",root,ped) --detect a ped clicked
				else
					handled = false --handled disabled
					outputChatBox("You have now disabled Automatic.")
					--remove detection of ped clicked and ped running
					removeEventHandler("onClientClick",root,ped)
					removeEventHandler("onClientRender",root,run)
					--restore buttons
					startT.enabled = true
					stopT.enabled  = false
					resetT.enabled = true
					closeW.enabled = true
				end
			end
		end
	end,true)
	stopWin.visible = false --hide the window
end)
addCommandHandler("stopw",function() --create a command "stopw"
	if not stopWin.visible then --can not be visible
		stopWin.visible = true --show window
		if not isCursorShowing() then
			showCursor(true,false)
		end
	end
end)

function sTime() --time var watcher
	handled=true
	if(milli>=1000)then
		milli=0
		sec=sec+1
		if(sec>=59)then
			sec=0
			min=min+1
			if(min>=59)then
				min=0
				hour=hour+1
			end
		end
	end
	timer.text = hour.."hour(s) :"..min.."min(s) :"..sec.."sec(s) :"..milli.."ms"
end

local pedMove = {["walk"]=true,["powerwalk"]=true,["jog"]=true,["sprint"]=true}
function ped(button,_,_,_,_,_,_,thePed) --ped clicked on
	if not thePed then return end
	if(thePed.type=="player" or thePed.type=="ped")then --is ped or player?
		if thePed==localPlayer then --self?
			outputChatBox("Start running now!",100,0,0)
		else
			outputChatBox("You are now watching "..(thePed.name)..".")
		end
		local moveState = getPedMoveState(thePed)
		if not pedMove[moveState] then --ped not moving?
			outputChatBox("Tell the player to start running.")
		end
		addEventHandler("onClientRender",root,run) --watch when ped runs
		removeEventHandler("onClientClick",root,ped) --remove detection of ped clicked
		pedplayer = thePed --set ped to watch
	else
		outputChatBox("Please select a player.",100,0,0)
	end
end

local preState --only to stop a bug
function run()
	local moveState = getPedMoveState(pedplayer)
	if pedMove[moveState] and moveState ~= preState then --is ped moving regardless?
		if not handled then --is the event not handled?
			addEventHandler("onClientPreRender",root,sTime)
			t = Timer(function()
				milli = milli + 50
			end,50,0)
		end
	else
		if handled then
			handled = false
			removeEventHandler("onClientPreRender",root,sTime)
			if t.valid then
				t:destroy()
			end
		end
	end
end

addEventHandler("onClientResourceStop",resourceRoot,function() --to stop any memory leak
	if t.valid then t:destroy() end
	removeEventHandler("onClientPreRender",root,sTime)
	removeEventHandler("onClientRender",root,run)
end)