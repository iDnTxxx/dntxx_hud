-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_inspect",cRP)
vCLIENT = Tunnel.getInterface("vrp_inspect")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local opened = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- /INSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("revistar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
	local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			local identity = vRP.getUserIdentity(user_id)
			local nsource = vRP.getUserSource(parseInt(nuser_id))
			if not vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
				local request = vRP.request(nplayer,"Você está sendo revistado, você permite?",60)
				if request then
					vRPclient._playAnim(source,false,{{"misscarsteal4@director_grip","end_loop_grip"}},true)
					vRPclient._playAnim(nplayer,false,{{"random@mugging3","handsup_standing_base"}},true)
					vCLIENT.toggleCarry(nplayer,source)
					
					TriggerClientEvent("cancelando",nplayer,true)
					TriggerClientEvent("Notify",nplayer,"aviso","Revistado por <b>"..identity.name.." "..identity.firstname.."</b>.")
		
					local weapons = vRPclient.replaceWeapons(nsource,{})
					for k,v in pairs(weapons) do
						vRP.giveInventoryItem(parseInt(nuser_id),"wbody|"..k,1)
						if parseInt(v.ammo) > 0 then
							vRP.giveInventoryItem(parseInt(nuser_id),"wammo|"..k,parseInt(v.ammo))
						end
					end
					local nmoney = vRP.getMoney(nuser_id)
					if vRP.tryPayment(nuser_id,nmoney) then
						vRP.giveMoney(user_id,nmoney)
						TriggerClientEvent("Notify",source,"sucesso","Você pegou "..vRP.format(parseInt(nmoney)).." dólares")
					end
						opened[parseInt(user_id)] = parseInt(nuser_id)
						vCLIENT.openInspect(source)
					else
						TriggerClientEvent("Notify",source,"negado","Pedido de revista recusado.",5000)
					end
				end
			end
		end

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /REVISTAR POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("apreender",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			local identity = vRP.getUserIdentity(user_id)
			local nsource = vRP.getUserSource(parseInt(nuser_id))
			if vRP.hasPermission(user_id,"policia.permissao") then

				vRPclient._playAnim(source,false,{{"oddjobs@shop_robbery@rob_till","loop"}},true)
				vRPclient._playAnim(nplayer,false,{{"random@mugging3","handsup_standing_base"}},true)
				vCLIENT.toggleCarry(nplayer,source)
				
				TriggerClientEvent("cancelando",nplayer,true)
				TriggerClientEvent("Notify",nplayer,"aviso","Revistado por <b>"..identity.name.." "..identity.firstname.."</b>.")

				local weapons = vRPclient.replaceWeapons(nsource,{})
				for k,v in pairs(weapons) do
					vRP.giveInventoryItem(parseInt(nuser_id),"wbody|"..k,1)
					if parseInt(v.ammo) > 0 then
						vRP.giveInventoryItem(parseInt(nuser_id),"wammo|"..k,parseInt(v.ammo))
					end
				end
				opened[parseInt(user_id)] = parseInt(nuser_id)
				vCLIENT.openInspect(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openChest()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ninventory = {}
		local uinventory = {}

		local inv = vRP.getInventory(parseInt(opened[user_id]))
		if inv then
			for k,v in pairs(inv) do
				if vRP.itemBodyList(k) then
					table.insert(ninventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
				end
			end
		end

		local inv2 = vRP.getInventory(parseInt(user_id))
		if inv2 then
			for k,v in pairs(inv2) do
				if vRP.itemBodyList(k) then
					table.insert(uinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
				end
			end
		end

		return ninventory,uinventory,vRP.getInventoryWeight(parseInt(user_id)),vRP.getInventoryMaxWeight(parseInt(user_id)),vRP.getInventoryWeight(parseInt(opened[user_id])),vRP.getInventoryMaxWeight(parseInt(opened[user_id]))
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.storeItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local nsource = vRP.getUserSource(parseInt(opened[user_id]))
		if user_id and nsource then
			if parseInt(amount) > 0 then
				if vRP.getInventoryWeight(parseInt(opened[user_id]))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(opened[user_id])) then
					if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(amount)) then
						vRP.giveInventoryItem(parseInt(opened[user_id]),itemName,parseInt(amount))
						TriggerClientEvent("Creative:UpdateInspec",source,"updateChest")
					end
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",5000)
				end
			else
				local inv = vRP.getInventory(parseInt(user_id))
				if inv and inv[itemName] ~= nil then
					if vRP.getInventoryWeight(parseInt(opened[user_id]))+vRP.getItemWeight(itemName)*parseInt(inv[itemName].amount) <= vRP.getInventoryMaxWeight(parseInt(opened[user_id])) then
						if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(inv[itemName].amount)) then
							vRP.giveInventoryItem(parseInt(opened[user_id]),itemName,parseInt(inv[itemName].amount))
							TriggerClientEvent("Creative:UpdateInspec",source,"updateChest")
						end
					else
						TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",5000)
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.takeItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local nsource = vRP.getUserSource(parseInt(opened[user_id]))
		if user_id and nsource then
			if parseInt(amount) > 0 then
				if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
					if vRP.tryGetInventoryItem(parseInt(opened[user_id]),itemName,parseInt(amount)) then
						vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(amount))
						--SendWebhookMessage(webhookinspect,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent("Creative:UpdateInspec",source,"updateChest")
					end
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",5000)
				end
			else
				local inv = vRP.getInventory(parseInt(opened[user_id]))
				if inv and inv[itemName] ~= nil then
					if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(inv[itemName].amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
						if vRP.tryGetInventoryItem(parseInt(opened[user_id]),itemName,parseInt(inv[itemName].amount)) then
							vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(inv[itemName].amount))
							TriggerClientEvent("Creative:UpdateInspec",source,"updateChest")
						end
					else
						TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",5000)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.resetInspect()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and opened[parseInt(user_id)] then
		local nplayer = vRP.getUserSource(parseInt(opened[parseInt(user_id)]))
		if nplayer then
			vCLIENT.toggleCarry(nplayer,source)
			TriggerClientEvent("cancelando",nplayer,false)
			vRPclient._stopAnim(nplayer,false)
		end

		opened[parseInt(user_id)] = nil
		vRPclient._stopAnim(source,false)
	end
end