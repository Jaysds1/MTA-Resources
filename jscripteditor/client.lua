local screenWidth, screenHeight = guiGetScreenSize()

local curRes = false
local curScpt = false

function jseWin()
	local visible = guiGetVisible(jse)
	guiSetVisible(jse,not visible)
	showCursor(not visible)
end

addEvent("editorReady",true)
addEventHandler("editorReady",root,function()

	jse = guiCreateWindow(screenWidth/2 - 342/2, screenHeight/2 - 426/2, 342, 426, "JScript Editor", false)
	guiWindowSetSizable(jse, false)
	
	guiCreateLabel(10, 35, 71, 16, "Resources:", false,jse)
	guiCreateLabel(170, 55, 71, 16, "Files:", false, jse)
	
	ress = guiCreateGridList(10, 75, 161, 241,false,jse)
	guiGridListAddColumn(ress,"#:",0.30)
	guiGridListAddColumn(ress,"Name:",0.37)
	guiGridListAddColumn(ress,"# of Files:",0.30)
	guiGridListSetSelectionMode(ress,1)
	
	files = guiCreateGridList(170, 75, 161, 241,false, jse)
	guiGridListAddColumn(files,"Name:",0.37)
	guiGridListAddColumn(files,"Type:",0.37)
	guiGridListAddColumn(files,"Size:",0.37)
	guiGridListSetSelectionMode(files,0)
	
	local resSearch = guiCreateEdit(10, 55, 113, 20, "Search", false, jse)
	local resCreate = guiCreateEdit(10, 315, 113, 20, "Resource Name", false, jse)
	local scriptCreate = guiCreateEdit(170, 315, 113, 20, "Script Name", false, jse)
	addEventHandler("onClientGUIChanged",guiRoot,function(edit)
		if getElementType(source)=="gui-edit" then
			if source==resSearch then
				for i=0, guiGridListGetRowCount(ress)do
					if not string.find(guiGridListGetItemText(ress,i,2),guiGetText(source),1,true)then
						guiGridListSetSelectedItem(ress,i,2)
						break;
					end
				end
			end
		end
	end)
	
	createRes = guiCreateButton(10, 335, 75, 23, "Create", false, jse)
	copyRes = guiCreateButton(10, 355, 75, 23, "Copy", false,jse)
	renameRes = guiCreateButton(90, 355, 75, 23, "Rename", false, jse)
	deleteRes = guiCreateButton(90, 335, 75, 23, "Delete", false, jse)
	
	createScript = guiCreateButton(170, 335, 75, 23, "Create", false, jse)
	copyScript = guiCreateButton(170, 355, 75, 23, "Copy", false, jse)
	openScript = guiCreateButton(170, 375, 75, 23, "Open", false, jse)
	renameScript = guiCreateButton(250, 355, 75, 23, "Rename", false, jse)
	deleteScript = guiCreateButton(250, 335, 75, 23, "Delete", false, jse)
	
	closejse = guiCreateButton(300, 15, 31, 23, "X", false, jse)
	addEventHandler("onClientGUIClick",guiRoot,function()
		if getElementType(source)=="gui-edit" then
			if string.find(guiGetText(source),"Name",1,true)then
				guiSetText(source,"")
			end
			guiSetInputEnabled(true)
		elseif getElementType(source)=="gui-memo" then
			guiSetInputEnabled(true)
		else
			guiSetInputEnabled(false)
		end
		if source==ress then
			curRes=guiGridListGetSelectedItem(ress)
			if curRes==-1 then
				curRes=false
				return
			end
			guiGridListClear(files)
			triggerServerEvent("JW.Services",localPlayer,"getResFiles",guiGridListGetItemText(ress,curRes,2))
		elseif source==files then
			curScpt=guiGridListGetSelectedItem(files)
			if curScpt==-1 then
				curScpt=false
				return
			end
		elseif source==createRes then
			triggerServerEvent("JW.Services",localPlayer,"createRes",guiGetText(resCreate))
		elseif source==copyRes then
			if not curRes then return end
			triggerServerEvent("JW.Services",localPlayer,"copyRes",guiGridListGetItemText(ress,curRes,2),guiGetText(resCreate))
		elseif source==renameRes then
			if not curRes then return end
			local newName = guiGetText(resCreate)
			triggerServerEvent("JW.Services",localPlayer,"renameRes",guiGridListGetItemText(ress,curRes,2),newName)
			guiGridListSetItemText(ress,curRes,2,newName,false,false)
		elseif source==deleteRes then
			if not curRes then return end
			triggerServerEvent("JW.Services",localPlayer,"deleteRes",guiGridListGetItemText(ress,curRes,2))
			guiGridListRemoveRow(ress,curRes)
		elseif source==createScript then
			if not curRes then return end
			local newName = guiGetText(scriptCreate)
			triggerServerEvent("JW.Services",localPlayer,"createScript",guiGridListGetItemText(ress,curRes,2),newName)
			local row = guiGridListAddRow(files)
			guiGridListSetItemText(files,row,1,newName,false,false)
			guiGridListSetItemText(files,row,2,"Nil",false,false)
			guiGridListSetItemText(files,row,3,0,false,true)
		elseif source==openScript then
			if not curScpt then return end
			guiSetVisible(jeditor,true)
			local resName = guiGridListGetItemText(ress,curRes,2)
			local fileName = guiGridListGetItemText(files,curScpt,1)
			guiSetText(filePath,"File Path: "..resName.."/"..fileName)
			triggerServerEvent("JW.Services",localPlayer,"openFile",resName,fileName)
		elseif source==copyScript then
			if not curScpt then return end
			local newName = guiGetText(scriptCreate)
			triggerServerEvent("JW.Services",localPlayer,"copyScript",guiGridListGetItemText(ress,curRes,2),guiGridListGetItemText(files,curScpt,1),newName)
			local row = guiGridListAddRow(files)
			guiGridListSetItemText(files,row,1,newName,false,false)
			guiGridListSetItemText(files,row,2,guiGridListGetItemText(files,curScpt,2),false,false)
			guiGridListSetItemText(files,row,3,guiGridListGetItemText(files,curScpt,3),false,true)
		elseif source==renameScript then
			if not curScpt then return end
			local newScript = guiGetText(scriptCreate)
			triggerServerEvent("JW.Services",localPlayer,"renameScript",guiGridListGetItemText(ress,curRes,2),guiGridListGetItemText(files,curScpt,1),newScript)
			guiGridListSetItemText(files,curScpt,1,newScript,false,false)
		elseif source==deleteScript then
			if not curScpt then return end
			triggerServerEvent("JW.Services",localPlayer,"deleteScript",guiGridListGetItemText(ress,curRes,2),guiGridListGetItemText(files,curScpt,1))
			guiGridListRemoveRow(files,curScpt)
		elseif source==closejse then
			jseWin()
		end
	end)
	jeditor = guiCreateWindow(screenWidth/2 - 342/2, screenHeight/2 - 308/2, 342, 308, "JEditor", false)

	filePath = guiCreateLabel(10, 248, 221, 20, "File Path: ", false, jeditor)
	fileScript = guiCreateMemo(10, 35, 311, 211,"", false, jeditor)
	done = guiCreateButton(250, 245, 75, 23, "Done", false, jeditor)
	closeje = guiCreateButton(300, 15, 31, 23, "X", false, jeditor)
	
	addEventHandler("onClientKey",root,function(key,release)
		if guiGetVisible(jeditor) then
			if key=="tab" and release then
				local script = guiGetText(fileScript)
				guiSetText(fileScript,script.."     ")
				guiMemoSetCaretIndex(fileScript,string.len(script))
			end
		end
	end)
	addEventHandler("onClientGUIClick",guiRoot,function()
		if source==done then
			triggerServerEvent("JW.Services",localPlayer,"fileSave",guiGetText(filePath),guiGetText(fileScript))
		elseif source==closeje then
			guiSetVisible(jeditor,false)
		end
	end) 
	
	guiBringToFront(jeditor)
	guiSetVisible(jse,false)
	guiSetVisible(jeditor,false)
	
	triggerServerEvent("JW.Services",localPlayer,"ready")
	outputChatBox("The Script Editor is now Ready, press 'f7' to open it!")
	bindKey("f7","down",jseWin)		
end)

local resNum = 1
addEvent("addRes",true)
addEventHandler("addRes",root,function(resName,resFiles,resState)
	local row=guiGridListAddRow(ress)
	guiGridListSetItemText(ress,row,1,resNum,false,true)
	guiGridListSetItemText(ress,row,2,resName,false,false)
	guiGridListSetItemText(ress,row,3,resFiles,false,true)
	if resState=="starting"or resState=="running" then
		guiGridListSetItemColor(ress,row,2,0,100,0)
	end
	resNum = resNum+1
end)

addEvent("resState",true)
addEventHandler("resState",root,function(resName,resStat)
	for i=0, guiGridListGetRowCount(ress) do
		if string.find(guiGridListGetItemText(ress,i,2),resName,1,true)then
			if resStat=="started" then
				guiGridListSetItemColor(ress,i,2,0,100,0)
			elseif resStat=="stopped" then
				guiGridListSetItemColor(ress,i,2,255,255,255)
			end
		end
	end
end)

addEvent("giveResFiles",true)
addEventHandler("giveResFiles",root,function(fileName,fileType,fileSize)
	local row = guiGridListAddRow(files)
	guiGridListSetItemText(files,row,1,fileName,false,false)
	guiGridListSetItemText(files,row,2,fileType,false,false)
	guiGridListSetItemText(files,row,3,fileSize,false,true)
end)

addEvent("scriptWrite",true)
addEventHandler("scriptWrite",root,function(contents)
	guiSetText(fileScript,contents)
end)