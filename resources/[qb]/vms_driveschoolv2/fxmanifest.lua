fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'vames™️'
description 'vms_driveschoolv2'
version '1.0.5'

shared_scripts {
	'config/config.lua',
}

client_scripts {
	'client/*.lua',
	'config/config.client.lua',
}

server_scripts {
	'server/*.lua',
	'config/config.server.lua'
}

ui_page 'html/index.html'

files {
	'data/vehicles.meta',
    'data/handling.meta',
	'html/*.*',
	'html/**/*.*',
	'config/*.js',
}

data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'

escrow_ignore {
	'config/*.lua',
	'server/version_check.lua',
}
dependency '/assetpacks'