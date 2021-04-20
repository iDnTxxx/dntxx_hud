-----------------------------------------------------------------------------------------------------------------------------------------
--[ DISPATCH ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for i = 1,120 do
		EnableDispatchService(i,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DESABILITAR X NA MOTO ]--------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			if GetPedInVehicleSeat(vehicle,0) == ped and GetVehicleClass(vehicle) == 8 then
				DisableControlAction(0,73,true) 
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DESABILITAR A CORONHADA ]------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        if IsPedArmed(ped,6) then
            DisableControlAction(0,140,true)
            DisableControlAction(0,141,true)
            DisableControlAction(0,142,true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ REMOVER ARMA ABAIXO DE 40MPH DENTRO DO CARRO ]---------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            -- BLOQUEIA QUALQUER ARMA DE ATIRAR
            SetPlayerCanDoDriveBy(PlayerId(),false)

            local vehicle = GetVehiclePedIsIn(ped)
            local speed = GetEntitySpeed(vehicle)*3.6

            -- CONDIÇÃO P2
            if GetPedInVehicleSeat(vehicle,0) == ped then
                if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_STUNGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
                    SetPlayerCanDoDriveBy(PlayerId(),true)
                end
            elseif GetPedInVehicleSeat(vehicle,-1) == ped then
                if speed <= 70 then
                    if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_STUNGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
                        SetPlayerCanDoDriveBy(PlayerId(),true)
                    end
                end
            else
                if IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("policiaheli")) then
                    SetPlayerCanDoDriveBy(PlayerId(),true)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- [ ERRO DE TANKAR HS ]-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(4)

        SetPedSuffersCriticalHits(PlayerPedId(-1), true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- [ REMOVER O Q ]-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health >= 101 then
        DisableControlAction(0,44,true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ STAMINA FULL ]------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	while true do
	  Citizen.Wait(0)
	  RestorePlayerStamina(PlayerId(), 1.0)
	end
  end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- [ STATUS DO DISCORD ] ----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        SetDiscordAppId("801136116941586503")
        SetDiscordRichPresenceAsset('ronaldinho')
        SetDiscordRichPresenceAssetText('Dev | Server')
        SetDiscordRichPresenceAssetSmallText('Server de desenvolvimento')
        SetDiscordRichPresenceAction(0, '', '')
        SetDiscordRichPresenceAction(1, 'Xvideos', 'https://www.xvideos.com')
        SetRichPresence("Framework")
        Citizen.Wait(8000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ESTOURAR OS PNEUS ]------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            if GetPedInVehicleSeat(vehicle,-1) == ped then
                local speed = GetEntitySpeed(vehicle)*2.236936
                if speed >= 180 and math.random(100) >= 97 then
                    if GetVehicleTyresCanBurst(vehicle) == false then return end
                    local pneus = GetVehicleNumberOfWheels(vehicle)
                    local pneusEffects
                    if pneus == 2 then
                        pneusEffects = (math.random(2)-1)*4
                    elseif pneus == 4 then
                        pneusEffects = (math.random(4)-1)
                        if pneusEffects > 1 then
                            pneusEffects = pneusEffects + 2
                        end
                    elseif pneus == 6 then
                        pneusEffects = (math.random(6)-1)
                    else
                        pneusEffects = 0
                    end
                    SetVehicleTyreBurst(vehicle,pneusEffects,false,1000.0)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ROUBAR F ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local disableShuffle = true
function disableSeatShuffle(flag)
    disableShuffle = flag
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
                if GetIsTaskActive(GetPlayerPed(-1), 165) then
                    SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DRIFT ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsPedInAnyVehicle(ped) then
			local speed = GetEntitySpeed(vehicle)*2.236936
			if GetPedInVehicleSeat(vehicle,-1) == ped 
				and (GetEntityModel(vehicle) ~= GetHashKey("coach") 
					and GetEntityModel(vehicle) ~= GetHashKey("bus") 
					and GetEntityModel(vehicle) ~= GetHashKey("youga2") 
					and GetEntityModel(vehicle) ~= GetHashKey("ratloader") 
					and GetEntityModel(vehicle) ~= GetHashKey("taxi") 
					and GetEntityModel(vehicle) ~= GetHashKey("boxville4") 
					and GetEntityModel(vehicle) ~= GetHashKey("trash2") 
					and GetEntityModel(vehicle) ~= GetHashKey("tiptruck") 
					and GetEntityModel(vehicle) ~= GetHashKey("rebel") 
					and GetEntityModel(vehicle) ~= GetHashKey("speedo") 
					and GetEntityModel(vehicle) ~= GetHashKey("phantom") 
					and GetEntityModel(vehicle) ~= GetHashKey("packer") 
					and GetEntityModel(vehicle) ~= GetHashKey("paramedicoambu")) then
					if speed <= 100.0 then
					if IsControlPressed(1,21) then
						SetVehicleReduceGrip(vehicle,true)
					else
						SetVehicleReduceGrip(vehicle,false)
					end
				end    
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BLIPS ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ ['x'] = 1839.19, ['y'] = 3673.01, ['z'] = 34.28, ['sprite'] = 80, ['color'] = 59, ['nome'] = "Hospital", ['scale'] = 0.5 },
	{ ['x'] = -43.86, ['y'] = -1099.84, ['z'] = 26.43, ['sprite'] = 225, ['color'] = 4, ['nome'] = "Concessionária", ['scale'] = 0.5 },
	{ ['x'] = -1436.77, ['y'] = -277.68, ['z'] = 46.21, ['sprite'] = 361, ['color'] = 4, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -2096.59, ['y'] = -339.87, ['z'] = 13.03, ['sprite'] = 361, ['color'] = 4, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
}

Citizen.CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v.x,v.y,v.z)
		SetBlipSprite(blip,v.sprite)
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v.color)
		SetBlipScale(blip,v.scale)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.nome)
		EndTextCommandSetBlipName(blip)
	end
end)







-----------------------------------------------------------------------------------------------------------------------------------------
--[ TASERTIME ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local tasertime = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if IsPedBeingStunned(ped) then
			SetPedToRagdoll(ped,10000,10000,0,0,0,0)
		end

		if IsPedBeingStunned(ped) and not tasertime then
			tasertime = true
			--SetTimecycleModifier("REDMIST_blend")
			--ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE",1.0)
		elseif not IsPedBeingStunned(ped) and tasertime then
			tasertime = false
			SetTimeout(5000,function()
				--SetTimecycleModifier("hud_def_desat_Trevor")
				SetTimeout(10000,function()
					SetTimecycleModifier("")
					SetTransitionTimecycleModifier("")
					StopGameplayCamShaking()
				end)
			end)
		end
	end
end)