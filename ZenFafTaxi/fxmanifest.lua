fx_version 'cerulean'
game 'gta5'

description 'Fast As Fuck Taxi Company'
version '1.2.3'

shared_scripts {
	'config.lua'
}
files {
	'data/carcols.meta'
  }
  
client_scripts {
	'client/main.lua',
	'client/job.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

	data_file 'CARCOLS_FILE' 'data/carcols.meta'
lua54 'yes'