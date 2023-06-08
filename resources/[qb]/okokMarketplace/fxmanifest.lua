lua54 'yes'

escrow_ignore {
	'config.lua'
}

fx_version 'adamant'

game 'gta5'

author 'okok#3488'
description 'okokMarketplace'

ui_page 'web/ui.html'

files {
	'web/*.*',
	'web/icons/*.png'
}

shared_script 'config.lua'

client_scripts {
	'client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}