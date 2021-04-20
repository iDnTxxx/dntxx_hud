local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("dntxx_policia",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"policia.permissao")
end

function emP.checkPayment()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        randmoney = math.random(220,330)
        vRP.giveMoney(user_id,parseInt(randmoney))
        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..parseInt(randmoney).." dólares</b>.")
    end
end