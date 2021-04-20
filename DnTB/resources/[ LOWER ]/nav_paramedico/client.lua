local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = Tunnel.getInterface("nav_paramedico")
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
		TriggerServerEvent("nav_paramedico:KIT",user_id)
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
	{ 310.29,-599.57,43.3 }
}

RegisterCommand('arsenal',function(source,args)
	for _,mark in pairs(marcacoes) do
		local x,y,z = table.unpack(mark)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z,true)
		if distance <= 1.9 then
			if src.checkPermissao() then
				ToggleActionMenu()
			else
				TriggerEvent("Notify","negado","Você não tem permissão para acessar o arsenal.")
			end
		end
	end
end)