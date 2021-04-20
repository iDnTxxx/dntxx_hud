local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emp = {}
Tunnel.bindInterface("dntxx_lixeiro",emp)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------

local items = { 
"bateria",
"cobre",
"plastico",
"borracha",
"linha",
"pano",
"vidro",
"fioeletronico",
}

function emp.GerarLixo()
	local source = source
	local user_id = vRP.getUserId(source)
	local quantidade = math.random(1,3)		
	local lixo = items[math.random(1,#items)]
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(lixo) <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,lixo,quantidade,true)
			return true
		else
			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.") 
			return false
		end
	end
end

function emp.GerarRecompensa(bonus)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local money = math.random(20000,25000)
        vRP.giveMoney(user_id,parseInt(money))
        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(money)).." dólares</b>.")
    end
end