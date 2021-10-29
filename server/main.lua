local Cooldowns = {}

function TimeToString(time)
	local formattedDate = table.concat(Config.DateFormat, '/') .. " %H:%M:%S"
	local str = os.date(formattedDate, time)
	
	if Config.Debug then
		print(string.format('^3[qb-cooldowns]^7 TimeToString(%s) formattedDate: %s; final string: %s', time, formattedDate, str))
	end
	
	return str
end

function TimeToTable(time)
	local tab = os.date("*t", time)
	
	if Config.Debug then
		print(string.format('^3[qb-cooldowns]^7 TimeToTable(%s) table: %s', time, json.encode(tab)))
	end
	
	return tab
end

function DoesCooldownExist(cb, type)
	if Cooldowns[type] then
		cb(true)
	else
		exports.oxmysql:fetch('SELECT `cooldown` FROM `cooldowns` WHERE `type` = @type', {
			['@type'] = type
		}, function(cooldowns)
			if cooldowns ~= nil and cooldowns[1] ~= nil then
				cb(true)
			else
				cb(false)
			end
		end)
	end
end

function FetchCooldown(cb, type)
	if Cooldowns[type] then
		cb(Cooldowns[type])
	else
		exports.oxmysql:fetch('SELECT `cooldown` FROM `cooldowns` WHERE `type` = @type', {
			['@type'] = type
		}, function(cooldowns)
			if cooldowns ~= nil and cooldowns[1] ~= nil then
				Cooldowns[type] = cooldowns[1].cooldown
				cb(cooldowns[1].cooldown)
			else
				cb(Config.InexistentCooldownStartsAt0 and 0 or os.time())
			end
		end)
	end
end

function GetCooldown(cb, type, format)
	FetchCooldown(function(cooldown)
		if format == nil then
			cb(cooldown - os.time())
		elseif format == 'table' then
			cb(CooldownToTable(cooldown - os.time()))
		elseif format == 'string' then
			cb(CooldownToString(cooldown - os.time()))
		else
			cb(cooldown - os.time())
		end
	end, type)
end

function GetTime(cb, type, format)
	FetchCooldown(function(cooldown)
		if format == nil then
			cb(cooldown)
		elseif format == 'table' then
			cb(TimeToTable(cooldown))
		elseif format == 'string' then
			cb(TimeToString(cooldown))
		else
			cb(cooldown)
		end
	end, type)
end

function SetCooldown(type, cooldown)
	DoesCooldownExist(function(doesExist)
		if doesExist then
			exports.oxmysql:execute('UPDATE `cooldowns` SET `cooldown` = @cooldown WHERE `type` = @type', {
				['@cooldown'] = cooldown,
				['@type'] = type
			}, function(rowsChanged)
				Cooldowns[type] = cooldown
				if Config.Debug then
					print(string.format('^3[qb-cooldowns]^7 The cooldown %s has been established to %s', type, cooldown))
				end
			end)
		else
			exports.oxmysql:execute('INSERT INTO `cooldowns` (`type`, `cooldown`) VALUES (@type, @cooldown)', {
				['@type'] = type,
				['@cooldown'] = cooldown
			}, function(id)
				Cooldowns[type] = cooldown
				if Config.Debug then
					print(string.format('^3[qb-cooldowns]^7 The cooldown %s has been established to %s, creating a new entry with ID %s', type, cooldown, id))
				end
			end)
		end
	end, type)
end

if Config.RegisterSetCooldown then
	RegisterNetEvent('qb-cooldowns:setCooldown')
	AddEventHandler('qb-cooldowns:setCooldown', function(type, cooldown)
		if Config.Debug then
			print(string.format('^1[qb-cooldowns]^7 setCooldown event has been called by source %s', source or 'resource'))
		end
		
		SetCooldown(type, cooldown)
	end)
end

RegisterNetEvent('qb-cooldowns:getCooldown')
AddEventHandler('qb-cooldowns:getCooldown', function(cb, type, format)
	if Config.Debug then
		print(string.format('^3[qb-cooldowns]^7 getCooldown event has been called by source %s', source or 'resource'))
	end
	
	GetCooldown(function(cooldown)
		cb(cooldown)
	end, type, format)
end)

QBCore.Functions.CreateCallback('qb-cooldowns:getCooldown', function(source, cb, type, format)
	if Config.Debug then
		print(string.format('^3[qb-cooldowns]^7 getCooldown qb callback has been called by source %s', source or 'resource'))
	end
	
	GetCooldown(function(cooldown)
		cb(cooldown)
	end, type, format)
end)

RegisterNetEvent('qb-cooldowns:getTime')
AddEventHandler('qb-cooldowns:getTime', function(cb, type, format)
	if Config.Debug then
		print(string.format('^3[qb-cooldowns]^7 getTime event has been called by source %s', source or 'resource'))
	end
	
	GetTime(function(cooldown)
		cb(cooldown)
	end, type, format)
end)

QBCore.Functions.CreateCallback('qb-cooldowns:getTime', function(source, cb, type, format)
	if Config.Debug then
		print(string.format('^3[qb-cooldowns]^7 getTime qb callback has been called by source %s', source or 'resource'))
	end
	
	GetTime(function(cooldown)
		cb(cooldown)
	end, type, format)
end)

if Config.Debug then
	RegisterCommand('testtimetostring', function()
		TimeToString(os.time())
	end, false)
	
	RegisterCommand('testtimetotable', function()
		TimeToTable(os.time())
	end, false)
end
