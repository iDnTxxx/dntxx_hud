local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("dntxx_alvejante",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUANTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(1,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSAO
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"bahamas.permissao") or vRP.hasPermission(user_id,"lifeinvader.permissao")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAGAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(payment)
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("agua")*quantidade[source]+vRP.getItemWeight("detergenteneutro")*quantidade[source]+vRP.getItemWeight("bicarbonatodesodio")*quantidade[source]+vRP.getItemWeight("vinagre")*quantidade[source] <= vRP.getInventoryMaxWeight(user_id) then
		vRP.giveInventoryItem(user_id,"detergenteneutro",quantidade[source]) 
		vRP.giveInventoryItem(user_id,"agua",quantidade[source]) 
		vRP.giveInventoryItem(user_id,"bicarbonatodesodio",quantidade[source]) 
		vRP.giveInventoryItem(user_id,"vinagre",quantidade[source]) 
		quantidade[source] = nil
		return true
		end
	end
end