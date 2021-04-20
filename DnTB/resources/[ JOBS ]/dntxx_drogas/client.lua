---@diagnostic disable: undefined-global
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
emP = Tunnel.getInterface("dntxx_drogas")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local entregando = false
local selecionado = 0
local quantidade = 0

local pontos = {
	{ 46.71,-1749.62,29.64 },
}

local locs = {
	[1] = { ['x'] = 327.12, ['y'] = -1258.71, ['z'] = 32.11 },
	[2] = { ['x'] = 857.59, ['y'] = -1038.39, ['z'] = 33.14 },
	[3] = { ['x'] = 105.23, ['y'] = -259.03, ['z'] = 51.5 },
	[4] = { ['x'] = -178.72, ['y'] = 314.34, ['z'] = 97.97 },
	[5] = { ['x'] = -1321.87, ['y'] = -247.55, ['z'] = 42.47 },
	[6] = { ['x'] = -1286.95, ['y'] = -833.34, ['z'] = 17.1 },
	[7] = { ['x'] = -762.81, ['y'] = -1310.56, ['z'] = 9.6 },
	[8] = { ['x'] = -289.26, ['y'] = -1080.56, ['z'] = 23.03 },
	[9] = { ['x'] = 355.0, ['y'] = -1282.57, ['z'] = 32.53 },
	[10] = { ['x'] = 746.82, ['y'] = -1399.34, ['z'] = 26.63 },
	[11] = { ['x'] = 889.78, ['y'] = -1045.8, ['z'] = 35.18 },
	[12] = { ['x'] = 910.68, ['y'] = -1065.39, ['z'] = 37.95 },
	[13] = { ['x'] = 1250.85, ['y'] = -515.36, ['z'] = 69.35 },
	[14] = { ['x'] = 642.39, ['y'] = 260.35, ['z'] = 103.3 },
	[15] = { ['x'] = -326.08, ['y'] = -54.57, ['z'] = 49.04 },
	[16] = { ['x'] = -490.25, ['y'] = 28.46, ['z'] = 46.3 },
	[17] = { ['x'] = -1118.01, ['y'] = -185.79, ['z'] = 38.55 },
	[18] = { ['x'] = -211.55, ['y'] = -787.22, ['z'] = 30.92 },
	[19] = { ['x'] = -319.82, ['y'] = -1389.73, ['z'] = 36.51 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 1200
		for _,mark in pairs(pontos) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 30 then
				dntxx = 4
				DrawMarker(21,x,y,z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,255,0,50,0,0,0,1)
				if not entregando then
					if distance <= 1.0 then
						drawTxt("PRESSIONE  ~y~E~w~  PARA INICIAR AS ENTREGAS",4,0.5,0.92,0.35,255,255,255,180)
						if IsControlJustPressed(0,38) then
							entregando = true
							selecionado = math.random(#locs)
							CriandoBlip(locs,selecionado)
							emP.Quantidade()
						end
					end
				end
			end
		end
		Citizen.Wait(dntxx)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ STATUS ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("quantidade-drogas")
AddEventHandler("quantidade-drogas",function(status)
    quantidade = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local dntxx = 1200
		if entregando then
			dntxx = 4
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 30.0 then
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,255,0,50,0,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~y~E~w~  PARA ENTREGAR AS DROGAS",4,0.5,0.92,0.35,255,255,255,180)
					if IsControlJustPressed(0,38) then
						if emP.checkPayment() then

							porcentagem = math.random(100)
							if porcentagem >= 80 then
								emP.MarcarOcorrencia()
							end

							RemoveBlip(blips)
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
									selecionado = math.random(#locs)
								else
									break
								end
								Citizen.Wait(1)
							end
							CriandoBlip(locs,selecionado)
							emP.Quantidade()
						end
					end
				end
			end

			if entregando then
				drawTxt("~y~PRESSIONE ~r~F7 ~w~PARA FINALIZAR A ROTA",4,0.230,0.905,0.35,255,255,255,200)
				drawTxt("VÁ ATÉ O DESTINO E VENDA ~g~"..quantidade.."x~w~ DROGAS",4,0.230,0.93,0.35,255,255,255,200)
			  end
			  
			if IsControlJustPressed(0,168) then
				entregando = false
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
	AddTextComponentString("Entrega de Drogas")
	EndTextCommandSetBlipName(blips)
end
