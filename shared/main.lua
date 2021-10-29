-- Credit: https://stackoverflow.com/a/45376848
function CooldownToTable(cooldown)
	local isNegative = cooldown < 0 and true or false
	cooldown = isNegative and math.abs(cooldown) or cooldown
	local days = math.floor(cooldown/86400)
	local hours = math.floor((cooldown%86400)/3600)
	local minutes = math.floor((cooldown%3600)/60)
	local seconds = math.floor(cooldown%60)
	return { isNegative = isNegative, days = days, hours = hours, minutes = minutes, seconds = seconds }
end

function CooldownToString(cooldown)
	local tab = CooldownToTable(cooldown)
	return string.format("%s%d:%02d:%02d:%02d", tab.isNegative and '-' or '', tab.days, tab.hours, tab.minutes, tab.seconds)
end
