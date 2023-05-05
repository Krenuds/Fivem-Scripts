fx_version 'cerulean'
game 'gta5'

description 'Zeno Scavenger Hunt'
version '1.0'

shared_scripts {
    'config.lua'
}

files {
    'images/*.txt'
}

client_script 'client.lua'

server_script 'server.lua'

lua54 'yes'
