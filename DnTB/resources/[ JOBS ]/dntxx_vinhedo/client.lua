local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("dntxx_vinhedo")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
local list = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORDENADAS DAS UVAS
-----------------------------------------------------------------------------------------------------------------------------------------
local uvas = {
	{1,-1834.92, 2066.51, 137.06},
	{2,-1832.42, 2068.04, 136.69},
	{3,-1829.06, 2070.22, 136.27},
	{4,-1819.27, 2075.43, 134.23},
	{5,-1816.37, 2077.33, 133.66},
	{6,-1810.26, 2080.86, 132.6},
	{7,-1806.21, 2083.36, 131.88},
	{8,-1802.21, 2085.72, 131.15},
	{9,-1794.16, 2089.89, 129.04},
	{10,-1786.99, 2094.2, 127.56},
	{11,-1781.06, 2097.6, 126.24},
	{12,-1774.06, 2101.93, 124.52},
	{13,-1767.5, 2105.55, 122.81},
	{14,-1759.88, 2110.32, 120.52},
	{15,-1751.5, 2109.61, 117.41},
	{16,-1755.15, 2107.52, 118.36},
	{17,-1759.89, 2104.57, 119.65},
	{18,-1762.13, 2103.39, 120.33},
	{19,-1768.56, 2099.83, 122.33},
	{20,-1777.41, 2094.74, 124.75},
	{21,-1784.85, 2090.12, 126.47},
	{22,-1788.08, 2088.12, 127.25},
	{23,-1794.65, 2084.76, 128.74},
	{24,-1798.88, 2082.42, 129.85},
	{25,-1807.94, 2077.3, 131.81},
	{26,-1814.45, 2073.55, 133.0},
	{27,-1830.52,2063.86,136.39},
	{28,-1827.73,2065.41,135.97},
	{29,-1824.67,2067.43,135.43},
	{30,-1819.81,2070.31,134.27},
	{31,-1803.58,2079.7,130.93}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 1000
		if not processo then
			for _,func in pairs(uvas) do
				local ped = PlayerPedId()
				local i,x,y,z = table.unpack(func)
				local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),x,y,z)
				if distance <= 50 and list[i] == nil then
					dntxx = 5
					DrawMarker(21,x,y,z,0,0,0,0,180.0,130.0,0.6,0.8,0.5,102,0,102,150,1,0,0,1)
					if distance <= 1.2 then
						dntxx = 5
						drawTxt("PRESSIONE  ~g~E~w~  PARA COLETAR UVA",4,0.5,0.93,0.50,255,255,255,180)
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
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR A EXTRAÇÃO DE UVA",4,0.5,0.93,0.50,255,255,255,180)
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
local CoordenadaX = -1856.87               
local CoordenadaY = 2061.37
local CoordenadaZ = 141.01
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
		local dntxx = 1000
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
					drawTxt("PRESSIONE  ~p~G~w~  PARA ENTREGAR UVAS",4,0.5,0.93,0.50,255,255,255,255)
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
		local dntxx = 1000
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
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Uvas")
	EndTextCommandSetBlipName(blips)
end
