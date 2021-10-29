Config = {}

Config.Debug = false

-- If true, inexistent cooldown will return 0, otherwise, it will return os.time()
Config.InexistentCooldownStartsAt0 = false

--[[
	If true, it will mean that the event setCooldown can be
	triggered by clients, I strongly recommend to not do
	this, use the export from server side.
]]
Config.RegisterSetCooldown = false
	
--[[
	Format the date in the function TimeToString(time):
	'%d': day; '%m': month; '%Y': year; '%y': short year
	More info: https://www.lua.org/pil/22.1.html
	Example: { '%d', '%m', '%Y' } will produce '20/05/2020'
]]
Config.DateFormat = { '%d', '%m', '%Y' }
