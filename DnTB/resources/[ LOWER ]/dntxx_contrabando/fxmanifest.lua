fx_version 'adamant'
game 'gta5'

author ''
description ''
version ''

ui_page 'nui/ui.html'

client_script {
	'@vrp/lib/utils.lua',
	'client.lua'
}

server_script {
	'@vrp/lib/utils.lua',
	'server.lua'
}

files {
	'nui/ui.html',
	'nui/ui.js',
	'nui/ui.css'
}