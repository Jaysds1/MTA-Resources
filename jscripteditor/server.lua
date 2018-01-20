addEventHandler("onResourceStart",resourceRoot,function(res)
	if res==getThisResource()then
		local resName = getResourceName(res)
		if not( hasObjectPermissionTo(res,"general.ModifyOtherObjects",false) or isObjectInACLGroup("resource."..resName,aclGetGroup("admin")))then
			outputDebugString("Resource: "..resName.." does not have access to 'general.ModifyOtherObjects', please add this resource to the 'admin' group.",1)
			outputDebugString("or type in the console 'aclrequest allow jScriptEditor all'",1)
			return
		end
		for _,v in ipairs(getElementsByType("player"))do
			local vAcc = getAccountName(getPlayerAccount(v))
			if isObjectInACLGroup("user."..vAcc,aclGetGroup("Admin"))then
				setTimer(triggerClientEvent,3000,1,v,"editorReady",v)
				outputDebugString(getPlayerName(v).."("..vAcc..") has access to the Script Editor")
			end
		end
		return
	end
	triggerClientEvent("resState",root,getResourceName(res),"started")
end)

addEventHandler("onResourceStop",resourceRoot,function(res)
	if res==getThisResource()then return end
	triggerClientEvent("resState",root,getResourceName(res),"stopped")
end)

addEventHandler("onPlayerLogin",root,function(_,curAcc)
	local vAcc = getAccountName(curAcc)
	if isObjectInACLGroup("user."..vAcc,aclGetGroup("Admin"))then
		triggerClientEvent(source,"editorReady",source)
		outputDebugString(getPlayerName(source).."("..vAcc..") has access to the Script Editor")
	end
end)

function outputToClient(theMessage,source,r,g,b)
	if theMessage then
		if not source then
			source = root
		end
		outputChatBox(theMessage,source,r,g,b)
		outputDebugString(getPlayerName(source).."("..getAccountName(getPlayerAccount(source))..") Scripting Action: '"..theMessage.."'",3)
		return true
	end
	return false
end

function fileCopy(curName,newName)
	if fileExists(curName) then
		local file = fileOpen(curName)
		if not file then return false end
		local file1 = fileCreate(newName)
		if file1 then
			local fileSize = fileGetSize(file)
			if fileSize==0 then
				fileClose(file1)
				fileClose(file)
				return true
			end
			fileWrite(file1,fileRead(file,fileSize))
			fileClose(file1)
			fileClose(file)
		end
		return true
	end
	return false
end

addEvent("JW.Services",true)
addEventHandler("JW.Services",root,function(typ,name,new,new1)
	if typ=="ready" then
		for _,v in ipairs(getResources())do
			local resName = getResourceName(v)
			local xml=xmlLoadFile(":"..resName.."/meta.xml")
			if xml then
				local files = 0
				for _,v in ipairs(xmlNodeGetChildren(xml))do
					if xmlNodeGetName(v) =="script" then
						files=files+1
					end
				end
				triggerClientEvent(client,"addRes",client,resName,files,getResourceState(v))
			else
				outputDebugString("Resource: "..resName.." doesn't have a 'meta.xml' file!",2)
			end
		end
	elseif typ=="getResFiles" then
		local xml=xmlLoadFile(":"..name.."/meta.xml")
		for _,i in ipairs(xmlNodeGetChildren(xml))do
			if xmlNodeGetName(i)=="script" then
				local fileName = xmlNodeGetAttribute(i,"src")
				local fileType = xmlNodeGetAttribute(i,"type")
				if not fileType then
					fileType = "server"
				end
				local filePath = ":"..name.."/"..fileName
				if fileExists(filePath) then
					local file = fileOpen(filePath)
					triggerClientEvent(client,"giveResFiles",client,fileName,fileType,fileGetSize(file))
					fileClose(file)
				end
			end
		end
		local file = fileOpen(":"..name.."/meta.xml")
		triggerClientEvent(client,"giveResFiles",client,"meta.xml","XML",fileGetSize(file))
		fileClose(file)
	elseif typ=="createRes" then
		local res = createResource(name)
		if res then
			local file = fileCreate(":"..name.."/server.lua")
			fileClose(file)
			file=fileCreate(":"..name.."/client.lua")
			fileClose(file)
			
			local xml = xmlCreateFile(":"..name.."/meta.xml","meta")
			local info = xmlCreateChild(xml,"info")
			xmlNodeSetAttribute(info,"author",getPlayerName(client))
			xmlNodeSetAttribute(info,"version","1.0.0")
			local done = "server"
			for i=0,1 do
				local script = xmlCreateChild(xml,"script")
				xmlNodeSetAttribute(script,"src",done..".lua")
				xmlNodeSetAttribute(script,"type",done)
				done = "client"
			end
			xmlSaveFile(xml)
			outputToClient("Resource: '"..name.."' has been successfully created!",client,0,100,0)
			triggerClientEvent(client,"addRes",client,name,2,getResourceState(res))
		end
	elseif typ=="copyRes" then
		local num = 1
		if new=="" then
			new = name.."new"..num
		end
		local res = getResourceFromName(name)
		if res then
			if copyResource(res,new) then
				outputToClient("Resource: '"..name.."' copied to: '"..new.."' !",client,0,100,0)
				local xml=xmlLoadFile(":"..new.."/meta.xml")
				local files = 0
				for i=0,files+1 do
					if xmlFindChild(xml,"script",i) then
						files=files+1
					else
						break;
					end
				end
				xmlUnloadFile(xml)
				triggerClientEvent(client,"addRes",client,new,files,"stopped")
			end
		end
	elseif typ=="renameRes" then
		if new=="" then
			new = name.."Renamed"
		end
		local res = getResourceFromName(name)
		if res then
			local started = false
			if getResourceState(res)=="running" then
				started = true
				stopResource(res)
			end
			if renameResource(name,new) then
				outputToClient("Resource: '"..name.."' has been renamed to: '"..new.."'",client,0,100,0)
				if started then
					startResource(res)
				end
			end
		end
	elseif typ=="deleteRes" then
		local res = getResourceFromName(name)
		if res then
			if deleteResource(res) then
				outputToClient("Resource: "..name.." has been deleted!",client,0,100,0)
			end
		end
	elseif typ=="openFile" then
		local file = fileOpen(":"..name.."/"..new)
		if file then
			local fileSize = fileGetSize(file)
			if fileSize==0 then return end
			triggerClientEvent(client,"scriptWrite",client,fileRead(file,fileSize))
			fileClose(file)
		end
	elseif typ=="fileSave" then
		name=string.gsub(name,"File Path: ","")
		local file = fileOpen(":"..name)
		if file then
			fileWrite(file,"")
			if fileWrite(file,new) then
				outputChatBox("The file has been saved!",client,0,100,0)
				fileClose(file)
				local res = getResourceFromName(string.gsub(string.sub(name,1,string.find(name,"/")),"/",""))
				if res and getResourceState(res)=="running" then
					restartResource(res)
				end
			else
				outputChatBox("File was not saved!",client,100,0,0)
			end
		end
	elseif typ=="copyScript" then
		if new1=="" then
			new1 = new.."1"
		end
		local filePath = ":"..name.."/"..new
		if fileExists(filePath) then
			if fileCopy(filePath,":"..name.."/"..new1) then
				outputToClient("File: '"..name.."/"..new1.."' was successfully copied!",client,0,100,0)
			end
		else
			outputToClient("File: '"..name.."/"..new.."' does not exist!",client,100,0,0)
		end
	elseif typ=="renameScript" then
		if new1=="" then
			new1 = new.."1"
		end
		local filePath = ":"..name.."/"..new
		if fileExists(filePath) then
			if fileRename(filePath,":"..name.."/"..new1) then
				outputToClient("File: '"..name.."/"..new.."' was renamed to: '"..name.."/"..new1.."' !",client,0,100,0)
			else
				outputToClient("File: '"..name.."/"..new.."' could not be renamed!",client,100,0,0)
			end
		else
			outputToClient("File: '"..name.."/"..new.."' does not exist!",client,100,0,0)
		end
	elseif typ=="deleteScript" then
		local filePath = ":"..name.."/"..new
		if fileExists(filePath) then
			if fileDelete(filePath) then
				outputToClient("File: '"..name.."/"..new.."' has been deleted!",client,0,100,0)
			end
		else
			outputToClient("File: '"..name.."/"..new.."' does not exist!",client,100,0,0)
		end
	end
end)