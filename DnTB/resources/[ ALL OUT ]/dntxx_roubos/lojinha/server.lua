-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_robberys",src)
vCLIENT = Tunnel.getInterface("vrp_robberys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local robbery = false
local timedown = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookdepartamento = "https://discordapp.com/api/webhooks/768797946359185448/S3rVL8IoClVsBj2cjYAzQ6nQXdXxE8LsIT1AMRmgQncptnBLAetjCaTxeE8e9_IhcG9V"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERS
-----------------------------------------------------------------------------------------------------------------------------------------
local robbers = {
	[1] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 80000, ['rewmax'] = 130000 },
	[2] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 80000, ['rewmax'] = 130000 },
	[3] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 80000, ['rewmax'] = 130000 },
	[4] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 80000, ['rewmax'] = 130000 },
	[5] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 80000, ['rewmax'] = 130000 },
	[6] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 80000, ['rewmax'] = 130000 },
	[7] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 80000, ['rewmax'] = 130000 },
	[8] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 80000, ['rewmax'] = 130000 },
	[9] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 120000, ['rewmax'] = 160000 },
	[10] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 120000, ['rewmax'] = 160000 },
	[11] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 120000, ['rewmax'] = 160000 },
	[12] = { ['place'] = "Loja de Departamento", ['seconds'] = 180, ['rewmin'] = 120000, ['rewmax'] = 160000 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		if #policia <= 4 then
			TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.",8000)
			return false
		elseif (os.time()-timedown) <= 1000 then
			TriggerClientEvent("Notify",source,"aviso","Os cofres estão vazios, aguarde <b>"..vRP.format(parseInt((7200-(os.time()-timedown)))).." segundos</b> até que os civis efetuem depositos.",8000)
			return false
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.startRobbery(id,x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		robbery = true
		timedown = os.time()
		vCLIENT.startRobbery(source,robbers[id].seconds,x,y,z)
		TriggerClientEvent("vrp_sound:source",source,'alarm',0.3)
		vRPclient.setStandBY(source,parseInt(600))

		local policia = vRP.getUsersByPermission("policia.permissao")
		for k,v in pairs(policia) do
			local policial = vRP.getUserSource(v)
			if policial then
				async(function()
					vCLIENT.startRobberyPolice(policial,x,y,z,robbers[id].place)
					vRPclient.playSound(policial,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
					TriggerClientEvent('chatMessage',policial,"Dispatch",{65,130,255},"O roubo começou no ^1"..robbers[id].place.."^0, dirija-se até o local e intercepte os assaltantes.")
				end)
			end
		end
		SendWebhookMessage(webhookdepartamento,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[LUGAR]: "..robbers[id].place.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		SetTimeout(robbers[id].seconds*1000,function()
			if robbery then
				robbery = false
				vRP.searchTimer(user_id,1800)
				vRP.giveInventoryItem(user_id,"dinheirosujo",parseInt(math.random(robbers[id].rewmin,robbers[id].rewmax)))
				for k,v in pairs(policia) do
					local policial = vRP.getUserSource(v)
					if policial then
						async(function()
							vCLIENT.stopRobberyPolice(policial)
							TriggerClientEvent('chatMessage',policial,"Dispatch",{65,130,255},"O roubo terminou, os assaltantes estão correndo antes que vocês cheguem.")
						end)
					end
				end
			end
		end)

	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.stopRobbery()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if robbery then
			robbery = false
			local policia = vRP.getUsersByPermission("policia.permissao")
			for k,v in pairs(policia) do
				local policial = vRP.getUserSource(v)
				if policial then
					async(function()
						vCLIENT.stopRobberyPolice(policial)
						TriggerClientEvent('chatMessage',policial,"Dispatch",{65,130,255},"O assaltante saiu correndo e deixou tudo para trás.")
					end)
				end
			end
		end
	end
end