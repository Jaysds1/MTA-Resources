addEventHandler("onPlayerLogin",root,function() triggerClientEvent("login",root,source.name)	end)

addEvent("JW.Service",true)
addEventHandler("JW.Service",root,function(typ)
	--[[ <--REMOVE THESE TO ENABLE THE META.xml settings 
	if typ == "ready" then
		triggerClientEvent("JW.Service",root,get("@joinquitj.panelType"),get("@joinquitj.type"))
	end
	AND THESE--> ]]
end)