-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_chest",src)
vCLIENT = Tunnel.getInterface("vrp_chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookbaupolicia = "https://discord.com/api/webhooks/769156041803694110/l-OUg6CF4gYwyzbKVT5g2bt-k7y3cV88D9UcQ6pgbZ5n3NF_75iGsdqSF6Ry7oNi5mv8"
local webhookbaugangues = "https://discordapp.com/api/webhooks/768796293707333654/mRL94BrCEYxzWxR0lJ1CNFlA5uGZpVmEWT8njNDqAQZpVugK1u6KHdkusdnkV4iffR8g"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
local chest = {
	["Policia"] = { 15000,"policia.permissao" },
	["Ballas"] = { 5000,"ballas.permissao" },
	["Groove"] = { 5000,"grove.permissao" },
	["Vagos"] = { 5000,"vagos.permissao" },
	["Bloods"] = { 5000,"blood.permissao" },
	["Crips"] = { 5000,"crips.permissao" },
	["Triade"] = { 5000,"mafia.permissao" },
	["Bratva"] = { 5000,"brt.permissao" },
	["MotoClub"] = { 5000,"motoclub.permissao" },
	["Bahamas"] = { 5000,"bahamas.permissao" },
	["LifeInvader"] = { 5000,"lifeinvader.permissao" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEDOWNTIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		for k,v in pairs(actived) do
			if v > 0 then
				actived[k] = v - 2
				if v == 0 then
					actived[k] = nil
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CHECKINTPERMISSIONS ]----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkIntPermissions(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)

	if nuser_id then
		TriggerClientEvent("Notify",source,"negado","Você não consegue pegar os itens com pessoas por perto.")
	else
		if user_id then
			if not vRP.searchReturn(source,user_id) then
				if vRP.hasPermission(user_id,chest[chestName][2]) then
					return true
				else
					TriggerClientEvent("Notify",source,"negado","Você não tem permissão para isso",8000)
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.openChest(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local hsinventory = {}
		local myinventory = {}
		local data = vRP.getSData("chest:"..tostring(chestName))
		local result = json.decode(data) or {}
		if result then
			for k,v in pairs(result) do
				table.insert(hsinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end

			local inv = vRP.getInventory(parseInt(user_id))
			for k,v in pairs(inv) do
				table.insert(myinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end
		end
		return hsinventory,myinventory,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(result),parseInt(chest[tostring(chestName)][1])
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.storeItem(chestName,itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
			if string.match(itemName,"identidade") then
				TriggerClientEvent("Notify",source,"importante","Não pode guardar este item.",8000)
				return
			end

			local data = vRP.getSData("chest:"..tostring(chestName))
			local items = json.decode(data) or {}
				if items then
					if parseInt(amount) > 0 then
						local new_weight = vRP.computeItemsWeight(items)+vRP.getItemWeight(itemName)*parseInt(amount)
						if new_weight <= parseInt(chest[tostring(chestName)][1]) then
							if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(amount)) then
								if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
									actived[parseInt(user_id)] = 4
								if chestName == "Policia" then
									SendWebhookMessage(webhookbaupolicia,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Ballas" or chestName == "Groove" or chestName == "Vagos" or chestName == "Bloods" or chestName == "Mafia" or chestName == "Elements" or chestName == "MotoClub" or chestName == "Bahamas" or chestName == "Bratva" or chestName == "Triade" or chestName == "Crips" then
									SendWebhookMessage(webhookbaugangues,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								end
								if items[itemName] ~= nil then
									items[itemName].amount = parseInt(items[itemName].amount) + parseInt(amount)
								else
									items[itemName] = { amount = parseInt(amount) }
								end
								vRP.setSData("chest:"..tostring(chestName),json.encode(items))
								TriggerClientEvent('Creative:UpdateChest',source,'updateChest')
							end

						end
					else
						TriggerClientEvent("Notify",source,"negado","<b>Vault</b> cheio.",8000)
					end
				else
					TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.takeItem(chestName,itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
			if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
				local data = vRP.getSData("chest:"..tostring(chestName))
				local items = json.decode(data) or {}
				if items then
					if parseInt(amount) > 0 then
						if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then
							if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
								if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
									actived[parseInt(user_id)] = 4
								if chestName == "Policia" then
									SendWebhookMessage(webhookbaupolicia,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Ballas" or chestName == "Groove" or chestName == "Vagos" or chestName == "Bloods" or chestName == "Mafia" or chestName == "Elements" or chestName == "MotoClub" or chestName == "Bahamas" or chestName == "Bratva" or chestName == "Triade" or chestName == "Crips" then
									SendWebhookMessage(webhookbaugangues,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								end
								vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(amount))
								items[itemName].amount = parseInt(items[itemName].amount) - parseInt(amount)
								if parseInt(items[itemName].amount) <= 0 then
									items[itemName] = nil
								end
							
								TriggerClientEvent('Creative:UpdateChest',source,'updateChest')
								vRP.setSData("chest:"..tostring(chestName),json.encode(items))
							end
							
						else
							TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
				end
				
			end
		end
	end
	return false
end