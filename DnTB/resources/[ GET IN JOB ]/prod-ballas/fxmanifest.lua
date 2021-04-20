fx_version 'adamant'
game 'gta5'

author 'Ziraflix Dev Group'
version '1.0.4'

ui_page 'nui/darkside.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'client.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua'
}

files {
	'nui/*.html',
	'nui/*.js',
	'nui/*.css'
}