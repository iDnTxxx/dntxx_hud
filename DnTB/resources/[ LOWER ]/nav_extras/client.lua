-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = Tunnel.getInterface("nav_extras")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsIn(ped)
		if vehicle then
			if data == "extra01" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),1)
			elseif data == "extra02" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),2)
			elseif data == "extra03" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),3)
			elseif data == "extra04" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),4)
			elseif data == "extra05" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),5)
			elseif data == "extra06" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),6)
			elseif data == "extra07" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),7)
			elseif data == "extra08" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),8)
			elseif data == "extra09" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),9)
			elseif data == "extra10" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),10)
			elseif data == "extra11" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),11)
			elseif data == "extra12" then
				TriggerServerEvent("tryextras",VehToNet(vehicle),12)
			elseif data == "livery01" then
				SetVehicleLivery(vehicle,0)
			elseif data == "livery03" then
				SetVehicleLivery(vehicle,1)
			elseif data == "livery02" then
				SetVehicleLivery(vehicle,2)
			elseif data == "fechar" then
				ToggleActionMenu()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXTRAS
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterNetEvent('extras')
AddEventHandler('extras',function()
	ToggleActionMenu()
end)--]]

local extras = {
	{443.25,-1020.97,28.57 } -- Delegacia LSPD
}

RegisterCommand("extras",function(source,args)
	local ped = GetPlayerPed(-1)
	local x,y,z = table.unpack(GetEntityCoords(ped))
	for k,v in pairs(extras) do
		local distance = Vdist(x,y,z,v[1],v[2],v[3])
		if IsPedInAnyPoliceVehicle(ped) then
			if distance <= 30.0 then
				if src.checkPermissao() then
					ToggleActionMenu()
				else
					TriggerEvent("Notify","negado","Você não tem permissão pra dar esse comando.")
				end
			else
				TriggerEvent("Notify","negado","Você precisa estar no patio da dp.")
			end
		else
			TriggerEvent("Notify","negado","Você precisa estar dentro de um veiculo da policia para usar o comando.")
		end
	end
end)

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCEXTRAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncextras")
AddEventHandler("syncextras",function(index,extra)
	Citizen.CreateThread(function()
		if NetworkDoesNetworkIdExist(index) then
			local v = NetToVeh(index)
			if DoesExtraExist(v,extra) then
				local engine = GetVehicleEngineHealth(v)
				local body = GetVehicleBodyHealth(v)
				if IsVehicleExtraTurnedOn(v,extra) then
					SetVehicleExtra(v,extra,true)
				else
					SetVehicleExtra(v,extra,false)
				end
				SetVehicleEngineHealth(v,engine+0.0)
				SetVehicleBodyHealth(v,body+0.0)
			end
		end
	end)
end)