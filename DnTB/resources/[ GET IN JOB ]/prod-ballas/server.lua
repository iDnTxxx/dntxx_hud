-----------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------
farM = {}
Tunnel.bindInterface("prod-ballas",farM)
-----------------------------------------------------------------------------------------------------------------------------------
-- PRODUZIR FERTILIZANTE
-----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("proc-adubo")
AddEventHandler("proc-adubo", function()
    local source = source
    local user_id = vRP.getUserId(source)

    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("fertilizante") <= vRP.getInventoryMaxWeight(user_id) then
        if vRP.tryGetInventoryItem(user_id,"adubo",1) then
            
            TriggerClientEvent("progress",source,10000)
            vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

            SetTimeout(10000,function()
                vRPclient._stopAnim(source,false)
                vRP.giveInventoryItem(user_id,"fertilizante",3)
                TriggerClientEvent("Notify",source,"sucesso","Você produziu <b>Fertilizantes</b>.")
            end)
        else
            TriggerClientEvent("Notify",source,"negado","Você não tem <b>Adubo</b> na mochila.")
        end
    else
        TriggerClientEvent("Notify",source,"negado","<b>Inventário cheio</b>.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------
-- PRODUZIR MACONHA
-----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("proc-ferti")
AddEventHandler("proc-ferti", function()
    local source = source
    local user_id = vRP.getUserId(source)

    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("maconha") <= vRP.getInventoryMaxWeight(user_id) then
        if vRP.tryGetInventoryItem(user_id,"fertilizante",3) then
            
            TriggerClientEvent("progress",source,10000)
            vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

            SetTimeout(10000,function()
                vRPclient._stopAnim(source,false)
                vRP.giveInventoryItem(user_id,"maconha",3)
                TriggerClientEvent("Notify",source,"sucesso","Você produziu <b>Maconha</b>.")
            end)
        else
            TriggerClientEvent("Notify",source,"negado","Você não tem <b>Fertilizante</b> na mochila.")
        end
    else
        TriggerClientEvent("Notify",source,"negado","<b>Inventário cheio</b>.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO DE PERMISSÃO
-----------------------------------------------------------------------------------------------------------------------------------
function farM.checkPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ballas.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        return true
    end
end