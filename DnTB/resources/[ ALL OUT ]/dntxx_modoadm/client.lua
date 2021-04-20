-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP UTILS
-----------------------------------------------------------------------------------------------------------------------------------------	
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
dntxx = {}
Tunnel.bindInterface("dntxx_modoadm",dntxx)
Proxy.addInterface("dntxx_modoadm",dntxx)
dntxx = Tunnel.getInterface("dntxx_modoadm")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARS
-----------------------------------------------------------------------------------------------------------------------------------------
local cDistance = 150
local showIds = false
local players = {}
local admin = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- INFO ADMIN MODE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
    	local dntxx = 1000
      	if showIds then
            dntxx = 5
	        for k, id in ipairs(GetActivePlayers()) do
	        	if  ((NetworkIsPlayerActive( id )) and GetPlayerPed(id) ~= PlayerPedId()) then
			        x1, y1, z1 = table.unpack( GetEntityCoords( PlayerPedId(), true ) )
			        x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
			        distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
			    	if admin and (PlayerPedId() ~= GetPlayerPed(id)) then
				    	if ((distance < cDistance)) then
				    		if GetPlayerPed(id) ~= -1 and players[id] ~= nil then
								local name = GetPlayerName(id)
								if name == nil or name == "" or name == -1 then
									name = "STEAM OFF"
								end
				    			local vida = (GetEntityHealth(GetPlayerPed(id)) - 100)
								if vida == 1 then
									vida = 0
								end
				    			local vidaPorcento = vida / 3
				    			vidaPorcento = math.floor(vidaPorcento)
				    			DrawText3D(x2, y2, z2+1, "STEAM: " .. name .. "\n ID: " .. players[id] .. " (HP: "..vida.. " (" .. vidaPorcento .. "%) ", 255, 255, 255)
				    		end
				    	end
				    end
				end
			end
		end
		Citizen.Wait(dntxx)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CORE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
	    for _, id in ipairs(GetActivePlayers()) do
	    	if id == -1 or id == nil then return end
			local pid = dntxx.getId(GetPlayerServerId(id))
			if pid == -1 then
				return
			end
			if players[id] ~= pid or not players[id] then
				players[id] = pid
			end
		end
		Citizen.Wait(1500)
	end
end)

Citizen.CreateThread(function()
	while true do
		admin = dntxx.isAdmin() 
		Citizen.Wait(10000)
	end
end)

RegisterCommand("am",function()
	if not admin then
		return
	end

	if admin then
		showIds = not showIds
	end

	if showIds then
		dntxx.reportLog("ADMIN MODE ON")
		print("ADMIN MODE ON")
	else
		dntxx.reportLog("ADMIN MODE OFF")
		print("ADMIN MODE OFF")
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- 3D TEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z, text, r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.25)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end