local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("dntxx_vinhedo",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(3)
	end
end

function emP.checkFrutas()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("uvas")*quantidade[source] <= vRP.getInventoryMaxWeight(user_id) then
			TriggerClientEvent("Notify",source,"sucesso","Sucesso, Você recebeu <b>"..quantidade[source].."</b> Uvas.") 
			vRP.giveInventoryItem(user_id,"uvas",quantidade[source])
			quantidade[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.")
			return false
		end
	end
end

function emP.checkPayment()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"uvas",quantidade[source]) then
			randmoney = (math.random(600,900)*quantidade[source])
	        vRP.giveMoney(user_id,parseInt(randmoney))
	        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
	        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..parseInt(randmoney).." dólares</b>.")
			quantidade[source] = nil
			emP.Quantidade()
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..quantidade[source].."x Uvas</b>.")
		end
	end
end