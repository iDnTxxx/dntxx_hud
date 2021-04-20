local bigas = false
local textoDisplay = ''
local porcentagem = 0

RegisterNetEvent("progress")
AddEventHandler("progress",function(time, text)
	textoDisplay = text
	if not text then textoDisplay = '...' end
	porcentagem = time
	bigas = true
	SendNUIMessage({ type = "ui", display = true, text = text, time = time})
end)

--[[ Citizen.CreateThread(function() 
	while true do
		Wait(1000)
		if bigas then
			if porcentagem > 0 then
				porcentagem = porcentagem - 1000
			end
		end
	end
end) ]]

--[[ Citizen.CreateThread(function() 
	while true do
		Wait(0)
		if bigas then
			if porcentagem > 0 then
				drawTxt( '~c~' .. string.upper(textoDisplay) .. ' - ' .. math.floor(100/(porcentagem/1000)) .. '%', 4,0.5,0.93,0.50,255,255,255,100)
			else
				bigas = false
				textoDisplay = ''
			end
		end
	end
end) ]]

--[[ RegisterCommand('bigas', function(source, args, rawCmd)
	TriggerEvent('progress', 5000)
end)
 ]]
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