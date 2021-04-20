local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

emP = Tunnel.getInterface("nav_contrabando")
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
	if data == "utilidades-comprar-placa" then
		TriggerServerEvent("contrabando-comprar","placa")
	elseif data == "utilidades-comprar-keycard" then
		TriggerServerEvent("contrabando-comprar","keycard")
	elseif data == "utilidades-comprar-c4" then
		TriggerServerEvent("contrabando-comprar","c4")
	--elseif data == "utilidades-comprar-algemas" then
		--TriggerServerEvent("contrabando-comprar","algemas")
	elseif data == "utilidades-comprar-masterpick" then
		TriggerServerEvent("contrabando-comprar","masterpick")
	elseif data == "utilidades-comprar-lockpick" then
		TriggerServerEvent("contrabando-comprar","lockpick")
	elseif data == "utilidades-comprar-pendrive" then
		TriggerServerEvent("contrabando-comprar","pendrive")
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local dntxx = 500
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),978.61,-91.96,74.85,true)
		if distance <= 3 then
			dntxx = 5
			DrawMarker(21,978.61, -91.96, 74.85-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,0,191,255,50,0,0,0,1)
			if distance <= 1.1 then
				if IsControlJustPressed(0,38) and emP.checkPermission() then
					ToggleActionMenu()
				end
			end
		end
		Citizen.Wait(dntxx)
	end
end)