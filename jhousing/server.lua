local interior = {
	{1,224.6351,1289.012,1082.141},
	{1,244.0892,304.8456,999.1484},
	{1,2525.0420,-1679.1150,1015.4990};
	}
	
function loadHouses()
	local dbType = get("@jhousing.dbType")
	if dbType == "sqlite" then
		connected = dbConnect(dbType,"houses.db")
	elseif dbType == "mysql" then
		-- Get Settings for MySQL
		local dbName = get("@jhousing.dbName")
		local dbHost = get("@jhousing.dbHost")
		local dbPort = get("@jhousing.dbPort")
		local dbUS = get("@jhousing.dbUnixSoc")
		local dbUser = get("@jhousing.dbUser")
		local dbPass = get("@jhousing.dbPass")
		if not( dbName or dbHost or dbUser or dbPass) then
			outputDebugString("You are missing a value in "..(thisResource.name)..", meta.xml for the MySQL Settings, please check it.",3)
			return
		end
		
		local host = "dbname="..dbName..";host="..dbHost
		if dbPort~="" then
			if dbUS~="" then
				host = "dbname="..dbName..";host="..dbHost..";port="..dbPort..";unix_socket="..dbUS
			else
				host = "dbname="..dbName..";host="..dbHost..";port="..dbPort
			end
		end
		connected = dbConnect(dbType,host,dbUser,dbPass,"share=1")
	end
	if connected then
		dbExec(connected,"CREATE TABLE IF NOT EXISTS houses (ID NUMBER, name TEXT, price NUMBER,int NUMBER, dim NUMBER, x FLOAT, y FLOAT, z FLOAT, x1 FLOAT, y1 FLOAT, z1 FLOAT, x2 FLOAT, y2 FLOAT, z2 FLOAT, x3 FLOAT, y3 FLOAT, z3 FLOAT, x4 FLOAT, y4 FLOAT, z4 FLOAT, bought BOOL, owner TEXT)")
		dbQuery(function(q)
			local hous=dbPoll(q,-1)
			for _,v in ipairs(hous)do
				local pickup=Pickup(v.x,v.y,v.z,3,1273,1000)
				pickup:setData("house",true)
				pickup:setData("ID",v.ID)
				pickup:setData("houseName",v.name)
				pickup:setData("housePrice",v.price)
				pickup:setData("Dim",v.dim)
				
				pickup:setData("Int",v.int)
				pickup:setData("bought",v.bought)
				pickup:setData("Owner",v.owner)
				
				local out = Marker(v.x3,v.y3,v.z3,"arrow",1.3,255,255,255,255)
				out.interior = v.int
				out.dimension = v.dim
				
				out:setData("house",true)
				out:setData("Pickup",pickup)
			end
			for _,i in ipairs(Element.getAllByType("pickup"))do
				if i:getData("house") and i:getData("bought")==1 then
					i:setType(3,1272)
				end
			end
		end,connected,"SELECT * FROM houses")
		addEventHandler("onPickupHit",root,function(client)
			if source:getData("house")then
				triggerClientEvent(client,"clientHousing",client,source,client.account:getName(),get("@jhousing.tourit"),get("@jhousing.guestkey"))
			end
		end)
		addEventHandler("onMarkerHit",root,function(client)
			if source:getData("house")then
				local pickup = source:getData("Pickup")
				local x,y,z = getElementPosition(pickup)
				client:setInterior(0,x,y,z)
				if client.dimension ~= 0 then
					client.dimension = 0
				end
			end
		end)
	end
end

addEventHandler("onResourceStart",resourceRoot,function()
	cmd = get("@jhousing.cmdName")
	for _,v in ipairs(Element.getAllByType("player"))do
		if isObjectInACLGroup("user."..(v.account:getName()),aclGetGroup("Admin")) then
			Timer(triggerClientEvent,3000,1,v,"accessToJHouse",v,cmd,ints)
		end
	end
	loadHouses()
end)

addEventHandler("onPlayerLogin",root,function(_,curAcc)
	if isObjectInACLGroup("user."..(curAcc.name),aclGetGroup("Admin")) then
		triggerClientEvent(source,"accessToJHouse",source,cmd,ints)
	end
end)

addEvent("JW.Services",true)
addEventHandler("JW.Services",root,function(typ,houseNme,housePrce,int,dim,dime)
	if typ=="create" then
		local x,y,z = getElementPosition(client)
		if houseNme=="sale" then
			if isElement(sale) then
				setElementPosition(sale,x,y,z)
				return
			end
			sale = Pickup(x,y,z,3,1273,1000)
		elseif houseNme=="outIn"then
			if isElement(OutInM) then
				setElementPosition(OutInM,x,y,z)
				return
			end
			OutInM = Marker(x,y,z,"arrow",2,255,255,255,255)
		elseif houseNme=="outOut"then
			if isElement(OutOutM) then
				setElementPosition(OutOutM,x,y,z)
				return
			end
			OutOutM = Marker(x,y,z,"arrow",2,0,255,255,255)
		elseif houseNme=="intOut"then
			if isElement(InOutM) then
				setElementPosition(InOutM,x,y,z)
				return
			end
			InOutM = Marker(x,y,z,"arrow",2,0,255,255,255)
			InOutM:setInterior(client.interior)
			if client.dimension~=0 then
				inOutM.dimension = client.dimension
			end
		elseif houseNme=="intIn"then
			if isElement(IntInM) then
				setElementPosition(IntInM,x,y,z)
				return
			end
			IntInM = Marker(x,y,z,"arrow",2,255,255,255,255)
			IntInM:setInterior(client.interior)
			if client.dimension~=0 then
				IntInM.dimension = client.dimension
			end
		end
	elseif typ=="storedb" then
		if connected then
			dbQuery(function(q)
				ID=dbPoll(q,-1)
				ID = #ID+1
				local x,y,z = getElementPosition(sale)
				local x1,y1,z1 = getElementPosition(OutInM)
				local x2,y2,z2 = getElementPosition(OutOutM)
				local x3,y3,z3 = getElementPosition(InOutM)
				local x4,y4,z4 = getElementPosition(IntInM)
				dbExec(connected,"INSERT INTO houses VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",ID,houseNme,housePrce,int,dim,x,y,z,x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,false,'No One')
				sale:destroy()
				
				OutInM:destroy()
				OutOutM:destroy()
				InOutM:destroy()
				IntInM:destroy()
				loadHouses()
			end,connected,"SELECT ID FROM houses")
			client:outputChat("House successfully saved.",0,100,0)
		end
	elseif typ=="buyHouse" then
		if connected then
			local clientName = client.account:getName()
			if dbExec(connected,"UPDATE houses SET owner=?,bought=? WHERE ID=?",clientName,true,houseNme)then
				client:outputChat("You now own this house!",0,100,0)
				client:takeMoney(housePrce)
			end
			for _,v in ipairs(Element.getAllByType("pickup"))do
				if v:getData("house") and v:getData("ID")==houseNme then
					v:setData("bought",1)
					v:setData("Owner",clientName)
					v:setType(3,1272)
				end
			end
		end
	elseif typ=="sellHouse" then
		if connected then
			if dbExec(connected,"UPDATE houses SET owner=?,bought=? WHERE ID=?","No One",false,houseNme)then
				client:outputChat("The house is now for sale!",0,100,0)
				client:giveMoney(housePrce-(housePrce*.7))
			end
			for _,v in ipairs(Element.getAllByType("pickup"))do
				if v:getData("house") and v:getData("ID")==houseNme then
					v:setData("bought",0)
					v:setData("Owner","No One")
					v:setType(3,1273)
				end
			end
		end
	elseif typ=="tourHouse"then
		if not client.onGround then client:outputChat("Please stay on the ground to go into the house!",100,0,0) return end
		client:setInterior(interior[houseNme][1],interior[houseNme][2],interior[houseNme][3],interior[houseNme][4])
		cliehnt:outputChat("You have 18 seconds to tour")
		Timer(function(client,housePrce,int,dim)
			client:setInterior(0,housePrce,int,dim)
			client.dimension = 0
			if not client.onGround then
				setElementPosition(client,housePrce,int,dim-3)
			end
		end,18000,1,client,housePrce,int,dim)
		if dime~=client.dimension then
			client.dimension = dime
		end
	elseif typ=="guestEnter" then
		houseNme = string.lower(houseNme)
		housePrce = string.lower(housePrce)
		if houseNme:len()~=tonumber(get("@jhousing.guestlen"))then
			client:outputChat("Sorry, but the guest key isn't that short/long!",100,0,0)
			return
		end
		if houseNme~=housePrce then
			client:outputChat("Sorry, but that isn't the guest key!",100,0,0)
			return
		end
		client:setInterior(interior[int][1],interior[int][2],interior[int][3],interior[int][4])
		if dim~=client.dimension then
			client.dimension = dim
		end
	elseif typ=="giveRandomKey" then
		local key = string.random(tonumber(get("@jhousing.guestlen")),"%l")
		local pickup = client:getData("Pickup")
		if pickup:setData("GuestKey",key) then
			client:outputChat("Your house GuestKey is: '"..key.."'.",0,100,0)
			client:outputChat("Please note that the key changes everytime you delete it and add it.",0,100,0)
			pickup:setData("Guest",true)
		end
	end
end)


--Lua Function
local Chars = {}
for Loop = 0, 255 do
   Chars[Loop+1] = string.char(Loop)
end
local String = table.concat(Chars)

local Built = {['.'] = Chars}

local AddLookup = function(CharSet)
   local Substitute = string.gsub(String, '[^'..CharSet..']', '')
   local Lookup = {}
   for Loop = 1, string.len(Substitute) do
       Lookup[Loop] = string.sub(Substitute, Loop, Loop)
   end
   Built[CharSet] = Lookup

   return Lookup
end

function string.random(Length, CharSet)
   -- Length (number)
   -- CharSet (string, optional); e.g. %l%d for lower case letters and digits

   local CharSet = CharSet or '.'

   if CharSet == '' then
      return ''
   else
      local Result = {}
      local Lookup = Built[CharSet] or AddLookup(CharSet)
      local Range = table.getn(Lookup)

      for Loop = 1,Length do
         Result[Loop] = Lookup[math.random(1, Range)]
      end

      return table.concat(Result)
   end
end