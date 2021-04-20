-----------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------
farM = Tunnel.getInterface("prod-ballas")
-----------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------
local procMachine = {
	{ 1,132.03,-1938.2,20.61 },
	{ 2,114.28,6360.26,32.305 }
}
-----------------------------------------------------------------------------------------------------------------------------------
-- MENU
-----------------------------------------------------------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------------------------------------------------
-- BUTTONS
-----------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "proc-adubo" then
		TriggerServerEvent("proc-adubo")
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
		menuactive = false

	elseif data == "proc-ferti" then
		TriggerServerEvent("proc-ferti")
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
		menuactive = false

	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------
-- ACTION
-----------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000

		local ped = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		for k,v in pairs(procMachine) do
			local bowz,cdz = GetGroundZFor_3dCoord(v[2],v[3],v[4])
			local distance = GetDistanceBetweenCoords(v[2],v[3],cdz,x,y,z,true)
			local procMachine = procMachine[k]

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),v[2],v[3],v[4],true) <= 1.6 then
				idle = 5
				text3D(v[2],v[3],v[4],"~g~E~w~  ABRIR")
			end
			
			if distance <= 1.5 then
				idle = 4
				if IsControlJustPressed(0,38) and farM.checkPermissao() then
					ToggleActionMenu()
				end
			end
		end
		Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
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
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,50)
end