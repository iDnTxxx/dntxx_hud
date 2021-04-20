fx_version 'bodacious'
games { 'gta5' }

ui_page "nui/ui.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"/regis/client.lua",
	"client.lua",
	"/lojinha/client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"/regis/server.lua",
	"server.lua",
	"/lojinha/server.lua"
}