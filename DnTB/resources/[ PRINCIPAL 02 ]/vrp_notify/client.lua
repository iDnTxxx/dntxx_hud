--[[ DUMPED USING COMPOSER DEVIL ]]--
RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css, mensagem, tempo)
	local diferencial = math.random(99999999999)
	if not tempo then tempo = 10000 end
	SendNUIMessage({ css = css, mensagem = mensagem, diferencial = diferencial, tempo = tempo })
end)
--[[ RegisterCommand("teste",function(source,args)
	TriggerEvent('Notify', 'sucesso', 'número insuficiente de puluça no momento')
	TriggerEvent('Notify', 'negado', 'número insuficiente de puluça no momento')
	TriggerEvent('Notify', 'aviso', 'número insuficiente de puluça no momento')
	TriggerEvent('Notify', 'financeiro', 'número insuficiente de puluça no momento')
	TriggerEvent('Notify', 'importante', 'número insuficiente de puluça no momento')
end) ]]
--[[ DUMPED USING COMPOSER DEVIL ]]--