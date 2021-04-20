-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = Tunnel.getInterface("muni-producao")
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAIN MENU
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
local onmenu = false

function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "produzir-m-ak103" then
		TriggerServerEvent("produzir-municao","m-ak103")

	elseif data == "produzir-m-five" then
		TriggerServerEvent("produzir-municao","m-five")

	elseif data == "produzir-m-tec9" then
		TriggerServerEvent("produzir-municao","m-tec9")

	elseif data == "produzir-m-mp5mk2" then
		TriggerServerEvent("produzir-municao","m-mp5mk2")
		
	elseif data == "produzir-mshot" then
		TriggerServerEvent("produzir-municao","mshot")

	elseif data == "produzir-m-g36c" then
		TriggerServerEvent("produzir-municao","m-g36c")

	elseif data == "fechar" then
		ToggleActionMenu()
		onmenu = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("fechar-nui-municoes")
AddEventHandler("fechar-nui-municoes", function()
	ToggleActionMenu()
	onmenu = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{ 574.19,-3127.13,18.77 },
	{ 1070.03,-2006.81,32.09 }
}

RegisterCommand('fmunicao',function(source,args)
	SetNuiFocus(false,false)
		for _,mark in pairs(marcacoes) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 2.6 then
				if src.checkPermissao() then
					ToggleActionMenu()
				else
					TriggerEvent('Notify','negado','Você não tem permissão para isso.')
				end
			end
		end
end)