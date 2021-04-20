local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("nav_radio")
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

RegisterNetEvent("radio:outServers")
AddEventHandler("radio:outServers",function()
    outServers()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if emP.checkRadio2() then
		outServers()
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "policiastd" then
		if emP.checkPermission2("policia.permissao","Policia STD 1") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1018)
		end
	elseif data == "policiatid" then
		if emP.checkPermission2("policia.permissao","Policia - STD 2") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1019)
		end
	elseif data == "policiatod" then
		if emP.checkPermission2("policia.permissao","Policia C.O.D") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1020)
		end
	elseif data == "policiaemacao" then
		if emP.checkPermission2("toogle2.permissao","Policia em ação") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1021)
		end	
	elseif data == "paramedico" then
		if emP.checkPermission2("paramedico.permissao","Paramédicos") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1022)
		end
	elseif data == "mecanico" then
		if emP.checkPermission2("mecanico.permissao","Mecânicos") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1023)
		end
	elseif data == "ballas" then
		if emP.checkPermission2("ballas.permissao","Ballas") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1024)
		end	
	elseif data == "vagos" then
		if emP.checkPermission2("vagos.permissao","Vagos") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1025)
		end		
	elseif data == "families" then
		if emP.checkPermission2("grove.permissao","Families") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1026)
		end	
	elseif data == "bloods" then
		if emP.checkPermission2("blood.permissao","Bloods") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1027)
		end
	elseif data == "crips" then
		if emP.checkPermission2("crips.permissao","Crips") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1028)
		end
	elseif data == "bratva" then
		if emP.checkPermission2("brt.permissao","Bratva") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1029)
		end
	elseif data == "triade" then
		if emP.checkPermission2("mafia.permissao","Triade") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1030)
		end
	elseif data == "bahamas" then
		if emP.checkPermission2("bahamas.permissao","Bahamas") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1030)
		end
	elseif data == "motoclub" then
		if emP.checkPermission2("motoclub.permissao","MotoClub") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1030)
		end
	elseif data == "lifeinvader" then
		if emP.checkPermission2("lifeinvader.permissao","LifeInvader") then
			outServers()
			exports.tokovoip_script:addPlayerToRadio(1030)
		end
	elseif data == "desconectar" then
		outServers()
		TriggerEvent("Notify","sucesso","Desconectou de todos os canais.")
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("radio",function(source,args)
	if GetEntityHealth(PlayerPedId()) > 101 then
		if emP.checkRadio() then
		ToggleActionMenu()
		end
	else
		TriggerEvent("Notify","negado","Você não pode fazer isso em coma.")	
    end
end)

RegisterCommand("radiof",function(source,args)
	if GetEntityHealth(PlayerPedId()) > 101 then
	if args[1] then
		if parseInt(args[1]) < 1017 then
        	if emP.checkRadio() then
				if emP.checkPermission() then
                	outServers()
                	exports.tokovoip_script:addPlayerToRadio(parseInt(args[1]))
					TriggerEvent("Notify","sucesso","Você entrou na Frequência <b>"..args[1].."</b> do rádio.",8000)
				end
			end
		else
			TriggerEvent("Notify","negado","Você não tem permissão.")
		end
	end
else
	TriggerEvent("Notify","negado","Você não pode fazer isso em coma.")	
    end
end)

RegisterCommand("radiod",function(source,args)
    if emP.checkRadio() then
		if emP.checkPermission() then
			outServers()
		    TriggerEvent("Notify","sucesso","Você desconectou de todos os canais.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTSERVERS
-----------------------------------------------------------------------------------------------------------------------------------------
function outServers()
	local i = 0
    while i < 1036 do
      if exports.tokovoip_script:isPlayerInChannel(i) == true then
		exports.tokovoip_script:removePlayerFromRadio(i)
	  end	
      i = i + 1
    end
end