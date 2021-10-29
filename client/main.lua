
function GetCooldown(cb, type, format)
	QBCore.Functions.TriggerCallback('qb-cooldowns:getCooldown', function(cooldown)
		cb(cooldown)
	end, type, format)
end

function GetTime(cb, type, format)
	QBCore.Functions.TriggerCallback('qb-cooldowns:getTime', function(time)
		cb(time)
	end, type, format)
end

RegisterNetEvent('qb-cooldowns:getCooldown')
AddEventHandler('qb-cooldowns:getCooldown', function(cb, type, format)
	GetCooldown(function(cooldown)
		cb(cooldown)
	end, type, format)
end)

RegisterNetEvent('qb-cooldowns:getTime')
AddEventHandler('qb-cooldowns:getTime', function(cb, type, format)
	GetTime(function(cooldown)
		cb(cooldown)
	end, type, format)
end)

if Config.Debug then
	RegisterCommand('testgetcooldown', function(source, args, rawCommand)
		GetCooldown(function(cooldown)
			print(cooldown)
		end, args[1], args[2])
	end, false)
	
	RegisterCommand('testgettime', function(source, args, rawCommand)
		GetTime(function(time)
			print(time)
		end, args[1], args[2])
	end, false)
end
