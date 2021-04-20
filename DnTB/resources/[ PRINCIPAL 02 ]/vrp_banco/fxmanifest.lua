fx_version 'bodacious'
game 'gta5'

ui_page('nui/index.html')

client_script{
    '@vrp/lib/utils.lua',
    'hansolo.lua'
}

server_script {
    '@vrp/lib/utils.lua',
	'skywalker.lua'
}

files {
    'nui/media/fonts/AvenirNextRoundedStd-Bold.ttf',
    'nui/media/fonts/AvenirNextRoundedStd-BoldIt.ttf',
    'nui/media/fonts/AvenirNextRoundedStd-Demi.ttf',
    'nui/media/fonts/AvenirNextRoundedStd-DemiIt.ttf',
    'nui/media/fonts/AvenirNextRoundedStd-Italic.ttf',
    'nui/media/fonts/AvenirNextRoundedStd-Med.ttf',
    'nui/media/fonts/AvenirNextRoundedStd-MedIt.ttf',
    'nui/media/fonts/AvenirNextRoundedStd-Reg.ttf',

    'nui/media/imagens/login/logo.png',
    'nui/media/imagens/login/botao.png',
    'nui/media/imagens/login/01.png',

    'nui/media/imagens/geral/img-depositar.png',
    'nui/media/imagens/geral/img-pagar.png',
    'nui/media/imagens/geral/img-sacar.png',
    'nui/media/imagens/geral/img-transferir.png',
    'nui/media/imagens/geral/logo-top.png',
    'nui/media/imagens/geral/ma-img.png',
    'nui/media/imagens/geral/tag-one.png',
    'nui/media/imagens/geral/tag-two.png',
    'nui/media/imagens/geral/icon-publi-one.png',
    'nui/media/imagens/geral/icon-publi-two.png',
    'nui/media/imagens/geral/botao-perfil.png',
    'nui/media/imagens/geral/botao-sair.png',
    'nui/media/imagens/geral/m-agua.png',
    'nui/media/imagens/geral/logo-depositar.png',
    'nui/media/imagens/geral/logo-sacar.png',
    'nui/media/imagens/geral/logo-transferir.png',

    'nui/index.html',
    'nui/style.css'
}
