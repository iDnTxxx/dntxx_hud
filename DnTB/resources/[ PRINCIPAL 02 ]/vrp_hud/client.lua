-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_hud",cRP)
vSERVER = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local hour = 0
local voice = 2
local minute = 0
local month = ""
local fome = 0
local sede = 0
local dayMonth = 0
local varDay = "th"
local showHud = true
local showMovie = false
local showRadar = true
local sBuffer = {}
local seatbelt = false
local ExNoCarro = false
local timedown = 0
local talking = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- GCPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
local menu_celular = false
RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	menu_celular = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusFome")
AddEventHandler("statusFome",function(number)
	fome = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusSede")
AddEventHandler("statusSede",function(number)
	sede = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUDACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hudActived")
AddEventHandler("hudActived",function()
	showHud = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHUD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if IsPauseMenuActive() or IsScreenFadedOut() or menu_celular then
			SendNUIMessage({ hud = false, movie = false })
		else
			local ped = PlayerPedId()
			local armour = GetPedArmour(ped)
			local health = math.floor((GetEntityHealth(ped)-100)/(GetEntityMaxHealth(ped)-100)*100) + 1
			local stamina = GetPlayerSprintStaminaRemaining(PlayerId())
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))


			if dayOfMonth == 1 then
				varDay = "st"
			elseif dayOfMonth == 2 then
				varDay = "nd"
			elseif dayOfMonth == 3 then
				varDay = "rd"
			else
				varDay = "th"
			end

			local ped = PlayerPedId()
			local car = GetVehiclePedIsIn(ped)

			if not showHud then 
				showRadar = false 
			end

			if IsPedOnAnyBike(ped) then
				showRadar = false
			end
			
			if  not IsPedInAnyVehicle(ped) then 
				showRadar = false
				DisplayRadar(showRadar)
			end

			if IsPedInAnyVehicle(ped) then 
				showRadar = true
				DisplayRadar(showRadar)
			end

			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)

				local fuel = GetVehicleFuelLevel(vehicle)
				local vidadocarro = GetVehicleEngineHealth(vehicle)

				local speed = GetEntitySpeed(vehicle) * 3.4

				SendNUIMessage({ hud = showHud, movie = showMovie, car = true, day = dayMonth..varDay, month = month, hour = hour, minute = minute, street = street, radio = radioDisplay, voice = voice, talking = talking, health = parseInt(health), armour = parseInt(armour), sede = parseInt(sede), fome = parseInt(fome), stamina = parseInt(stamina), fuel = parseInt(fuel), speed = parseInt(speed), seatbelt = seatbelt, vidadocarro = vidadocarro })
			else
				SendNUIMessage({ hud = showHud, movie = showMovie, car = false, day = dayMonth..varDay, month = month, hour = hour, minute = minute, street = street, radio = radioDisplay, voice = voice, talking = talking, health = parseInt(health), armour = parseInt(armour), sede = parseInt(sede), fome = parseInt(fome), stamina = parseInt(stamina)})

			
			end
		end

		Citizen.Wait(2500)
	end
end)
RegisterCommand('seat', function(source, args, rawCmd)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then	
		local carrinhu = GetVehiclePedIsIn(ped, false)
		if not CintoSeguranca then
			if args[1] then
				local acento = parseInt(args[1])
				
				if acento == 1 then
					if IsVehicleSeatFree(carrinhu, -1) then 
						if GetPedInVehicleSeat(carrinhu, 0) == ped then
							SetPedIntoVehicle(ped, carrinhu, -1)
						else
							TriggerEvent('Notify', 'negado',"Negado", 'Você só pode passar para o P1 a partir do P2.')
						end
					else
						TriggerEvent('Notify', 'negado',"Negado", 'O acento deve estar livre.')
					end
				elseif acento == 2 then
					if IsVehicleSeatFree(carrinhu, 0) then 
						if GetPedInVehicleSeat(carrinhu, -1) == ped then
							SetPedIntoVehicle(ped, carrinhu, 0)
						else
							TriggerEvent('Notify', 'negado',"Negado", 'Você só pode passar para o P2 a partir do P1.')
						end
					else
						TriggerEvent('Notify', 'negado',"Negado", 'O acento deve estar livre.')
					end
				elseif acento == 3 then
					if IsVehicleSeatFree(carrinhu, 1) then 
						if GetPedInVehicleSeat(carrinhu, 2) == ped then
							SetPedIntoVehicle(ped, carrinhu, 1)
						else
							TriggerEvent('Notify', 'negado',"Negado", 'Você só pode passar para o P3 a partir do P4.')
						end
					else
						TriggerEvent('Notify', 'negado',"Negado", 'O acento deve estar livre.')
					end
				elseif acento == 4 then
					if IsVehicleSeatFree(carrinhu, 2) then 
						if GetPedInVehicleSeat(carrinhu, 1) == ped then
							SetPedIntoVehicle(ped, carrinhu, 2)
						else
							TriggerEvent('Notify', 'negado',"Negado", 'Você só pode passar para o P4 a partir do P3.')
						end
					else
						TriggerEvent('Notify', 'negado',"Negado", 'O acento deve estar livre.')
					end
				end
			else
				TriggerEvent('Notify', 'negado',"Negado", 'Especifique o acento que quer ir!')
			end
		else
			TriggerEvent('Notify', 'negado',"Negado", 'Você não pode utilizar esse comando com o cinto de segurança!')
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANDAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("homem",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@confident")
end)

RegisterCommand("mulher",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@heels@c")
end)

RegisterCommand("depressivo",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@depressed@a")
end)

RegisterCommand("depressiva",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@depressed@a")
end)

RegisterCommand("empresario",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@business@a")
end)

RegisterCommand("determinado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@brave@a")
end)

RegisterCommand("descontraido",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@casual@a")
end)

RegisterCommand("farto",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@fat@a")
end)

RegisterCommand("estiloso",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@hipster@a")
end)

RegisterCommand("ferido",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@injured")
end)

RegisterCommand("nervoso",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@hurry@a")
end)

RegisterCommand("desleixado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@hobo@a")
end)

RegisterCommand("infeliz",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@sad@a")
end)

RegisterCommand("musculoso",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@muscle@a")
end)

RegisterCommand("desligado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@shadyped@a")
end)

RegisterCommand("fadiga",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@buzzed")
end)

RegisterCommand("apressado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@hurry_butch@a")
end)

RegisterCommand("descolado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@money")
end)

RegisterCommand("corridinha",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@quick")
end)

RegisterCommand("piriguete",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@maneater")
end)

RegisterCommand("petulante",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@sassy")
end)

RegisterCommand("arrogante",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@arrogant@a")
end)

RegisterCommand("bebado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@drunk@slightlydrunk")
end)

RegisterCommand("bebado2",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@drunk@verydrunk")
end)

RegisterCommand("bebado3",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@drunk@moderatedrunk")
end)

RegisterCommand("irritado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@fire")
end)

RegisterCommand("intimidado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_m@intimidation@cop@unarmed")
end)

RegisterCommand("poderosa",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@handbag")
end)

RegisterCommand("chateado",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@injured")
end)

RegisterCommand("estilosa",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@posh@")
end)

RegisterCommand("sensual",function(source,args)
	movimento = true
	vRP.loadAnimSet("move_f@sexy@a")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function(source,args)
	showHud = not showHud
	showRadar = not showRadar
--	print(showRadar)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVIE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("movie",function(source,args)
	showMovie = not showMovie
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHEALTHREDUCE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local health = GetEntityHealth(ped)

		if health > 101 then
			if fome >= 80 and fome <= 90 then
				SetFlash(0,0,500,1000,500)
				SetEntityHealth(ped,health-1)
			elseif fome > 90 then
				SetFlash(0,0,500,1000,500)
				SetEntityHealth(ped,health-2)
			end

			if sede >= 80 and sede <= 90 then
				SetFlash(0,0,500,1000,500)
				SetEntityHealth(ped,health-1)
			elseif sede > 90 then
				SetFlash(0,0,500,1000,500)
				SetEntityHealth(ped,health-2)
			end
		end

		Citizen.Wait(6000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
end

Citizen.CreateThread(function()
	while true do
		local dntxx = 5000
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			ExNoCarro = true
			if seatbelt then
				DisableControlAction(0,75)
			end

			dntxx = 5
			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not seatbelt and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				SetEntityHealth(ped,GetEntityHealth(ped)-10)
				TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),4160)
				timedown = 10
			end

			if IsControlJustReleased(1,73) then
				if seatbelt then
					TriggerEvent("vrp_sound:source","unbelt",0.5)
					showRadar = true
					seatbelt = false
				else
					TriggerEvent("vrp_sound:source","belt",0.5)
					seatbelt = true
					showRadar = true
				end
			end

			if IsPedOnAnyBike(ped) then
				showRadar = true
			end

			if not seatbelt and not showHud then 
				showRadar = true
			end

		elseif ExNoCarro then
			ExNoCarro = false
			seatbelt = false
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end
		DisplayRadar(showRadar)
		Citizen.Wait(dntxx)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4250)
		local ped = PlayerPedId()
		if timedown > 0 and GetEntityHealth(ped) > 101 then
			timedown = timedown - 1
			if timedown <= 1 then
				TriggerServerEvent("vrp_inventory:Cancel")
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RAGDOLL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		local ped = PlayerPedId()
		if timedown > 1 and GetEntityHealth(ped) > 101 then
			if not IsEntityPlayingAnim(ped,"anim@heists@ornate_bank@hostages@hit","hit_react_die_loop_ped_a",3) then
				vRP.playAnim(false,{"anim@heists@ornate_bank@hostages@hit","hit_react_die_loop_ped_a"},true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 3000
		if timedown > 0 then
			dntxx = 3
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,105,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,20,true)
			DisableControlAction(0,29,true)
		end
		Citizen.Wait(dntxx)
	end
end)

