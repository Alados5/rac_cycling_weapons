------------------------------------
-- CYCLING WEAPONS MOD BY ALADOS5 --
------------------------------------

-- To customize the configuration parameters, check the config.lua file
-- This is the main code of the mod, if you find any bugs feel free to let me know!

require 'config'

-- Ordered by menu
weaponNames = {
	"Bomb Glove", "Pyrocitor", "Blaster", "Glove of Doom", "Mine Glove",
	"Taunter", "Suck Cannon", "Devastator", "Walloper", "Visibomb Gun",
	"Decoy Glove", "Drone Device", "Tesla Claw", "Morph-o-Ray", "RYNO"
}
nWeapons = #weaponNames
nWeaPool = nWeapons
ammoAddresses = {
	0x96C0D4, 0x96C0EC, 0x96C0E8, 0x96C0FC, 0x96C0F0,
	0x96C0E4, 0x96C0D0, 0x96C0D8, 0x96C0F4, 0x96C0E0,
	0x96C110, 0x96C10C, 0x96C0F8, 0x96C100, 0x96C108
}
maxAmmo = {
	40, 240, 200, 10, 50,
	 0,   0,  20,  0, 20,
	20,  10, 240,  0, 50
}
unlockAddresses = {
	0x96C14A, 0x96C150, 0x96C14F, 0x96C154, 0x96C151,
	0x96C14E, 0x96C149, 0x96C14B, 0x96C152, 0x96C14D,
	0x96C159, 0x96C158, 0x96C153, 0x96C155, 0x96C157
}
vanillaUnlocks = {
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0
}
convIdx = {
	 1,  2,  3,  4,  5,
	 6,  7,  8,  9, 10,
	11, 12, 13, 14, 15
}
qsValues = {
	10, 16, 15, 20, 17,
	14, 09, 11, 18, 13,
	25, 24, 19, 21, 23
}
qsAddresses = {
	0x72A977,
	0x72A97B,
	0x72A97F,
	0x72A983,
	0x72A987,
	0x72A98B,
	0x72A98F,
	0x72A993
}
nQSweapons = #qsAddresses

hpExpAddr 	 = 0xA10954 --It's a damage-related value
currHeldAddr = 0x969C7F
prevHeldAddr = 0x969C9B
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
	prevBolts = ratchet.bolts
	prevAmmo = getWeaponAmmo(randWid)
	usedAmmo = false
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
	elseif swapMode == 'KILL' and ticks%15 == 0 then
		currExp = bytestoint(Ratchetron:ReadMemory(GAME_PID, hpExpAddr, 4))
		currBolts = ratchet.bolts
		
		if currExp ~= prevExp and currBolts ~= prevBolts and usedAmmo then
			kills = kills+1
			prevExp = currExp
			usedAmmo = false
		end
		prevBolts = currBolts
		
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
		
			currAmmo = getWeaponAmmo(randWid)
			if currAmmo < maxAmmo[randWid] or maxAmmo[randWid] == 0 then
				usedAmmo = true
			end

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