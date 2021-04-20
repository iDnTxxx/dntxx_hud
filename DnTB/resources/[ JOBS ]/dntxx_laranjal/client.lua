local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("dntxx_laranjal")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
local list = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORDENADAS DAS LARANJAS
-----------------------------------------------------------------------------------------------------------------------------------------
local laranjas = {
	{1,378.11, 6504.98, 27.96},
	{2,370.34, 6504.8, 28.4},
	{3,363.37, 6504.62, 28.53},
	{4,355.65, 6503.75, 28.44},
	{5,347.97, 6504.42, 28.8},
	{6,339.92, 6504.07, 28.71},
	{7,330.92, 6504.27, 28.62},
	{8,321.82, 6504.32, 29.21},
	{9,321.72, 6516.23, 29.13},
	{10,330.26, 6516.44, 28.97},
	{11,338.69, 6516.04, 28.93},
	{12,347.55, 6515.85, 28.8},
	{13,355.37, 6516.19, 28.22},
	{14,362.55, 6516.85, 28.27},
	{15,369.89, 6516.53, 28.38},
	{16,378.01, 6516.3, 28.36},
	{17,369.48, 6530.67, 28.43},
	{18,361.51, 6530.42, 28.4},
	{19,353.97, 6529.69, 28.45},
	{20,345.97, 6530.14, 28.75},
	{21,338.53, 6529.92, 28.57},
	{22,329.59, 6530.08, 28.62},
	{23,321.95, 6530.14, 29.19}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 1000
		if not processo then
			for _,func in pairs(laranjas) do
				local ped = PlayerPedId()
				local i,x,y,z = table.unpack(func)
				local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),x,y,z)
				if distance <= 50 and list[i] == nil then
					dntxx = 5
					DrawMarker(21,x,y,z,0,0,0,0,180.0,130.0,0.6,0.8,0.5,255,165,0,150,1,0,0,1)
					if distance <= 1.2 then
						dntxx = 5
						drawTxt("PRESSIONE  ~g~E~w~  PARA COLETAR LARANJA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							if emP.checkFrutas() then
								list[i] = true
								processo = true
								segundos = 5
								SetEntityCoords(ped,x,y,z-1)
								SetEntityHeading(ped,32.78)
								vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}},true)
								TriggerEvent('cancelando',true)
							end
						end
					end
				end
			end
		end
		if processo then
			dntxx = 5
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR A EXTRAÇÃO DA LARANJA",4,0.5,0.93,0.50,255,255,255,180)
		end
		Citizen.Wait(dntxx)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if processo then
			if segundos > 0 then
				segundos = segundos - 1
				if segundos == 0 then
					processo = false
					vRP._stopAnim(false)
					TriggerEvent('cancelando',false)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(180000)
		list = {}
	end
end)

local blips = false
local servico = false
local selecionado = 1
local CoordenadaX = 408.28     
local CoordenadaY = 6497.6
local CoordenadaZ = 27.79
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = -458.83, ['y'] = 2861.69, ['z'] = 35.07},
	[2] = { ['x'] = 1477.65, ['y'] = 2724.77, ['z'] = 37.57},
	[3] = { ['x'] = 2679.82, ['y'] = 3280.9, ['z'] = 55.25},
	[4] = { ['x'] = 1701.62, ['y'] = 4931.09, ['z'] = 42.07},
	[5] = { ['x'] = 163.19, ['y'] = 6632.92, ['z'] = 31.62},
	[6] = { ['x'] = -2508.85, ['y'] = 3613.17, ['z'] = 13.79},
	[7] = { ['x'] = -3241.21, ['y'] = 1002.4, ['z'] = 12.84},
	[8] = { ['x'] = -1488.35, ['y'] = -377.92, ['z'] = 40.17},
	[9] = { ['x'] = 374.2, ['y'] = 325.02, ['z'] = 103.57},
	[10] = { ['x'] = 1156.77, ['y'] = -326.09, ['z'] = 69.21},
	[11] = { ['x'] = -242.18, ['y'] = 279.78, ['z'] = 92.04},
	[12] = { ['x'] = -1931.73, ['y'] = 362.45, ['z'] = 93.79},
	[13] = { ['x'] = -1825.34, ['y'] = 786.84, ['z'] = 138.26},
	[14] = { ['x'] = -2797.52, ['y'] = 1432.09, ['z'] = 100.93},
	[15] = { ['x'] = -1928.61, ['y'] = 1778.93, ['z'] = 173.04}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 1000
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 10.0 then
				dntxx = 5
				if distance <= 1.2 then
					dntxx = 5
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						dntxx = 5
						servico = true
						selecionado = 1
						CriandoBlip(locs,selecionado)
					end
				end
			end
		end
		Citizen.Wait(dntxx)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 10000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 15.0 then
				dntxx = 5
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z,0,0,0,0,0,0,0.5, 0.5, 0.5, 111, 3, 252, 150,1,0,0,1)
				if distance <= 1.2 then
					dntxx = 5
					drawTxt("PRESSIONE  ~b~G~w~  PARA ENTREGAR LARANJAS",4,0.5,0.93,0.50,255,255,255,255)
					if IsControlJustPressed(0,47) and not IsPedInAnyVehicle(ped, false) then
						dntxx = 5
						if emP.checkPayment() then
							RemoveBlip(blips)
							selecionado = selecionado + 1
							if selecionado == (#locs+1) then selecionado = 1 end
							CriandoBlip(locs,selecionado)
						end
					end
				end
			end
		end
		Citizen.Wait(dntxx)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 10000
		if servico then
			dntxx = 5
			if IsControlJustPressed(0,168) then
				dntxx = 5
				servico = false
				RemoveBlip(blips)
			end
		end
		Citizen.Wait(dntxx)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
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

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,9)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Laranjas")
	EndTextCommandSetBlipName(blips)
end
