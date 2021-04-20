local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
func = Tunnel.getInterface("last_webhook")

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,121) then -- INSERT
			func.buttonInsert()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,127) then -- NUMPAD 8
			func.buttonNumOito()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,125) then -- NUMPAD 6
			func.buttonNumSeis()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,172) then -- SETA CIMA
			func.buttonSetaCima()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,172) then -- SETA BAIXO
			func.buttonSetaBaixo()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,288) then -- F1
			func.buttonfUm()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,344) then -- F1
			func.buttonfOnze()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,167) then -- F6
			func.buttonfSeis()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,168) then -- F7
			func.buttonfSete()
		end
	end
end)

Citizen.CreateThread(function() -- LOG DE FIXAR CARRO
    while true do
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
            local carroAntiga = GetEntityHealth(GetVehiclePedIsIn(PlayerPedId(), false))
            Wait(1000)
            local carroAtual = GetEntityHealth(GetVehiclePedIsIn(PlayerPedId(), false))
            if carroAtual - carroAntiga > 1 then
                func.LoggarFixCarro(carroAntiga, carroAtual)
            end
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) then-- LOG DE CARRO SABOTADO
            local vehspeed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false))*3.6
            local nomecarro = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)))
            if vehspeed > 400 then
                func.LoggarCarroSabotado(vehspeed,nomecarro)
            end
        end
    end
end)

Citizen.CreateThread(function() -- LOG DE DANO SABOTADO
    while true do
        Wait(1000)
        SetPlayerWeaponDamageModifier(PlayerId(), 1.0)
        Wait(1000)
        local dano = GetPlayerWeaponDamageModifier(PlayerId())
        if dano > 1 then
            func.LoggarDanoSabotado(tD(dano))
        end
    end
end)

Citizen.CreateThread(function() -- LOG DE COLETE
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if GetPedArmour(ped) > 0 then
			--SetPedArmour(ped, 0)
			TriggerEvent("blxqygoixtosoaas1",0)
            func.LoggarColete()
        end
    end
end)

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end