fx_version 'cerulean'
game 'gta5'

description 'ZenFoodCart'
version '1.0.0'

shared_scripts { 
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client/cl_main.lua'
server_script 'server/sv_main.lua'  



lua54 'yes'