# R&C Cycling Weapons Mod

 Ratchet & Clank mod for RaCMAN: Changes weapons randomly after some time, kills or ammo used.
 
 ** The mod is currently only available for Ratchet & Clank 2: Going Commando**
 
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

1. Download the zip file(s) on the [Releases]() section
2. Open the `mods` folder in the RaCMAN folder
3. Unzip the downloaded zip file(s)
4. Place each mod folder inside the corresponding game's folder
   - R&C1 is `NPEA00385`
   - R&C2 is `NPEA00386`
   - R&C3 is `NPEA00387`

### Option 2: in RaCMAN

1. Download the zip file(s) on the [Releases]() section
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
   - `swapMode`: ...

## Running the mod

1. Configure the mod to your liking
2. Open the desired game on PS3
3. Run RaCMAN
4. Connect RaCMAN to console or emulator
5. Open `Menu` -> `Patch loader...`
6. Start a game (mod will not start correctly in the main menu)
7. Select the checkbox of the mod on the list
8. Enjoy!