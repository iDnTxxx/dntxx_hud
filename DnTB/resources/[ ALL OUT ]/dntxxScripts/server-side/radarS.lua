local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

fan_radar = {}
Tunnel.bindInterface("cl_radar",fan_radar)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RADAR
-----------------------------------------------------------------------------------------------------------------------------------------
function fan_radar.checarMulta(valor)
	local user_id = vRP.getUserId(source)
	if user_id then
		local fan_valor = vRP.getUData(parseInt(user_id),"vRP:multas")
		local fan_multas = json.decode(valor) or 0
		vRP.setUData(parseInt(user_id),"vRP:multas",json.encode(parseInt(fan_multas)+parseInt(fan_valor)))
	end
end

function fan_radar.checkperm()
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
        return true
    end
    return false
end