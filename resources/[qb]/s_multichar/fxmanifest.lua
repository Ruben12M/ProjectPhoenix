fx_version 'cerulean'
game 'gta5'

description 's_multichar'
version '1.0.1'

shared_scripts {
   -- '@ox_lib/init.lua', -- uncomment if u want to use ox
    'config/config.lua',
    'config/translations.lua',
    'shared/*.lua',
}

client_scripts {
    'client/main.lua',
    'config/config_client.lua',
    'client/apps.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
}

server_scripts  {
    '@oxmysql/lib/MySQL.lua',
    'config/config_server.lua',
    'server/main.lua',
    'server/apps.lua',
    'server/version_check.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'starter_shells_k4mb1.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'starter_shells_k4mb1.ytyp'

escrow_ignore {
    'config/*.lua',
    'server/version_check',
}

lua54 'yes'

dependency '/assetpacks'