local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
DntxxCarteiro = {}
Tunnel.bindInterface("dntxx_carteiro",DntxxCarteiro)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function DntxxCarteiro.GerarRecompensa()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		randmoney = math.random(5000,7090)
		vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
		return true
	end
end