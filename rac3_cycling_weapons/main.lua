------------------------------------
-- CYCLING WEAPONS MOD BY ALADOS5 --
------------------------------------

-- To customize the configuration parameters, check the config.lua file
-- This is the main code of the mod, if you find any bugs feel free to let me know!

require 'config'

-- Ordered by menu: 1=Lancer, 2=Gravity Bomb, ..., 23=RYNO II, 24=Clank Zapper
weaponNames = {
	"Shock Blaster", "Nitro Launcher", "N60 Storm", "Plasma Whip", "Infector",
	"Suck Cannon", "Spitting Hydra", "Agents of Doom", "Flux Rifle", "Annihilator",
	"Holoshield Glove", "Disc Blade Gun", "Rift Inducer", "Qwack-o-Ray", "RY3NO",
	"Miniturret Glove", "Lava Gun", "Shield Charger", "Bouncer", "Plasma Coil"
}
nWeapons = #weaponNames
nWeaPool = nWeapons
ammoAddr = 0xDA5240-0x230
ammoAddresses = {
	ammoAddr+0x2CC, ammoAddr+0x40C, ammoAddr+0x2EC, ammoAddr+0x42C, ammoAddr+0x30C,
	ammoAddr+0x44C, ammoAddr+0x34C, ammoAddr+0x38C, ammoAddr+0x3EC, ammoAddr+0x32C,
	ammoAddr+0x3CC, ammoAddr+0x36C, ammoAddr+0x3AC, ammoAddr+0x46C, ammoAddr+0x48C,
	ammoAddr+0x284, ammoAddr+0x274, ammoAddr+0x288, ammoAddr+0x27C, ammoAddr+0x270
}
maxAmmo = {
	30,   8, 150, 25, 15,
	 0,  15,   6, 10, 20,
	 8,  25,   8,  0, 25,
	10, 150,   3, 10, 15
}
unlockAddr = 0xDA56EC-0x4A8
unlockAddresses = {
	unlockAddr+0x4CF, unlockAddr+0x51F, unlockAddr+0x4D7, unlockAddr+0x527, unlockAddr+0x4DF,
	unlockAddr+0x52F, unlockAddr+0x4EF, unlockAddr+0x4FF, unlockAddr+0x517, unlockAddr+0x4E7,
	unlockAddr+0x50F, unlockAddr+0x4F7, unlockAddr+0x507, unlockAddr+0x537, unlockAddr+0x53F,
	unlockAddr+0x4BD, unlockAddr+0x4B9, unlockAddr+0x4BE, unlockAddr+0x4BB, unlockAddr+0x4B8
}
vanillaUnlocks = {
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0
}
convIdx = {
	 1,  2,  3,  4,  5,
	 6,  7,  8,  9, 10,
	11, 12, 13, 14, 15,
	16, 17, 18, 19, 20
}
qsValues = {
	 39, 119,  47, 127,  55,
	135,  71,  87, 111,  63,
	103,  79,  95, 143, 151,
	 21,  17,  22,  19,  16
}
--[[
39-46 = shock blaster
47-54 = N60
55-62 = infector
63-70 = annihilator
71-78 = spitting hydra
79-86 = disc blade gun
87-94 = agents of doom
95-102 = rift inducer
103-110 = holo shield glove
111-118 = flux rifle
119-126 = nitro launcher
127-134 = plasma whip
135-142 = suck cannon
143-150 = qwack-o-ray
151-155 = ryno
--]]
qsAddresses = {
	0xC537C3,
	0xC537C7,
	0xC537CB,
	0xC537CF,
	0xC537D3,
	0xC537D7,
	0xC537DB,
	0xC537DF,
	0xC537E3,
	0xC537E7,
	0xC537EB,
	0xC537EF,
	0xC537F3,
	0xC537F7,
	0xC537FB,
	0xC537FF
}
nQSweapons = #qsAddresses

hpExpAddr 	 = 0xC1E510
currHeldAddr = 0xDA27CB
nextHeldAddr = 0xC1E4EF
prevHeldAddr = 0xC1E4F3
thirHeldAddr = 0xC1E4F7
randWeapon = 0

-- Clamp parameter limits
function clampParameters()
	-- Minimum swap time: 10 s
	swapTime = math.floor(swapTime)
	if swapTime < 10 then
		swapTime = 10
	end
	
	-- Minimum swap kills: 1
	swapKills = math.floor(swapKills)
	if swapKills < 1 then
		swapKills = 1
	end
	
end

-- Remove banned weapons
function removeBannedWeapons()
	for wid=nWeapons,1,-1 do
	
		-- Avoid infinite/0 ammo weapons when swap is based on AMMO
		noAmmoBan = (swapMode=='AMMO') and (maxAmmo[wid]<=0 or swapAmmo[weaponNames[wid]]<=0)
		
		-- convIdx is a conversion table between full wid and pool indexes (wpid)
		if bannedWeapons[weaponNames[wid]] or noAmmoBan then
			table.remove(convIdx, wid)
		end
		
	end
	nWeaPool = #convIdx
	
	if nWeaPool <= 1 then
		error('----------------------------------------------------------------------------- '..
			'\nERROR: The pool must have at least two weapons! '..
			'\nPlease change bannedWeapons in the config.lua file. '..
			'-----------------------------------------------------------------------------')
	end
end

-- Clean weapon from quick select
function cleanQS(wid)
	for i=1,nQSweapons do
		itemInSlot = bytestoint(Ratchetron:ReadMemory(GAME_PID, qsAddresses[i], 1))
		if itemInSlot == qsValues[wid] then
			Ratchetron:WriteMemory(GAME_PID, qsAddresses[i], 1, inttobytes(0,1))
		end
	end
end
	
-- Set max or no ammo for a weapon
function setWeaponAmmo(wid, withAmmo)
	-- Only for weapons with ammo
	if maxAmmo[wid]==0 then
		return
	elseif (withAmmo==true or withAmmo==1) and swapMode~='AMMO' then
		Ratchetron:WriteMemory(GAME_PID, ammoAddresses[wid], 4, inttobytes(maxAmmo[wid],4))
	elseif (withAmmo==true or withAmmo==1) then
		Ratchetron:WriteMemory(GAME_PID, ammoAddresses[wid], 4, inttobytes(swapAmmo[weaponNames[wid]],4))
	else
		Ratchetron:WriteMemory(GAME_PID, ammoAddresses[wid], 4, inttobytes(0,4))
	end
end

-- Get ammo for a weapon
function getWeaponAmmo(wid)
	-- Only for weapons with ammo
	if maxAmmo[wid]==0 then
		ammo = 0
	else
		ammo = bytestoint(Ratchetron:ReadMemory(GAME_PID, ammoAddresses[wid], 4))
	end
	return ammo
end

-- Lock or unlock a weapon
function setWeaponUnlock(wid, unlocked)
	if unlocked==0 or not unlocked then
		writeVal = 0
	else
		writeVal = 1
	end
	
	Ratchetron:WriteMemory(GAME_PID, unlockAddresses[wid], 1, inttobytes(writeVal,1))
end

-- Get weapon unlock status
function getWeaponUnlock(wid)
	unlocked = bytestoint(Ratchetron:ReadMemory(GAME_PID, unlockAddresses[wid], 1))
	
	return unlocked
end

-- Choose a new random weapon
function chooseRandomWeapon()
	-- Check current weapon
	prevRandW = randWeapon
	
	-- Choose weapon. Reroll if avoiding repeats
	randWeapon = math.random(nWeaPool)
	while (randWeapon == prevRandW) and avoidRepeats do	
		print("Avoiding a repeat!")
		randWeapon = math.random(nWeaPool)
	end
	randWid = convIdx[randWeapon]
		
	-- Set unlocked and max ammo
	setWeaponUnlock(randWid, true)
	setWeaponAmmo(randWid, true)

	-- Put it on the top QS slot
	Ratchetron:WriteMemory(GAME_PID, qsAddresses[1], 1, inttobytes(qsValues[randWid],1))

	-- Make it the next weapon to shoot and previous held item
	Ratchetron:WriteMemory(GAME_PID, currHeldAddr, 1, inttobytes(qsValues[randWid],1))
	Ratchetron:WriteMemory(GAME_PID, nextHeldAddr, 1, inttobytes(qsValues[randWid],1))
	Ratchetron:WriteMemory(GAME_PID, prevHeldAddr, 1, inttobytes(qsValues[randWid],1))
	Ratchetron:WriteMemory(GAME_PID, thirHeldAddr, 1, inttobytes(qsValues[randWid],1))
	
	print("Changed weapon to... "..weaponNames[randWid].."!")
	return randWid
end


------------------------------------
function OnLoad()
	-- Show swap mode
	print("Mod loading, swap mode: "..swapMode)

	-- Save already unlocked weapons
	for wid=1,nWeapons do
		vanillaUnlocks[wid] = getWeaponUnlock(wid)
	end

	-- Remove banned weapons from pool
	removeBannedWeapons()
	
	-- Display final pool
	poolStr = 'Weapon pool: '
	for wpid=1,nWeaPool do
		poolStr = poolStr..weaponNames[convIdx[wpid]]..', '
	end
	poolStr = poolStr:sub(1,-3)
	print(poolStr)
	
	-- Clamp config parameters
	clampParameters()
	
	-- Clean all weapons, ammo and QS
	for wid=1,nWeapons do
		setWeaponUnlock(wid, false)
		setWeaponAmmo(wid, false)
		cleanQS(wid)
	end
	
	-- Set random seed based on current timestamp
	math.randomseed(os.time())
	
	-- Get the first random weapon
	randWid = chooseRandomWeapon()
	
	-- Initialize variables
	time0 = os.clock()
	kills = 0
	prevExp = bytestoint(Ratchetron:ReadMemory(GAME_PID, hpExpAddr, 4))
	prevAmmo = getWeaponAmmo(randWid)
	switching = false
	
	print("Loaded!")
end


function OnTick(ticks)
	-- Check swap conditions
	-- TIME: get current time, delta, and swap if over parameter
	if swapMode == 'TIME' then
		time_now = os.clock()
		dtime = time_now-time0
	
		if dtime > swapTime and not switching then
			switching = true
			randWid = chooseRandomWeapon()
			time0 = time_now
			switching = false
		end
	
	-- AMMO: get current ammo, ban increases (if enabled) and swap if 0
	elseif swapMode == 'AMMO' then
		currAmmo = getWeaponAmmo(randWid)
		
		deltaAmmo = currAmmo-prevAmmo
		if banAmmoIncreases and deltaAmmo > 0 then
			Ratchetron:WriteMemory(GAME_PID, ammoAddresses[randWid], 4, inttobytes(prevAmmo,4))
			currAmmo = prevAmmo
		end
		
		if currAmmo <= 0 and not switching then
			switching = true
			randWid = chooseRandomWeapon()
			currAmmo = getWeaponAmmo(randWid)
			switching = false
		end
		prevAmmo = currAmmo
	
	-- KILL: get current exp, add a kill if increased, and swap if over parameter
	elseif swapMode == 'KILL' then
		currExp = bytestoint(Ratchetron:ReadMemory(GAME_PID, hpExpAddr, 4))
		if currExp > prevExp then
			kills = kills+1
			prevExp = currExp
		end
		
		if kills >= swapKills and not switching then
			switching = true
			randWid = chooseRandomWeapon()
			kills = 0
			switching = false
		end
	end
	
	-- Make sure the chosen weapon stays at max ammo and all others are cleared
	wid = ticks%nWeapons + 1
	if wid==randWid then
		if swapMode~='AMMO' then
			setWeaponAmmo(wid, true)
		end
	else
		setWeaponUnlock(wid, false)
		setWeaponAmmo(wid, false)
		cleanQS(wid)
	end
	
end


function OnUnload()
	-- Give initially unlocked weapons back
	ogUnlocked = 'Weapons given back: '
	for wid=1,nWeapons do
		if vanillaUnlocks[wid]==1 then
			ogUnlocked = ogUnlocked..weaponNames[wid]..', '
		end
		setWeaponUnlock(wid, vanillaUnlocks[wid])
		setWeaponAmmo(wid, vanillaUnlocks[wid])
	end
	ogUnlocked = ogUnlocked:sub(1,-3)
	print(ogUnlocked)
	
	-- Remove the top QS slot
	Ratchetron:WriteMemory(GAME_PID, qsAddresses[1], 1, inttobytes(0,1))
	
	-- Change the next weapon to shoot and previous held item to the first weapon
	Ratchetron:WriteMemory(GAME_PID, currHeldAddr, 1, inttobytes(qsValues[1],1))
	Ratchetron:WriteMemory(GAME_PID, nextHeldAddr, 1, inttobytes(qsValues[1],1))
	Ratchetron:WriteMemory(GAME_PID, prevHeldAddr, 1, inttobytes(qsValues[1],1))
	Ratchetron:WriteMemory(GAME_PID, thirHeldAddr, 1, inttobytes(qsValues[1],1))
	
	print("Unloaded!")
end