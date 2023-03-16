local smascharacterglobals = {}

--We will first make the tables for each global setting.
smascharacterglobals.abilitySettings = {}
smascharacterglobals.imageSettings = {}
smascharacterglobals.soundSettings = {}
smascharacterglobals.speedSettings = {}
smascharacterglobals.miscellaneousSettings = {}

--Then, we will introduce each new variable below.


--**ABILITY SETTINGS**

--*BORIS (VYOND)*
--Whether Boris (Vyond)'s gun can be drawn to the screen.
smascharacterglobals.abilitySettings.borisCanDrawGun = true
--Whether Boris (Vyond) can use any of his guns. To disable drawing the gun itself, see above.
smascharacterglobals.abilitySettings.borisCanUseGun = true
--Whether Boris (Vyond) can use the grenade ability. Disable to disable this ability.
smascharacterglobals.abilitySettings.borisCanUseGrenade = true

--*BALDI (BALDI'S BASICS)*
--Whether Baldi can use his ruler.
smascharacterglobals.abilitySettings.baldiCanUseRuler = true

--*ERIC CARTMAN (SOUTH PARK)*
--Whether Eric can throw snowballs.
smascharacterglobals.abilitySettings.southParkEricCanThrowSnowballs = true

--*SPONGEBOB SQUAREPANTS*
--Whether SpongeBob can double jump.
smascharacterglobals.abilitySettings.spongeBobCanDoubleJump = true

--*TAIZO (DIG DUG)*
--Whether Taizo can use his harpoon.
smascharacterglobals.abilitySettings.taizoCanUseHarpoon = true
--Whether music should stop when not moving Taizo.
smascharacterglobals.abilitySettings.taizoMuteMusicWhenNotMoving = false

--*JASMINE (SEE)*
--Whether Jasmine can double jump.
smascharacterglobals.abilitySettings.jasmineCanDoubleJump = true

--*REBEL TROOPER (LEGO STAR WARS)*
--Whether the Rebel Trooper can double jump.
smascharacterglobals.abilitySettings.rebelTrooperCanDoubleJump = true
--Whether the Revel Trooper can shoot a blaster.
smascharacterglobals.abilitySettings.rebelTrooperCanShootBlaster = true
--Whether the Rebel Trooper gets hurt as coded in or not. If false, the Rebel Trooper will get hurt like other characters.
smascharacterglobals.abilitySettings.rebelTrooperCanUseCustomHurtSystem = true


--**SOUND SETTINGS**

--*BORIS (VYOND)*
--The sound used for the grenade explosion (Boris)
smascharacterglobals.soundSettings.borisGrenadeExplodeSFX = "costumes/luigi/GA-Boris/grenade-explode.ogg"
--The sound used for the grenade launch (Boris)
smascharacterglobals.soundSettings.borisGrenadeLaunchSFX = "costumes/luigi/GA-Boris/grenade-launch.ogg"

--*KAYLOO/CAILLOU (VYOND)*
--The sound used for when Caillou (Vyond) gets a powerup.
smascharacterglobals.soundSettings.kaylooPowerupVoiceSFX = "costumes/mario/GA-Caillou/voices/kayloo-timetodieenemies.ogg"
--The sound delay set for when Caillou (Vyond) gets a powerup.
smascharacterglobals.soundSettings.kaylooPowerupVoiceSFXDelay = 80
--The sound delay set for when Caillou (Vyond) gets a special powerup.
smascharacterglobals.soundSettings.kaylooSpecialPowerupVoiceSFXDelay = 80
--The sound used for when Caillou (Vyond) gets a special powerup.
smascharacterglobals.soundSettings.kaylooSpecialPowerupVoiceSFX = "costumes/mario/GA-Caillou/voices/kayloo-aspecialitem.ogg"
--The sound used for when Caillou (Vyond) gets hurt.
smascharacterglobals.soundSettings.kaylooHurtVoiceSFX = "costumes/mario/GA-Caillou/voices/kayloo-owthathurt.ogg"

--*ERIC CARTMAN (SOUTH PARK)*
--The sound used for throwing snowballs.
smascharacterglobals.soundSettings.southParkEricSnowballThrowSFX = "costumes/mario/SP-1-EricCartman/snowball_throw.ogg"
--Whether Eric can use his voice or not.
smascharacterglobals.soundSettings.southParkEricCanUseVoice = true

--*SPONGEBOB SQUAREPANTS*
--Whether SpongeBob can use his voice or not.
smascharacterglobals.soundSettings.spongeBobCanUseVoice = true
--The sound used for double jumping.
smascharacterglobals.soundSettings.spongeBobDoubleJumpSFX = "costumes/mario/SpongeBobSquarePants/player-jump-twice.ogg"
--The sound used for flying down (This is not a string!!!)
smascharacterglobals.soundSettings.spongeBobFlyBeginSFX = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/spongebob-flyingdown.ogg"))

--*TAIZO (DIG DUG)*
--The sound used for shooting the harpoon.
smascharacterglobals.soundSettings.taizoHarpoonShootSFX = "costumes/toad/DigDug-DiggingStrike/harpoon-shoot.ogg"

--*JASMINE (SEE)*
--The sound used for double jumping.
smascharacterglobals.soundSettings.jasmineDoubleJumpSFX = "costumes/toad/Jasmine/player-doublejump.ogg"

--*REBEL TROOPER (LEGO STAR WARS)*
--The sound used for shooting a blaster.
smascharacterglobals.soundSettings.rebelTrooperBlasterSFX = "costumes/toad/LEGOStarWars-RebelTrooper/blaster.ogg"
--The sound used for double jumping.
smascharacterglobals.soundSettings.rebelTrooperDoubleJumpSFX = "costumes/toad/LEGOStarWars-RebelTrooper/player-doublejump.ogg"
--Whether the Rebel Trooper can use hurt sounds or not.
smascharacterglobals.soundSettings.rebelTrooperCanUseHurtSFX = true


--**MISCELLANEOUS SETTINGS**


--*SMBX38A CHARACTERS*
--The powerup-to-big forced state ID for 38A characters.
smascharacterglobals.miscellaneousSettings.smbx38APowerupBigForcedStateID = 752
--The powerup-to-fire forced state ID for 38A characters.
smascharacterglobals.miscellaneousSettings.smbx38APowerupFireForcedStateID = 753
--The powerup-to-ice forced state ID for 38A characters.
smascharacterglobals.miscellaneousSettings.smbx38APowerupIceForcedStateID = 754
--The powerdown-to-small forced state ID for 38A characters.
smascharacterglobals.miscellaneousSettings.smbx38APowerdownSmallForcedStateID = 755

--*SONIC THE HEDGEHOG*
--This is used for Sonic's spin dash, which is the amount a spindash has been charged.
smascharacterglobals.miscellaneousSettings.sonicSpinRev = 0

return smascharacterglobals