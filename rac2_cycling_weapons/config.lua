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
	["Lancer"]				= 50,
	["Gravity Bomb"]		= 2,
	["Chopper"]				= 7,
	["Seeker Gun"]			= 6,
	["Pulse Rifle"]			= 2,
	["Miniturret Glove"]	= 4,
	["Blitz Gun"]			= 10,
	["Shield Charger"]		= 1,
	["Synthenoid"]			= 4,
	["Lava Gun"]			= 50,
	["Bouncer"]				= 5,
	["Minirocket Tube"]		= 6,
	["Plasma Coil"]			= 4,
	["Hoverbomb Gun"]		= 3,
	["Spiderbot Glove"]		= 2,
	["Sheepinator"]			= 0,
	["Tesla Claw"]			= 50,
	["Bomb Glove"]			= 8,
	["Walloper"]			= 0,
	["Visibomb Gun"]		= 2,
	["Decoy Glove"]			= 2,
	["Zodiac"]				= 1,
	["RYNO II"]				= 20,
	["Clank Zapper"]		= 2
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
	Recommended options are the Clank Zapper, Synthenoid and Shield Charger,
	as they tend to crash the game (they are not weapons held by Ratchet)
--]]
bannedWeapons = {
	["Lancer"]				= false,
	["Gravity Bomb"]		= false,
	["Chopper"]				= false,
	["Seeker Gun"]			= false,
	["Pulse Rifle"]			= false,
	["Miniturret Glove"]	= false,
	["Blitz Gun"]			= false,
	["Shield Charger"]		= true,
	["Synthenoid"]			= true,
	["Lava Gun"]			= false,
	["Bouncer"]				= false,
	["Minirocket Tube"]		= false,
	["Plasma Coil"]			= false,
	["Hoverbomb Gun"]		= false,
	["Spiderbot Glove"]		= false,
	["Sheepinator"]			= false,
	["Tesla Claw"]			= false,
	["Bomb Glove"]			= false,
	["Walloper"]			= false,
	["Visibomb Gun"]		= false,
	["Decoy Glove"]			= false,
	["Zodiac"]				= false,
	["RYNO II"]				= false,
	["Clank Zapper"]		= true
}



