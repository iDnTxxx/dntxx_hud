local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENT P
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsControlJustPressed(0,11) then
            TriggerServerEvent('police:Pressed')
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /RMASCARA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rmascara")
AddEventHandler("rmascara",function()
	SetPedComponentVariation(PlayerPedId(),1,0,0,2)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /RCHAPEU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rchapeu")
AddEventHandler("rchapeu",function()
	ClearPedProp(PlayerPedId(),0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET & REMOVE ALGEMAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("setalgemas")
AddEventHandler("setalgemas",function()
	local ped = PlayerPedId()
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,7,41,0,2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,7,25,0,2)
	end
end)
RegisterNetEvent("removealgemas")
AddEventHandler("removealgemas",function()
	SetPedComponentVariation(PlayerPedId(),7,0,0,2)
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR
--------------------------------------------------------------------------------------------------------------------------------------------------
other = nil
drag = false
carregado = false
RegisterNetEvent("carregar")
AddEventHandler("carregar",function(p1)
    other = p1
    drag = not drag
end)

Citizen.CreateThread(function()
    while true do
    	local dntxx = 1500
		if drag and other then
			dntxx = 5
			local ped = GetPlayerPed(GetPlayerFromServerId(other))
			Citizen.InvokeNative(0x6B9BBD38AB0796DF,PlayerPedId(),ped,4103,11816,0.48,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
			carregado = true
        else
			if carregado then
				dntxx = 5
				DetachEntity(PlayerPedId(),true,false)
				carregado = false
			end
		end
		Citizen.Wait(dntxx)
	end
end)

Citizen.CreateThread(function()
	while true do
		local dntxx = 1500
		if not IsPedInAnyVehicle(PlayerPedId()) then
			dntxx = 5
			if IsControlJustPressed(0,47) then
				TriggerServerEvent("vrp_policia:algemar")
			end
			if IsControlJustPressed(0,74) then
				TriggerServerEvent("vrp_policia:carregar")
			end
		end
		Citizen.Wait(dntxx)
	end
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1000)		
		if IsControlJustPressed(0,165) then
		TriggerServerEvent("vrp_policia:p")
		end		
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
local blacklistedWeapons = {
	"WEAPON_UNARMED",
	"WEAPON_DAGGER",
	"WEAPON_BAT",
	"WEAPON_BOTTLE",
	"WEAPON_CROWBAR",
	"WEAPON_FLASHLIGHT",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_HATCHET",
	"WEAPON_KNUCKLE",
	"WEAPON_KNIFE",
	"WEAPON_MACHETE",
	"WEAPON_SWITCHBLADE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_WRENCH",
	"WEAPON_BATTLEAXE",
	"WEAPON_POOLCUE",
	"WEAPON_STONE_HATCHET",
	"WEAPON_STUNGUN",
	"WEAPON_FLARE",
	"GADGET_PARACHUTE",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_PETROLCAN",
	"WEAPON_FIREWORK",
	"WEAPON_SNOWBALL",
	"WEAPON_BZGAS",
	"WEAPON_MUSKET"
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		local blacklistweapon = false
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

		for k,v in ipairs(blacklistedWeapons) do
			if GetSelectedPedWeapon(ped) == GetHashKey(v) then
				blacklistweapon = true
			end
		end

		if IsPedShooting(ped) and not blacklistweapon then
			TriggerServerEvent('atirando',x,y,z)
		end

		blacklistweapon = false
	end
end)

local blips = {}
RegisterNetEvent('notificacao')
AddEventHandler('notificacao',function(x,y,z,user_id)
	--local distance = GetDistanceBetweenCoords(x,y,z,-186.1,-893.5,29.3,true)
	--if distance <= 2100 then
		if not DoesBlipExist(blips[user_id]) then
			PlaySoundFrontend(-1,"Enter_1st","GTAO_FM_Events_Soundset",false)
			TriggerEvent('chatMessage',"Dispatch",{65,130,255},"Disparos de arma de fogo aconteceram, verifique o ocorrido.")
			blips[user_id] = AddBlipForCoord(x,y,z)
			SetBlipScale(blips[user_id],0.5)
			SetBlipSprite(blips[user_id],10)
			SetBlipColour(blips[user_id],49)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Disparos de arma de fogo")
			EndTextCommandSetBlipName(blips[user_id])
			SetBlipAsShortRange(blips[user_id],false)
			SetTimeout(30000,function()
				if DoesBlipExist(blips[user_id]) then
					RemoveBlip(blips[user_id])
				end
			end)
		end
	--end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONE
-----------------------------------------------------------------------------------------------------------------------------------------
local cone = nil
RegisterNetEvent('cone')
AddEventHandler('cone',function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.0,-0.94)
	local prop = "prop_mp_cone_02"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		cone = CreateObject(GetHashKey(prop),coord.x,coord.y-0.5,coord.z,true,true,true)
		PlaceObjectOnGroundProperly(cone)
		SetModelAsNoLongerNeeded(cone)
		Citizen.InvokeNative(0xAD738C3085FE7E11,cone,true,true)
		SetEntityHeading(cone,h)
		FreezeEntityPosition(cone,true)
		SetEntityAsNoLongerNeeded(cone)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),true) then
			cone = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),false,false,false)
			Citizen.InvokeNative(0xAD738C3085FE7E11,cone,true,true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(cone))
			DeleteObject(cone)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARREIRA
-----------------------------------------------------------------------------------------------------------------------------------------
local barreira = nil
RegisterNetEvent('barreira')
AddEventHandler('barreira',function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.5,-0.94)
	local prop = "prop_mp_barrier_02b"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		barreira = CreateObject(GetHashKey(prop),coord.x,coord.y-0.95,coord.z,true,true,true)
		PlaceObjectOnGroundProperly(barreira)
		SetModelAsNoLongerNeeded(barreira)
		Citizen.InvokeNative(0xAD738C3085FE7E11,barreira,true,true)
		SetEntityHeading(barreira,h-180)
		FreezeEntityPosition(barreira,true)
		SetEntityAsNoLongerNeeded(barreira)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),true) then
			barreira = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),false,false,false)
			Citizen.InvokeNative(0xAD738C3085FE7E11,barreira,true,true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(barreira))
			DeleteObject(barreira)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPIKE
-----------------------------------------------------------------------------------------------------------------------------------------
local spike = nil
RegisterNetEvent('spike')
AddEventHandler('spike',function(nome)
	local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,2.5,0.0)
	local prop = "p_ld_stinger_s"
	local h = GetEntityHeading(PlayerPedId())
	if nome ~= "d" then
		spike = CreateObject(GetHashKey(prop),coord.x,coord.y,coord.z,true,true,true)
		PlaceObjectOnGroundProperly(spike)
		SetModelAsNoLongerNeeded(spike)
		Citizen.InvokeNative(0xAD738C3085FE7E11,spike,true,true)
		SetEntityHeading(spike,h-180)
		FreezeEntityPosition(spike,true)
		SetEntityAsNoLongerNeeded(spike)
	else
		if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),true) then
			spike = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey(prop),false,false,false)
			Citizen.InvokeNative(0xAD738C3085FE7E11,spike,true,true)
			SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(spike))
			DeleteObject(spike)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1800)
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)
		local vcoord = GetEntityCoords(veh)
		local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.0,-0.94)
		if IsPedInAnyVehicle(PlayerPedId()) then
			if DoesObjectOfTypeExistAtCoords(vcoord.x,vcoord.y,vcoord.z,0.9,GetHashKey("p_ld_stinger_s"),true) then
				SetVehicleTyreBurst(veh,0,true,1000.0)
				SetVehicleTyreBurst(veh,1,true,1000.0)
				SetVehicleTyreBurst(veh,2,true,1000.0)
				SetVehicleTyreBurst(veh,3,true,1000.0)
				SetVehicleTyreBurst(veh,4,true,1000.0)
				SetVehicleTyreBurst(veh,5,true,1000.0)
				SetVehicleTyreBurst(veh,6,true,1000.0)
				SetVehicleTyreBurst(veh,7,true,1000.0)
				if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey("p_ld_stinger_s"),true) then
					spike = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey("p_ld_stinger_s"),false,false,false)
					Citizen.InvokeNative(0xAD738C3085FE7E11,spike,true,true)
					SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(spike))
					DeleteObject(spike)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BVIDA POR COORDENADAS
-----------------------------------------------------------------------------------------------------------------------------------------
local cds_bvida = {
    { 306.85,-588.18,43.3 },
    { 327.96,-591.05,43.3 }
}
Citizen.CreateThread(function()
    while true do
        local dntxx = 5000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        for k,v in pairs(cds_bvida) do
            local distance = Vdist(x,y,z,v[1],v[2],v[3])
            if distance <= 7 then
                dntxx = 5
                DrawMarker(21,v[1],v[2],v[3]-0.2,0,0,0,0.0,0,0,0.3,0.3,0.4,255,255,255,100,1,0,0,1)
				if distance <= 1.1 then
					dntxx = 5
                    drawTxt("PRESSIONE  ~b~E~w~  PARA BEBER ÁGUA SANTIFICADA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						FreezeEntityPosition(PlayerPedId(), true)
						TriggerEvent("emotes","beber7")
						Citizen.Wait(8000)
						vRP.stopAnim(false)
						vRP._DeletarObjeto()
						FreezeEntityPosition(PlayerPedId(), false)
						TriggerServerEvent('bvida')
                    end
                end
            end
        end
        Citizen.Wait(dntxx)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ PRISÃO ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local prisioneiro = false

RegisterNetEvent('prisioneiro')
AddEventHandler('prisioneiro',function(status)
	prisioneiro = status
	local ped = PlayerPedId()
	if prisioneiro then
		SetEntityInvincible(ped,false) --MQCu
		FreezeEntityPosition(ped,true)
		SetEntityVisible(ped,false,false)
		SetTimeout(10000,function()
			SetEntityInvincible(ped,false)
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true,false)
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(8000)
		if prisioneiro then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1700.5,2605.2,45.5,true)
			if distance >= 150 then
				SetEntityCoords(PlayerPedId(),1680.1,2513.0,45.5)
				TriggerEvent("Notify","aviso","O agente penitenciário encontrou você tentando escapar.")
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local dntxx = 8000
		if prisioneiro then
			dntxx = 5
			local distance1 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1646.43,2536.09,45.57,true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1643.05,2528.01,45.57,true)
			local distance3 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1638.37,2541.9,45.57,true)

			if GetEntityHealth(PlayerPedId()) <= 100 then
				vRP._DeletarObjeto()
			end

			if distance1 <= 1.2 then
				if IsControlJustPressed(0,38) then
					FreezeEntityPosition(PlayerPedId(), true)
					TriggerEvent('cancelando',true)
					TriggerEvent("emotes","malhar")
					Citizen.Wait(30000)
					FreezeEntityPosition(PlayerPedId(), false)
					TriggerEvent('cancelando',false)
					vRP._stopAnim(true)
					vRP._DeletarObjeto()
					TriggerServerEvent("diminuirpena2121")
				end
			end

			if distance2 <= 1.2 then
				if IsControlJustPressed(0,38) then
					TriggerEvent('cancelando',true)
					TriggerEvent("emotes","malhar2")
					Citizen.Wait(22000)
					TriggerEvent('cancelando',false)
					vRP._stopAnim(false)
					TriggerServerEvent("diminuirpena2121")
				end
			end

			if distance3 <= 1.2 then
				if IsControlJustPressed(0,38) then
					TriggerEvent('cancelando',true)
					TriggerEvent("emotes","abdominal")
					Citizen.Wait(22000)
					TriggerEvent('cancelando',false)
					vRP._stopAnim(false)
					TriggerServerEvent("diminuirpena2121")
				end
			end
		end
		Citizen.Wait(dntxx)
	end
end)

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