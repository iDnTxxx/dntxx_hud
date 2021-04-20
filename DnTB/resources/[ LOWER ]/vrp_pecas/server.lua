-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_pecas",src)
vCLIENT = Tunnel.getInterface("vrp_pecas")
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local utilidades = {
	["couro"] = { ['price'] = 470 },
	["farol"] = { ['price'] = 441 },
	["pneus"] = { ['price'] = 749 },
	["carpete"] = { ['price'] = 219 },
	["bancos"] = { ['price'] = 449 },
	["molas"] = { ['price'] = 49 },
	["escapamento"] = { ['price'] = 1541 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PECASLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.pecasList()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local itemlist = {}
		for k,v in pairs(utilidades) do
			table.insert(itemlist,{ index = k, name = vRP.itemNameList(k), price = parseInt(v.price) })
		end
		return itemlist
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPSELL
-----------------------------------------------------------------------------------------------------------------------------------------
function src.shopSell(index,price,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,index,parseInt(amount)) then
			vRP.giveMoney(user_id,parseInt(price))
			TriggerClientEvent("Notify",source,"sucesso","Vendeu <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(index).."</b> por <b>$"..vRP.format(parseInt(price*amount)).." dólares</b>.")
		else
			TriggerClientEvent("Notify",source,"negado","Não possui <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(index).."</b> em sua mochila.")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSEARCH
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkSearch()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			return true
		end
		return false
	end
end