local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = Tunnel.getInterface("vrp_player",src)


RegisterNetEvent( 'lafa2k_flag:fps20' )
AddEventHandler( 'lafa2k_flag:fps20', function()   
    SetTimecycleModifier("int_hospital2_dm")
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- /ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('me', function(source, args, rawCommand)
    local text = 'Pensamento: ' .. rawCommand:sub(4) .. ' '
    local ped = PlayerPedId()
    if GetEntityHealth(ped) > 101 then
        TriggerServerEvent('ChatMe', text)
    end
end)

local DisplayMe = false
RegisterNetEvent('DisplayMe')
AddEventHandler('DisplayMe',function(text,source)
    local DisplayMe = true
    local id = GetPlayerFromServerId(source)
    if id == -1 then
        return
    end
    Citizen.CreateThread(function()
        while DisplayMe do
            local ped = PlayerPedId()
            Wait(1500)
            local coordsMe = GetEntityCoords(GetPlayerPed(id),false)
            local coords = GetEntityCoords(ped,false)
            local distance = Vdist2(coordsMe,coords)
            if distance <= 30 then
                DrawText3Ds(coordsMe['x'],coordsMe['y'],coordsMe['z']+0.90,text)
            end
        end
    end)
    Wait(7000)
    DisplayMe = false
end)


local adminMode = false
local adminsIDS = {}
local adminDIST = 100

function adminThread()
    Citizen.CreateThread(function()
        while adminMode do
            
            Citizen.Wait(1500)
            
            local players = GetActivePlayers()
            local myPED = PlayerPedId()
            local pCDS = GetEntityCoords(myPED,true)
            
            for k,v in pairs(players) do
                
                local otherPED = GetPlayerPed(v)               
                
                if (otherPED ~= myPED) then
                    
                    local oCDS = GetEntityCoords(otherPED,true)
                    local distance = #(oCDS - pCDS)
                    if (distance <= adminDIST) then
                        local srcPED = GetPlayerServerId(v)
                        local name = GetPlayerName(v)
                        local vida = tonumber(string.format("%.2f",(GetEntityHealth(otherPED)-100)/300*100))
                        DrawText3Ds(oCDS.x,oCDS.y,oCDS.z+1.5,"~b~ID:~w~ "..(adminsIDS[srcPED].user_id or "ERRO!").."\n~r~HP:~w~ ("..vida..")\n~g~STEAM:~w~ "..name)
                    end

                end
            end
        end
    end)  
end

RegisterCommand("modoadm", function(source,args)
    if src.isAdm() then
        if not adminMode then
            adminMode = true
            adminsIDS = src.refreshPlayerList()   
            adminThread()
            TriggerEvent("Notify","sucesso","Modo adm <b>ON</b>")
        else
            adminMode = false
            TriggerEvent("Notify","sucesso","Modo adm <b>OFF</b>")
        end
    end   
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR O Q
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health >= 101 then
        	DisableControlAction(0,44,true)
        end
    end
end)
---------------------------------------------------- 
------ Trintar
----------------------------------------------------
RegisterCommand('30s',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRPclient.getNearestPlayer(source,2)
    if vRP.request(nplayer,"Voc?? deseja trintar",1000) then

    TriggerClientEvent("Notify",source,"importante","Importante","Contagem dos 30 segundos de a????o",5000)
    TriggerClientEvent("Notify",nplayer,"importante","Importante","Contagem dos 30 segundos de a????o",5000)

    TriggerClientEvent("progress",source,30000,"30s")
    TriggerClientEvent("progress",nplayer,30000,"30s")

        SetTimeout(30000,function()
            TriggerClientEvent("Notify",source,"sucesso","Sucesso","A Contagem dos 30 segundos de a????o acabou",2000)
            TriggerClientEvent("Notify",nplayer,"sucesso","Sucesso","A Contagem dos 30 segundos de a????o acabou",2000)
        end)
        end
 end)
---------------------------------------------------- 
------ N??O ATIRAR AGACHADO 
----------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local player = PlayerId()
        if agachar then 
            DisablePlayerFiring(player, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        DisableControlAction(0,36,true)
        if not IsPedInAnyVehicle(ped) then
            RequestAnimSet("move_ped_crouched")
            RequestAnimSet("move_ped_crouched_strafing")
            if IsDisabledControlJustPressed(0,36) then
                if agachar then
                    ResetPedStrafeClipset(ped)
                    ResetPedMovementClipset(ped,0.25)
                    agachar = false
                else
                    SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
                    SetPedMovementClipset(ped,"move_ped_crouched",0.25)
                    agachar = true
                end
            end
        end
    end
end) 
-----------------------------------------------------------------------------------------------------------------------------------------
-- /VTUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vtuning",function(source,args)
	local vehicle = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(vehicle) then
		local motor = GetVehicleMod(vehicle,11)
		local freio = GetVehicleMod(vehicle,12)
		local transmissao = GetVehicleMod(vehicle,13)
		local suspensao = GetVehicleMod(vehicle,15)
		local blindagem = GetVehicleMod(vehicle,16)
		local body = GetVehicleBodyHealth(vehicle)
		local engine = GetVehicleEngineHealth(vehicle)
		local fuel = GetVehicleFuelLevel(vehicle)

		if motor == -1 then
			motor = "Desativado"
		elseif motor == 0 then
			motor = "N??vel 1 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 1 then
			motor = "N??vel 2 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 2 then
			motor = "N??vel 3 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 3 then
			motor = "N??vel 4 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 4 then
			motor = "N??vel 5 / "..GetNumVehicleMods(vehicle,11)
		end

		if freio == -1 then
			freio = "Desativado"
		elseif freio == 0 then
			freio = "N??vel 1 / "..GetNumVehicleMods(vehicle,12)
		elseif freio == 1 then
			freio = "N??vel 2 / "..GetNumVehicleMods(vehicle,12)
		elseif freio == 2 then
			freio = "N??vel 3 / "..GetNumVehicleMods(vehicle,12)
		end

		if transmissao == -1 then
			transmissao = "Desativado"
		elseif transmissao == 0 then
			transmissao = "N??vel 1 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 1 then
			transmissao = "N??vel 2 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 2 then
			transmissao = "N??vel 3 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 3 then
			transmissao = "N??vel 4 / "..GetNumVehicleMods(vehicle,13)
		end

		if suspensao == -1 then
			suspensao = "Desativado"
		elseif suspensao == 0 then
			suspensao = "N??vel 1 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 1 then
			suspensao = "N??vel 2 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 2 then
			suspensao = "N??vel 3 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 3 then
			suspensao = "N??vel 4 / "..GetNumVehicleMods(vehicle,15)
		end

		if blindagem == -1 then
			blindagem = "Desativado"
		elseif blindagem == 0 then
			blindagem = "N??vel 1 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 1 then
			blindagem = "N??vel 2 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 2 then
			blindagem = "N??vel 3 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 3 then
			blindagem = "N??vel 4 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 4 then
			blindagem = "N??vel 5 / "..GetNumVehicleMods(vehicle,16)
		end

		TriggerEvent("Notify","importante","<b>Motor:</b> "..motor.."<br><b>Freio:</b> "..freio.."<br><b>Transmiss??o:</b> "..transmissao.."<br><b>Suspens??o:</b> "..suspensao.."<br><b>Blindagem:</b> "..blindagem.."<br><b>Chassi:</b> "..parseInt(body/10).."%<br><b>Engine:</b> "..parseInt(engine/10).."%<br><b>Gasolina:</b> "..parseInt(fuel).."%",15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAL??RIO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30*60000)
		TriggerServerEvent('salario:pagamento')
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AGACHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        local player = PlayerId()
        if agachar then 
            DisablePlayerFiring(player, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        local ped = PlayerPedId()
        DisableControlAction(0,36,true)
        if not IsPedInAnyVehicle(ped) then
            RequestAnimSet("move_ped_crouched")
            RequestAnimSet("move_ped_crouched_strafing")
            if IsDisabledControlJustPressed(0,36) then
                if agachar then
                    ResetPedStrafeClipset(ped)
                    ResetPedMovementClipset(ped,0.25)
                    agachar = false
                else
                    SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
                    SetPedMovementClipset(ped,"move_ped_crouched",0.25)
                    agachar = true
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMACAO DA BOCA AO FALAR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayers()
	local players = {}
	-- for i = 0, 256 do
	-- 		if NetworkIsPlayerActive(i) then
	-- 				players[#players + 1] = i
	-- 		end
	-- end
  
  -- LISTA DE PLAYERS ATIVOS OTIMIZADA
  for _, player in ipairs(GetActivePlayers()) do
    table.insert(players, player)
  end

  return players
end

Citizen.CreateThread(function()
	RequestAnimDict("facials@gen_male@variations@normal")
	RequestAnimDict("mp_facial")

	local talkingPlayers = {}
	while true do
			Citizen.Wait(1300)

			for k,v in pairs(GetPlayers()) do
					local boolTalking = NetworkIsPlayerTalking(v)
					if v ~= PlayerId() then
							if boolTalking and not talkingPlayers[v] then
									PlayFacialAnim(GetPlayerPed(v), "mic_chatter", "mp_facial")
									talkingPlayers[v] = true
							elseif not boolTalking and talkingPlayers[v] then
									PlayFacialAnim(GetPlayerPed(v), "mood_normal_1", "facials@gen_male@variations@normal")
									talkingPlayers[v] = nil
							end
					end
			end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCARJACK
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
			local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
			if GetVehicleDoorLockStatus(veh) >= 2 or GetPedInVehicleSeat(veh,-1) then
				TriggerServerEvent("TryDoorsEveryone",veh,2,GetVehicleNumberPlateText(veh))
			end
		end
	end
end)

RegisterNetEvent("SyncDoorsEveryone")
AddEventHandler("SyncDoorsEveryone",function(veh,doors)
	SetVehicleDoorsLocked(veh,doors)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /ATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPISTOL") then
	GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))
end

RegisterCommand("attachs",function(source,args)
	local ped = PlayerPedId()
	if src.CheckVip() or src.checkAttachs () then
		if not args[1] then
			TriggerEvent('Notify', 'aviso', 'Escolha qual componente voc?? quer equipar.<br><br> Componentes:<br>- <b>lan</b> (LANTERNA)<br>- <b>mira</b> (MIRA)<br>- <b>emp</b> (EMPUNHADORA)<br>- <b>todos</b> (TODOS ACIMA)')
		else
			local NomeComp = string.lower(args[1])
			local arma = GetSelectedPedWeapon(ped)
			if NomeComp == 'lan' then
				if arma == GetHashKey("WEAPON_PISTOL_MK2") then
					GiveWeaponComponentToPed(ped, arma,GetHashKey("COMPONENT_AT_PI_FLSH_02"))
					TriggerEvent('Notify', 'sucesso', '<b>Lanterna</b> equipada.')
				elseif arma == GetHashKey("WEAPON_HEAVYPISTOL") or arma == GetHashKey("WEAPON_COMBATPISTOL") then
					GiveWeaponComponentToPed(ped, arma,GetHashKey("COMPONENT_AT_PI_FLSH"))
					TriggerEvent('Notify', 'sucesso', '<b>Lanterna</b> equipada.')
				elseif arma == GetHashKey("WEAPON_SMG_MK2") 
					or arma == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") 
					or arma == GetHashKey("WEAPON_CARBINERIFLE") 
					or arma == GetHashKey("WEAPON_SMG") 
					or arma == GetHashKey("WEAPON_PUMPSHOTGUN") 
					or arma == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
						GiveWeaponComponentToPed(ped, arma, GetHashKey("COMPONENT_AT_AR_FLSH"))
						TriggerEvent('Notify', 'sucesso', '<b>Lanterna</b> equipada.')
				end
			elseif NomeComp == 'mira' then
				if arma == GetHashKey("WEAPON_PISTOL_MK2") then
					GiveWeaponComponentToPed(ped, arma,GetHashKey("COMPONENT_AT_PI_RAIL"))
					TriggerEvent('Notify', 'sucesso', '<b>Mira</b> equipada.')
				elseif arma == GetHashKey("WEAPON_SMG_MK2") then
					GiveWeaponComponentToPed(ped, arma, GetHashKey("COMPONENT_AT_SCOPE_SMALL_SMG_MK2"))
					TriggerEvent('Notify', 'sucesso', '<b>Mira</b> equipada.')
				elseif arma == GetHashKey("WEAPON_SMG") then
					GiveWeaponComponentToPed(ped, arma, GetHashKey("COMPONENT_AT_SCOPE_MACRO_02"))
					TriggerEvent('Notify', 'sucesso', '<b>Mira</b> equipada.')
				elseif arma == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or arma == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
					GiveWeaponComponentToPed(ped, arma, GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))
					TriggerEvent('Notify', 'sucesso', '<b>Mira</b> equipada.')
				elseif arma == GetHashKey("WEAPON_CARBINERIFLE") then
					GiveWeaponComponentToPed(ped, arma, GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))
					TriggerEvent('Notify', 'sucesso', '<b>Mira</b> equipada.')
				end
			elseif NomeComp == 'emp' then
				if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))
					TriggerEvent('Notify', 'sucesso', '<b>Empunhadura</b> equipada.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_AFGRIP"))
					TriggerEvent('Notify', 'sucesso', '<b>Empunhadura</b> equipada.')
				end
			elseif NomeComp == 'todos' then
				if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_PI_RAIL"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_PI_FLSH_02"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_PI_COMP"))
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") then
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG_MK2") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_FLSH"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_SCOPE_SMALL_SMG_MK2"))
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PUMPSHOTGUN") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_FLSH"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_SR_SUPP"))
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_FLSH"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_SCOPE_MACRO_02"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_PI_SUPP"))
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_FLSH"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_MUZZLE_02"))
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_FLSH"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_AR_AFGRIP"))
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPDW") then
					GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_AR_FLSH"))
					GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_SCOPE_SMALL"))
					GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPISTOL") then
					GiveWeaponComponentToPed(ped,arma,GetHashKey("COMPONENT_AT_PI_FLSH"))
					TriggerEvent('Notify', 'sucesso', '<b>TODOS</b> os componentes equipados.')
				end
			end
		end
	else
		TriggerEvent('Notify', 'negado', 'Voc?? n??o possui um kit de componentes.<br><br>OBS: Membros <b>VIP Ultimate</b> n??o necessitam deste item para usar o comando.')
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /ATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterCommand("attachs",function(source,args)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkAttachs() then
		if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPISTOL") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_COMBATPISTOL_CLIP_02"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_COMBATPDW") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_AR_FLSH"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_SCOPE_SMALL"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPDW"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PUMPSHOTGUN") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PUMPSHOTGUN"),GetHashKey("COMPONENT_AT_SR_SUPP"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PUMPSHOTGUN"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_CARBINERIFLE_CLIP_02"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_AR_FLSH"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE"),GetHashKey("COMPONENT_AT_AR_AFGRIP"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SPECIALCARBINE") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE"),GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_02"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE"),GetHashKey("COMPONENT_AT_AR_FLSH"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SPECIALCARBINE"),GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_02"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_SIGHTS"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),GetHashKey("COMPONENT_AT_MUZZLE_03")) 
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_RAIL"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_FLSH_02"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PISTOL_MK2"),GetHashKey("COMPONENT_AT_PI_COMP"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_HEAVYPISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))
			--GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_HEAVYPISTOL"),GetHashKey("COMPONENT_HEAVYPISTOL_CLIP_02"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SNSPISTOL") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SNSPISTOL"),GetHashKey("COMPONENT_SNSPISTOL_CLIP_02"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTSMG") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTSMG"),GetHashKey("COMPONENT_AT_AR_FLSH"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_ASSAULTSMG"),GetHashKey("COMPONENT_AT_SCOPE_MACRO"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL") then
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_PISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))
		elseif GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_CARBINERIFLE_MK2") then	
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_MUZZLE_04"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_SIGHTS"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))
			GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		end
	end
end)]]--
-----------------------------------------------------------------------------------------------------------------------------------------
-- COR NA ARMA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cor",function(source,args)
	local tinta = parseInt(args[1])
	local ped = PlayerPedId()
	local arma = GetSelectedPedWeapon(ped)
	if tinta >= 0 and src.checkVIP() then
		SetPedWeaponTintIndex(ped,arma,tinta)
	end
end,false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COR DO XENON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("xc",function(source,args)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(PlayerPedId())
	local tinta = parseInt(args[1])
	if IsEntityAVehicle(vehicle) then
		if tinta >= 0 and src.checkVIP() then
			ToggleVehicleMod(vehicle, 22, true)
			SetVehicleHeadlightsColour(vehicle, tinta)
    	end
  	end
end,false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STAMINA INFINITA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
    while true do
    Citizen.Wait(1000)
        RestorePlayerStamina(PlayerId(), 1.0)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEBIDAS ENERGETICAS
-----------------------------------------------------------------------------------------------------------------------------------------
local energetico = false
RegisterNetEvent('energeticos')
AddEventHandler('energeticos',function(status)
	energetico = status
	if energetico then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.15)
	else
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if energetico then
			RestorePlayerStamina(PlayerId(),1.0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO O F6
-----------------------------------------------------------------------------------------------------------------------------------------
local cancelando = false
RegisterNetEvent('cancelando')
AddEventHandler('cancelando',function(status)
    cancelando = status
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cancelando then
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,29,true)
			DisableControlAction(0,38,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,137,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,169,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AFKSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if x == px and y == py then
            if tempo > 0 then
                tempo = tempo - 1
                if tempo == 60 then
                    TriggerEvent("Notify","importante","Voc?? vai ser desconectado em <b>60 segundos</b>.",8000)
                end
            else
                TriggerServerEvent("kickAFK")
            end
        else
            tempo = 1800
        end
        px = x
        py = y
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR CAPO DO VEICULO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hood",function(source,args)
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryhood",VehToNet(vehicle))
	end
end)

RegisterNetEvent("synchood")
AddEventHandler("synchood",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,4)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if isopen == 0 then
					SetVehicleDoorOpen(v,4,0,0)
				else
					SetVehicleDoorShut(v,4,0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRE E FECHA OS VIDROS
-----------------------------------------------------------------------------------------------------------------------------------------
local vidros = false
RegisterCommand("wins",function(source,args)
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trywins",VehToNet(vehicle))
	end
end)

RegisterNetEvent("syncwins")
AddEventHandler("syncwins",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if vidros then
					vidros = false
					RollUpWindow(v,0)
					RollUpWindow(v,1)
					RollUpWindow(v,2)
					RollUpWindow(v,3)
				else
					vidros = true
					RollDownWindow(v,0)
					RollDownWindow(v,1)
					RollDownWindow(v,2)
					RollDownWindow(v,3)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR PORTAS DO VEICULO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("doors",function(source,args)
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		if parseInt(args[1]) == 5 then
			TriggerServerEvent("trytrunk",VehToNet(vehicle))
		else
			TriggerServerEvent("trydoors",VehToNet(vehicle),args[1])
		end
	end
end)

RegisterNetEvent("syncdoors")
AddEventHandler("syncdoors",function(index,door)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,0) and GetVehicleDoorAngleRatio(v,1)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if door == "1" then
					if GetVehicleDoorAngleRatio(v,0) == 0 then
						SetVehicleDoorOpen(v,0,0,0)
					else
						SetVehicleDoorShut(v,0,0)
					end
				elseif door == "2" then
					if GetVehicleDoorAngleRatio(v,1) == 0 then
						SetVehicleDoorOpen(v,1,0,0)
					else
						SetVehicleDoorShut(v,1,0)
					end
				elseif door == "3" then
					if GetVehicleDoorAngleRatio(v,2) == 0 then
						SetVehicleDoorOpen(v,2,0,0)
					else
						SetVehicleDoorShut(v,2,0)
					end
				elseif door == "4" then
					if GetVehicleDoorAngleRatio(v,3) == 0 then
						SetVehicleDoorOpen(v,3,0,0)
					else
						SetVehicleDoorShut(v,3,0)
					end
				elseif door == nil then
					if isopen == 0 then
						SetVehicleDoorOpen(v,0,0,0)
						SetVehicleDoorOpen(v,1,0,0)
						SetVehicleDoorOpen(v,2,0,0)
						SetVehicleDoorOpen(v,3,0,0)
					else
						SetVehicleDoorShut(v,0,0)
						SetVehicleDoorShut(v,1,0)
						SetVehicleDoorShut(v,2,0)
						SetVehicleDoorShut(v,3,0)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("synctrunk")
AddEventHandler("synctrunk",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,5)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if isopen == 0 then
					SetVehicleDoorOpen(v,5,0,0)
				else
					SetVehicleDoorShut(v,5,0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR PNEUS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('repararpneus')
AddEventHandler('repararpneus',function(vehicle)
	TriggerServerEvent("trypneus",VehToNet(vehicle))
end)

RegisterNetEvent('syncpneus')
AddEventHandler('syncpneus',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			for i = 0,5 do
				SetVehicleTyreFixed(v,i)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMASCARA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setmascara')
AddEventHandler('setmascara',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkRoupas() then
		if modelo == nil then
			vRP._playAnim(true,{{"missfbi4","takeoff_mask"}},false)
			Wait(1100)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,1,0,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps"}},false)
			Wait(1500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,1,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBLUSA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setblusa')
AddEventHandler('setblusa',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkVIP() then
		if not modelo then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,8,15,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,8,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,8,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCOLETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setcolete')
AddEventHandler('setcolete',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkVIP() then
		if not modelo then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,9,0,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,9,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,9,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setmochila')
AddEventHandler('setmochila',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkVIP() then
		if not modelo then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,5,0,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,5,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,5,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETJAQUETA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setjaqueta')
AddEventHandler('setjaqueta',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkVIP() then
		if not modelo then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,11,15,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,11,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,11,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMAOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setmaos')
AddEventHandler('setmaos',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkRoupas() then
		if not modelo then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,15,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"clothingshirt","try_shirt_positive_d"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,3,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCALCA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setcalca')
AddEventHandler('setcalca',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkVIP() then
		if not modelo then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				vRP._playAnim(true,{{"clothingtrousers","try_trousers_neutral_c"}},false)
				Wait(2500)
				ClearPedTasks(ped)
				SetPedComponentVariation(ped,4,18,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				vRP._playAnim(true,{{"clothingtrousers","try_trousers_neutral_c"}},false)
				Wait(2500)
				ClearPedTasks(ped)
				SetPedComponentVariation(ped,4,15,0,2)
			end
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"clothingtrousers","try_trousers_neutral_c"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,4,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"clothingtrousers","try_trousers_neutral_c"}},false)
			Wait(2500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped,4,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETACESSORIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setacessorios')
AddEventHandler('setacessorios',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkRoupas() then
		if not modelo then
			SetPedComponentVariation(ped,7,0,0,2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,7,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,7,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSAPATOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setsapatos')
AddEventHandler('setsapatos',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkVIP() and not IsPedInAnyVehicle(ped) then
		if not modelo then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				vRP._playAnim(false,{{"clothingshoes","try_shoes_positive_d"}},false)
				Wait(2200)
				SetPedComponentVariation(ped,6,34,0,2)
				Wait(500)
				ClearPedTasks(ped)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				vRP._playAnim(false,{{"clothingshoes","try_shoes_positive_d"}},false)
				Wait(2200)
				SetPedComponentVariation(ped,6,35,0,2)
				Wait(500)
				ClearPedTasks(ped)
			end
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(false,{{"clothingshoes","try_shoes_positive_d"}},false)
			Wait(2200)
			SetPedComponentVariation(ped,6,parseInt(modelo),parseInt(cor),2)
			Wait(500)
			ClearPedTasks(ped)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(false,{{"clothingshoes","try_shoes_positive_d"}},false)
			Wait(2200)
			SetPedComponentVariation(ped,6,parseInt(modelo),parseInt(cor),2)
			Wait(500)
			ClearPedTasks(ped)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCHAPEU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setchapeu')
AddEventHandler('setchapeu',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkRoupas() then
		if not modelo then
			vRP._playAnim(true,{{"veh@common@fp_helmet@","take_off_helmet_stand"}},false)
			Wait(700)
			ClearPedProp(ped,0)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") and parseInt(modelo) ~= 39 then
			vRP._playAnim(true,{{"veh@common@fp_helmet@","put_on_helmet"}},false)
			Wait(1700)
			SetPedPropIndex(ped,0,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") and parseInt(modelo) ~= 38 then
			vRP._playAnim(true,{{"veh@common@fp_helmet@","put_on_helmet"}},false)
			Wait(1700)
			SetPedPropIndex(ped,0,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setoculos')
AddEventHandler('setoculos',function(modelo,cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and src.checkRoupas() then
		if not modelo then
			vRP._playAnim(true,{{"mini@ears_defenders","takeoff_earsdefenders_idle"}},false)
			Wait(500)
			ClearPedTasks(ped)
			ClearPedProp(ped,1)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			vRP._playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps"}},false)
			Wait(800)
			ClearPedTasks(ped)
			SetPedPropIndex(ped,1,parseInt(modelo),parseInt(cor),2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP._playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps"}},false)
			Wait(800)
			ClearPedTasks(ped)
			SetPedPropIndex(ped,1,parseInt(modelo),parseInt(cor),2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /TOW
-----------------------------------------------------------------------------------------------------------------------------------------
local tow = nil
local towed = nil
RegisterNetEvent("vTow")
AddEventHandler("vTow",function()
	local vehicle = GetPlayersLastVehicle()
	if IsVehicleModel(vehicle,GetHashKey("flatbed")) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
		towed = vRP.getNearestVehicle(7)
		if IsEntityAVehicle(vehicle) and IsEntityAVehicle(towed) then
			if tow then
				TriggerServerEvent("trytow",VehToNet(vehicle),VehToNet(tow),"out")
				towed = nil
				tow = nil
			else
				if vehicle ~= towed then
					TriggerServerEvent("trytow",VehToNet(vehicle),VehToNet(towed),"in")
					tow = towed
				end
			end
		end
	end
end)

RegisterNetEvent('synctow')
AddEventHandler('synctow',function(vehid01,vehid02,mod)
	if NetworkDoesNetworkIdExist(vehid01) and NetworkDoesNetworkIdExist(vehid02) then
		local vehicle = NetToEnt(vehid01)
		local towed = NetToEnt(vehid02)
		if DoesEntityExist(vehicle) and DoesEntityExist(towed) then
			if mod == "in" then
				local min,max = GetModelDimensions(GetEntityModel(towed))
				AttachEntityToEntity(towed,vehicle,GetEntityBoneIndexByName(vehicle,"bodyshell"),0,-2.2,0.4-min.z,0,0,0,1,1,0,1,0,1)
			elseif mod == "out" then
				AttachEntityToEntity(towed,vehicle,20,-0.5,-14.0,-0.2,0.0,0.0,0.0,false,false,true,false,20,true)
				DetachEntity(towed,false,false)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reparar')
AddEventHandler('reparar',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryreparar",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncreparar')
AddEventHandler('syncreparar',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleFixed(v)
				SetVehicleDirtLevel(v,0.0)
				SetVehicleUndriveable(v,false)
				Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR MOTOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('repararmotor')
AddEventHandler('repararmotor',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trymotor",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncmotor')
AddEventHandler('syncmotor',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleEngineHealth(v,1000.0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('bandagem')
AddEventHandler('bandagem',function()
    local ped = PlayerPedId()
    local bandagem = 0
    repeat
        Citizen.Wait(1600)
        bandagem = bandagem + 2
        if GetEntityHealth(ped) > 101 then
            SetEntityHealth(ped,GetEntityHealth(ped)+2)
        end
    until GetEntityHealth(ped) >= 400 or GetEntityHealth(ped) <= 101 or bandagem == 60
        TriggerEvent("Notify","sucesso","Tratamento concluido.")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /sequestro2
-----------------------------------------------------------------------------------------------------------------------------------------
local sequestrado = nil
RegisterCommand("sequestro2",function(source,args)
	local ped = PlayerPedId()
	local random,npc = FindFirstPed()
	repeat
		local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),GetEntityCoords(npc),true)
		if not IsPedAPlayer(npc) and distancia <= 3 and not IsPedInAnyVehicle(npc) then
			vehicle = vRP.getNearestVehicle(7)
			if IsEntityAVehicle(vehicle) then
				if vRP.getCarroClass(vehicle) then
					if sequestrado then
						AttachEntityToEntity(sequestrado,vehicle,GetEntityBoneIndexByName(vehicle,"bumper_r"),0.6,-1.2,-0.6,60.0,-90.0,180.0,false,false,false,true,2,true)
						DetachEntity(sequestrado,true,true)
						SetEntityVisible(sequestrado,true)
						SetEntityInvincible(sequestrado,false)
						Citizen.InvokeNative(0xAD738C3085FE7E11,sequestrado,true,true)
						ClearPedTasksImmediately(sequestrado)
						sequestrado = nil
					elseif not sequestrado then
						Citizen.InvokeNative(0xAD738C3085FE7E11,npc,true,true)
						AttachEntityToEntity(npc,vehicle,GetEntityBoneIndexByName(vehicle,"bumper_r"),0.6,-0.4,-0.1,60.0,-90.0,180.0,false,false,false,true,2,true)
						SetEntityVisible(npc,false)
						SetEntityInvincible(npc,true)
						sequestrado = npc
						complet = true
					end
					TriggerServerEvent("trymala",VehToNet(vehicle))
				end
			end
		end
		complet,npc = FindNextPed(random)
	until not complet
	EndFindPed(random)
end)


RegisterCommand("checkhash",function(source,args)
    local ped = PlayerPedId()
    if ped then
        local xesquedele = GetHashKey("mp_m_freemode_01") 
        print(xesquedele)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMPURRAR
-----------------------------------------------------------------------------------------------------------------------------------------
local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc,moveFunc,disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = { handle = iter, destructor = disposeFunc }
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next,id = moveFunc(iter)
		until not next

		enum.destructor,enum.handle = nil,nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle,FindNextVehicle,EndFindVehicle)
end

function GetVeh()
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        table.insert(vehicles,vehicle)
    end
    return vehicles
end

function GetClosestVeh(coords)
	local vehicles = GetVeh()
	local closestDistance = -1
	local closestVehicle = -1
	local coords = coords

	if coords == nil then
		local ped = PlayerPedId()
		coords = GetEntityCoords(ped)
	end

	for i=1,#vehicles,1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = GetDistanceBetweenCoords(vehicleCoords,coords.x,coords.y,coords.z,true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end
	return closestVehicle,closestDistance
end

local First = vector3(0.0,0.0,0.0)
local Second = vector3(5.0,5.0,5.0)
local Vehicle = { Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil }

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local closestVehicle,Distance = GetClosestVeh()
		if Distance < 6.1 and not IsPedInAnyVehicle(ped) then
			Vehicle.Coords = GetEntityCoords(closestVehicle)
			Vehicle.Dimensions = GetModelDimensions(GetEntityModel(closestVehicle),First,Second)
			Vehicle.Vehicle = closestVehicle
			Vehicle.Distance = Distance
			if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
				Vehicle.IsInFront = false
			else
				Vehicle.IsInFront = true
			end
		else
			Vehicle = { Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil }
		end
		Citizen.Wait(1500)
	end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1500)
		if Vehicle.Vehicle ~= nil then
			local ped = PlayerPedId()
			if IsControlPressed(0,244) and GetEntityHealth(ped) > 100 and IsVehicleSeatFree(Vehicle.Vehicle,-1) and not IsEntityInAir(ped) and not IsPedBeingStunned(ped) and not IsEntityAttachedToEntity(ped,Vehicle.Vehicle) and not (GetEntityRoll(Vehicle.Vehicle) > 75.0 or GetEntityRoll(Vehicle.Vehicle) < -75.0) then
				RequestAnimDict('missfinale_c2ig_11')
				TaskPlayAnim(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0,-8.0,-1,35,0,0,0,0)
				NetworkRequestControlOfEntity(Vehicle.Vehicle)

				if Vehicle.IsInFront then
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y*-1+0.1,Vehicle.Dimensions.z+1.0,0.0,0.0,180.0,0.0,false,false,true,false,true)
				else
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y-0.3,Vehicle.Dimensions.z+1.0,0.0,0.0,0.0,0.0,false,false,true,false,true)
				end

				while true do
					Citizen.Wait(1500)
					if IsDisabledControlPressed(0,34) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,11,100)
					end

					if IsDisabledControlPressed(0,9) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,10,100)
					end

					if Vehicle.IsInFront then
						SetVehicleForwardSpeed(Vehicle.Vehicle,-1.0)
					else
						SetVehicleForwardSpeed(Vehicle.Vehicle,1.0)
					end

					if not IsDisabledControlPressed(0,244) then
						DetachEntity(ped,false,false)
						StopAnimTask(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0)
						break
					end
				end
			end
		end
	end
end)


RegisterCommand("mvida",function(source,args,rawCommand)
	print(GetEntityHealth(PlayerPedId()))
end)

RegisterCommand("mcolete",function(source,args,rawCommand)
	print(GetPedArmour(PlayerPedId()))
end)

-- DETECTAR COLETE
Citizen.CreateThread(function()
	local timerArmour = false
	local amountArmourNotification = 0
	while true do 
		Citizen.Wait(1600)
		if GetPedArmour(PlayerPedId()) > 1 then 
      if not timerArmour then
        --src.sendArmourLogs(GetPedArmour(PlayerPedId()))
      end

      timerArmour = true
      SetTimeout(1000, function()
        timerArmour = false
      end)
		end

	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GCPHONE:SUBMITCALLER
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterNetEvent("gcphone:submitCaller")
AddEventHandler("gcphone:submitCaller",function(data)
	local message = data.message

	if message == nil then
		DisplayOnscreenKeyboard(1,"FMMC_MPM_NA","","","","","",200)
		while UpdateOnscreenKeyboard() == 0 do
			DisableAllControlActions(0)
			Citizen.Wait(10)
		end

		if GetOnscreenKeyboardResult() then
			message = GetOnscreenKeyboardResult()
		end

		if message ~= nil and message ~= "" then
			TriggerServerEvent("vrp_player:submitCaller",tostring(data.number),tostring(message))
		end
	end
end)--]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("updateRoupas")
AddEventHandler("updateRoupas",function(custom)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if custom[1] == -1 then
			SetPedComponentVariation(ped,1,0,0,2)
		else
			SetPedComponentVariation(ped,1,custom[1],custom[2],2)
		end

		if custom[3] == -1 then
			SetPedComponentVariation(ped,5,0,0,2)
		else
			SetPedComponentVariation(ped,5,custom[3],custom[4],2)
		end

		if custom[5] == -1 then
			SetPedComponentVariation(ped,7,0,0,2)
		else
			SetPedComponentVariation(ped,7,custom[5],custom[6],2)
		end

		if custom[7] == -1 then
			SetPedComponentVariation(ped,3,15,0,2)
		else
			SetPedComponentVariation(ped,3,custom[7],custom[8],2)
		end

		if custom[9] == -1 then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				SetPedComponentVariation(ped,4,18,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				SetPedComponentVariation(ped,4,15,0,2)
			end
		else
			SetPedComponentVariation(ped,4,custom[9],custom[10],2)
		end

		if custom[11] == -1 then
			SetPedComponentVariation(ped,8,15,0,2)
		else
			SetPedComponentVariation(ped,8,custom[11],custom[12],2)
		end

		if custom[13] == -1 then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				SetPedComponentVariation(ped,6,34,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				SetPedComponentVariation(ped,6,35,0,2)
			end
		else
			SetPedComponentVariation(ped,6,custom[13],custom[14],2)
		end

		if custom[15] == -1 then
			SetPedComponentVariation(ped,11,15,0,2)
		else
			SetPedComponentVariation(ped,11,custom[15],custom[16],2)
		end

		if custom[17] == -1 then
			SetPedComponentVariation(ped,9,0,0,2)
		else
			SetPedComponentVariation(ped,9,custom[17],custom[18],2)
		end

		if custom[19] == -1 then
			SetPedComponentVariation(ped,10,0,0,2)
		else
			SetPedComponentVariation(ped,10,custom[19],custom[20],2)
		end

		if custom[21] == -1 then
			ClearPedProp(ped,0)
		else
			SetPedPropIndex(ped,0,custom[21],custom[22],2)
		end

		if custom[23] == -1 then
			ClearPedProp(ped,1)
		else
			SetPedPropIndex(ped,1,custom[23],custom[24],2)
		end

		if custom[25] == -1 then
			ClearPedProp(ped,2)
		else
			SetPedPropIndex(ped,2,custom[25],custom[26],2)
		end

		if custom[27] == -1 then
			ClearPedProp(ped,6)
		else
			SetPedPropIndex(ped,6,custom[27],custom[28],2)
		end

		if custom[29] == -1 then
			ClearPedProp(ped,7)
		else
			SetPedPropIndex(ped,7,custom[29],custom[30],2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3DS
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(0)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,255)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/300
	--DrawRect(_x,_y+0.0125,0.01+factor,0.1,0,0,0,80)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALIMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('alimento')
AddEventHandler('alimento',function()
    local ped = PlayerPedId()
    local alimenta = 0
    repeat
        Citizen.Wait(1500)
        alimenta = alimenta + 1
        if GetEntityHealth(ped) > 101 then
            SetEntityHealth(ped,GetEntityHealth(ped)+1)
        end
    until GetEntityHealth(ped) >= 400 or GetEntityHealth(ped) <= 101 or alimentado == 10
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /CARTAS
-----------------------------------------------------------------------------------------------------------------------------------------
local card = {
	[1] = "A",
	[2] = "2",
	[3] = "3",
	[4] = "4",
	[5] = "5",
	[6] = "6",
	[7] = "7",
	[8] = "8",
	[9] = "9",
	[10] = "10",
	[11] = "J",
	[12] = "Q",
	[13] = "K"
}

local tipos = {
	[1] = "^8???",
	[2] = "^8???",
	[3] = "^9???",
	[4] = "^9???"
}

RegisterNetEvent('CartasMe')
AddEventHandler('CartasMe',function(id,name,cd,naipe)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	if sonid == -1 then
        return -- PLAYER NOT CLOSE
    end
	if sonid == monid then
		TriggerEvent('chatMessage',"",{},"^3* "..name.." tirou do baralho a carta: "..card[cd]..""..tipos[naipe])
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)),GetEntityCoords(GetPlayerPed(sonid)),true) < 5.999 then
		TriggerEvent('chatMessage',"",{},"^3* "..name.." tirou do baralho a carta: "..card[cd]..""..tipos[naipe])
	end
end)