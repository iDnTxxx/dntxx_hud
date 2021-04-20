-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
DntxxStockade = Tunnel.getInterface("dntxx_stockade")
vRP = Proxy.getInterface("vRP")
vRPclient = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local central = {223.84, 121.39, 102.78}
local garagem = {225.7, 129.2, 103.41}
local spawnStockade = {233.13, 119.96, 102.61, 340.99}
local descargaCentral = {241.41, 225.38, 106.29}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS
-----------------------------------------------------------------------------------------------------------------------------------------
local rota = {
    [1] = {['x'] = 89.57, ['y'] = 2.16, ['z'] = 68.32},
    [2] = {['x'] = -526.49, ['y'] = -1222.79, ['z'] = 18.45},
    [3] = {['x'] = -2072.48, ['y'] = -317.19, ['z'] = 13.31},
    [4] = {['x'] = -821.56, ['y'] = -1081.90, ['z'] = 11.13},
    [5] = {['x'] = 380.89,  ['y'] = 323.68, ['z'] = 103.57},
    [6] = {['x'] = -717.46,  ['y'] = -915.68,  ['z'] = 19.22},
    [7] = {['x'] = 119.35,  ['y'] = -883.78,  ['z'] = 31.13},
    [8] = {['x'] = 2558.85, ['y'] = 351.04, ['z'] = 108.62},
    [9] = {['x'] = 1153.75, ['y'] = -326.80, ['z'] = 69.20},
    [10] = {['x'] = -56.91, ['y'] = -1752.17, ['z'] = 29.42},
    [11] = {['x'] = -3241.02, ['y'] = 997.58, ['z'] = 12.55},
    [12] = {['x'] = -1827.18, ['y'] = 784.90, ['z'] = 138.30},
    [13] = {['x'] = -1211.73, ['y'] = -335.77,  ['z'] = 37.8},
    [14] = {['x'] = 112.45, ['y'] = -819.25, ['z'] = 31.33},
    [15] = {['x'] = -256.17, ['y'] = -716.03, ['z'] = 33.52},
    [16] = {['x'] = -2957.69,  ['y'] = 481.25,  ['z'] = 15.71},
    [17] = {['x'] = -660.72, ['y'] = -853.97, ['z'] = 24.48},
    [18] = {['x'] = -712.89, ['y'] = -819.29, ['z'] = 23.73},
    [19] = {['x'] = -1109.45, ['y'] = -1690.5, ['z'] = 4.38},
    [20] = {['x'] = 228.34, ['y'] = 338.82, ['z'] = 105.56},
    [21] = {['x'] = 158.57, ['y'] = 234.1, ['z'] = 106.63},
    [22] = {['x'] = -1305.04, ['y'] = -706.14, ['z'] = 25.33},
    [23] = {['x'] = -1315.12, ['y'] = -836.18, ['z'] = 16.97},
    [24] = {['x'] = -3143.96, ['y'] = 1127.45, ['z'] = 20.86},
    [25] = {['x'] = -2544.14, ['y'] = 2316.28, ['z'] = 33.22}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local trabalhando = false
local CarroSpawnado = false
local etapa = 0
local ComMaleta = false
local PontoMarcado = false
local blip = false
local nveh = nil
local maletas = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CÓDIGO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function() 
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if not trabalhando then 
            local DistCentral = Vdist2(x,y,z,central[1],central[2],central[3])
            if DistCentral <= 15 then
                timeDistance = 4
                DrawMarker(21,central[1],central[2],central[3],0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                timeDistance = 4
                if DistCentral <= 1.5 then
                    timeDistance = 4
                    DrawText3D(central[1], central[2], central[3], '~g~[E] ~w~PARA TRABALHAR')
                    if IsControlJustPressed(0,38) then
                        timeDistance = 4
                        trabalhando = true
                        TriggerEvent('Notify','sucesso','Você <b>INICIOU</b> o serviço, pegue o caminhão ao lado.')
                        ClearPedTasks(ped)
                    end
                end
            end
        elseif trabalhando and not CarroSpawnado then
            local DistGaragem = Vdist(x,y,z, garagem[1], garagem[2], garagem[3])
            if DistGaragem <= 15 then
                timeDistance = 4
                DrawMarker(21,garagem[1],garagem[2],garagem[3],0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                if DistGaragem <= 1.5 then
                    timeDistance = 4
                    DrawText3D(garagem[1],garagem[2],garagem[3],'~g~[E] ~w~PARA SOLICITAR CAMINHÃO')
                    if IsControlJustPressed(0,38) then
                        timeDistance = 4
                        CarroSpawnado = true
                        SpawnStockade()
                    end
                end
            end
        elseif trabalhando and CarroSpawnado then
            local xCar, yCar, zCar = table.unpack(GetEntityCoords(nveh))
            local DistCarro = Vdist2(x,y,z, xCar, yCar, zCar)
            if not ComMaleta and not acabou then
                if not PontoMarcado then
                    PontoMarcado = math.random(#rota)
                    if not blip then
                        CriandoBlip(rota[PontoMarcado].x, rota[PontoMarcado].y, rota[PontoMarcado].z,207,5,0.4,'Retirada de maleta')
                        vRPclient.playSound("CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
                        TriggerEvent('Notify','sucesso','Vá até o próximo ponto.')
                        blip = true
                    end
                else
                    local DistPonto = Vdist2(x,y,z, rota[PontoMarcado].x, rota[PontoMarcado].y, rota[PontoMarcado].z)
                    if DistPonto < 15 then
                        timeDistance = 4
                        if blip then
                            RemoveBlip(blips)
                            blip = false
                        end
                        DrawMarker(21, rota[PontoMarcado].x, rota[PontoMarcado].y, rota[PontoMarcado].z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255,255,255,150, 1, 0, 0, 1)
                        if DistPonto <= 1.5 then
                            timeDistance = 4
                            DrawText3D(rota[PontoMarcado].x, rota[PontoMarcado].y, rota[PontoMarcado].z, '~g~[E] ~w~PARA COLETAR A MALETA')
                            if IsControlJustPressed(0,38) then
                                timeDistance = 4
                                ComMaleta = true
                                vRP.CarregarObjeto("","","prop_security_case_01",50,57005,0.16, 0, -0.01, 0, 260.0, 60.0)
                                TriggerEvent('Notify','sucesso','Você <b>COLETOU</b> uma maleta, deposite-a no caminhão.')
                            end
                        end
                    end
                end 
            elseif ComMaleta and not acabou then
                if DistCarro < 30 then
                    timeDistance = 4
                    DrawMarker(0, xCar, yCar, zCar+3.0, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255,255,255,150, 1, 0, 0, 1)
                    if DistCarro <= 3.5 then
                        timeDistance = 4
                        DrawText3D(xCar, yCar, zCar, '~g~[E] ~w~PARA GUARDAR A MALETA')
                        if IsControlJustPressed(0,38) then
                            timeDistance = 4
                            if maletas + 1 < 8 then
                                maletas = maletas + 1
                                TriggerEvent('Notify','importante','Maletas guardadas: ' .. maletas .. '/8')
                                ComMaleta = false
                                PontoMarcado = false
                            else
                                maletas = maletas + 1
                                ComMaleta = false
                                acabou = true
                                TriggerEvent('Notify','sucesso','Vá até o <b>BANCO CENTRAL</b> para descarregar o caminhão.')
                                if not blip then
                                    CriandoBlip(descargaCentral[1], descargaCentral[2], descargaCentral[3],408,5,0.4,'Descarregamento de malotes')
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
                if not ComMaleta and not IsPedInAnyVehicle(ped) then 
                    if DistCarro < 30 then
                        timeDistance = 4
                        DrawMarker(0, xCar, yCar, zCar+3.0, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255,255,255,150, 1, 0, 0, 1)
                        if DistCarro <= 3.5 then
                            timeDistance = 4
                            DrawText3D(xCar, yCar, zCar, '~g~[E] ~w~PARA RETIRAR A MALETA')
                            if IsControlJustPressed(0,38) then
                                timeDistance = 4
                                maletas = maletas - 1
                                TriggerEvent('Notify','aviso','Maletas restantes: ' .. maletas .. '/8')
                                ComMaleta = true
                                vRP.CarregarObjeto("","","prop_security_case_01",50,57005,0.16, 0, -0.01, 0, 260.0, 60.0)
                            end
                        end
                    end
                elseif ComMaleta and not IsPedInAnyVehicle(ped) then
                    local DistDescarga = Vdist2(x,y,z, descargaCentral[1], descargaCentral[2], descargaCentral[3])
                    if DistDescarga < 30 then
                        timeDistance = 4
                        DrawMarker(21, descargaCentral[1], descargaCentral[2], descargaCentral[3], 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255,255,255,150, 1, 0, 0, 1)
                        if DistDescarga < 1.5 then
                            timeDistance = 4
                            DrawText3D(descargaCentral[1], descargaCentral[2], descargaCentral[3], '~g~[E] ~w~PARA ENTREGAR A MALETA')
                            if IsControlJustPressed(0,38) then
                                timeDistance = 4
                                if maletas > 0 then
                                    TriggerEvent('Notify','importante','Você entregou uma maleta, entregue as outras.')
                                else
                                    PontoMarcado = false
                                    acabou = false
                                    maletas = 0
                                    if blip then
                                        blip = false
                                        RemoveBlip(blips)
                                    end
                                    TriggerEvent('Notify','sucesso','Você <b>FINALIZOU</b> o serviço, poderá continuar a rota.')
                                    -- GERAR PAGAMENTO
                                    DntxxStockade.gerarRecompensa()
                                end
                                ComMaleta = false
                                ClearPedTasks(ped)
                                vRP.DeletarObjeto()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR F6
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function() 
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        if trabalhando then
            timeDistance = 4
            if IsControlJustPressed(0,168) then
                timeDistance = 4
                trabalhando = false
                etapa = 0
                ComMaleta = false
                maletas = 0
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
                TriggerEvent('Notify', 'aviso', 'Você cancelou o serviço.')
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function SpawnStockade()
    local mhash = GetHashKey('stockade')
    modelRequest('stockade')
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