local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
oC = {}
Tunnel.bindInterface("prod_alvejantes",oC)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local alveja = {
	{ item = "alvejantecaseiro" },
}
-----------------------------------------------------------------------------------------------------------------------------------
--[ EVENTOS ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("produzir-alveja")
AddEventHandler("produzir-alveja",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(alveja) do
			if item == v.item then
				if item == "alvejantecaseiro" then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("alvejantecaseiro") <= vRP.getInventoryMaxWeight(user_id) then
                        if vRP.getInventoryItemAmount(user_id,"agua") >= 10 then
                            if vRP.getInventoryItemAmount(user_id,"vinagre") >= 10 then
                                if vRP.getInventoryItemAmount(user_id,"bicarbonatodesodio") >= 10 then
                                    if vRP.getInventoryItemAmount(user_id,"detergenteneutro") >= 10 then
                                        if vRP.tryGetInventoryItem(user_id,"agua",10) and vRP.tryGetInventoryItem(user_id,"vinagre",10) and vRP.tryGetInventoryItem(user_id,"bicarbonatodesodio",10) and vRP.tryGetInventoryItem(user_id,"detergenteneutro",10) then
                                            TriggerClientEvent("fechar-nui-alveja",source)

                                            TriggerClientEvent("progress",source,10000,"Montando Alvejante")
                                            TriggerClientEvent("bancadaalveja:posicao",source)
                                            vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

                                            SetTimeout(10000,function()
                                                vRPclient._stopAnim(source,false)
                                                vRP.giveInventoryItem(user_id,"alvejantecaseiro",5)
                                                TriggerClientEvent("Notify",source,"sucesso","Você montou <b>Alvejantes Caseiros</b>.")
                                            end)
                                        end
                                    else
                                        TriggerClientEvent("Notify",source,"negado","Você não tem <b>detergente neutro</b> na mochila.")
                                    end
                                else
                                    TriggerClientEvent("Notify",source,"negado","Você precisa de <b>bicarbonato de sódio</b>.")
                                end
                            else
                                TriggerClientEvent("Notify",source,"negado","Você precisa de <b>vinagre</b>.")
                            end
                        else
                            TriggerClientEvent("Notify",source,"negado","Você não tem <b>água</b> na mochila.")
                        end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente na mochila.")
                    end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------
--[ FUNÇÃO DE PERMISSÃO ]----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
function oC.checkPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"bahamas.permissao") or vRP.hasPermission(user_id,"lifeinvader.permissao") then
        return true
    end
end