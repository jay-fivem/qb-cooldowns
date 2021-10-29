fx_version 'adamant'
game 'gta5'

shared_script '@qb-core/import.lua'

client_scripts {
	'config.lua',
	'shared/main.lua',
	'client/main.lua'
}

server_scripts {
	'config.lua',
	'shared/main.lua',
	'server/main.lua'
}

exports {
	'CooldownToTable',
	'CooldownToString',
	'GetCooldown',
	'GetTime'
}

server_exports {
	'CooldownToTable',
	'CooldownToString',
	'TimeToString',
	'TimeToTable',
	'GetCooldown',
	'GetTime',
	'SetCooldown'
}
