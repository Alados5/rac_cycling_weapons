# R&C Cycling Weapons Mod

 Ratchet & Clank mod for RaCMAN: Changes weapons randomly after some time, kills or ammo used.
 
 **The mod is currently only available for Ratchet & Clank 2: Going Commando**
 
 The mod has 3 separate modes:
 - Time: swap weapons after a set amount of time
 - Kill: swap weapons after killing a specific amount of enemies
   - **Disclaimer:** The mod can only detect experience increases on a frame, so killing several enemies on the same frame counts as 1 single kill.
 - Ammo: swap weapons after using a predefined amount of ammo
 
## Pre-requisites

- A Homebrew Enabled (HEN) PS3
   - There are guides available online
   - The RPCS3 Emulator is not tested
- [RaCMAN](https://github.com/MichaelRelaxen/racman) installed
- A digital PAL PS3 version of the compatible R&C games

## Installing the mod

### Option 1: copying the files

1. Download the zip file(s) on the [Releases](https://github.com/Alados5/rac_cycling_weapons/releases) section
2. Open the `mods` folder in the RaCMAN folder
3. Unzip the downloaded zip file(s)
4. Place each mod folder inside the corresponding game's folder
   - R&C1 is `NPEA00385`
   - R&C2 is `NPEA00386`
   - R&C3 is `NPEA00387`

### Option 2: in RaCMAN

1. Download the zip file(s) on the [Releases](https://github.com/Alados5/rac_cycling_weapons/releases) section
2. Open the desired game on PS3
3. Run RaCMAN
4. Connect RaCMAN to console or emulator
5. Open `Menu` -> `Patch loader...`
6. Click `Add ZIP...` and browse the downloaded zip
7. Repeat from step 2 for any other games

## Configuring mod options

1. Open the mod folder once installed in RaCMAN
2. Open the `config.lua` file in a text editor
3. Change the parameters to your liking
   - `swapMode`: The main parameter, determines when weapons are swapped. It can be:
      - `'TIME'`: weapons will change after a certain amount of time, configured in `swapTime`.
	  - `'KILL'`: weapons will change after a certain amount of kills, configured in `swapKills`.
	  - `'AMMO'`: weapons will change after a set amount of ammo is used, configured in `swapAmmo`.
   - `avoidRepeats`: A boolean (`true`/`false`) to avoid rolling the same weapon twice in a row. When set to `true`, if the random number generator picks the current weapon again, it will reroll until generating a different weapon.
   - `swapTime`: If `swapMode = 'TIME'`, determines the time in seconds between weapon changes. Minimum is 10 seconds.
   - `swapKills`: If `swapMode = 'KILL'`, determines the enemies that need to be killed for weapons to change.
      - **Disclaimer:** `'KILL'` mode works with experience increases, so if you kill multiple enemies on the same frame, it will count as 1 single kill towards the total.
   - `swapAmmo`: If `swapMode = 'AMMO'`, this list determines the amount of ammo each weapon will have on swap. The next swap will happen when ammo reaches 0. If you set any value here to 0, the weapon will be banned. Infinite ammo weapons are banned from this mode.
   - `banAmmoIncreases`: A boolean (`true`/`false`) to remove any ammo increases if `swapMode = 'AMMO'`. This will roll back ammo from crates and purchased in vendors, to ensure the swap happens after the configured ammo is used and not more.
   - `bannedWeapons`: A list of booleans (`true`/`false`) to remove specific weapons from the pool. When set to true, they will never get chosen at random.
      - Recommended options are the Clank Zapper, Synthenoid and Shield Charger, as they tend to crash the game (they are not weapons held by Ratchet)


## Running the mod

1. Configure the mod to your liking
2. Open the desired game on PS3
3. Run RaCMAN
4. Connect RaCMAN to console or emulator
5. Open `Menu` -> `Patch loader...`
6. Start a game (mod will not start correctly in the main menu)
7. Select the checkbox of the mod on the list
8. Enjoy!
