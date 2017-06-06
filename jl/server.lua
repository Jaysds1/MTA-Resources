addEvent("onPlayerAutoLogin")
addEvent("JW.Services",true)
thisResource = thisResource or getThisResource()

addEventHandler("onResourceStart",resourceRoot,function(res)
	if(res~=thisResource)then return end
	if(
		not ACL.hasObjectPermissionTo(thisResource,"function.addAccount") or
		not ACL.hasObjectPermissionTo(thisResource,"function.logIn") or 
		not ACL.hasObjectPermissionTo(thisResource,"function.logOut")
	)then
		outputDebugString("Resource requires permission!")
		cancelEvent(true,"Resource requires permission!")
		return
	end
	for _,v in ipairs(Element.getAllByType("player"))do
		if not v.account:isGuest()then
			v:logOut()
		end
		Timer(triggerClientEvent,3000,1,v,"JW.Services",v,"pic",get("@jl.picShow"),get("@jl.picPath"))
	end
end)

addEventHandler("JW.Services",root,function(typ,user,pass,email)
	if typ=="Login" or typ=="Register" then
		if user=="" or pass=="" then
			if email and email=="" then
				triggerClientEvent(client,"JW.Services",client,"failed","Username/Password/Email not entered!")
			else
				triggerClientEvent(client,"JW.Services",client,"failed","Username/Password not entered!")
			end
			return
		end
		acc = Account(user)
	end
	
	if typ=="Login" then
		if acc then
			if client:logIn(acc,pass)then
				triggerClientEvent(client,"JW.Services",client,"success","Successfully Logged-In!")
			else
				triggerClientEvent(client,"JW.Services",client,"failed","Wrong Password!")
			end
		else
			triggerClientEvent(client,"JW.Services",client,"failed","Account doesn't exist!")
		end
	elseif typ=="Register"then
		if acc then
			triggerClientEvent(client,"JW.Services",client,"failed","Account exists!")
		else
			for _,v in ipairs(Account.getAll())do
				if v:getData("Email")==email then
					triggerClientEvent(client,"JW.Services",client,"failed","Email Already Used!")
					return
				end
			end
			acc=Account.add(user,pass)
			if acc then
				acc:setData("Email",email)
				acc:setData("Password",pass)
				client:logIn(acc,pass)
				triggerClientEvent(client,"JW.Services",client,"success","Successfully Registered and Logged-In!")
			end
		end
	elseif typ=="autologin" then
		if acc then
			if client:logIn(acc,pass)then
				triggerClientEvent(client,"JW.Services",client,"success","Successfully Logged-In! \nTo remove the autologin, type in '/ral' ","command")
				triggerEvent("onPlayerAutoLogin",client)
			else
				triggerClientEvent(client,"JW.Services",client,"failed","Wrong Password!")
			end
		else
			triggerClientEvent(client,"JW.Services",client,"failed","Account doesn't exist!")
		end
	--[[elseif typ=="email"then
		local len = email:len()
		if not email:find("@",1,true)then
			triggerClientEvent(client,"JW.Services",client,"failed","Invalid email entered!")
			return
		end
		local emailExist = false
		for _,v in ipairs(getAccounts())do
			if v:getData("Email")==email then
				emailExist = true
				user = v:getName()
				pass = getAccountPassword(v,user)
				break;
			else
				emailExist = false
			end
		end
		if not emailExist then
			triggerClientEvent(client,"JW.Services",client,"failed","Email doesn't exist in our Database!")
		else
			triggerClientEvent(client,"JW.Services",client,output,"Username and Password was sent to your email!")
		end]]
	end
end)

--[[function getAccountPassword(theAccount,theUsername)
	if Account(theUsername)==theAccount then
		return theAccount.getData("Password")
	end
	return false
end]]

addEventHandler("onPlayerLogout",root,function()
	triggerClientEvent(source,"JW.Services",source,"login","Successfully Logged-Out!")
end)

addEventHandler("onPlayerChat",root,function()
	local acc = source.account
	if acc.isGuest() or not acc then
		cancelEvent(true,"YOU HAVE TO BE LOGGED-IN TO CHAT!")
		outputChatBox("YOU HAVE TO BE LOGGED-IN TO CHAT!",source,255,0,0)
	end
end)