
fx_version 'bodacious'
games { 'gta5' }

author 'Trigueiro'
description 'Desmanche para vRPEX'
version '1.0.0'


client_script {
    "@vrp/lib/utils.lua",
    'client.lua'
}
server_script {
    "@vrp/lib/utils.lua",
    'server.lua'
}