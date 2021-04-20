-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("muni-producao",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRAY
-----------------------------------------------------------------------------------------------------------------------------------------
local municoes = {
	{ item = "m-ak103" },
	{ item = "m-five" },
	{ item = "m-tec9" },
    { item = "m-mp5mk2" },
    { item = "mshot" },
    { item = "m-g36c" } 
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAIN MENU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("produzir-municao")
AddEventHandler("produzir-municao",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(municoes) do
			if item == v.item then
				if item == "m-ak103" then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|WEAPON_ASSAULTRIFLE_MK2") <= vRP.getInventoryMaxWeight(user_id) then
                        if vRP.tryGetInventoryItem(user_id,"m-armacaoak",40) then
                                    TriggerClientEvent("fechar-nui-municoes",source)

                                    TriggerClientEvent("progress",source,10000,"FABRICANDO")
                                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

                                    SetTimeout(10000,function()
                                        vRPclient._stopAnim(source,false)
                                        vRP.giveInventoryItem(user_id,"wammo|WEAPON_ASSAULTRIFLE_MK2",70)
                                    end)
                                else
                                    TriggerClientEvent("Notify",source,"negado","Você precisa <b>40x ArmaçãoAk</b>.")
                               end
                           else
                               TriggerClientEvent("Notify",source,"negado","Espaço insuficiente na mochila.")
                       end
                elseif item == "m-mp5mk2" then
                    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|WEAPON_SMG_MK2") <= vRP.getInventoryMaxWeight(user_id) then
                        if vRP.tryGetInventoryItem(user_id,"m-armacaomp5",40) then
                                    TriggerClientEvent("fechar-nui-municoes",source)

                                    TriggerClientEvent("progress",source,10000,"FABRICANDO")
                                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

                                    SetTimeout(10000,function()
                                        vRPclient._stopAnim(source,false)
                                        vRP.giveInventoryItem(user_id,"wammo|WEAPON_SMG_MK2",70)
                                    end)
                                else
                                    TriggerClientEvent("Notify",source,"negado","Você precisa <b>40x ArmaçãoMp5</b>.")
                               end
                           else
                               TriggerClientEvent("Notify",source,"negado","Espaço insuficiente na mochila.")
                       end
                elseif item == "m-tec9" then
                    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|WEAPON_MACHINEPISTOL") <= vRP.getInventoryMaxWeight(user_id) then
                        if vRP.tryGetInventoryItem(user_id,"m-armacaotec",40) then
                                    TriggerClientEvent("fechar-nui-municoes",source)

                                    TriggerClientEvent("progress",source,10000,"FABRICANDO")
                                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

                                    SetTimeout(10000,function()
                                        vRPclient._stopAnim(source,false)
                                        vRP.giveInventoryItem(user_id,"wammo|WEAPON_MACHINEPISTOL",70)
                                    end)
                             else
                                 TriggerClientEvent("Notify",source,"negado","Você precisa <b>40x ArmaçãoTec</b>.")
                            end
                        else
                            TriggerClientEvent("Notify",source,"negado","Espaço insuficiente na mochila.")
                    end
                elseif item == "m-five" then
                    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|WEAPON_PISTOL_MK2") <= vRP.getInventoryMaxWeight(user_id) then
                        if vRP.getInventoryItemAmount(user_id,"capsulas") >= 60 then
                            if vRP.getInventoryItemAmount(user_id,"polvora") >= 40 then  
                                if vRP.tryGetInventoryItem(user_id,"capsulas",60) and vRP.tryGetInventoryItem(user_id,"polvora",40) then
                                    TriggerClientEvent("fechar-nui-municoes",source)

                                    TriggerClientEvent("progress",source,10000,"FABRICANDO")
                                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

                                    SetTimeout(10000,function()
                                        vRPclient._stopAnim(source,false)
                                        vRP.giveInventoryItem(user_id,"wammo|WEAPON_PISTOL_MK2",70)
                                    end)
                                end
                            else
                                TriggerClientEvent("Notify",source,"negado","Você precisa <b>40x Polvoras</b>.")
                            end
                        else
                            TriggerClientEvent("Notify",source,"negado","Você precisa <b>60x Capsulas</b>.")
                        end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente na mochila.")
                    end
                elseif item == "mshot" then
                    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|WEAPON_SAWNOFFSHOTGUN") <= vRP.getInventoryMaxWeight(user_id) then
                        if vRP.getInventoryItemAmount(user_id,"capsulas") >= 60 then
                            if vRP.getInventoryItemAmount(user_id,"polvora") >= 40 then  
                                if vRP.tryGetInventoryItem(user_id,"capsulas",60) and vRP.tryGetInventoryItem(user_id,"polvora",40) then
                                    TriggerClientEvent("fechar-nui-municoes",source)

                                    TriggerClientEvent("progress",source,10000,"FABRICANDO")
                                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

                                    SetTimeout(10000,function()
                                        vRPclient._stopAnim(source,false)
                                        vRP.giveInventoryItem(user_id,"wammo|WEAPON_SAWNOFFSHOTGUN",70)
                                    end)
                                end
                            else
                                TriggerClientEvent("Notify",source,"negado","Você precisa <b>40x Polvoras</b>.")
                            end
                        else
                            TriggerClientEvent("Notify",source,"negado","Você precisa <b>60x Capsulas</b>.")
                        end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente na mochila.")
                    end
                elseif item == "m-g36c" then
                    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wammo|WEAPON_SPECIALCARBINE_MK2") <= vRP.getInventoryMaxWeight(user_id) then
                        if vRP.tryGetInventoryItem(user_id,"m-armacaog3",40) then
                                    TriggerClientEvent("fechar-nui-municoes",source)

                                    TriggerClientEvent("progress",source,10000,"FABRICANDO")
                                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

                                    SetTimeout(10000,function()
                                        vRPclient._stopAnim(source,false)
                                        vRP.giveInventoryItem(user_id,"wammo|WEAPON_SPECIALCARBINE_MK2",70)
                                    end)
                        else
                            TriggerClientEvent("Notify",source,"negado","Você precisa <b>40x Armaçãog3</b>.")
                        end
					else
						TriggerClientEvent("Notify",source,"negado","Espaço insuficiente na mochila.")
                    end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"mafia.permissao") or vRP.hasPermission(user_id,"brt.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        return true
    end
end