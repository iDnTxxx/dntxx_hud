local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
DntxxStockade = {}
Tunnel.bindInterface("dntxx_stockade",DntxxStockade)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function DntxxStockade.gerarRecompensa()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		randmoney = math.random(1060,2200)
		vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
		TriggerClientEvent("Notify",source,"financeiro","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
		return true
	end
end