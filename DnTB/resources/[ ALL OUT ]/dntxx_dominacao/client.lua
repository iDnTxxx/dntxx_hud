local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
dntxx = Tunnel.getInterface("dntxx_dominacao",dntxx)

-------------------------------------------------------------
-- VARIAVEIS
-------------------------------------------------------------
local segundos = 0 
local pegando = false 

-------------------------------------------------------------
-- COORDENADAS
-------------------------------------------------------------
local locais = {
    -- DROGAS

    [1] = { ['x'] = 1486.11, ['y'] = 1132.07, ['z'] = 114.34, ['perm'] = "drogas.permissao", ['blip'] = 1},
    [2] = { ['x'] = 1419.14, ['y'] = 1089.14, ['z'] = 114.33, ['perm'] = "drogas.permissao", ['blip'] = 2},
    [3] = { ['x'] = 1469.96, ['y'] = 1134.51, ['z'] = 114.33, ['perm'] = "drogas.permissao", ['blip'] = 3},
    [4] = { ['x'] = 1460.0, ['y'] = 1086.62, ['z'] = 114.34, ['perm'] = "drogas.permissao", ['blip'] = 4},

    -- ARMAS

    [5] = { ['x'] = 2670.21, ['y'] = 1612.72, ['z'] = 24.51, ['perm'] = "armas.permissao", ['blip'] = 1},
    [6] = { ['x'] = 2748.35, ['y'] = 1453.75, ['z'] = 24.5, ['perm'] = "armas.permissao", ['blip'] = 2},
    [7] = { ['x'] = 2723.84, ['y'] = 1510.84, ['z'] = 44.56, ['perm'] = "armas.permissao", ['blip'] = 3},
    [8] = { ['x'] = 2658.49, ['y'] = 1376.58, ['z'] = 24.06, ['perm'] = "armas.permissao", ['blip'] = 4},

    -- MUNICAO

    [9] = { ['x'] = 65.08, ['y'] = 3713.54, ['z'] = 39.76, ['perm'] = "municoes.permissao", ['blip'] = 1},
    [10] = { ['x'] = 118.03, ['y'] = 3700.07, ['z'] = 39.76, ['perm'] = "municoes.permissao", ['blip'] = 2},
    [11] = { ['x'] = 13.14, ['y'] = 3732.46, ['z'] = 39.68, ['perm'] = "municoes.permissao", ['blip'] = 3},
    [12] = { ['x'] = 65.41, ['y'] = 3606.59, ['z'] = 39.83, ['perm'] = "municoes.permissao", ['blip'] = 4},

    -- LAVAGEM
    
    [13] = { ['x'] = 2491.31, ['y'] = 3761.36, ['z'] = 42.26, ['perm'] = "lavagem.permissao", ['blip'] = 1},
    [14] = { ['x'] = 2482.49, ['y'] = 3722.35, ['z'] = 43.93, ['perm'] = "lavagem.permissao", ['blip'] = 2},

}

Citizen.CreateThread(function()
    while true do
        local timeDistance = 1000
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        for k,v in pairs(locais) do
            local dist = GetDistanceBetweenCoords(v.x, v.y, v.z, x, y, z, true)
            if dist <= 15 and not pegando then
                timeDistance = 4
                DrawMarker(23,v.x,v.y,v.z-1,0,0,0,0.0,0,0,1.5,1.5,1.5,255,0,0,50,0,0,0,1)
                if IsControlJustPressed(0, 38) and dntxx.permissao(v.perm) and dist <= 1 then
                    if dntxx.lootear(k) then
                        pegando = true 
                        TriggerEvent('cancelando',true)
                        FreezeEntityPosition(ped, true)
                        vRP._playAnim(false,{{"anim@heists@ornate_bank@grab_cash_heels","grab"}},true)
                        TriggerEvent("progress", 13000, "pegando")
                        SetTimeout(13000, function()
                            FreezeEntityPosition(ped, false)
                            vRP._stopAnim(false)
                            dntxx.pagamento(v.perm,v.blip,k)
                            TriggerEvent('cancelando',false)
                            pegando = false
                        end)
                    else
                        TriggerEvent("Notify","negado","Já coletaram o farm!")
                    end            
                end    
            end    
        end
        Citizen.Wait(timeDistance)
    end    
end) 

