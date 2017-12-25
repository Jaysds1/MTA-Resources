local milli,sec,min,hour,handled = 0,0,0,0,false
local pedplayer, stopWin, t

addEventHandler("onClientResourceStart",resourceRoot,function()
	local screenWidth, screenHeight = guiGetScreenSize()
	stopWin = GuiWindow((screenWidth/1 - 302/1),(screenHeight/1 - 172/1), 302, 172, "Stop Watch", false)
	stopWin.sizable = false
	
	timer = GuiLabel(20, 45, 271, 41, hour.."hour(s) :"..min.."min(s) :"..sec.."sec(s) :"..milli.."ms", false,stopWin)
	local startT = GuiButton(10, 105, 75, 23, "Start", false,stopWin)
	local stopT = GuiButton(210, 105, 75, 23, "Stop", false, stopWin)
	local resetT = GuiButton(110, 105, 75, 23, "Reset", false, stopWin)
	local closeW = GuiButton(260, 25, 31, 23,"X", false, stopWin)
	--local auto = GuiCheckBox(10, 25, 71, 17, "Automatic", false, false, stopWin)
	
	stopT.enabled = false
	resetT.enabled = false
	addEventHandler("onClientGUIClick",guiRoot,function(btn)
		if(btn=="left")then
			if(source==startT)then
				addEventHandler("onClientPreRender",root,sTime)
				t = Timer(function()
					milli = milli + 50
				end,50,0)
				startT.enabled = false
				stopT.enabled = true
				resetT.enabled = true
			elseif(source==resetT)then
				milli = 0
				sec = 0
				min = 0
				hour = 0
				timer.text = hour.."hour(s) :"..min.."min(s) :"..sec.."sec(s) :"..milli.."ms"
			elseif(source==stopT)then
				t:destroy()
				removeEventHandler("onClientPreRender",root,sTime)
				stopT.enabled = false
				startT.enabled = true
				resetT.enabled = true
			elseif(source==closeW)then
				removeEventHandler("onClientPreRender",root,sTime)
				stopWin.visible = false
				showCursor(false)
			--[[elseif(source==auto)then
				if(guiCheckBoxGetSelected(auto))then
					outputChatBox("Please click on a player to time.(You could click on your self if you want)")
					addEventHandler("onClientClick",root,ped)
					guiSetEnabled(startT,false)
					guiSetEnabled(stopT,false)
					guiSetEnabled(resetT,false)
					guiSetEnabled(closeW,false)
				else
					outputChatBox("You have now disabled Automatic.")
					removeEventHandler("onClientClick",root,ped)
					removeEventHandler("onClientPreRender",root,run)
					guiSetEnabled(startT,true)
					guiSetEnabled(stopT,false)
					guiSetEnabled(resetT,true)
					guiSetEnabled(closeW,true)
				end]]
			end
		end
	end,true)
	stopWin.visible = false
end)
addCommandHandler("stopw",function()
	if not stopWin.visible then
		stopWin.visible = true
		if not isCursorShowing() then
			showCursor(true,false)
		end
	end
end)

function sTime()
	handled=true
	if(milli==1000)then
		milli=0
		sec=sec+1
		if(sec==59)then
			sec=0
			min=min+1
			if(min==59)then
				min=0
				hour=hour+1
			end
		end
	else
		milli=milli+10
	end
	timer.text = hour.."hour(s) :"..min.."min(s) :"..sec.."sec(s) :"..milli.."ms"
end

function ped(button,_,_,_,_,_,_,thePed)
	if(thePed.type=="player"or thePed.type=="ped")then
		if(thePed==localPlayer)then
			outputChatBox("Start running now!",100,0,0)
		else
			outputChatBox("You are now watching "..(thePed.name)..".")
		end
		local moveState = getPedMoveState(thePed)
		if(moveState=="walk" or moveState=="powerwalk" or moveState=="jog" or moveState=="sprint")then
			addEventHandler("onClientPreRender",root,run)
		else
			outputChatBox("Tell the player to start running.")
		end
		removeEventHandler("onClientClick",root,ped)
	else
		outputChatBox("Please select a player.",100,0,0)
	end
	pedplayer = thePed
end

function run()
	local moveState = getPedMoveState(thePed)
	if(moveState=="walk" or moveState=="powerwalk" or moveState=="jog" or moveState=="sprint")then
		if(handled==false)then
			addEventHandler("onClientPreRender",root,sTime)
		end
	else
		if(handled==true)then
			removeEventHandler("onClientPreRender",root,sTime)
		end
	end
end

addEventHandler("onClientResourceStop",resourceRoot,function()
	removeEventHandler("onClientPreRender",root,sTime)
end)