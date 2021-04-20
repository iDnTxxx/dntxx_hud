-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
local idgens = Tools.newIDGenerator()
Tunnel.bindInterface("vrp_inventory",cRP)
vCLIENT = Tunnel.getInterface("vrp_inventory")
vRPclient = Tunnel.getInterface("vRP")

vGARAGE = Tunnel.getInterface("vrp_garages")
vDIAGNOSTIC = Tunnel.getInterface("vrp_diagnostic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookequipar = "https://discordapp.com/api/webhooks/768779346029576193/LJmBcloWuC8kK6PVn97_KWFxAeBRQb5_b8ZtfJX3Ulal0GgOLfxowoVAwnbKFdBnCqN6" 
local webhookenviaritem = "https://discordapp.com/api/webhooks/768779515551023116/5FFGJ4jnf-RMsv7NJPmWn78IbyZXh7OzuMtMRpL5J4G0x2hZQgP-TEBVZZlKwAS7lis7"
local webhookdropar = "https://discordapp.com/api/webhooks/768779656010268702/kBOdddRYhtw28530tF3FtH7Y3mzDpHBlbcQZrCy4mrrqjhGmPCOS98bDTJMlqz9cymTy"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inventario = {}
		local inv = vRP.getInventory(user_id)
		for k,v in pairs(inv) do
			if vRP.itemBodyList(k) then
				table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k), desc = vRP.itemDescList(k) })
			end
		end
		return inventario,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.sendItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local nplayer = vRPclient.getNearestPlayer(source,2)
		local nuser_id = vRP.getUserId(nplayer)
		local identity = vRP.getUserIdentity(user_id)
		local identitynu = vRP.getUserIdentity(nuser_id)
		if nuser_id and vRP.itemIndexList(itemName) and itemName ~= "identidade" then
			if parseInt(amount) > 0 then
				if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * amount <= vRP.getInventoryMaxWeight(nuser_id) then
					if vRP.tryGetInventoryItem(user_id,itemName,amount) then
						vRP.giveInventoryItem(nuser_id,itemName,amount)
						vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
						TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
						SendWebhookMessage(webhookenviaritem,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(amount).." "..vRP.itemNameList(itemName).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						TriggerClientEvent('Creative:Update',nplayer,'updateMochila')
						return true
					end
				end
			else
				local inv = vRP.getInventory(user_id)
				for k,v in pairs(inv) do
					if itemName == k then
						if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * parseInt(v.amount) <= vRP.getInventoryMaxWeight(nuser_id) then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
								vRP.giveInventoryItem(nuser_id,itemName,parseInt(v.amount))
								vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
								TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
								SendWebhookMessage(webhookenviaritem,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(parseInt(v.amount)).." "..vRP.itemNameList(itemName).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('Creative:Update',nplayer,'updateMochila')
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.dropItem(itemName,amount)
	local source = source
	if itemName ~= "identidade" then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local x,y,z = vRPclient.getPosition(source)
		if parseInt(amount) > 0 and vRP.tryGetInventoryItem(user_id,itemName,amount) then
			TriggerEvent("DropSystem:create",itemName,amount,x,y,z)
			vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
			SendWebhookMessage(webhookdropar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.itemNameList(itemName).." \n[QUANTIDADE]: "..vRP.format(parseInt(amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			TriggerClientEvent('Creative:Update',source,'updateMochila')
			return true
		else
			local inv = vRP.getInventory(user_id)
			for k,v in pairs(inv) do
				if itemName == k then
					if vRP.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
						TriggerEvent("DropSystem:create",itemName,parseInt(v.amount),x,y,z)
						vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
						SendWebhookMessage(webhookdropar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.itemNameList(itemName).." \n[QUANTIDADE]: "..vRP.format(parseInt(v.amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						return true
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
local bandagem = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(bandagem) do
			if v > 0 then
				bandagem[k] = v - 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
local pick = {}
local blips = {}
function cRP.useItem(itemName,type,ramount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and ramount ~= nil and parseInt(ramount) >= 0 and not actived[user_id] and actived[user_id] == nil then
		if type == "usar" then
			if itemName == "bandagem" then
				vida = vRPclient.getHealth(source)
				if vida > 101 and vida < 400 then
					if bandagem[user_id] == 0 or not bandagem[user_id] then
						if vRP.tryGetInventoryItem(user_id,"bandagem",1) then
							actived[user_id] = true
							vRPclient._CarregarObjeto(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)
							TriggerClientEvent('Creative:Update',source,'updateMochila')
							TriggerClientEvent('cancelando',source,true)
							TriggerClientEvent("progress",source,9000,"bandagem")
							SetTimeout(9000,function()
								actived[user_id] = nil
								bandagem[user_id] = 80
								TriggerClientEvent('bandagem',source)
								TriggerClientEvent('cancelando',source,false)
								vRPclient._DeletarObjeto(source)
								TriggerClientEvent("Notify",source,"sucesso","<b>Bandagem</b> utilizada com sucesso.",8000)
							end)
						end
					else
						TriggerClientEvent("Notify",source,"importante","Você precisa aguardar <b>"..bandagem[user_id].." segundos</b> para utilizar outra Bandagem.",8000)
					end
				else
					TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",8000)
				end
			elseif itemName == "chocolate" then
					vida = vRPclient.getHealth(source)
					if vida > 101 and vida < 400 then
						if bandagem[user_id] == 0 or not bandagem[user_id] then
							if vRP.tryGetInventoryItem(user_id,"chocolate",1) then
								actived[user_id] = true
								vRPclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('cancelando',source,true)
								TriggerClientEvent("progress",source,7000,"chocolate")
								TriggerClientEvent('alimento',source)
								SetTimeout(7000,function()
									actived[user_id] = nil
									bandagem[user_id] = 5
									vRPclient._DeletarObjeto(source)
									TriggerClientEvent('cancelando',source,false)
									TriggerClientEvent("Notify",source,"sucesso","<b>Chocolate</b> utilizada com sucesso.",8000)
								end)
							end
						else
							TriggerClientEvent("Notify",source,"importante","Você não pode comer muito rapido.",8000)
						end
					else
						TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",8000)
					end
			elseif itemName == "mochila" then
				if vRP.getInventoryMaxWeight(user_id) >= 90 then
					TriggerClientEvent("Notify",source,"negado","Você não pode equipar mais mochilas.",8000)
				else
					if vRP.tryGetInventoryItem(user_id,"mochila",1) then
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						vRP.varyExp(user_id,"physical","strength",650)
						TriggerClientEvent("Notify",source,"sucesso","<b>Mochila</b> equipada com sucesso.",8000)
					end
				end
			elseif itemName == "cerveja" then
				if vRP.tryGetInventoryItem(user_id,"cerveja",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Cerveja</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "tequila" then
				if vRP.tryGetInventoryItem(user_id,"tequila",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Tequila</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "vodka" then
				if vRP.tryGetInventoryItem(user_id,"vodka",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Vodka</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "whisky" then
				if vRP.tryGetInventoryItem(user_id,"whisky",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Whisky</b> utilizado com sucesso.",8000)
					end)
				end
			elseif itemName == "conhaque" then
				if vRP.tryGetInventoryItem(user_id,"conhaque",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Conhaque</b> utilizado com sucesso.",8000)
					end)
				end
			elseif itemName == "absinto" then
				if vRP.tryGetInventoryItem(user_id,"absinto",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Absinto</b> utilizado com sucesso.",8000)
					end)
				end
			elseif itemName == "maconha" then
				if vRP.tryGetInventoryItem(user_id,"maconha",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent("progress",source,10000,"fumando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent("Notify",source,"sucesso","<b>Maconha</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "cocaina" then
				if vRP.tryGetInventoryItem(user_id,"cocaina",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent('cancelando',source,true)
					TriggerClientEvent("progress",source,10000,"cheirando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent('cancelando',source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",120)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",120)
						TriggerClientEvent("Notify",source,"sucesso","<b>Cocaína</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "lancaperfume" then
				if vRP.tryGetInventoryItem(user_id,"lancaperfume",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent('cancelando',source,true)
					TriggerClientEvent("progress",source,10000,"baforando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent('cancelando',source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",120)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",120)
						TriggerClientEvent("Notify",source,"sucesso","<b>Lança</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "metanfetamina" then
				if vRP.tryGetInventoryItem(user_id,"metanfetamina",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent("progress",source,10000,"fumando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent("Notify",source,"sucesso","<b>Metanfetamina</b> utilizada com sucesso.",8000)
					end)
				end	
			elseif itemName == "lsd" then
				if vRP.tryGetInventoryItem(user_id,"lsd",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent("progress",source,10000,"tomando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent("Notify",source,"sucesso","<b>LSD</b> utilizado com sucesso.",8000)
					end)
				end		
			elseif itemName == "capuz" then
				if vRP.getInventoryItemAmount(user_id,"capuz") >= 1 then
					local nplayer = vRPclient.getNearestPlayer(source,2)
					if nplayer then
						vRPclient.setCapuz(nplayer)
						vRP.closeMenu(nplayer)
						TriggerClientEvent("Notify",source,"sucesso","<b>Capuz</b> utilizado com sucesso.",8000)
					end
				end
			elseif itemName == "energetico" then
				if vRP.tryGetInventoryItem(user_id,"energetico",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,7000,"bebendo")
					SetTimeout(7000,function()
						actived[user_id] = nil
						TriggerClientEvent('energeticos',source,true)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Energético</b> utilizado com sucesso.",8000)
					end)
					SetTimeout(60000,function()
						TriggerClientEvent('energeticos',source,false)
						TriggerClientEvent("Notify",source,"aviso","O efeito do <b>Energético</b> passou e o coração voltou a bater normalmente.",8000)
					end)
				end
			elseif itemName == "lockpick" then
				local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
				local policia = vRP.getUsersByPermission("policia.permissao")
				if #policia < 0 then
					TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento para iniciar o roubo.")
					return true
				end
				if vRP.hasPermission(user_id,"paramedico.permissao") then
					TriggerEvent("setPlateEveryone",placa)
					vGARAGE.vehicleClientLock(-1,vnetid,lock)
					return
				end
				if vRP.getInventoryItemAmount(user_id,"lockpick") >= 1 and vRP.tryGetInventoryItem(user_id,"lockpick",1) and vehicle then
					actived[user_id] = true
					if vRP.hasPermission(user_id,"paramedico.permissao") then
						actived[user_id] = nil
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						TriggerEvent("setPlateEveryone",placa)
						vGARAGE.vehicleClientLock(-1,vnetid,lock)
						TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
						return
					end

					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
					TriggerClientEvent("progress",source,20000,"roubando")
					SetTimeout(20000,function()
						actived[user_id] = nil
						TriggerClientEvent('cancelando',source,false)
						vRPclient._stopAnim(source,false)

						if math.random(100) >= 80 then
							TriggerClientEvent('Creative:Update',source,'updateMochila')
							TriggerEvent("setPlateEveryone",placa)
							vGARAGE.vehicleClientLock(-1,vnetid,lock)
							TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
						else
							TriggerClientEvent("Notify",source,"negado","Roubo do veículo concluído e as autoridades foram acionadas.",8000)
							local policia = vRP.getUsersByPermission("policia.permissao")
							local x,y,z = vRPclient.getPosition(source)
							for k,v in pairs(policia) do
								local player = vRP.getUserSource(parseInt(v))
								if player then
									async(function()
										local id = idgens:gen()
										vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
										TriggerClientEvent('chatMessage',player,"Dispatch",{65,130,255},"Roubo na ^1"..street.."^0 do veículo ^1"..model.."^0 de placa ^1"..placa.."^0 verifique o ocorrido.")
										pick[id] = vRPclient.addBlip(player,x,y,z,10,5,"Ocorrência",0.5,false)
										SetTimeout(20000,function() vRPclient.removeBlip(player,pick[id]) idgens:free(id) end)
									end)
								end
							end
						end
					end)
				end
			elseif itemName == "masterpick" then
				local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
				local policia = vRP.getUsersByPermission("policia.permissao")
				if #policia < 0 then
					TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento para iniciar o roubo.")
					return true
				end
				if vRP.hasPermission(user_id,"policia.permissao") then
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerEvent("setPlateEveryone",placa)
					vGARAGE.vehicleClientLock(-1,vnetid,lock)
					TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
					return
				end
				if vRP.getInventoryItemAmount(user_id,"masterpick") >= 1 and vehicle then
					actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
							TriggerClientEvent("progress",source,60000,"roubando")
							SetTimeout(60000,function()

								TriggerClientEvent('cancelando',source,false)
								vRPclient._stopAnim(source,false)
								actived[user_id] = nil
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerEvent("setPlateEveryone",placa)
								vGARAGE.vehicleClientLock(-1,vnetid,lock)
								TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
							return
						end)
					end
			elseif itemName == "militec" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source,3.5)
					if vehicle then
						if vRP.hasPermission(user_id,"mecanico.permissao") then
							actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
							TriggerClientEvent("progress",source,30000,"reparando motor")
							SetTimeout(30000,function()
								actived[user_id] = nil
								TriggerClientEvent('cancelando',source,false)
								TriggerClientEvent('repararmotor',source,vehicle)
								vRPclient._stopAnim(source,false)
							end)
						else
							if vRP.tryGetInventoryItem(user_id,"militec",1) then
								actived[user_id] = true
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('cancelando',source,true)
								vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
								TriggerClientEvent("progress",source,30000,"reparando motor")
								SetTimeout(30000,function()
									actived[user_id] = nil
									TriggerClientEvent('cancelando',source,false)
									TriggerClientEvent('repararmotor',source,vehicle)
									vRPclient._stopAnim(source,false)
								end)
							end
						end
					end
				end	
			elseif itemName == "repairkit" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source,3.5)
					if vehicle then
						if vRP.hasPermission(user_id,"mecanico.permissao") then
							actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
							TriggerClientEvent("progress",source,30000,"reparando veículo")
							SetTimeout(30000,function()
								actived[user_id] = nil
								TriggerClientEvent('cancelando',source,false)
								TriggerClientEvent('reparar',source)
								vRPclient._stopAnim(source,false)
							end)
						else
							if vRP.tryGetInventoryItem(user_id,"repairkit",1) then
								actived[user_id] = true
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('cancelando',source,true)
								vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
								TriggerClientEvent("progress",source,30000,"reparando veículo")
								SetTimeout(30000,function()
									actived[user_id] = nil
									TriggerClientEvent('cancelando',source,false)
									TriggerClientEvent('reparar',source)
									vRPclient._stopAnim(source,false)
								end)
							end
						end
					end
				end	
			elseif itemName == "pneus" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source,7)
					if vehicle then
						if vRP.hasPermission(user_id,"mecanico.permissao") then
							actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
							TriggerClientEvent("progress",source,45000)
							SetTimeout(45000,function()
								actived[user_id] = nil
								TriggerClientEvent('cancelando',source,false)
								TriggerClientEvent('repararpneus',source,vehicle)
								vRPclient._stopAnim(source,false)
							end)
						else
							if vRP.tryGetInventoryItem(user_id,"pneus",1) then
								actived[user_id] = true
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('cancelando',source,true)
								vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
								TriggerClientEvent("progress",source,45000)
								SetTimeout(45000,function()
									actived[user_id] = nil
									TriggerClientEvent('cancelando',source,false)
									TriggerClientEvent('repararpneus',source,vehicle)
									vRPclient._stopAnim(source,false)
								end)
							end
						end
					end
				end	
			elseif itemName == "placa" then
                if vRPclient.GetVehicleSeat(source) then
                    if vRP.tryGetInventoryItem(user_id,"placa",1) then
                        local placa = vRP.generatePlate()
                        TriggerClientEvent('Creative:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent("vehicleanchor",source)
                        TriggerClientEvent("progress",source,59500,"clonando")
                        SetTimeout(60000,function()
                            TriggerClientEvent('cancelando',source,false)
                            TriggerClientEvent("cloneplates",source,placa)
                            --TriggerEvent("setPlateEveryone",placa)
                            TriggerClientEvent("Notify",source,"sucesso","Placa clonada com sucesso.",8000)
                        end)
                    end
				end
			end
		elseif type == "equipar" then
			if vRP.tryGetInventoryItem(user_id,itemName,1) then
				local weapons = {}
				local identity = vRP.getUserIdentity(user_id)
				weapons[string.gsub(itemName,"wbody|","")] = { ammo = 0 }
				vRPclient._giveWeapons(source,weapons)
				SendWebhookMessage(webhookequipar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[EQUIPOU]: "..vRP.itemNameList(itemName).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				TriggerClientEvent('Creative:Update',source,'updateMochila')
			end
		elseif type == "recarregar" then
			local uweapons = vRPclient.getWeapons(source)
      		local weaponuse = string.gsub(itemName,"wammo|","")
      		local weaponusename = "wammo|"..weaponuse
			local identity = vRP.getUserIdentity(user_id)
      		if uweapons[weaponuse] then
        		local itemAmount = 0
        		local data = vRP.getUserDataTable(user_id)
        		for k,v in pairs(data.inventory) do
          		if weaponusename == k then
            		if v.amount > 250 then
              			v.amount = 250
            		end

            		itemAmount = v.amount

					if vRP.tryGetInventoryItem(user_id, weaponusename, parseInt(v.amount)) then
						local weapons = {}
						weapons[weaponuse] = { ammo = v.amount }
						itemAmount = v.amount
						vRPclient._giveWeapons(source,weapons,false)
						SendWebhookMessage(webhookequipar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECARREGOU]: "..vRP.itemNameList(itemName).." \n[MUNICAO]: "..parseInt(v.amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	actived[user_id] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ GMOCHILA ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('gmochila',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if vRP.getExp(user_id,"physical","strength") == 1900 then -- 90Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 15 then
				TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				vRP.varyExp(user_id,"physical","strength",-580)
				vRP.giveInventoryItem(user_id,"mochila",1)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 1320 then -- 75Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 24 then
				TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				vRP.varyExp(user_id,"physical","strength",-650)
				vRP.giveInventoryItem(user_id,"mochila",1)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 670 then -- 51Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 45 then
				TriggerClientEvent("Notify",source,"sucesso","Você desequipou sua mochila.")
				vRP.varyExp(user_id,"physical","strength",-650)
				vRP.giveInventoryItem(user_id,"mochila",1)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 20 then -- 6Kg
			TriggerClientEvent("Notify",source,"negado","Você não tem mochilas equipadas.")
		end
	end
end)