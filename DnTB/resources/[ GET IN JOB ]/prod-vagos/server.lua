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
Tunnel.bindInterface("prod-vagos",farM)
-----------------------------------------------------------------------------------------------------------------------------------
-- PRODUZIR FOLHA
-----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("proc-folha")
AddEventHandler("proc-folha", function()
    local source = source
    local user_id = vRP.getUserId(source)

    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("pastadecoca") <= vRP.getInventoryMaxWeight(user_id) then
        if vRP.tryGetInventoryItem(user_id,"folhadecoca",1) then
            
            TriggerClientEvent("progress",source,10000)
            vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

            SetTimeout(10000,function()
                vRPclient._stopAnim(source,false)
                vRP.giveInventoryItem(user_id,"pastadecoca",3)
                TriggerClientEvent("Notify",source,"sucesso","Você produziu <b>Pastas de Coca</b>.")
            end)
        else
            TriggerClientEvent("Notify",source,"negado","Você não tem <b>Folhas de Coca</b> na mochila.")
        end
    else
        TriggerClientEvent("Notify",source,"negado","<b>Inventário cheio</b>.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------
-- PRODUZIR COCA
-----------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("proc-coca")
AddEventHandler("proc-coca", function()
    local source = source
    local user_id = vRP.getUserId(source)

    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("cocaina") <= vRP.getInventoryMaxWeight(user_id) then
        if vRP.tryGetInventoryItem(user_id,"pastadecoca",1) then
            
            TriggerClientEvent("progress",source,10000)
            vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)

            SetTimeout(10000,function()
                vRPclient._stopAnim(source,false)
                vRP.giveInventoryItem(user_id,"cocaina",3)
                TriggerClientEvent("Notify",source,"sucesso","Você produziu <b>Cocaina</b>.")
            end)
        else
            TriggerClientEvent("Notify",source,"negado","Você não tem <b>Pastas de Coca</b> na mochila.")
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
    if vRP.hasPermission(user_id,"vagos.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        return true
    end
end