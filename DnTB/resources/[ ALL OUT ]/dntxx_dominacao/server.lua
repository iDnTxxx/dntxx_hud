local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
dntxx = {}
Tunnel.bindInterface("dntxx_dominacao",dntxx)

-----------------------------------------------------------
-- CHECK USE
-----------------------------------------------------------
local locais = {
    -- DROGAS

    [1] = {  ['timer'] = 15 },
    [2] = {  ['timer'] = 15 },
    [3] = {  ['timer'] = 15 },
    [4] = {  ['timer'] = 15 },

    -- ARMAS

    [5] = {  ['timer'] = 15 },
    [6] = {  ['timer'] = 15 },
    [7] = {  ['timer'] = 15 },
    [8] = {  ['timer'] = 15 },

    [9] = {  ['timer'] = 15 },
    [10] = {  ['timer'] = 15 },
    [11] = {  ['timer'] = 15 },
    [12] = { ['timer'] = 15 },

    [13] = {  ['timer'] = 15 },
    [14] = {  ['timer'] = 15 },

}

function  dntxx.lootear(k)
    return (locais[k].timer <= 0)
end

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(locais) do
            if v.timer > 0 then
                v.timer = v.timer - 2
            end
        end
        Citizen.Wait(2000)
    end
end)

-----------------------------------------------------------
-- PERMISSAO
-----------------------------------------------------------
function  dntxx.permissao(perm)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then 
        if vRP.hasPermission(user_id, perm) then
            return true
        else
            return false
        end
    end            
end    
----------------------------------------------------------------
-- PAGAMENTO
----------------------------------------------------------------
function  dntxx.pagamento(perm,blip,k)

    local source = source
    local user_id = vRP.getUserId(source)
    local qtdDrogas = math.random(100,200)
    local qtdArmas = 20
    local qtdMunicao = 20
    local qtdLavagem = 20

    if user_id then 
        
        if perm == "drogas.permissao" and blip == 1 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lancaperfume")*qtdDrogas <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "lancaperfume", qtdDrogas)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end
        elseif perm == "drogas.permissao" and blip == 2 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lancaperfume")*qtdDrogas <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "lancaperfume", qtdDrogas)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end
        elseif perm == "drogas.permissao" and blip == 3 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lsd")*qtdDrogas <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "lsd", qtdDrogas)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end
                    elseif perm == "drogas.permissao" and blip == 4 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lsd")*qtdDrogas <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "lsd", qtdDrogas)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end
        elseif perm == "armas.permissao" and blip == 1 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("armacaodeak")*qtdArmas <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "armacaodeak", qtdArmas)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end
        elseif perm == "armas.permissao" and blip == 2 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("armacaodemp5")*qtdArmas <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "armacaodemp5", qtdArmas)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end
        elseif perm == "armas.permissao" and blip == 3 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("armacaodetec")*qtdArmas <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "armacaodetec", qtdArmas)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end 
        elseif perm == "armas.permissao" and blip == 4 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("armacaodeg3")*qtdArmas <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "armacaodeg3", qtdArmas)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end                 
        elseif perm == "municoes.permissao" and blip == 1 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("m-armacaotec")*qtdMunicao <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "m-armacaotec", qtdMunicao)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end 
        elseif perm == "municoes.permissao" and blip == 2 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("m-armacaog3")*qtdMunicao <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "m-armacaog3", qtdMunicao)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end               
        elseif perm == "municoes.permissao" and blip == 3 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("m-armacaomp5")*qtdMunicao <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "m-armacaomp5", qtdMunicao)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end            
        elseif perm == "municoes.permissao" and blip == 4 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("m-armacaoak")*qtdMunicao <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "m-armacaoak", qtdMunicao)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end            
        elseif perm == "lavagem.permissao" and blip == 1 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("alvejantepremium")*qtdLavagem <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "alvejantepremium", qtdLavagem)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end 
        elseif perm == "lavagem.permissao" and blip == 2 then
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("alvejantepremium")*qtdLavagem <= vRP.getInventoryMaxWeight(user_id) then
                locais[k].timer = 7200
                vRP.giveInventoryItem(user_id, "alvejantepremium", qtdLavagem)
            else
                TriggerClientEvent("Notify", source, "negado","Mochila Cheia!")
            end  
        end        
    end    
end
