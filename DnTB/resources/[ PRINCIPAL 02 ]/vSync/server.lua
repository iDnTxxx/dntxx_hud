-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC TIME TRUE/FALSE
-----------------------------------------------------------------------------------------------------------------------------------------
DynamicWeather = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG PRINT
-----------------------------------------------------------------------------------------------------------------------------------------
debugprint = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEMPOS ACESSIVEIS 
-----------------------------------------------------------------------------------------------------------------------------------------
AvailableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS',  
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}

CurrentWeather = "EXTRASUNNY"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 35

local source = source
local user_id = vRP.getUserId(source)

RegisterServerEvent('vSync:requestSync')
AddEventHandler('vSync:requestSync', function()
    TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if debugprint then print('admin id: ' .. id .. '\nplayer id:' .. pid) end
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONGELAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('congelar', function(source, args)
	local source = source
	local user_id = vRP.getUserId(source)
    if source ~= 0 then
        if vRP.hasPermission(user_id,'admin.permissao') then
            freezeTime = not freezeTime
            if freezeTime then
                TriggerClientEvent("Notify",source,"sucesso","O tempo agora está congelado.")
            else
                TriggerClientEvent("Notify",source,"negado","O tempo não está mais congelado.")
            end
        else
            TriggerClientEvent("Notify",source,"negado","<b>Erro:</b><br>Você não tem acesso a esse comando.")
        end
    else
        freezeTime = not freezeTime
        if freezeTime then
            --print("Time is now frozen.")
        else
            --print("Time is no longer frozen.")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DINAMICO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dinamico', function(source, args)
	local source = source
	local user_id = vRP.getUserId(source)
    if source ~= 0 then
        if vRP.hasPermission(user_id,'admin.permissao') then
            DynamicWeather = not DynamicWeather
            if not DynamicWeather then
                TriggerClientEvent("Notify",source,"negado","Mudanças climáticas dinâmicas agora estão <b>desabilitadas</b>.")
            else
                TriggerClientEvent("Notify",source,"sucesso","Mudanças climáticas dinâmicas agora estão <b>habilitadas</b>.")
            end
        else
            TriggerClientEvent("Notify",source,"negado","<b>Erro:</b><br>Você não tem acesso a esse comando.")
        end
    else
        DynamicWeather = not DynamicWeather
        if not DynamicWeather then
            --print("Weather is now frozen.")
        else
            --print("Weather is no longer frozen.")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEMPO 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tempo', function(source, args)
	local source = source
	local user_id = vRP.getUserId(source)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            --print("Invalid syntax, correct syntax is: /weather <weathertype> ")
            return
        else
            for i,wtype in ipairs(AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                print("Weather has been updated.")
                CurrentWeather = string.upper(args[1])
                newWeatherTimer = 35
                TriggerEvent('vSync:requestSync')
            else
                --print("Invalid weather type, valid weather types are: \nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ")
            end
        end
    else
		if vRP.hasPermission(user_id,'admin.permissao') then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent("Notify",source,"negado","<b>Erro:</b><br>Comando inválido, use /tempo <tipodetempo>")
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent("Notify",source,"importante","O tempo vai mudar para: <b>" .. string.lower(args[1]) .. "</b>.")
                    CurrentWeather = string.upper(args[1])
                    newWeatherTimer = 35
                    TriggerEvent('vSync:requestSync')
                else
                    TriggerClientEvent("Notify",source,"aviso","<b>Erro:</b><br> Tipo de clima inválido, tipos de clima válidos são: <b>\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN</b>")
                end
            end
        else
            TriggerClientEvent("Notify",source,"negado","<b>Erro:</b><br>Você não tem acesso a esse comando.")
            --print('Access for command /weather denied.')
        end
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APAGAO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('apagao', function(source)
	local source = source
	local user_id = vRP.getUserId(source)
    if source == 0 then
        blackout = not blackout
        if blackout then
            --print("Blackout is now enabled.")
        else
            --print("Blackout is now disabled.")
        end
    else
		if vRP.hasPermission(user_id,'admin.permissao') then
            blackout = not blackout
            if blackout then
                TriggerClientEvent("Notify",source,"sucesso","<b>Apagão</b><br>Ativado.")
            else
                TriggerClientEvent("Notify",source,"negado","<b>Apagão</b><br>Desativado.")
            end
            TriggerEvent('vSync:requestSync')
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MANHA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('manha', function(source)
	local source = source
	local user_id = vRP.getUserId(source)
    if source == 0 then
        --print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
	if vRP.hasPermission(user_id,'admin.permissao') then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerClientEvent("Notify",source,"importante","Tempo definido pra <b>Manha</b>.")
        TriggerEvent('vSync:requestSync')
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MEIODIA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('meiodia', function(source)
	local source = source
	local user_id = vRP.getUserId(source)
    if source == 0 then
        --print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if vRP.hasPermission(user_id,'admin.permissao') then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerClientEvent("Notify",source,"importante","Tempo definido pra <b>Meio dia</b>.")
        TriggerEvent('vSync:requestSync')
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARDE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tarde', function(source)
	local source = source
	local user_id = vRP.getUserId(source)
    if source == 0 then
        --print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
	if vRP.hasPermission(user_id,'admin.permissao') then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerClientEvent("Notify",source,"importante","Tempo definido pra <b>Tarde</b>.")
        TriggerEvent('vSync:requestSync')
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOITE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('noite', function(source)
	local source = source
	local user_id = vRP.getUserId(source)
    if source == 0 then
        --print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if vRP.hasPermission(user_id,'admin.permissao') then
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerClientEvent("Notify",source,"importante","Tempo definido pra <b>Noite</b>.")
        TriggerEvent('vSync:requestSync')
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINUTES
-----------------------------------------------------------------------------------------------------------------------------------------
function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOURS
-----------------------------------------------------------------------------------------------------------------------------------------
function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HORA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('hora', function(source, args, rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            --print("Time has changed to " .. argh .. ":" .. argm .. ".")
            TriggerEvent('vSync:requestSync')
        else
            --print("Invalid syntax, correct syntax is: time <hour> <minute> !")
        end
    elseif source ~= 0 then
        if vRP.hasPermission(user_id,'admin.permissao') then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                if argh < 24 then
                    ShiftToHour(argh)
                else
                    ShiftToHour(0)
                end
                if argm < 60 then
                    ShiftToMinute(argm)
                else
                    ShiftToMinute(0)
                end
                local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
				local minute = math.floor((baseTime+timeOffset)%60)
                if minute < 10 then
                    newtime = newtime .. "0" .. minute
                else
                    newtime = newtime .. minute
                end
                TriggerClientEvent("Notify",source,"importante","A hora foi alterada para: " .. newtime .. ".")
                TriggerEvent('vSync:requestSync')
            else
                TriggerClientEvent("Notify",source,"negado","<b>Erro:</b><br>Comando inválido. Use <b>/hora <horario> <minutos></b>.")
            end
        else
            TriggerClientEvent("Notify",source,"negado","<b>Erro:</b><br>Você não tem acesso a esse comando.")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEW BASE TIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEWEATHER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWWEATHERTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait(60000)
        if newWeatherTimer == 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 35
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEXT WEATHER STAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,1)
        if new == 1 then
            CurrentWeather = "OVERCAST"
        else
            CurrentWeather = "DESATIVADO"
        end
    elseif CurrentWeather == "OVERCAST" then
        local new = math.random(1,5)
        if new == 1 then
            CurrentWeather = "FOGGY"
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("vSync:requestSync")
    if debugprint then
        print("[vSync] Novo tipo de clima aleatório foi gerado: " .. CurrentWeather .. ".\n")
        print("[vSync] Redefinindo cronômetro para 10 minutos.\n")
    end
end

