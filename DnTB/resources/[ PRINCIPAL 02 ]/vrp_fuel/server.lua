local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent("vrp_fuel:pagamento")
AddEventHandler("vrp_fuel:pagamento",function(price,galao,vehicle,fuel,fuel2)
	local user_id = vRP.getUserId(source)
	if user_id and price > 0 then
		if vRP.tryPayment(user_id,price) then
			if galao then
				TriggerClientEvent('syncfuel',-1,vehicle,fuel)
				TriggerClientEvent("Notify",source,"sucesso","Pagou <b>$"..vRP.format(price).." dólares</b> em combustível.",8000)
			end
		else
			TriggerClientEvent('vrp_fuel:insuficiente',source,vehicle,fuel2)
			TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",8000)
		end
	end
end)