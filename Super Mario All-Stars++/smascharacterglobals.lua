local smasCharacterGlobals = {}

--We will first make the tables for each global setting.
smasCharacterGlobals.abilitySettings = {}
smasCharacterGlobals.imageSettings = {}
smasCharacterGlobals.soundSettings = {}
smasCharacterGlobals.speedSettings = {}
smasCharacterGlobals.miscellaneousSettings = {}

--Then, we will introduce each new variable below.


--**ABILITY SETTINGS**

--*BORIS (VYOND)*
--Whether Boris (Vyond)'s gun can be drawn to the screen.
smasCharacterGlobals.abilitySettings.borisCanDrawGun = true
--Whether Boris (Vyond) can use any of his guns. To disable drawing the gun itself, see above.
smasCharacterGlobals.abilitySettings.borisCanUseGun = true
--Whether Boris (Vyond) can use the grenade ability. Disable to disable this ability.
smasCharacterGlobals.abilitySettings.borisCanUseGrenade = true

--*BALDI (BALDI'S BASICS)*
--Whether Baldi can use his ruler.
smasCharacterGlobals.abilitySettings.baldiCanUseRuler = true

--*ERIC CARTMAN (SOUTH PARK)*
--Whether Eric can throw snowballs.
smasCharacterGlobals.abilitySettings.southParkEricCanThrowSnowballs = true

--*SPONGEBOB SQUAREPANTS*
--Whether SpongeBob can double jump.
smasCharacterGlobals.abilitySettings.spongeBobCanDoubleJump = true

--*TAIZO (DIG DUG)*
--Whether Taizo can use his harpoon.
smasCharacterGlobals.abilitySettings.taizoCanUseHarpoon = true
--Whether music should stop when not moving Taizo.
smasCharacterGlobals.abilitySettings.taizoMuteMusicWhenNotMoving = false

--*JASMINE (SEE)*
--Whether Jasmine can double jump.
smasCharacterGlobals.abilitySettings.jasmineCanDoubleJump = true

--*REBEL TROOPER (LEGO STAR WARS)*
--Whether the Rebel Trooper can double jump.
smasCharacterGlobals.abilitySettings.rebelTrooperCanDoubleJump = true
--Whether the Revel Trooper can shoot a blaster.
smasCharacterGlobals.abilitySettings.rebelTrooperCanShootBlaster = true
--Whether the Rebel Trooper gets hurt as coded in or not. If false, the Rebel Trooper will get hurt like other characters.
smasCharacterGlobals.abilitySettings.rebelTrooperCanUseCustomHurtSystem = true


--**SOUND SETTINGS**

--*BORIS (VYOND)*
--The sound used for the grenade explosion (Boris)
smasCharacterGlobals.soundSettings.borisGrenadeExplodeSFX = "costumes/luigi/GA-Boris/grenade-explode.ogg"
--The sound used for the grenade launch (Boris)
smasCharacterGlobals.soundSettings.borisGrenadeLaunchSFX = "costumes/luigi/GA-Boris/grenade-launch.ogg"

--*KAYLOO/CAILLOU (VYOND)*
--The sound used for when Caillou (Vyond) gets a powerup.
smasCharacterGlobals.soundSettings.kaylooPowerupVoiceSFX = "costumes/mario/GA-Caillou/voices/kayloo-timetodieenemies.ogg"
--The sound delay set for when Caillou (Vyond) gets a powerup.
smasCharacterGlobals.soundSettings.kaylooPowerupVoiceSFXDelay = 80
--The sound delay set for when Caillou (Vyond) gets a special powerup.
smasCharacterGlobals.soundSettings.kaylooSpecialPowerupVoiceSFXDelay = 80
--The sound used for when Caillou (Vyond) gets a special powerup.
smasCharacterGlobals.soundSettings.kaylooSpecialPowerupVoiceSFX = "costumes/mario/GA-Caillou/voices/kayloo-aspecialitem.ogg"
--The sound used for when Caillou (Vyond) gets hurt.
smasCharacterGlobals.soundSettings.kaylooHurtVoiceSFX = "costumes/mario/GA-Caillou/voices/kayloo-owthathurt.ogg"

--*ERIC CARTMAN (SOUTH PARK)*
--The sound used for throwing snowballs.
smasCharacterGlobals.soundSettings.southParkEricSnowballThrowSFX = "costumes/mario/SP-1-EricCartman/snowball_throw.ogg"
--Whether Eric can use his voice or not.
smasCharacterGlobals.soundSettings.southParkEricCanUseVoice = true

--*SPONGEBOB SQUAREPANTS*
--Whether SpongeBob can use his voice or not.
smasCharacterGlobals.soundSettings.spongeBobCanUseVoice = true
--The sound used for double jumping.
smasCharacterGlobals.soundSettings.spongeBobDoubleJumpSFX = "costumes/mario/SpongeBobSquarePants/player-jump-twice.ogg"
--The sound used for flying down (This is not a string!!!)
smasCharacterGlobals.soundSettings.spongeBobFlyBeginSFX = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/spongebob-flyingdown.ogg"))

--*TAIZO (DIG DUG)*
--The sound used for shooting the harpoon.
smasCharacterGlobals.soundSettings.taizoHarpoonShootSFX = "costumes/toad/DigDug-DiggingStrike/harpoon-shoot.ogg"

--*JASMINE (SEE)*
--The sound used for double jumping.
smasCharacterGlobals.soundSettings.jasmineDoubleJumpSFX = "costumes/toad/Jasmine/player-doublejump.ogg"

--*REBEL TROOPER (LEGO STAR WARS)*
--The sound used for shooting a blaster.
smasCharacterGlobals.soundSettings.rebelTrooperBlasterSFX = "costumes/toad/LEGOStarWars-RebelTrooper/blaster.ogg"
--The sound used for double jumping.
smasCharacterGlobals.soundSettings.rebelTrooperDoubleJumpSFX = "costumes/toad/LEGOStarWars-RebelTrooper/player-doublejump.ogg"
--Whether the Rebel Trooper can use hurt sounds or not.
smasCharacterGlobals.soundSettings.rebelTrooperCanUseHurtSFX = true


--**MISCELLANEOUS SETTINGS**


--*SMBX38A CHARACTERS*
--The powerup-to-big forced state ID for 38A characters.
smasCharacterGlobals.miscellaneousSettings.smbx38APowerupBigForcedStateID = 752
--The powerup-to-fire forced state ID for 38A characters.
smasCharacterGlobals.miscellaneousSettings.smbx38APowerupFireForcedStateID = 753
--The powerup-to-ice forced state ID for 38A characters.
smasCharacterGlobals.miscellaneousSettings.smbx38APowerupIceForcedStateID = 754
--The powerdown-to-small forced state ID for 38A characters.
smasCharacterGlobals.miscellaneousSettings.smbx38APowerdownSmallForcedStateID = 755

--*SONIC THE HEDGEHOG*
--This is used for Sonic's spin dash, which is the amount a spindash has been charged.
smasCharacterGlobals.miscellaneousSettings.sonicSpinRev = 0

return smasCharacterGlobals