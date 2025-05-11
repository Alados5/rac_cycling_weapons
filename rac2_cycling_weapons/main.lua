------------------------------------
-- CYCLING WEAPONS MOD BY ALADOS5 --
------------------------------------

-- To customize the configuration parameters, check the config.lua file
-- This is the main code of the mod, if you find any bugs feel free to let me know!

require 'config'

-- Ordered by menu: 1=Lancer, 2=Gravity Bomb, ..., 23=RYNO II, 24=Clank Zapper
weaponNames = {
	"Lancer", "Gravity Bomb", "Chopper", "Seeker Gun",
	"Pulse Rifle", "Miniturret Glove", "Blitz Gun", "Shield Charger",
	"Synthenoid", "Lava Gun", "Bouncer", "Minirocket Tube",
	"Plasma Coil", "Hoverbomb Gun", "Spiderbot Glove", "Sheepinator",
	"Tesla Claw", "Bomb Glove", "Walloper", "Visibomb Gun",
	"Decoy Glove", "Zodiac", "RYNO II", "Clank Zapper"
}
nWeapons = #weaponNames
nWeaPool = nWeapons
ammoAddresses = {
	0x014818A4, 0x014818D4, 0x01481884, 0x0148188C,
	0x01481888, 0x014818D0, 0x01481894, 0x014818E0,
	0x014818A8, 0x014818A0, 0x014818C0, 0x01481898,
	0x0148189C, 0x01481890, 0x014818AC, 0x00000000, --Sheepinator => DO NOT WRITE!
	0x01481874, 0x0148185C, 0x00000000, 0x01481864, --Walloper => DO NOT WRITE!
	0x01481870, 0x014818D8, 0x014818DC, 0x01481850
}
maxAmmo = {
	200,   8,  35, 25,
	  8,  20,  40,  5,
	 12, 200,  25, 25,
	 15,  10,   8,  0,
	300,  40,   0, 20,
	 20,   4, 100, 30
}
unlockAddresses = {
	0x01481A9E, 0x01481AAA, 0x01481A96, 0x01481A98,
	0x01481A97, 0x01481AA9, 0x01481A9A, 0x01481AAD,
	0x01481A9F, 0x01481A9D, 0x01481AA5, 0x01481A9B,
	0x01481A9C, 0x01481A99, 0x01481AA0, 0x01481A90,
	0x01481A92, 0x01481A8C, 0x01481AB5, 0x01481A8E,
	0x01481A91, 0x01481AAB, 0x01481AAC, 0x01481A89
}
vanillaUnlocks = {
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
}
convIdx = {
	 1,  2,  3,  4,
	 5,  6,  7,  8,
	 9, 10, 11, 12,
	13, 14, 15, 16,
	17, 18, 19, 20,
	21, 22, 23, 24
}
qsValues = {
	30, 42, 22, 24,
	23, 41, 26, 45,
	31, 29, 37, 27,
	28, 25, 32, 16,
	18, 12, 53, 14,
	17, 43, 44, 09
}
qsAddresses = {
	0x01481C43,
	0x01481C47,
	0x01481C4B,
	0x01481C4F,
	0x01481C53,
	0x01481C57,
	0x01481C5B,
	0x01481C5F,
}
nQSweapons = #qsAddresses

hpExpAddr 	 = 0x1329AA4
currHeldAddr = 0x147F1BB --0x148042B
prevHeldAddr = 0x1329A9F
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
	for i=2,nQSweapons do
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
	Ratchetron:WriteMemory(GAME_PID, prevHeldAddr, 1, inttobytes(qsValues[randWid],1))
	
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
	Ratchetron:WriteMemory(GAME_PID, prevHeldAddr, 1, inttobytes(qsValues[1],1))
	
	print("Unloaded!")
end