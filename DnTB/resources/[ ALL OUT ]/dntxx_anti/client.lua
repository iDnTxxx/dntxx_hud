local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("dntxx_anti",src)
Proxy.addInterface("dntxx_anti",src)
acClient = Tunnel.getInterface("dntxx_anti")

RegisterNUICallback("loadNuis", function(data, cb)
	acClient.pegaTrouxa()
end)


