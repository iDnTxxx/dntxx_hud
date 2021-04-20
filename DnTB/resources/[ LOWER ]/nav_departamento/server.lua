-----------------------------------------------------------------------------------------------------------------------------------------
--[ VRP ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
	{ item = "celular", quantidade = 1, compra = 2500 },
	{ item = "radio", quantidade = 1, compra = 1000 },
	{ item = "roupas", quantidade = 1, compra = 5000 },
	{ item = "mochila", quantidade = 1, compra = 10000 },
	{ item = "alianca", quantidade = 1, compra = 300 },

	{ item = "militec", quantidade = 1, compra = 4000 },
	{ item = "pneus", quantidade = 1, compra = 1000 },
	{ item = "repairkit", quantidade = 1, compra = 6500 }, 
	{ item = "serra", quantidade = 1, compra = 10000 },
	{ item = "furadeira", quantidade = 1, compra = 10000 },

	{ item = "cerveja", quantidade = 3, compra = 18 },
	{ item = "vodka", quantidade = 3, compra = 48 },
	{ item = "tequila", quantidade = 3, compra = 30 },
	{ item = "whisky", quantidade = 3, compra = 60 },
	{ item = "conhaque", quantidade = 3, compra = 72 },
	{ item = "absinto", quantidade = 3, compra = 90 },
	{ item = "energetico", quantidade = 3, compra = 3500 },
	{ item = "garrafavazia", quantidade = 3, compra = 600 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
--[ COMPRAR ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("departamento-comprar")
AddEventHandler("departamento-comprar",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
					if vRP.tryPayment(user_id,parseInt(v.compra)) then
						vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
						--TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(v.compra)).." dólares</b>.")
					else
						TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
				end
			end
		end
	end
end)