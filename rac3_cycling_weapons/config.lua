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
swapMode = 'KILL'

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
	Disclaimer: KILL mode works with experience increases, so if you kill multiple enemies
	on the same frame, it will count as 1 single kill towards the total
--]]
swapKills = 1

--[[
swapAmmo
	If swapMode = 'AMMO', this list determines the amount of ammo each weapon will have on swap.
	The next swap will happen when ammo = 0. If you set any value here to 0, the weapon will be banned.
	Infinite ammo weapons are banned from this mode.
--]]
swapAmmo = {
	["Shock Blaster"]		= 6,
	["Nitro Launcher"]		= 2,
	["N60 Storm"]			= 30,
	["Plasma Whip"]			= 5,
	["Infector"]			= 3,
	["Suck Cannon"]			= 0,
	["Spitting Hydra"]		= 3,
	["Agents of Doom"]		= 1,
	["Flux Rifle"]			= 2,
	["Annihilator"]			= 4,
	["Holoshield Glove"]	= 2,
	["Disc Blade Gun"]		= 5,
	["Rift Inducer"]		= 2,
	["Qwack-o-Ray"]			= 0,
	["RY3NO"]				= 5,
	["Miniturret Glove"]	= 2,
	["Lava Gun"]			= 30,
	["Shield Charger"]		= 1,
	["Bouncer"]				= 2,
	["Plasma Coil"]			= 3
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
	Recommended to ban: Shield Charger,
	as they tend to crash the game (they are not weapons held by Ratchet)
--]]
bannedWeapons = {
	["Shock Blaster"]		= false,
	["Nitro Launcher"]		= false,
	["N60 Storm"]			= false,
	["Plasma Whip"]			= false,
	["Infector"]			= false,
	["Suck Cannon"]			= false,
	["Spitting Hydra"]		= false,
	["Agents of Doom"]		= false,
	["Flux Rifle"]			= false,
	["Annihilator"]			= false,
	["Holoshield Glove"]	= false,
	["Disc Blade Gun"]		= false,
	["Rift Inducer"]		= false,
	["Qwack-o-Ray"]			= false,
	["RY3NO"]				= false,
	["Miniturret Glove"]	= false,
	["Lava Gun"]			= false,
	["Shield Charger"]		= true,
	["Bouncer"]				= false,
	["Plasma Coil"]			= false
}



