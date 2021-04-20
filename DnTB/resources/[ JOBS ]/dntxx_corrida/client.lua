local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = Tunnel.getInterface("dntxx_corrida")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local inrace = false
local timerace = 0
local racePoint = 1
local racepos = 0 
local CoordenadaX, CoordenadaY, CoordenadaZ = 386.45,-1656.96,26.64
local PlateIndex = nil
local bomba = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local races = {
	[1] = {
		['time'] = 130,
		[1] = { ['x'] = 1204.02, ['y'] = -1217.99, ['z'] = 33.67 },
		[2] = { ['x'] = 1241.02, ['y'] = -1102.99, ['z'] = 38.52 },
		[3] = { ['x'] = 1156.01, ['y'] = -966.99, ['z'] = 47.09 },
		[4] = { ['x'] = 1004.01, ['y'] = -986.99, ['z'] = 42.07 },
		[5] = { ['x'] = 890.01, ['y'] = -1070.99, ['z'] = 31.09 },
		[6] = { ['x'] = 906.01, ['y'] = -1014.99, ['z'] = 34.84 },
		[7] = { ['x'] = 755.0, ['y'] = -983.98, ['z'] = 25.4 },
		[8] = { ['x'] = 692.01, ['y'] = -1016.99, ['z'] = 22.63 },
		[9] = { ['x'] = 707.02, ['y'] = -1085.99, ['z'] = 22.42 },
		[10] = { ['x'] = 786.01, ['y'] = -1025.99, ['z'] = 26.22 },
		[11] = { ['x'] = 415.01, ['y'] = -1044.99, ['z'] = 29.5 },
		[12] = { ['x'] = 131.05, ['y'] = -1009.04, ['z'] = 29.41 },
		[13] = { ['x'] = 82.0, ['y'] = -1038.0, ['z'] = 29.47 },
		[14] = { ['x'] = 222.0, ['y'] = -1041.0, ['z'] = 29.37 },
		[15] = { ['x'] = 303.0, ['y'] = -1107.0, ['z'] = 29.42 },
		[16] = { ['x'] = 431.0, ['y'] = -1133.0, ['z'] = 29.44 },
		[17] = { ['x'] = 471.01, ['y'] = -1093.99, ['z'] = 29.2 }
	}
}

RegisterCommand('corrida', function(source, args, rawCmd)
	if not inrace then
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsUsing(ped)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
		local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) ~= 8 and GetPedInVehicleSeat(vehicle,-1) == ped then
				if distance <= 30 then
						if emP.CorridaLiberada() then
							emP.checkPolice()
							vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
							racepos = 1
							racepoint = emP.ReicePointe()
							inrace = true
							timerace = races[racepoint].time
							PlateIndex = GetVehicleNumberPlateText(vehicle)
							SetVehicleNumberPlateText(vehicle,"CORREDOR")
							CriandoBlip(races,racepoint,racepos)
							emP.startBombRace()
							bomba = CreateObject(GetHashKey("prop_c4_final_green"),x,y,z,true,false,false)
							AttachEntityToEntity(bomba,vehicle,GetEntityBoneIndexByName(vehicle,"exhaust"),0.0,0.0,0.0,180.0,-90.0,180.0,false,false,false,true,2,true)
							TriggerEvent("Notify","sucesso","Sucesso","Você iniciou uma <b>corrida</b>, acabe ela antes do tempo previstoe e <b>NÃO</b> desça do veículo, caso contrário seu veículo explodirá.")
						end
				end
			end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOINTS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if inrace then
			timeDistance = 4
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z)
			local distance = GetDistanceBetweenCoords(races[racepoint][racepos].x,races[racepoint][racepos].y,cdz,x,y,z,true)

			if distance <= 15.0 then
				if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) ~= 8 then
					DrawMarker(1,races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z-3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25,0,0,0,0)
					DrawMarker(21,races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,255,0,0,50,1,0,0,1)
					if distance <= 15.1 then
						RemoveBlip(blips)
						if racepos == #races[racepoint] then
							inrace = false
							timerace = 0
							SetVehicleNumberPlateText(GetPlayersLastVehicle(),PlateIndex)
							PlateIndex = nil
							PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
							DetachEntity(bomba,false,false)
							TriggerServerEvent("trydeleteobj",ObjToNet(bomba))
							emP.removeBombRace()
							emP.paymentCheck(racepoint,1)
							TriggerEvent('Notify', 'importante',"Importante", 'Você finalizou a corrida com sucesso!')
						else
							racepos = racepos + 1
							CriandoBlip(races,racepoint,racepos)
						end
						vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEDRAWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if inrace and timerace > 0 and GetVehiclePedIsUsing(PlayerPedId()) then
			timeDistance = 4
			drawTxt("RESTAM ~b~"..timerace.." SEGUNDOS ~w~PARA CHEGAR AO DESTINO FINAL DA CORRIDA",4,0.5,0.905,0.45,255,255,255,100)
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERACE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if inrace and timerace > 0 then
			timerace = timerace - 1
			if timerace <= 0 or not IsPedInAnyVehicle(PlayerPedId()) then
				inrace = false
				RemoveBlip(blips)
				SetVehicleNumberPlateText(GetPlayersLastVehicle(),PlateIndex)
				PlateIndex = nil
				SetTimeout(3000,function()
					DetachEntity(bomba,false,false)
					TriggerServerEvent("trydeleteobj",ObjToNet(bomba))
					emP.removeBombRace()
					AddExplosion(GetEntityCoords(GetPlayersLastVehicle()),1,1.0,true,true,true)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
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

function CriandoBlip(races,racepoint,racepos)
	blips = AddBlipForCoord(races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z)
	SetBlipSprite(blips,433)
	SetBlipColour(blips,1)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Corrida Clandestina")
	EndTextCommandSetBlipName(blips)
end

RegisterNetEvent("emp_race:defuse")
AddEventHandler("emp_race:defuse",function()
	inrace = false
	SetVehicleNumberPlateText(GetPlayersLastVehicle(),PlateIndex)
	PlateIndex = nil
	RemoveBlip(blips)
	DetachEntity(bomba,false,false)
	TriggerServerEvent("trydeleteobj",ObjToNet(bomba))
	emP.removeBombRace()
end)