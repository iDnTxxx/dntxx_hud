local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

DntxxCarteiro = Tunnel.getInterface("dntxx_carteiro")
vRP = Proxy.getInterface("vRP")
vRPclient = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local central = {78.83,112.08,81.17}
local garagem = {53.54,114.81,79.2}
local spawnStockade = {65.87,120.78,79.11, 140.99}
local descargaCentral = {1231.3,-3001.61,9.32}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS
-----------------------------------------------------------------------------------------------------------------------------------------
local rota = {
    [1] = {['x'] = 3.44, ['y'] = 36.79, ['z'] = 71.54},
    [2] = {['x'] = 435.71, ['y'] = 215.51, ['z'] = 103.17},
    [3] = {['x'] = 300.09, ['y'] = -232.28, ['z'] = 53.85},
    [4] = {['x'] = -424.85, ['y'] = 22.72, ['z'] = 46.27},
    [5] = {['x'] = -1041.76, ['y'] = 383.54, ['z'] = 69.7},
    [6] = {['x'] = -1405.66, ['y'] = 526.74, ['z'] = 123.84},
    [7] = {['x'] = -658.69, ['y'] = 887.35, ['z'] = 229.25},
    [8] = {['x'] = -475.08, ['y'] = 585.92, ['z'] = 128.69},
    [9] = {['x'] = 1394.44, ['y'] = 1152.76, ['z'] = 114.42},
    [10] = {['x'] = 1218.93, ['y'] = 1848.38, ['z'] = 78.96},
    [11] = {['x'] = 1367.32, ['y'] = -605.94, ['z'] = 74.72},
    [12] = {['x'] = 1331.98, ['y'] = -1642.44, ['z'] = 52.13},
    [13] = {['x'] = 791.15, ['y'] = -2191.72, ['z'] = 29.56},
    [14] = {['x'] = 23.4, ['y'] = -1896.49, ['z'] = 22.97},
    [15] = {['x'] = -148.6, ['y'] = -1688.31, ['z'] = 32.88},
    [16] = {['x'] = 323.83, ['y'] = -1990.74, ['z'] = 24.17},
    [17] = {['x'] = -1292.1, ['y'] = -1103.23, ['z'] = 6.92},
    [18] = {['x'] = -989.34, ['y'] = -1575.95, ['z'] = 5.18},
    [19] = {['x'] = -1180.2, ['y'] = -1777.11, ['z'] = 3.91},
    [20] = {['x'] = -1636.23, ['y'] = -1015.27, ['z'] = 13.13},
    [21] = {['x'] = -2205.29, ['y'] = -373.34, ['z'] = 13.33},
    [22] = {['x'] = -2963.73, ['y'] = 432.26, ['z'] = 15.28},
    [23] = {['x'] = -3077.55, ['y'] = 659.23, ['z'] = 11.64}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local trabalhando = false
local CarroSpawnado = false
local etapa = 0
local ComEncomendas = false
local PontoMarcado = false
local blip = false
local encomendas = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CÓDIGO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function() 
    while true do
        local dntxx = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if not trabalhando then 
            local DistCentral = Vdist2(x,y,z, central[1], central[2], central[3])
            if DistCentral <= 50 then    
                dntxx = 5            
                DrawMarker(21,central[1],central[2],central[3],0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                if DistCentral <= 1.5 then
                    dntxx = 4
                    DrawText3D(central[1],central[2],central[3],"~g~[E] ~w~PARA TRABALHAR")
                    if IsControlJustPressed(0,38) then
                        trabalhando = true
                        TriggerEvent("Notify","sucesso","Você <b>INICIOU</b> o emprego, pegue o caminhão.")
                    end
                end
            end
        elseif trabalhando and not CarroSpawnado then
            local DistGaragem = Vdist(x,y,z,garagem[1],garagem[2],garagem[3])
            if DistGaragem <= 15 then
                dntxx = 4
                DrawMarker(21,garagem[1],garagem[2],garagem[3],0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                if DistGaragem <= 1.5 then
                    dntxx = 4
                    DrawText3D(garagem[1],garagem[2],garagem[3],"~g~[E] ~w~PARA SOLICITAR CAMINHÃO")
                    if IsControlJustPressed(0,38) then
                        dntxx = 4
                        CarroSpawnado = true
                        SpawnStockade()
                        TriggerEvent("Notify","sucesso","Você <b>PEGOU</b> o caminhão, pegue as encomendas para entregar na central.")
                    end
                end
            end
        elseif trabalhando and CarroSpawnado then
            local xCar, yCar, zCar = table.unpack(GetEntityCoords(nveh))
            local DistCarro = Vdist2(x,y,z, xCar, yCar, zCar)
            if not ComEncomendas and not acabou then
                if not PontoMarcado then
                    PontoMarcado = math.random(#rota)
                    if not blip then
                        CriandoBlip(rota[PontoMarcado].x,rota[PontoMarcado].y,rota[PontoMarcado].z,207,2,0.4,"Retirada de encomendas")
                        vRPclient.playSound("CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
                        TriggerEvent("Notify","sucesso","Vá até o próximo ponto.")
                        blip = true
                    end
                else
                    local DistPonto = Vdist2(x,y,z,rota[PontoMarcado].x,rota[PontoMarcado].y,rota[PontoMarcado].z)
                    if DistPonto < 30 then
                        dntxx = 5
                        if blip then
                            RemoveBlip(blips)
                            blip = false
                        end
                        DrawMarker(21,rota[PontoMarcado].x,rota[PontoMarcado].y,rota[PontoMarcado].z,0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                        if DistPonto <= 1.5 then
                            dntxx = 5
                            DrawText3D(rota[PontoMarcado].x,rota[PontoMarcado].y,rota[PontoMarcado].z,"~g~[E] ~w~PARA COLETAR A ENCOMENDAS")
                            if IsControlJustPressed(0,38) then
                                dntxx = 4
                                ComEncomendas = true
                                vRP._CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
                                TriggerEvent("Notify","sucesso","Você <b>COLETOU</b> uma encomenda, deposite-a no caminhão.")
                            end
                        end
                    end
                end 
            elseif ComEncomendas and not acabou then
                if DistCarro < 30 then
                    DrawMarker(0,xCar,yCar,zCar+3.0,0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                    if DistCarro <= 3.5 then
                        dntxx = 4
                        DrawText3D(xCar,yCar,zCar,"~g~[E] ~w~PARA GUARDAR A ENCOMENDA")
                        if IsControlJustPressed(0,38) then
                            dntxx = 4
                            if encomendas + 1 < 8 then
                                encomendas = encomendas + 1
                                TriggerEvent("Notify", "importante","Encomendas guardadas: " .. encomendas .. "/8")
                                ComEncomendas = false
                                PontoMarcado = false
                            else
                                encomendas = encomendas + 1
                                ComEncomendas = false
                                acabou = true
                                TriggerEvent("Notify","sucesso","Vá até o <b>PORTO</b> para descarregar o caminhão.")
                                if not blip then
                                    CriandoBlip(descargaCentral[1],descargaCentral[2],descargaCentral[3],408,2,0.4,"Descarregamento de cargas")
                                    vRPclient.playSound("CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
                                    blip = true
                                end
                            end
                            ClearPedTasks(ped)
                            vRP.DeletarObjeto()
                        end
                    end
                end
            elseif acabou then
                if not ComEncomendas and not IsPedInAnyVehicle(ped) then 
                    if DistCarro < 100.0 then
                        dntxx = 5
                        DrawMarker(0,xCar,yCar,zCar+3.0,0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                        if DistCarro <= 3.5 then
                            dntxx = 4
                            DrawText3D(xCar,yCar,zCar,"~g~[E] ~w~PARA RETIRAR A EMCOMENDA")
                            if IsControlJustPressed(0,38) then
                                dntxx = 4
                                encomendas = encomendas - 1
                                TriggerEvent("Notify","aviso","Encomendas restantes: " .. encomendas .. "/8")
                                ComEncomendas = true
                                vRP._CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
                            end
                        end
                    end
                elseif ComEncomendas and not IsPedInAnyVehicle(ped) then
                    local DistDescarga = Vdist2(x,y,z,descargaCentral[1],descargaCentral[2],descargaCentral[3])
                    if DistDescarga < 30 then
                        dntxx = 5
                        DrawMarker(21,descargaCentral[1],descargaCentral[2],descargaCentral[3],0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                        if DistDescarga < 1.5 then
                            dntxx = 4
                            DrawText3D(descargaCentral[1],descargaCentral[2],descargaCentral[3],"~g~[E] ~w~PARA ENTREGAR A ENCOMENDA")
                            if IsControlJustPressed(0,38) then
                                dntxx = 4
                                if encomendas > 0 then
                                    TriggerEvent("Notify","importante","Você entregou uma encomenda, entregue as outras.")
                                else
                                    PontoMarcado = false
                                    acabou = false
                                    encomendas = 0
                                    if blip then
                                        blip = false
                                        RemoveBlip(blips)
                                    end
                                    TriggerEvent("Notify","sucesso","Você <b>FINALIZOU</b> o serviço, poderá continuar a rota.")
                                    -- GERAR PAGAMENTO
                                    DntxxCarteiro.GerarRecompensa()
                                end
                                ComEncomendas = false
                                ClearPedTasks(ped)
                                vRP.DeletarObjeto()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(dntxx)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR F6
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function() 
    while true do
        local dntxx = 500
        local ped = PlayerPedId()
        if trabalhando then
            dntxx = 4
            if IsControlJustPressed(0,168) then
                dntxx = 4
                trabalhando = false
                etapa = 0
                ComEncomendas = false
                encomendas = 0
                PontoMarcado = false
                if CarroSpawnado then
                    deleteCar(nveh)
                    CarroSpawnado = false
                end
                if blip then
                    blip = false
                    RemoveBlip(blips)
                end
                ClearPedTasks(ped)
                vRP.DeletarObjeto()
                TriggerEvent("Notify","aviso","Você cancelou o serviço.")
            end
        end
        Citizen.Wait(dntxx)
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function SpawnStockade()
    local mhash = GetHashKey('boxville4')
    modelRequest('boxville4')
    nveh = CreateVehicle(mhash,spawnStockade[1], spawnStockade[2], spawnStockade[3], spawnStockade[4],true,false)
    SetVehicleHasBeenOwnedByPlayer(nveh,true)
    SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
    SetVehicleOnGroundProperly(nveh)
    SetEntityAsMissionEntity(nveh,true,true)
    SetModelAsNoLongerNeeded(mhash)
end

function CriandoBlip(x,y,z, sprite, colour, scale, texto)
	blips = AddBlipForCoord(x,y,z)
	SetBlipSprite(blips,sprite)
	SetBlipColour(blips,colour)
	SetBlipScale(blips,scale)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(texto)
	EndTextCommandSetBlipName(blips)
end

function loaddict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function DrawText3D(x,y,z, text, r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.35, 0.35)
        SetTextColour(r, g, b, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 55, 55, 55, 68)
    end
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function modelRequest(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(10)
	end
end