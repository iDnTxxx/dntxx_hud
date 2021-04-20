-----------------------------------------------------------------------------------------------------------------------------------------
-- DANO VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local pedInSameVehicleLast = false
local vehicle = nil
local lastVehicle = nil
local vehicleClass = nil

local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local classDamageMultiplier = { [0] = 2.2,2.2,2.2,2.2,2.2,2.2,2.2,2.2,2.2,2.2,2.2,2.2,2.2,0.0,0.0,1.2,1.6,1.6,1.6,2.2,2.2,2.2 }

local function isPedDrivingAVehicle()
	local ped = PlayerPedId()
	vehicle = GetVehiclePedIsIn(ped)
	if IsPedInAnyVehicle(ped) then
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			local class = GetVehicleClass(vehicle)
			if class ~= 13 and class ~= 14 then
				return true
			end
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		local dntxx = 1500
		if pedInSameVehicleLast then
			dntxx = 3
			local factor = 1.0
			if healthEngineNew < 900 then
				factor = (healthEngineNew+200.0) / 1100
			end
			SetVehicleEngineTorqueMultiplier(vehicle,factor)
		end

		local roll = GetEntityRoll(vehicle)
		if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
			DisableControlAction(2,59,true)
			DisableControlAction(2,60,true)
		end

		Citizen.Wait(dntxx)
	end
end)

Citizen.CreateThread(function()
	while true do
		local roll = GetEntityRoll(vehicle)
		if roll > 75.0 or roll < -75.0 then
			local tyre = math.random(4)
			if math.random(100) <= 100 then
				if tyre == 1 then
					if not IsVehicleTyreBurst(vehicle,0,false) then
						SetVehicleTyreBurst(vehicle,0,true,1000.0)
					end
				elseif tyre == 2 then
					if not IsVehicleTyreBurst(vehicle,1,false) then
						SetVehicleTyreBurst(vehicle,1,true,1000.0)
					end
				elseif tyre == 3 then
					if not IsVehicleTyreBurst(vehicle,4,false) then
						SetVehicleTyreBurst(vehicle,4,true,1000.0)
					end
				elseif tyre == 4 then
					if not IsVehicleTyreBurst(vehicle,5,false) then
						SetVehicleTyreBurst(vehicle,5,true,1000.0)
					end
				end
			end
		end
		Citizen.Wait(2500)
	end
end)

Citizen.CreateThread(function()
	while true do
		local dntxx = 2500
		local ped = PlayerPedId()
		if isPedDrivingAVehicle() then
			dntxx = 3
			vehicle = GetVehiclePedIsIn(ped)
			vehicleClass = GetVehicleClass(vehicle)
			healthEngineCurrent = GetVehicleEngineHealth(vehicle)

			if healthEngineCurrent >= 1000 then
				healthEngineLast = 1000.0
			end

			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * 1.2 * classDamageMultiplier[vehicleClass]
			healthBodyCurrent = GetVehicleBodyHealth(vehicle)

			if healthBodyCurrent == 1000 then
				healthBodyLast = 1000.0
			end

			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * 1.2 * classDamageMultiplier[vehicleClass]

			if healthEngineCurrent > 101.0 then
				SetVehicleUndriveable(vehicle,false)
			end

			if healthEngineCurrent <= 101.0 then
				SetVehicleUndriveable(vehicle,true)
			end

			if vehicle ~= lastVehicle then
				pedInSameVehicleLast = false
			end

			if pedInSameVehicleLast then
				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 then
					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled,healthBodyDeltaScaled)
					if healthEngineCombinedDelta > (healthEngineCurrent - 100.0) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
					end

					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (210.0 / 5)
					end
					healthEngineNew = healthEngineLast - healthEngineCombinedDelta

					if healthEngineNew > (210.0 + 5) and healthEngineNew < 477.0 then
						healthEngineNew = healthEngineNew-(0.038 * 3.2)
					end

					if healthEngineNew < 210.0 then
						healthEngineNew = healthEngineNew-(0.1 * 0.9)
					end

					if healthEngineNew < 100.0 then
						healthEngineNew = 100.0
					end

					if healthBodyNew < 0 then
						healthBodyNew = 0.0
					end
				end
			else
				if healthBodyCurrent < 210.0 then
					healthBodyNew = 210.0
				end
				pedInSameVehicleLast = true
			end

			if healthEngineNew ~= healthEngineCurrent then
				SetVehicleEngineHealth(vehicle,healthEngineNew)
			end

			if healthBodyNew ~= healthBodyCurrent then
				SetVehicleBodyHealth(vehicle,healthBodyNew)
			end

			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			lastVehicle = vehicle
		else
			pedInSameVehicleLast = false
		end

		Citizen.Wait(dntxx)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEÍCULO LENTO COM PNEU ESTOURADO
-----------------------------------------------------------------------------------------------------------------------------------------
local tParams = {}
local speedLimit = 100.0
local justIn = false
local tParams = {tyresPopped = 0, isSpeedLimited = false, t0 = false, t1 = false, t4 = false, t5 = false}
local speedLimitTwoTires = 20.0  --12 Speed limit when 2 or more tires get bursted
local speedLimitOneTire = 25.0   --17 Speed limit when 1 tire gets bursted
local speedLimitDelay = 0     --How long it takes (in milliseconds) for speed limit kicks in after tire bursts
local vehicleSpeedMax = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        local me = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(me, false)
        
        if DoesEntityExist(veh) then
            vehicleSpeedMax = GetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel") -- Gets vehicle's maximum possible speed from handling file
            --[[ RegisterCommand('burst', function() -- Debug command
                SetVehicleTyreBurst(veh, 4, true, 1000.0)
                StartVehicleAlarm(veh)
                speed = GetEntitySpeed(veh)
            end, false) ]]
        --------------------------------------------------------------------------
        ------Checks if any tyres are poped and adds it to popped tyres amount----
        --------------------------------------------------------------------------
        --Left Front
            if IsVehicleTyreBurst(veh, 0, true)and tParams.t0 == false then
                tParams.t0 = true
                tParams.tyresPopped = tParams.tyresPopped + 1
            end
            --Right Front
            if IsVehicleTyreBurst(veh, 1, true) and tParams.t1 == false then
                tParams.t1 = true
                tParams.tyresPopped = tParams.tyresPopped + 1
            end
            --Left Rear
            if IsVehicleTyreBurst(veh, 4, true) and tParams.t4 == false then
                tParams.t4 = true
                tParams.tyresPopped = tParams.tyresPopped + 1
            end
            --Right Rear
            if IsVehicleTyreBurst(veh, 5, true) and tParams.t5 == false then
                tParams.t5 = true
                tParams.tyresPopped = tParams.tyresPopped + 1
            end

        end

        --Wheel id's on 6-wheeler: middle right - 3
        -------------------------- middle left - 2

        --If two or more tyres burst max drivavle speed is set to speedLimitTwoTires
        if tParams.tyresPopped >= 2 then
            local maxSpeedAfterBurst = speedLimitTwoTires
            Wait(speedLimitDelay)

            while speedLimit >= maxSpeedAfterBurst do
                SetVehicleMaxSpeed(veh, speedLimit)
                speedLimit = speedLimit - 4.0
                Wait(2200)
            end

        --If one tire is burst max drivable speed set to speedLimitOneTire
        elseif tParams.tyresPopped > 0 then
            local maxSpeedAfterBurst = speedLimitOneTire

            Wait(speedLimitDelay)

            while speedLimit >= maxSpeedAfterBurst do
                SetVehicleMaxSpeed(veh, speedLimit)
                speedLimit = speedLimit - 3.0
                Wait(200)
            end

        else
            SetVehicleMaxSpeed(veh, vehicleSpeedMax)
        end

        --Refreshes variables when person gets to a new vehicle
        if IsPedInAnyVehicle(me, false) then
            if justIn == false then
                speedLimit = vehicleSpeedMax
                tParams.t0 = false
                tParams.t1 = false
                tParams.t4 = false
                tParams.t5 = false
                tParams.tyresPopped = 0
				justIn = true
            end
        else
            if justIn == true then
                justIn = false
            end
		end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOURAR PNEU SE RAMPAR (ANTI-POWERGAMING)
-----------------------------------------------------------------------------------------------------------------------------------------
local vehFlyTime = 0
local vehBody = false
local vehWheelFL = false
local vehWheelFR = false
local vehWheelBL = false
local vehWheelBR = false
local distance = 0
local initPos = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
      if GetPedInVehicleSeat(vehicle, -1) == ped and (GetVehicleClass(vehicle) < 5 or GetVehicleClass(vehicle) == 10 or GetVehicleClass(vehicle) == 15) then
        if IsVehicleStuckOnRoof(vehicle) then
          --print('Veículo stuck on roof')
				end
				local slowLevel = 0
        if IsEntityInAir(vehicle) then
          if vehFlyTime == 0 then
            vehBody = GetVehicleBodyHealth(vehicle)
            vehWheelFL = GetVehicleWheelHealth(vehicle, 0)
            vehWheelFR = GetVehicleWheelHealth(vehicle, 1)
            vehWheelBL = GetVehicleWheelHealth(vehicle, 4)
            vehWheelBR = GetVehicleWheelHealth(vehicle, 5)
						initPos = vector3(x,y,z)
						--print('teste')
            
            local slow = 0
            if IsVehicleTyreBurst(vehicle, 0, true) then slow = slow + 1 end
            if IsVehicleTyreBurst(vehicle, 1, true) then slow = slow + 1 end
            if IsVehicleTyreBurst(vehicle, 4, true) then slow = slow + 1 end
            if IsVehicleTyreBurst(vehicle, 5, true) then slow = slow + 1 end

						--print('slow: '..slow)
            if slow > 0 then
              local speed = (1 - (slow / 10))
              ModifyVehicleTopSpeed(vehicle, speed)
            end
          end

          vehFlyTime = vehFlyTime + 5
        elseif vehFlyTime > 200 and vehFlyTime < 2000 then
          damage = vehBody - GetEntityHealth(vehicle)
          distance = Vdist(x, y, z, initPos.x, initPos.y, initPos.z)
          chance = (damage * 20) + (distance / 2) + (vehFlyTime / 100)

          --print("Distancia: "..distance)
          if distance > 500 then
            return
          end

          if math.random(100) <= chance then
            local bursted = false
            
            repeat
              local tyreBurst = math.random(4)
              if tyreBurst == 1 then
                if not IsVehicleTyreBurst(vehicle, 0, true) then
                  SetVehicleTyreBurst(vehicle, 0, true, 500)
                  bursted = true
                end
              elseif tyreBurst == 2 then
                if not IsVehicleTyreBurst(vehicle, 1, true) then
                  SetVehicleTyreBurst(vehicle, 1, true, 500)
                  bursted = true
                end
              elseif tyreBurst == 3 then
                if not IsVehicleTyreBurst(vehicle, 4, true) then
                  SetVehicleTyreBurst(vehicle, 4, true, 500)
                  bursted = true
                end
              elseif tyreBurst == 4 then
                if not IsVehicleTyreBurst(vehicle, 5, true) then
                  SetVehicleTyreBurst(vehicle, 5, true, 500)
                  bursted = true
                end
              end
            until bursted == true
          end
          vehBody = GetVehicleBodyHealth(vehicle)
          vehFlyTime = 0
          vehBody = nil
        else
          vehFlyTime = 0
        end
      elseif GetPedInVehicleSeat(vehicle, -1) == ped and GetVehicleClass(vehicle) == 8 then
        if IsEntityInAir(vehicle) then
          if vehFlyTime == 0 then
            vehBody = GetVehicleBodyHealth(vehicle)
            initPos = vector3(x,y,z)
            
            local slow = 0
            if IsVehicleTyreBurst(vehicle, 0, true) then slow = slow + 1 end
            if IsVehicleTyreBurst(vehicle, 5, true) then slow = slow + 1 end

            if slow > 0 then
              local speed = (1 - (slow / 10))
							ModifyVehicleTopSpeed(vehicle, speed)
							-- print('slow: '..slow)
            end
          end

          vehFlyTime = vehFlyTime + 5
        elseif vehFlyTime > 200 and vehFlyTime < 2000 then
          damage = vehBody - GetEntityHealth(vehicle)
          distance = Vdist(x, y, z, initPos.x, initPos.y, initPos.z)
          chance = (damage * 20) + (distance / 2) + (vehFlyTime / 75)

          --print("Distancia: "..distance)
          if distance > 500 then
            return
          end

          if math.random(100) <= chance then
            local bursted = false
            --print('Estourando...')
            
            if not IsVehicleTyreBurst(vehicle, 0, true) or not IsVehicleTyreBurst(vehicle, 0, true) then
              repeat
                local tyreBurst = math.random(2)
                if tyreBurst == 1 then
                  if not IsVehicleTyreBurst(vehicle, 0, true) then
                    SetVehicleTyreBurst(vehicle, 0, true, 500)
                    bursted = true
                  end
                elseif tyreBurst == 2 then
                  if not IsVehicleTyreBurst(vehicle, 4, true) then
                    SetVehicleTyreBurst(vehicle, 4, true, 500)
                    bursted = true
                  end
                end
              until bursted == true
            end
          end
          vehBody = GetVehicleBodyHealth(vehicle)
          vehFlyTime = 0
          vehBody = nil
        else
          vehFlyTime = 0
        end
      end
		end
	end
end)