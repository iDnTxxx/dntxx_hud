local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("nav_arsenal",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") then
        return true
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('nav_arsenal:Radio')
AddEventHandler('nav_arsenal:Radio', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRP.giveInventoryItem(user_id,"radio",1)
			TriggerClientEvent("Notify",source,"sucesso","Você pegou radio 1x.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARSENAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('nav_arsenal:KIT')
AddEventHandler('nav_arsenal:KIT', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_STUNGUN"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_FLASHLIGHT"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_NIGHTSTICK"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_FIREEXTINGUISHER"] = { ammo = 0 }})
			TriggerClientEvent("Notify",source,"sucesso","Você pegou Kit Basico.")
		end
	end
end)

RegisterServerEvent('nav_arsenal:GLOCK')
AddEventHandler('nav_arsenal:GLOCK', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_COMBATPISTOL"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('nav_arsenal:DESERT')
AddEventHandler('nav_arsenal:DESERT', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_HEAVYPISTOL"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('nav_arsenal:SIG')
AddEventHandler('nav_arsenal:SIG', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_COMBATPDW"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('nav_arsenal:M4A1')
AddEventHandler('nav_arsenal:M4A1', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_CARBINERIFLE"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('nav_arsenal:MPX')
AddEventHandler('nav_arsenal:MPX', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_CARBINERIFLE_MK2"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('nav_arsenal:DOZE')
AddEventHandler('nav_arsenal:DOZE', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_PUMPSHOTGUN"] = { ammo = 250 }})
		end
	end
end)
