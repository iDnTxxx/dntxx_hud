-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "ammunation-comprar-faca" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_KNIFE")
	elseif data == "ammunation-comprar-adaga" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_DAGGER")
	elseif data == "ammunation-comprar-ingles" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_KNUCKLE")
	elseif data == "ammunation-comprar-machete" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_MACHETE")
	elseif data == "ammunation-comprar-canivete" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_SWITCHBLADE")
	elseif data == "ammunation-comprar-grifo" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_WRENCH")
	elseif data == "ammunation-comprar-martelo" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_HAMMER")
	elseif data == "ammunation-comprar-golf" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_GOLFCLUB")	
	elseif data == "ammunation-comprar-cabra" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_CROWBAR")
	elseif data == "ammunation-comprar-machado" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_HATCHET")
	elseif data == "ammunation-comprar-lanterna" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_FLASHLIGHT")	
	elseif data == "ammunation-comprar-beisebol" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_BAT")
	elseif data == "ammunation-comprar-garrafa" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_BOTTLE")
	elseif data == "ammunation-comprar-batalha" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_BATTLEAXE")
	elseif data == "ammunation-comprar-sinuca" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_POOLCUE")
	elseif data == "ammunation-comprar-paraquedas" then
		TriggerServerEvent("ammunation-comprar","wbody|GADGET_PARACHUTE")
	elseif data == "ammunation-comprar-compattach" then
		TriggerServerEvent("ammunation-comprar","compattach")
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{ 1692.62,3759.50,34.70 },
	{ 252.89,-49.25,69.94 },
	{ 843.28,-1034.02,28.19 },
	{ -331.35,6083.45,31.45 },
	{ -663.15,-934.92,21.82 },
	{ -1305.18,-393.48,36.69 },
	{ -1118.80,2698.22,18.55 },
	{ 2568.83,293.89,108.73 },
	{ -3172.68,1087.10,20.83 },
	{ 21.32,-1106.44,29.79 },
	{ 811.19,-2157.67,29.61 }
}

RegisterCommand('acomprar',function(source,args)
	SetNuiFocus(false,false)
	for _,mark in pairs(marcacoes) do
		local ped = PlayerPedId()
		local x,y,z = table.unpack(mark)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		if distance <= 2.3 then
			ToggleActionMenu()
		end
	end
end)