local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fan_radar = Tunnel.getInterface("cl_radar")

local multar = false
local flash = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADAR
----------------------------------------------------------------------------------------------------------------------------------------
local radares = {  
	{ ['x'] = 172.01, ['y'] = -1025.15, ['z'] = 29.38, ['m'] = 220 }, --PRAÇA
	{ ['x'] = 297.23, ['y'] = -486.86, ['z'] = 43.38, ['m'] = 220 }, --HOSPITAL
}


Citizen.CreateThread(function()
	while true do
		local dntxx = 1000
		for v,k in pairs(radares) do
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			local driver = GetPedInVehicleSeat(vehicle, -1)
			local distance = GetDistanceBetweenCoords(k.x,k.y,k.z,GetEntityCoords(ped),true)
			local speed = GetEntitySpeed(vehicle)*3.6
			if distance <= 19.0 and driver == ped then
				dntxx = 5
				if speed >= k.m and fan_radar.checkperm() and not multa then 
					TriggerEvent("Notify","importante","<b>Radar</b> "..k.m.." KM/H<br> Você está livre do radar, obrigado por seus serviços")
					multa = true
					SetTimeout(1000,function()
						multa = false
					end)
				end

				if speed >= k.m and not fan_radar.checkperm() then
					if not flash then
						flash = true
						PlaySoundFrontend( -1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1 )
						vRP.setDiv("radar",".div_radar { background: #fff; margin: 0; width: 100%; height: 100%; opacity: 0.9; }","")
						SetTimeout(20,function()
							vRP.removeDiv("radar")
						end)
					end
					if not multa then
						multa = true
						flash = false
						multa = false
						calculo = 4000
						fan_radar.checarMulta(calculo)
						vRP.removeDiv("radar")
						TriggerEvent("Notify","aviso","<b>Multa</b> <br>Você foi multado por alta velocidade em: <b>$"..parseInt(calculo).." dólares.</b>")
					end
				end
			end
		end
		Citizen.Wait(dntxx)
	end
end)

Citizen.CreateThread(function()
	for v, k in pairs(radares) do
		posblip = AddBlipForCoord(k.x, k.y, k.z)
		SetBlipSprite(posblip,184)
		SetBlipScale(posblip,0.4)
		SetBlipColour(posblip,0)
		SetBlipAsShortRange(posblip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Radar 220KM/H")
		EndTextCommandSetBlipName(posblip)
	end
end)