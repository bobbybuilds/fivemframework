fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'BobbyBuilds'
description 'BB - Custom Framework'
version '0.0.1'

client_scripts {
    'scripts/client/framework.lua',
    'rageui/RMenu.lua',
    'rageui/menu/RageUI.lua',
    'rageui/menu/Menu.lua',
    'rageui/menu/MenuController.lua',
    'rageui/components/*.lua',
    'rageui/menu/elements/*.lua',
    'rageui/menu/items/*.lua',
    'rageui/menu/panels/*.lua',
    'rageui/menu/windows/*.lua',

    'scripts/client/**/*.lua',
}

shared_scripts {
    'scripts/config/**/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'scripts/server/framework.lua',

    'scripts/server/**/*.lua'
}

loadscreen 'scripts/ui/loadingscreen/index.html'
loading_screen_manual_shutdown "yes"

ui_page 'scripts/ui/**/index.html'

files {
    'scripts/ui/**/index.html',
    'scripts/ui/**/script.js',
    'scripts/ui/**/style.css',
}


