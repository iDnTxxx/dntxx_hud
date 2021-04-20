local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("vrp_desmanche",emP)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,perm)
end

function emP.checkVehicle()
	local source = source
	local user_id = vRP.getUserId(source)
	local salario = math.random(15000,25000)	
	if user_id then
	local policia = vRP.getUsersByPermission("policia.permissao")
		if #policia < 0 then
		  TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.",8000)
		  return
		end
		local vehicle,vnetid,placa,vname,lock,banned,work = vRPclient.vehList(source,7)
		if vehicle and placa then
			local puser_id = vRP.getUserByRegistration(placa)
			if puser_id then
				local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(puser_id), vehicle = vname })
				if #vehicle <= 0 then
					TriggerClientEvent("Notify",source,"importante","Veículo não encontrado na lista do proprietário.",8000)
					return
				end
				if parseInt(vehicle[1].detido) == 1 then
					TriggerClientEvent("Notify",source,"aviso","Veículo encontra-se apreendido na seguradora.",8000)
					return
				end
				if banned then
					TriggerClientEvent("Notify",source,"negado","Veículos de serviço ou alugados não podem ser desmanchados.",8000)
					return
				end
				
			end
			SetTimeout(23000,function()
				TriggerClientEvent("vrp_sound:source",user_id,'saw',0.6)
			end)

			vRP.giveInventoryItem(user_id,"dinheirosujo",salario,true)
			return true					
		end
	end
end