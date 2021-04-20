local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

func = {}
Tunnel.bindInterface("last_webhook",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookhack = "https://discordapp.com/api/webhooks/768798451642662943/zbEPNp-PUx2b9jVGfajyyxPGj9b6aGrQ7_ua-8WeFw9mYWz5dhcsN70soJ9QZJISCjs8"
local webhookinsert = "https://discordapp.com/api/webhooks/768798544428793867/dZC5NrFwnMhKGLjpdM2dKGB_1HVfx7Kon31IyAIZ0VyT3WKw0_YbAjY961FTQhO2eBDl"
local webhookdano = "https://discordapp.com/api/webhooks/768798630055772213/0r3y2NyWzoFSKy8sDq-T3jeP08tpTLknA14-N5CC0SfYivNQP24XpN_xNS7DeyDmIRMY"
local webhookcarro = "https://discordapp.com/api/webhooks/768798721332346902/KIEueWI7KsQTUF5LngdvVAQn98jV_FQl_LoCFAYdKHst6sRyLbmUmm07zqMGANtmX3e6"
local webhookcolete = "https://discordapp.com/api/webhooks/768798841960267816/Sgz71w3_1oP8PGEzXeTEPCE0ql9tZKJUv5zvlodguF7z0CDrZstlLvsyInWAZNLlSugi"
local webhookvelocidade = "https://discordapp.com/api/webhooks/768798948172365834/vDyIt8SCUlUk_nOIznpDIVnAyFr9Xn9yqnFXT3NHoEA6ZJcaNCtil8ZwPLGS1_ZxTPsw"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function func.buttonInsert()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		--SendWebhookMessage(webhookinsert, "``` O ID: " ..user_id.. " PRESSIONOU [INSERT].```")
		SendWebhookMessage(webhookinsert,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[INSERT] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.buttonNumOito()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		--SendWebhookMessage(webhookhack, "``` O ID: " ..user_id.. " PRESSIONOU [NUMPAD 8].```")
		SendWebhookMessage(webhookhack,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[NUMPAD 8] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

--[[function func.buttonNumSeis()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		--SendWebhookMessage(webhookhack, "``` O ID: " ..user_id.. " PRESSIONOU [NUMPAD 6].```")
		SendWebhookMessage(webhookhack,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[NUMPAD 6] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end--]]

function func.buttonSetaCima()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		--SendWebhookMessage(webhookhack, "``` O ID: " ..user_id.. " PRESSIONOU [SETA PRA CIMA].```")
		SendWebhookMessage(webhookhack,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETA PRA CIMA] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.buttonSetaBaixo()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		--SendWebhookMessage(webhookhack, "``` O ID: " ..user_id.. " PRESSIONOU [SETA PRA BAIXO].```")
		SendWebhookMessage(webhookhack,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETA PRA BAIXO] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.buttonfUm()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		--SendWebhookMessage(webhookhack, "``` O ID: " ..user_id.. " PRESSIONOU [F1].```")
		SendWebhookMessage(webhookhack,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APERTOU F1] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.buttonfSeis()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		--SendWebhookMessage(webhookhack, "``` O ID: " ..user_id.. " PRESSIONOU [F6].```")
		SendWebhookMessage(webhookhack,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APERTOU F6] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.buttonfSete()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		--SendWebhookMessage(webhookademir, "``` O ID: " ..user_id.. " APERTOU [F7].```")
		SendWebhookMessage(webhookademir,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APERTOU F7] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.LoggarFixCarro(carroAntiga,carroAtual)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		SendWebhookMessage(webhookcarro,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[FIXOU UM CARRO] \n[VIDA ANTIGA] "..carroAntiga.." \n[VIDA ATUAL] "..carroAtual.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.LoggarCarroSabotado(vehspeed,nomecarro)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		SendWebhookMessage(webhookvelocidade,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[AUMENTO A VELOCIDADE DO CARRO] "..nomecarro.." \n[VELOCIDADE] "..vehspeed.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.LoggarDanoSabotado(dano)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		SendWebhookMessage(webhookdano,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ESTA COM DANO SABOTADO] "..dano.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end

function func.LoggarColete()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		SendWebhookMessage(webhookcolete,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ESTA TENTANDO PEGAR UM COLETE] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end