local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
banK = {}
Tunnel.bindInterface("vrp_banco",banK)
Proxy.addInterface("vrp_banco",banK)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ WEBHOOKS ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookDepositar = ""
local webhookSacar = ""
local webhookPTrans = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ PAGAR MULTAS ]-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('multas',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)

	local value = vRP.getUData(parseInt(user_id),"vRP:multas")
	local multas = json.decode(value) or 0
	local banco = vRP.getBankMoney(user_id)
	
	if user_id then
		if args[1] == nil then
			if multas >= 1 then
				TriggerClientEvent("Notify",source,"aviso","Você possuí <b>$"..multas.." dólares em multas</b> para pagar.",8000)
			else
				TriggerClientEvent("Notify",source,"aviso","Você <b>não possuí</b> multas para pagar.",8000)
			end
		elseif args[1] == "pagar" then
			local valorpay = vRP.prompt(source,"Saldo de multas: $"..multas.." - Valor de multas a pagar:","")
			if banco >= parseInt(valorpay) then
				if parseInt(valorpay) <= parseInt(multas) then
					vRP.setBankMoney(user_id,parseInt(banco-valorpay))
					vRP.setUData(user_id,"vRP:multas",json.encode(parseInt(multas)-parseInt(valorpay)))
					TriggerClientEvent("Notify",source,"sucesso","Você pagou <b>$"..valorpay.." dólares</b> em multas.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Você não pode pagar mais multas do que deve.",8000)
				end
			else
				TriggerClientEvent("Notify",source,"negado","Você não tem dinheiro em sua conta suficiente para isso.",8000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DEPOSITAR ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('banco:depositar')
AddEventHandler('banco:depositar', function(amount)
	local _source = source
	local identity = vRP.getUserIdentity(user_id)
	local user_id = vRP.getUserId(_source)

	if amount == nil or amount <= 0 or amount > vRP.getMoney(user_id) then
		TriggerClientEvent("Notify",_source,"negado","Valor inválido")
	else
		vRP.tryDeposit(user_id, tonumber(amount))
		TriggerClientEvent("Notify",_source,"sucesso","Você depositou <b>$"..parseInt(amount).." dólares</b>.")
		--SendWebhookMessage(webhookDepositar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.."\n[DEPOSITOU]: "..parseInt(amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SACAR ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('banco:sacar')
AddEventHandler('banco:sacar', function(amount)
	local _source = source
	local identity = vRP.getUserIdentity(user_id)
	local user_id = vRP.getUserId(_source)

	amount = tonumber(amount)
	local getbankmoney = vRP.getBankMoney(user_id)

	if amount == nil or amount <= 0 or amount > getbankmoney then
		TriggerClientEvent("Notify",_source,"negado","Valor inválido")
	else
		vRP.tryWithdraw(user_id,amount)
		TriggerClientEvent("Notify",_source,"sucesso","Você sacou <b>$"..amount.." dólares</b>.")
		--SendWebhookMessage(webhookSacar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.."\n[SACOU]: "..parseInt(amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SALDO ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('banco:balance')
AddEventHandler('banco:balance', function()
	local _source = source
	local user_id = vRP.getUserId(_source)
	local getbankmoney = vRP.getBankMoney(user_id)

	TriggerClientEvent("currentbalance1",_source,getbankmoney)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRANSFERENCIAS ]---------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('banco:transferir')
AddEventHandler('banco:transferir', function(to,amountt)
	local _source = source
	local user_id = vRP.getUserId(_source)
	local identity = vRP.getUserIdentity(user_id)

	local _nplayer = vRP.getUserSource(parseInt(to))
	local nuser_id = vRP.getUserId(_nplayer)
	local identitynu = vRP.getUserIdentity(nuser_id)
	local banco = 0

	if nuser_id == nil then
		TriggerClientEvent("Notify",_source,"negado","Passaporte inválido ou indisponível.")
	else
		if nuser_id == user_id then
			TriggerClientEvent("Notify",_source,"negado","Você não pode transferir dinheiro para si mesmo.")	
		else
			local banco = vRP.getBankMoney(user_id)
			local banconu = vRP.getBankMoney(nuser_id)
			
			if banco <= 0 or banco < tonumber(amountt) or tonumber(amountt) <= 0 then
				TriggerClientEvent("Notify",_source,"negado","Dinheiro Insuficiente")
			else
				vRP.setBankMoney(user_id,banco-tonumber(amountt))
				vRP.setBankMoney(nuser_id,banconu+tonumber(amountt))

				TriggerClientEvent("Notify",_nplayer,"sucesso","<b>"..identity.name.." "..identity.firstname.."</b> depositou <b>$"..amountt.." dólares</b> na sua conta.")
				TriggerClientEvent("Notify",_source,"sucesso","Você transferiu <b>$"..amountt.." dólares</b> para conta de <b>"..identitynu.name.." "..identitynu.firstname.."</b>.")
				--SendWebhookMessage(webhookPTrans,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.."\n[TRANSFERIU]: "..parseInt(amountt).."\n[PARA O ID] "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)