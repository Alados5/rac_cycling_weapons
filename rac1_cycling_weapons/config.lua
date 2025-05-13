------------------------------------
-- CYCLING WEAPONS MOD BY ALADOS5 --
------------------------------------

-- Change this configuration to your liking!

--[[
swapMode
	The main parameter, determines when weapons are swapped. It can be:
	'TIME': weapons will change after a certain amount of time, configured in swapTime
	'KILL': weapons will change after a certain amount of kills, configured in swapKills
	'AMMO': weapons will change after a set amount of ammo is used, configured in swapAmmo
--]]
swapMode = 'AMMO'

--[[
avoidRepeats
	A boolean (true/false) to avoid rolling the same weapon twice in a row.
	When set to true, if the random number generator picks the current weapon again,
	it will reroll until generating a different weapon
--]]
avoidRepeats = true

--[[
swapTime
	If swapMode = 'TIME', determines the time in seconds between weapon changes
	Minimum is 10 seconds
--]]
swapTime = 30

--[[
swapKills
	If swapMode = 'KILL', determines the enemies that need to be killed for weapons to change
	Disclaimer: KILL mode works checking when you've dealt or received damage (same address),
	bolts have changed and ammo has been used, as rac1 has no experience.
	This mode might be a bit finnicky on this game, not swapping exactly on kill
--]]
swapKills = 1

--[[
swapAmmo
	If swapMode = 'AMMO', this list determines the amount of ammo each weapon will have on swap.
	The next swap will happen when ammo = 0. If you set any value here to 0, the weapon will be banned.
	Infinite ammo weapons are banned from this mode.
--]]
swapAmmo = {
	["Bomb Glove"]		= 8,
	["Pyrocitor"]		= 50,
	["Blaster"]			= 40,
	["Glove of Doom"]	= 2,
	["Mine Glove"]		= 10,
	["Taunter"]			= 0,
	["Suck Cannon"]		= 0,
	["Devastator"]		= 4,
	["Walloper"]		= 0,
	["Visibomb Gun"]	= 4,
	["Decoy Glove"]		= 4,
	["Drone Device"]	= 2,
	["Tesla Claw"]		= 50,
	["Morph-o-Ray"]		= 0,
	["RYNO"]			= 10
}

--[[
banAmmoIncreases
	A boolean (true/false) to remove any ammo increases if swapMode = 'AMMO'
	This will roll back ammo from crates and purchased in vendors,
	to ensure the swap happens after the configured ammo is used and not more.
--]]
banAmmoIncreases = true

--[[
bannedWeapons
	A list of booleans (true/false) to remove specific weapons from the pool.
	When set to true, they will never get chosen at random
	Recommended to ban: Taunter,
	just to enjoy the run more
--]]
bannedWeapons = {
	["Bomb Glove"]		= false,
	["Pyrocitor"]		= false,
	["Blaster"]			= false,
	["Glove of Doom"]	= false,
	["Mine Glove"]		= false,
	["Taunter"]			= true,
	["Suck Cannon"]		= false,
	["Devastator"]		= false,
	["Walloper"]		= false,
	["Visibomb Gun"]	= false,
	["Decoy Glove"]		= false,
	["Drone Device"]	= false,
	["Tesla Claw"]		= false,
	["Morph-o-Ray"]		= false,
	["RYNO"]			= false
}



