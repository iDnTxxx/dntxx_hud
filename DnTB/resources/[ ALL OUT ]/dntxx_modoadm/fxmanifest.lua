
fx_version 'bodacious'
game 'gta5'

description "vrp_names"

dependency "vrp"

client_scripts {
    "@vrp/lib/utils.lua",
	"client.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
	"server.lua"
}
