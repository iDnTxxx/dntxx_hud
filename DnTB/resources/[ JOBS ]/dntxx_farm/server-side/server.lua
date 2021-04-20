-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
emP = {}
Tunnel.bindInterface("dntxx_farm",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSAO 
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"ballas.permissao") or vRP.hasPermission(user_id,"grove.permissao") or vRP.hasPermission(user_id,"vagos.permissao") or vRP.hasPermission(user_id,"blood.permissao") or vRP.hasPermission(user_id,"crips.permissao") or vRP.hasPermission(user_id,"mafia.permissao") or vRP.hasPermission(user_id,"brt.permissao") then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não tem acesso.")
			return false
		end						
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PAGAMENTO 
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PAGAMENTO 
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"grove.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(7,7)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("acidobateria")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(7,7)
					vRP.giveInventoryItem( user_id,"acidobateria",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Acido de Bateria.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"ballas.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(7,7)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("adubo")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(7,7)
					vRP.giveInventoryItem( user_id,"adubo",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Adubo.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end			

		elseif vRP.hasPermission(user_id,"vagos.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(7,7)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("folhadecoca")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(7,7)
					vRP.giveInventoryItem( user_id,"folhadecoca",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Folha de Coca.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"crips.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(20,20)
			local pagamento = math.random(1000,2000)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("armacaodearma")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(20,20)
					vRP.giveInventoryItem( user_id,"armacaodearma",quantidade)
					vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Armações de Arma.</b>")
					TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"blood.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(20,20)
			local pagamento = math.random(1000,2000)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("armacaodearma")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(20,20)
					vRP.giveInventoryItem( user_id,"armacaodearma",quantidade)
					vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Armações de Arma.</b>")
					TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"mafia.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(40,40)
			if itens <= 29 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("capsulas")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(40,40)
					vRP.giveInventoryItem( user_id,"capsulas",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Capsulas.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end

			if itens > 26 and itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("polvora")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(40,40)
					vRP.giveInventoryItem( user_id,"polvora",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Polvoras.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end

		elseif vRP.hasPermission(user_id,"brt.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(40,40)
			if itens <= 29 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("capsulas")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(40,40)
					vRP.giveInventoryItem( user_id,"capsulas",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Capsulas.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end

			if itens > 26 and itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("polvora")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(40,40)
					vRP.giveInventoryItem( user_id,"polvora",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Polvoras.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		end
		return true			
	end
end