-----------------------------------------------------------------------------------------------------------------------------------------
-- HOLSTER
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}
Config.WeaponList = {
	"WEAPON_SNSPISTOL",
	"WEAPON_MICROSMG",
	"WEAPON_KNIFE",
	"WEAPON_DAGGER",
	"WEAPON_MACHETE",
	"WEAPON_SWITCHBLADE",
	"WEAPON_WRENCH",
	"WEAPON_HAMMER",
	"WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR",
	"WEAPON_HATCHET",
	"WEAPON_BAT",
	"WEAPON_BOTTLE",
	"WEAPON_BATTLEAXE",
	"WEAPON_POOLCUE",
	"WEAPON_STONE_HATCHET",
	"WEAPON_PISTOL_MK2",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_PISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_COMBATPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_ASSAULTSMG",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_PUMPSHOTGUN",
	"weapon_specialcarbine_mk2",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_COMBATPDW",
	"WEAPON_CARBINERIFLE"
}

local LastWeapon = nil
local block = false
Citizen.CreateThread(function()
	while true do
		local dntxx = 1000
		local ped = PlayerPedId()
		if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped) then
			for i=1,#Config.WeaponList do
				loadAnimDict("reaction@intimidation@1h")
				if not holstered and LastWeapon ~= nil and LastWeapon ~= GetHashKey(Config.WeaponList[i]) and GetSelectedPedWeapon(ped) == GetHashKey(Config.WeaponList[i]) then
					dntxx = 5
					block = true
					SetCurrentPedWeapon(ped,-1569615261,true)
					TaskPlayAnim(ped,"reaction@intimidation@1h","intro",8.0,8.0,-1,48,10,0,0,0)

					Citizen.Wait(1200)
					SetCurrentPedWeapon(ped,GetHashKey(Config.WeaponList[i]),true)
					Citizen.Wait(1300)
					ClearPedTasks(ped)
					holstered = true
					block = false
				end

				if holstered and LastWeapon ~= nil and LastWeapon == GetHashKey(Config.WeaponList[i]) and GetSelectedPedWeapon(ped) == -1569615261 then
					dntxx = 5
					block = true
					SetCurrentPedWeapon(ped,GetHashKey(Config.WeaponList[i]),true)
					TaskPlayAnim(ped,"reaction@intimidation@1h","outro",8.0,8.0,-1,48,10,0,0,0)

					Citizen.Wait(1400)
					SetCurrentPedWeapon(ped,-1569615261,true)
					Citizen.Wait(600)
					ClearPedTasks(ped)
					holstered = false
					block = false
				end
			end
			LastWeapon = GetSelectedPedWeapon(ped)
		end
		Citizen.Wait(dntxx)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if block then
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,25,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMDICT
-----------------------------------------------------------------------------------------------------------------------------------------
function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local teleport = {
	["COMEDY"] = {
		positionFrom = { -430.04,261.80,83.00 },
		positionTo = { -458.92,284.85,78.52 }
	},
	["TELEFERICO"] = {
		positionFrom = { -741.06,5593.12,41.65 },
		positionTo = { 446.15,5571.72,781.18 }
	},
	["HOSPITALHELIPONTO"] = {
        positionFrom = { 340.37,-592.84,43.28 },
        positionTo = { 338.53,-583.79,74.16 }
    },
	["HOSPITALLABORATORIO"] = {
		positionFrom = { 243.35,-1366.86,24.53 },
		positionTo = { 251.66,-1366.49,39.53 }
	},
	["HOSPITALHUMANLABS"] = {
		positionFrom = { 3552.9,3667.51,28.13 },
		positionTo = { 247.02,-1371.68,24.54 }
	},
	["HUMANLABSELEVATOR"] = {
		positionFrom = { 3540.71,3675.08,28.12 },
		positionTo = { 3540.56,3676.0,20.99 }
	},
	["VARANDA"] = {
		positionFrom = { -2994.91,757.73,14.14 },
		positionTo = { -3017.50,746.71,31.59 }
	},
	["MOTOCLUB"] = {
		positionFrom = { -80.89,214.78,96.55 },
		positionTo = { 1120.96,-3152.57,-37.06 }
	},
	["LUXURY06"] = {
		positionFrom = { -1018.74,167.24,58.74 },
		positionTo = { -1020.62,166.59,58.54 }
	},
	["ESCRITORIO"] = {
		positionFrom = { -70.93,-801.04,44.22 },
		positionTo = { -75.64,-827.15,243.39 }
	},
	["ESCRITORIO2"] = {
		positionFrom = { -1194.46,-1189.31,7.69 },
		positionTo = { 1173.55,-3196.68,-39.00 }
	},
	["ESCRITORIO3"] = {
		positionFrom = { -1007.12,-486.67,39.97 },
		positionTo = { -1003.05,-477.92,50.02 }
	},
	["ESCRITORIO4"] = {
		positionFrom = { -1913.48,-574.11,11.43 },
		positionTo = { -1902.05,-572.42,19.09 }
	},
	["LUXURY43/1"] = {
		positionFrom = { -1775.462,352.3035,89.3709 },
		positionTo = { -1773.7652,351.3415,89.3712 }
	},
	["LUXURY43/2"] = {
		positionFrom = { -1810.075,320.6946,89.3713 },
		positionTo = { -1809.1458,318.8099,89.3713 }
	},
	["TORRE"] = {
		positionFrom = { -53.51,825.8,231.34 },
		positionTo = { -47.87,831.48,235.73 }
	},
	["GALAXY"] = {
		positionFrom = { -1569.42,-3017.35,-74.40 },
		positionTo = { 4.35,220.43,107.72 }
	},
	["HOSPITAL"] = {
		positionFrom = { 334.3,-569.21,43.32 },
		positionTo = { 275.81,-1361.37,24.54 }
	},
	["PILOTO"] = {
		positionFrom = { -75.54,-824.96,321.3 },
		positionTo = { -84.43,-823.38,36.03 }
	}
}
Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(teleport) do
				if GetDistanceBetweenCoords(v.positionFrom[1],v.positionFrom[2],v.positionFrom[3],x,y,z,true) <= 1.2 then
					timeDistance = 5
					if IsControlJustPressed(0,38) then
						DoScreenFadeOut(1000)
						SetTimeout(2000,function()
							SetEntityCoords(ped,v.positionTo[1]+0.0001,v.positionTo[2]+0.0001,v.positionTo[3]+0.0001-0.50,1,0,0,1)
							Citizen.Wait(750)
							DoScreenFadeIn(1000)
						end)
					end
				end

				if GetDistanceBetweenCoords(v.positionTo[1],v.positionTo[2],v.positionTo[3],x,y,z,true) <= 1.2 then
					timeDistance = 5
					if IsControlJustPressed(0,38) then
						DoScreenFadeOut(1000)
						SetTimeout(2000,function()
							SetEntityCoords(ped,v.positionFrom[1]+0.0001,v.positionFrom[2]+0.0001,v.positionFrom[3]+0.0001-0.50,1,0,0,1)
							Citizen.Wait(750)
							DoScreenFadeIn(1000)
						end)
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)