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
Tunnel.bindInterface("vrp_robguns",src)
vCLIENT = Tunnel.getInterface("vrp_robguns")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local robbery = false
local timedown = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookrouboarmas = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERS
-----------------------------------------------------------------------------------------------------------------------------------------
local robbers = {
	[1] = { "Loja de Armas",60,50000,67000 },
	[2] = { "Loja de Armas",60,50000,67000 },
	[3] = { "Loja de Armas",60,50000,67000 },
	[4] = { "Loja de Armas",60,50000,67000 },
	[5] = { "Loja de Armas",60,50000,67000 },
	[6] = { "Loja de Armas",60,50000,67000 },
	[7] = { "Loja de Armas",60,50000,67000 },
	[8] = { "Loja de Armas",60,50000,67000 },
	[9] = { "Loja de Armas",60,50000,67000 },
	[10] = { "Loja de Armas",60,50000,67000 },
	[11] = { "Loja de Armas",60,50000,67000 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		if #policia <= 1 then
			TriggerClientEvent("Notify",source,"aviso","Sistema indisponível no momento.",8000)
			return false
		elseif (parseInt(os.time())-timedown) <= 2500 then
			TriggerClientEvent("Notify",source,"importante","Aguarde "..vRP.getMinSecs(parseInt(2500-(os.time()-timedown)))..".",8000)
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
	local identity_user = vRP.getUserIdentity(user_id)
	if user_id then
		robbery = true
		timedown = parseInt(os.time())
		vCLIENT.startRobbery(source,robbers[id][2],x,y,z)

		local policia = vRP.getUsersByPermission("policia.permissao")
		for k,v in pairs(policia) do
			local policial = vRP.getUserSource(v)
			if policial then
				async(function()
					vCLIENT.startRobberyPolice(policial,x,y,z,robbers[id][1])
					vRPclient.playSound(policial,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
					TriggerClientEvent('chatMessage',policial,"Dispatch",{65,130,255},"O roubo começou na ^1"..robbers[id][1].."^0, dirija-se até o local e intercepte os assaltantes.")
					SendWebhookMessage(webhookrouboarmas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.."\n [AMMUNATION]: "..robbers[id][1].."\n "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end)
			end
		end

		SetTimeout(robbers[id][2]*1000,function()
			if robbery then
				robbery = false
				vRP.searchTimer(user_id,1800)
				vRP.giveInventoryItem( user_id,"dinheirosujo",parseInt(math.random(robbers[id][3],robbers[id][4])))

				if parseInt(math.random(100)) <= 10 then
					local weaponsort = math.random(1,4)
					if parseInt(weaponsort) == 1 then
						vRP.giveInventoryItem( user_id,"wbody|WEAPON_SNSPISTOL",1)
						vRP.giveInventoryItem( user_id,"wammo|WEAPON_SNSPISTOL",20)
					elseif parseInt(weaponsort) == 2 then
						vRP.giveInventoryItem( user_id,"wbody|WEAPON_PISTOL_MK2",1)
						vRP.giveInventoryItem( user_id,"wammo|WEAPON_PISTOL_MK2",70)
					elseif parseInt(weaponsort) == 3 then
						vRP.giveInventoryItem( user_id,"wbody|WEAPON_SNSPISTOL",1)
						vRP.giveInventoryItem( user_id,"wammo|WEAPON_SNSPISTOL",80)
					elseif parseInt(weaponsort) == 4 then
						vRP.giveInventoryItem( user_id,"wbody|WEAPON_PISTOL_MK2",1)
						vRP.giveInventoryItem( user_id,"wammo|WEAPON_PISTOL_MK2",80)
					end
				end

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