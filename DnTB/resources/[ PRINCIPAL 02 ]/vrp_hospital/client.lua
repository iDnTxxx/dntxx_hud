-----------------------------------------------------------------------------------------------------------------------------------------
--[ vRP ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Resg = Tunnel.getInterface("vrp_hospital")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VARIÁVEIS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
--[ REANIMAR ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reanimar')
AddEventHandler('reanimar',function()
	local handle,ped = FindFirstPed()
	local finished = false
	local reviver = nil
	repeat
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(ped),true)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance <= 1.5 and reviver == nil then
			reviver = ped
			TriggerEvent("cancelando",true)
			vRP._playAnim(false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
			TriggerEvent("progress",15000,"reanimando")
			SetTimeout(15000,function()
				SetEntityHealth(reviver,110)
				local newped = ClonePed(reviver,GetEntityHeading(reviver),true,true)
				TaskWanderStandard(newped,10.0,10)
				local model = GetEntityModel(reviver)
				SetModelAsNoLongerNeeded(model)
				Citizen.InvokeNative(0xAD738C3085FE7E11,reviver,true,true)
				TriggerServerEvent("trydeleteped",PedToNet(reviver))
				vRP._stopAnim(false)
				TriggerServerEvent("reanimar:pagamento2121")
				TriggerEvent("cancelando",false)
			end)
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MACAS DO HOSPITAL ]------------------------------------------------------------------------------------------------------------------ 
-----------------------------------------------------------------------------------------------------------------------------------------
local macas = {
	{ ['x'] = 344.24, ['y'] = -582.21, ['z'] = 43.31, ['x2'] = 344.66, ['y2'] = -580.87, ['z2'] = 44.01, ['h'] = 70.0 },
	{ ['x'] = 348.82, ['y'] = -583.36, ['z'] = 43.31, ['x2'] = 349.71, ['y2'] = -583.56, ['z2'] = 44.01, ['h'] = 330.0 },
	{ ['x'] = 352.31, ['y'] = -584.43, ['z'] = 43.31, ['x2'] = 353.10, ['y2'] = -584.77, ['z2'] = 44.10, ['h'] = 330.0 },
	{ ['x'] = 355.82, ['y'] = -585.73, ['z'] = 43.31, ['x2'] = 356.56, ['y2'] = -585.94, ['z2'] = 44.10, ['h'] = 330.0 },
	{ ['x'] = 359.60, ['y'] = -586.81, ['z'] = 43.31, ['x2'] = 360.55, ['y2'] = -587.08, ['z2'] = 44.01, ['h'] = 330.0 },
	{ ['x'] = 346.12, ['y'] = -590.31, ['z'] = 43.31, ['x2'] = 346.99, ['y2'] = -590.55, ['z2'] = 44.10, ['h'] = 150.0 },
	{ ['x'] = 349.93, ['y'] = -591.46, ['z'] = 43.31, ['x2'] = 350.78, ['y2'] = -591.64, ['z2'] = 44.10, ['h'] = 150.0 },
	{ ['x'] = 353.42, ['y'] = -592.40, ['z'] = 43.31, ['x2'] = 354.26, ['y2'] = -592.52, ['z2'] = 44.10, ['h'] = 150.0 },
	{ ['x'] = 356.51, ['y'] = -593.99, ['z'] = 43.31, ['x2'] = 357.42, ['y2'] = -594.18, ['z2'] = 44.10, ['h'] = 150.0 },
	{ ['x'] = 327.22, ['y'] = -569.09, ['z'] = 43.31, ['x2'] = 326.81, ['y2'] = -569.85, ['z2'] = 44.01, ['h'] = 70.0 },
	{ ['x'] = 250.28, ['y'] = -1354.36, ['z'] = 24.54, ['x2'] = 249.51, ['y2'] = -1355.35, ['z2'] = 25.56, ['h'] = 46.47 },
	{ ['x'] = 252.59, ['y'] = -1349.43, ['z'] = 24.55, ['x2'] = 251.94, ['y2'] = -1348.77, ['z2'] = 25.58, ['h'] = 139.19 },
	{ ['x'] = 255.11, ['y'] = -1351.8, ['z'] = 24.55, ['x2'] = 255.9, ['y2'] = -1352.11, ['z2'] = 25.52, ['h'] = 139.19 },
	{ ['x'] = 256.98, ['y'] = -1344.08, ['z'] = 24.55, ['x2'] = 256.11, ['y2'] = -1343.91, ['z2'] = 25.52, ['h'] = 315.83 },
	{ ['x'] = 259.5, ['y'] = -1346.58, ['z'] = 24.54, ['x2'] = 260.14, ['y2'] = -1347.18, ['z2'] = 25.52, ['h'] = 315.83 },
	{ ['x'] = 261.39, ['y'] = -1340.91, ['z'] = 24.54, ['x2'] = 262.21, ['y2'] = -1339.96, ['z2'] = 25.56, ['h'] = 46.47 },
	{ ['x'] = 279.1, ['y'] = -1338.03, ['z'] = 24.54, ['x2'] = 278.47, ['y2'] = -1338.55, ['z2'] = 25.52, ['h'] = 226.65 },
	{ ['x'] = 280.41, ['y'] = -1336.5, ['z'] = 24.55, ['x2'] = 280.79, ['y2'] = -1335.89, ['z2'] = 25.52, ['h'] = 226.65 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
--[ USO ]-------------------------------------------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------------------------------------------------
local emMaca = false
Citizen.CreateThread(function()
	while true do
		local dntxx = 5000
		for k,v in pairs(macas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local cod = macas[k]

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),cod.x,cod.y,cod.z,true) < 2.2 then
				dntxx = 5
				text3D(cod.x,cod.y,cod.z,"~g~E ~w~ DEITAR       ~y~G ~w~ TRATAMENTO")
			end

			if distance < 1.2 then
				dntxx = 5
				if IsControlJustPressed(0,38) then
					SetEntityCoords(ped,v.x2,v.y2,v.z2)
					SetEntityHeading(ped,v.h)
					vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
					emMaca = true
				end

				if IsControlJustPressed(0,47) then
					if Resg.checkServices() then
						if Resg.checkPayment() then
							TriggerEvent('tratamento-macas')
							SetEntityCoords(ped,v.x2,v.y2,v.z2)
							SetEntityHeading(ped,v.h)
							vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
						end
					else
						TriggerEvent("Notify","aviso","Existem paramédicos em serviço.")
					end
				end

			end

			if IsControlJustPressed(0,167) and emMaca then
				ClearPedTasks(GetPlayerPed(-1))
				emMaca = false
			end
		end

		Citizen.Wait(dntxx)
	end
end)

RegisterNetEvent('tratamento-macas')
AddEventHandler('tratamento-macas',function()
	TriggerEvent("cancelando",true)
	repeat
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+3)
		Citizen.Wait(1800)
	until GetEntityHealth(PlayerPedId()) >= 399 or GetEntityHealth(PlayerPedId()) <= 101
	TriggerEvent("Notify","importante","Tratamento concluido.")
	TriggerEvent("cancelando",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRATAMENTO ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local tratamento = false
RegisterNetEvent("tratamento")
AddEventHandler("tratamento",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)

    SetEntityHealth(ped,health)
	
	if emMaca then
		if tratamento then
			return
		end

		tratamento = true
		TriggerEvent("Notify","sucesso","Tratamento iniciado, aguarde a liberação do <b>profissional médico.</b>.",8000)
		

		if tratamento then
			repeat
				Citizen.Wait(600)
				if GetEntityHealth(ped) > 101 then
					SetEntityHealth(ped,GetEntityHealth(ped)+3)
				end
			until GetEntityHealth(ped) >= 399 or GetEntityHealth(ped) <= 101
				TriggerEvent("Notify","sucesso","Tratamento concluido.",8000)
				tratamento = false
		end
	else
		TriggerEvent("Notify","negado","Você precisa estar deitado em uma maca para ser tratado.",8000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TEXT3D ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function text3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local checkinX, checkinY, checkinZ = 321.83, -569.78, 43.32
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local distance = Vdist(x,y,z,checkinX,checkinY,checkinZ)
		if distance <= 2.0 then
			text3D(checkinX,checkinY,checkinZ,"~g~E~w~  PARA PRODUZIR BANDAGEM")
			if IsControlJustPressed(1,38) then
				Resg.receiveBandagem()
			end
		end
		Citizen.Wait(1000)
	end
end)