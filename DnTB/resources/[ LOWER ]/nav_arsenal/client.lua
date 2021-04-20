local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = Tunnel.getInterface("nav_arsenal")
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
	local ped = GetPlayerPed(-1)
	if data == "kit" then
		TriggerServerEvent("nav_arsenal:KIT",user_id)
	elseif data == "radio" then
		TriggerServerEvent("nav_arsenal:Radio",user_id)
	elseif data == "glock" then
		TriggerServerEvent("nav_arsenal:GLOCK",user_id)
	elseif data == "desert" then
		TriggerServerEvent("nav_arsenal:DESERT",user_id)
	elseif data == "sigsauer" then
		TriggerServerEvent("nav_arsenal:SIG",user_id)
	elseif data == "remington" then
		TriggerServerEvent("nav_arsenal:DOZE",user_id)
	elseif data == "m4a1" then
		TriggerServerEvent("nav_arsenal:M4A1",user_id)
	elseif data == "mpx" then
		TriggerServerEvent("nav_arsenal:MPX",user_id)
	elseif data == "limpar" then
		RemoveAllPedWeapons(ped,true)
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{ 451.46, -978.78, 30.69 }
}

--[[RegisterNetEvent('arsenal')
AddEventHandler('arsenal',function()
	for _,mark in pairs(marcacoes) do
		local x,y,z = table.unpack(mark)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z,true)
		if distance <= 3 then
			ToggleActionMenu()
		end
	end
end)--]]

Citizen.CreateThread(function()
	while true do
		Wait(0)
		for _,mark in pairs(marcacoes) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z,true)
			DrawMarker(21,x,y+0.33,z)
			if distance <= 3 then
				if IsControlJustPressed(0,38) then
					if src.checkPermissao() then
						ToggleActionMenu()
					else
						TriggerEvent("Notify","negado","Você não tem permissão para acessar o arsenal.")
					end
				end
			end
		end
	end
end)