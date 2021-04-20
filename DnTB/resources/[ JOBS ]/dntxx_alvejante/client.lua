local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("dntxx_alvejante")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emservico = false
local CoordenadaX = 37.82
local CoordenadaY = -1403.64
local CoordenadaZ = 29.34
local timers = 0
local payment = 0

-- 37.82, -1403.64, 29.34
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local entregas = {
    [1] = {-1336.14,-407.7,36.51}, -- ROTA BAHAMAS
    [2] = {-1200.22,-156.26,40.1},
    [3] = {461.82,-277.29,48.71},
    [4] = {1083.44,-351.63,67.1},
    [5] = {1043.62,190.35,81.0},
    [6] = {2601.16,2804.09,33.83},
    [7] = {2741.96,4412.74,48.63},
    [8] = {1705.99,6425.56,32.77},
    [9] = {-162.43,6189.51,31.44},
    [10] = {-2218.6,4229.55,47.4},
    [11] = {-3147.19,1121.29,20.87},
    [12] = {-904.67,780.17,186.45},
    [13] = {655.45,588.7,129.06},
    [14] = {756.31,-557.79,33.65},
    [15] = {767.04,-1895.48,29.09},
    [16] = {262.08,-1822.19,26.88},
    [17] = {-289.11,-1080.96,23.03},
    [18] = {-1378.03,-361.05,36.62},

    [19] = {-602.0,-347.46,35.25}, -- ROTA LIFEINVADER
    [20] = {-1286.07,-1386.67,4.45},
    [21] = {5.82,-985.48,29.36},
    [22] = {1230.94,-1083.36,38.53},
    [23] = {1620.49,-2258.28,106.68},
    [24] = {-621.3,-1640.59,25.98},
    [25] = {254.5,-1012.87,29.27},
    [26] = {1533.06,792.38,77.55},
    [27] = {1531.12,1727.9,109.93},
    [28] = {46.36,2789.05,57.88},
    [29] = {1361.23,3602.9,34.95},
    [30] = {1258.7,2739.79,38.85},
    [31] = {-42.28,1883.37,195.63},
    [32] = {-681.38,916.77,232.12},
    [33] = {-1305.59,240.17,58.99},
    [34] = {-2066.58,-312.17,13.26},
    [35] = {245.6,-677.46,37.76},
    [36] = {561.15,92.36,96.06},
    [37] = {-1197.25,-259.33,37.76},
    [38] = {-67.88,-205.93,45.81}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 4000
		if not emservico then
			dntxx = 4
			local ped = GetPlayerPed(-1)
			if not IsPedInAnyVehicle(ped) then
				dntxx = 4
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ)

				if distance <= 30.0 then
					dntxx = 4
					DrawMarker(27,CoordenadaX,CoordenadaY,CoordenadaZ-0.9,0,0,0,0.0,0,0,0.5,0.5,0.4,118, 210, 217,50,0,0,0,1)
					if distance <= 1.2 then
						dntxx = 4
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ROTA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) and emP.checkPermission() then
							dntxx = 4
							emservico = true
							destino = 1
							payment = 10
							CriandoBlip(entregas,destino)
						end
					end
				end
			end
		end
		Citizen.Wait(dntxx)
	end
end)

Citizen.CreateThread(function()
	while true do
		local dntxx = 2000
		if emservico then
			dntxx = 2
			drawTxt("PRESSIONE ~r~F7~w~ SE DESEJA FINALIZAR",4,0.227,0.915,0.448,255,255,255,220)
			drawTxt("VÁ ATÉ O DESTINO E COLETE OS ~g~COMPONENTES~w~.",4,0.252,0.941,0.48,255,255,255,220)
		end
		Citizen.Wait(dntxx)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 4000
		if emservico then
			dntxx = 4
			local ped = GetPlayerPed(-1)
			if not IsPedInAnyVehicle(ped) then
				dntxx = 4
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,entregas[destino][1],entregas[destino][2],entregas[destino][3])
				if distance <= 100.0 then
					dntxx = 4
					DrawMarker(21,entregas[destino][1],entregas[destino][2],entregas[destino][3]+0.60,0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
					if distance <= 1.3 then
						dntxx = 4
						drawTxt("PRESSIONE  ~b~E~w~  PARA CONTINUAR A ROTA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) then
							dntxx = 4
							RemoveBlip(blip)
							if destino == 40 then
								dntxx = 4
								emP.checkPayment(payment)
								destino = 1
								payment = 1
							else
								emP.checkPayment(payment,0)
								destino = destino + 1
							end
							CriandoBlip(entregas,destino)
						end
					end
				end
			end 
		end 
		Citizen.Wait(dntxx)
	end 
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(8500)
		if emservico then
			if timers > 0 then
				timers = timers - 5
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 4000
		if emservico then
			dntxx = 4
			if IsControlJustPressed(1,168) then
				dntxx = 4
				emservico = false
				RemoveBlip(blip)
				TriggerEvent("Notify","sucesso","Sucesso","Rota Finalizada.",5000)
			end
		end
		Citizen.Wait(dntxx)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCOES
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

function CriandoBlip(entregas,destino)
	blip = AddBlipForCoord(entregas[destino][1],entregas[destino][2],entregas[destino][3])
	SetBlipSprite(blip,1)
	SetBlipColour(blip,18)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rota de Munições")
	EndTextCommandSetBlipName(blip)
end