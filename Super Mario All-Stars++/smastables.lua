local smastables = {}

--Placing in levels onto a table that'll prevent the loading sound from playing
smastables._noLoadingSoundLevels = {
    "SMAS - Start.lvlx",
    "SMAS - Raca's World (Part 0).lvlx",
    "SMAS - Raca's World (Part 1).lvlx",
    "map.lvlx",
}

--All SMB1 levels, listed here for many reasons
smastables.__smb1Levels = {
    "SMB1 - W-1, L-1.lvlx",
    "SMB1 - W-1, L-2.lvlx",
    "SMB1 - W-1, L-3.lvlx",
    "SMB1 - W-1, L-4.lvlx",
    "SMB1 - W-2, L-1.lvlx",
    "SMB1 - W-2, L-2.lvlx",
    "SMB1 - W-2, L-3.lvlx",
    "SMB1 - W-2, L-4.lvlx",
    "SMB1 - W-3, L-1.lvlx",
    "SMB1 - W-3, L-2.lvlx",
    "SMB1 - W-3, L-3.lvlx",
    "SMB1 - W-3, L-4.lvlx",
    "SMB1 - W-4, L-1.lvlx",
    "SMB1 - W-4, L-2.lvlx",
    "SMB1 - W-4, L-3.lvlx",
    "SMB1 - W-4, L-4.lvlx",
    "SMB1 - W-5, L-1.lvlx",
    "SMB1 - W-5, L-2.lvlx",
    "SMB1 - W-5, L-3.lvlx",
    "SMB1 - W-5, L-4.lvlx",
    "SMB1 - W-6, L-1.lvlx",
    "SMB1 - W-6, L-2.lvlx",
    "SMB1 - W-6, L-3.lvlx",
    "SMB1 - W-6, L-4.lvlx",
    "SMB1 - W-7, L-1.lvlx",
    "SMB1 - W-7, L-2.lvlx",
    "SMB1 - W-7, L-3.lvlx",
    "SMB1 - W-7, L-4.lvlx",
    "SMB1 - W-8, L-1.lvlx",
    "SMB1 - W-8, L-2.lvlx",
    "SMB1 - W-8, L-3.lvlx",
    "SMB1 - W-8, L-4.lvlx",
    "SMB1 - W-9, L-1.lvlx",
    "SMB1 - W-9, L-2.lvlx",
    "SMB1 - W-9, L-3.lvlx",
    "SMB1 - W-9, L-4.lvlx",
}

--All SMB2 levels, listed here for many reasons
smastables.__smb2Levels = {
    "SMB2 - W-1, L-1.lvlx",
    "SMB2 - W-1, L-2.lvlx",
    "SMB2 - W-1, L-3.lvlx",
    "SMB2 - W-2, L-1.lvlx",
    "SMB2 - W-2, L-2.lvlx",
    "SMB2 - W-2, L-3.lvlx",
    "SMB2 - W-3, L-1.lvlx",
    "SMB2 - W-3, L-2.lvlx",
    "SMB2 - W-3, L-3.lvlx",
    "SMB2 - W-4, L-1.lvlx",
    "SMB2 - W-4, L-2.lvlx",
    "SMB2 - W-4, L-3.lvlx",
    "SMB2 - W-5, L-1.lvlx",
    "SMB2 - W-5, L-2.lvlx",
    "SMB2 - W-5, L-3.lvlx",
    "SMB2 - W-6, L-1.lvlx",
    "SMB2 - W-6, L-2.lvlx",
    "SMB2 - W-6, L-3.lvlx",
    "SMB2 - W-7, L-1.lvlx",
    "SMB2 - W-7, L-2.lvlx",
}

--All SMBLL levels, listed here for many reasons
smastables.__smbllLevels = {
    "SMBLL - W-1, L-1.lvlx",
    "SMBLL - W-1, L-2.lvlx",
    "SMBLL - W-1, L-3.lvlx",
    "SMBLL - W-1, L-4.lvlx",
    "SMBLL - W-2, L-1.lvlx",
    "SMBLL - W-2, L-2.lvlx",
    "SMBLL - W-2, L-3.lvlx",
    "SMBLL - W-2, L-4.lvlx",
    "SMBLL - W-3, L-1.lvlx",
    "SMBLL - W-3, L-2.lvlx",
    "SMBLL - W-3, L-3.lvlx",
    "SMBLL - W-3, L-4.lvlx",
    "SMBLL - W-4, L-1.lvlx",
    "SMBLL - W-4, L-2.lvlx",
    "SMBLL - W-4, L-3.lvlx",
    "SMBLL - W-4, L-4.lvlx",
    "SMBLL - W-5, L-1.lvlx",
    "SMBLL - W-5, L-2.lvlx",
    "SMBLL - W-5, L-3.lvlx",
    "SMBLL - W-5, L-4.lvlx",
    "SMBLL - W-6, L-1.lvlx",
    "SMBLL - W-6, L-2.lvlx",
    "SMBLL - W-6, L-3.lvlx",
    "SMBLL - W-6, L-4.lvlx",
    "SMBLL - W-7, L-1.lvlx",
    "SMBLL - W-7, L-2.lvlx",
    "SMBLL - W-7, L-3.lvlx",
    "SMBLL - W-7, L-4.lvlx",
    "SMBLL - W-8, L-1.lvlx",
    "SMBLL - W-8, L-2.lvlx",
    "SMBLL - W-8, L-3.lvlx",
    "SMBLL - W-8, L-4.lvlx",
    "SMBLL - W-9, L-1.lvlx",
    "SMBLL - W-9, L-2.lvlx",
    "SMBLL - W-9, L-3.lvlx",
    "SMBLL - W-9, L-4.lvlx",
    "SMBLL - W-A, L-1.lvlx",
    "SMBLL - W-A, L-2.lvlx",
    "SMBLL - W-A, L-3.lvlx",
    "SMBLL - W-A, L-4.lvlx",
    "SMBLL - W-B, L-1.lvlx",
    "SMBLL - W-B, L-2.lvlx",
    "SMBLL - W-B, L-3.lvlx",
    "SMBLL - W-B, L-4.lvlx",
    "SMBLL - W-C, L-1.lvlx",
    "SMBLL - W-C, L-2.lvlx",
    "SMBLL - W-C, L-3.lvlx",
    "SMBLL - W-C, L-4.lvlx",
    "SMBLL - W-D, L-1.lvlx",
    "SMBLL - W-D, L-2.lvlx",
    "SMBLL - W-D, L-3.lvlx",
    "SMBLL - W-D, L-4.lvlx",
}

smastables.__smb3Levels = {
    "SMB3 - W-1, L-1.lvlx",
    "SMB3 - W-1, L-2.lvlx",
    "SMB3 - W-1, L-3.lvlx",
    "SMB3 - W-1, L-4.lvlx",
    "SMB3 - W-1, L-5.lvlx",
    "SMB3 - W-1, L-6.lvlx",
    "SMB3 - W-1, L-Airship.lvlx",
    "SMB3 - W-1, L-Fortress.lvlx",
    "SMB3 - W-2, L-1.lvlx",
    "SMB3 - W-2, L-2.lvlx",
    "SMB3 - W-2, L-3.lvlx",
    "SMB3 - W-2, L-4.lvlx",
    "SMB3 - W-2, L-5.lvlx",
    "SMB3 - W-2, L-Airship.lvlx",
    "SMB3 - W-2, L-Fortress.lvlx",
    "SMB3 - W-2, L-Pyramid.lvlx",
    "SMB3 - W-2, L-Quicksand.lvlx",
    "SMB3 - W-3, L-1.lvlx",
    "SMB3 - W-3, L-2.lvlx",
    "SMB3 - W-3, L-3.lvlx",
    "SMB3 - W-3, L-4.lvlx",
    "SMB3 - W-3, L-5.lvlx",
    "SMB3 - W-3, L-6.lvlx",
    "SMB3 - W-3, L-7.lvlx",
    "SMB3 - W-3, L-8.lvlx",
    "SMB3 - W-3, L-9.lvlx",
    "SMB3 - W-3, L-Fortress1.lvlx",
    "SMB3 - W-3, L-Fortress2.lvlx",
    "SMB3 - W-3, L-Airship.lvlx",
    "SMB3 - W-4, L-1.lvlx",
    "SMB3 - W-4, L-2.lvlx",
    "SMB3 - W-4, L-3.lvlx",
    "SMB3 - W-4, L-Fortress1.lvlx",
    "SMB3 - W-4, L-4.lvlx",
    "SMB3 - W-4, L-5.lvlx",
    "SMB3 - W-4, L-6.lvlx",
    "SMB3 - W-4, L-Fortress2.lvlx",
    "SMB3 - W-4, L-Airship.lvlx",
    "SMB3 - W-5, L-1.lvlx",
    "SMB3 - W-5, L-2.lvlx",
    "SMB3 - W-5, L-3.lvlx",
    "SMB3 - W-5, L-Fortress1.lvlx",
    "SMB3 - W-5, L-Tower.lvlx",
    "SMB3 - W-5, L-4.lvlx",
    "SMB3 - W-5, L-5.lvlx",
    "SMB3 - W-5, L-6.lvlx",
    "SMB3 - W-5, L-7.lvlx",
    "SMB3 - W-5, L-Fortress2.lvlx",
    "SMB3 - W-5, L-8.lvlx",
    "SMB3 - W-5, L-9.lvlx",
    "SMB3 - W-5, L-Airship.lvlx",
    "SMB3 - W-6, L-1.lvlx",
    "SMB3 - W-6, L-2.lvlx",
    "SMB3 - W-6, L-3.lvlx",
    "SMB3 - W-6, L-Fortress1.lvlx",
    "SMB3 - W-6, L-4.lvlx",
    "SMB3 - W-6, L-5.lvlx",
    "SMB3 - W-6, L-6.lvlx",
    "SMB3 - W-6, L-7.lvlx",
    "SMB3 - W-6, L-Fortress2.lvlx",
    "SMB3 - W-6, L-8.lvlx",
    "SMB3 - W-6, L-9.lvlx",
    "SMB3 - W-6, L-10.lvlx",
    "SMB3 - W-6, L-Fortress3.lvlx",
    "SMB3 - W-6, L-Airship.lvlx",
    "SMB3 - W-7, L-1.lvlx",
    "SMB3 - W-7, L-2.lvlx",
    "SMB3 - W-7, L-3.lvlx",
    "SMB3 - W-7, L-4.lvlx",
    "SMB3 - W-7, L-5.lvlx",
    "SMB3 - W-7, L-PP1.lvlx",
    "SMB3 - W-7, L-Fortress1.lvlx",
    "SMB3 - W-7, L-6.lvlx",
    "SMB3 - W-7, L-7.lvlx",
    "SMB3 - W-7, L-8.lvlx",
    "SMB3 - W-7, L-9.lvlx",
    "SMB3 - W-7, L-Fortress2.lvlx",
    "SMB3 - W-7, L-PP2.lvlx",
    "SMB3 - W-7, L-Airship.lvlx",
    "SMB3 - W-8, L-Tank1.lvlx",
    "SMB3 - W-8, L-Ship.lvlx",
    "SMB3 - W-8, L-Hand Trap 1.lvlx",
    "SMB3 - W-8, L-Hand Trap 2.lvlx",
    "SMB3 - W-8, L-Hand Trap 3.lvlx",
    "SMB3 - W-8, L-Jet.lvlx",
    "SMB3 - W-8, L-1.lvlx",
    "SMB3 - W-8, L-2.lvlx",
    "SMB3 - W-8, L-Fortress.lvlx",
    "SMB3 - W-8, L-Tank2.lvlx",
    "SMB3 - W-8, L-Castle.lvlx",
    "SMB3 - W-e, L-1.lvlx",
}

smastables.__smwLevels = {
    "SMW - W-1, L-YI1.lvlx",
    "SMW - W-1, L-YI2.lvlx",
    "SMW - W-1, L-YI3.lvlx",
    "SMW - W-1, L-YI4.lvlx",
    "SMW - W-1, L-YIIC.lvlx",
    "SMW - W-2, L-DP1.lvlx",
    "SMW - W-2, L-DP2.lvlx",
    "SMW - W-2, L-DS1.lvlx",
    "SMW - W-2, L-DSGH.lvlx",
    "SMW - W-2, L-DPGH.lvlx",
    "SMW - W-2, L-DP3.lvlx",
    "SMW - W-2, L-DP4.lvlx",
    "SMW - W-2, L-DPMC.lvlx",
    "SMW - W-8, L-BVLC.lvlx",
}

smastables.__smbspencerLevels = {
    "SMBS - W-1, L-1.lvlx",
    "SMBS - W-1, L-2.lvlx",
    "SMBS - W-1, L-3.lvlx",
    "SMBS - W-1, L-4.lvlx",
    "SMBS - W-1, L-5.lvlx",
    "SMBS - W-1, L-6.lvlx",
    "SMBS - W-1, L-A.lvlx",
    "SMBS - W-1, L-Castle.lvlx",
    "SMBS - W-1, L-Tower.lvlx",
    "SMBS - W-2, L-1.lvlx",
    "SMBS - W-2, L-2.lvlx",
    "SMBS - W-2, L-3.lvlx",
    "SMBS - W-2, L-4.lvlx",
    "SMBS - W-2, L-5.lvlx",
    "SMBS - W-2, L-A.lvlx",
    "SMBS - W-2, L-Tower.lvlx",
}

--All WSMBA levels, listed here for many reasons
smastables.__wsmbaLevels = {
    "WSMBA - W-0, L-Bonus.lvlx",
    "WSMBA - W-0, L-MALC.lvlx",
    "WSMBA - W-0, L-Mario City.lvlx",
    "WSMBA - W-1, L-1.lvlx",
    "WSMBA - W-1, L-2.lvlx",
    "WSMBA - W-1, L-3.lvlx",
    "WSMBA - W-2, L-1.lvlx",
    "WSMBA - W-2, L-2.lvlx",
    "WSMBA - W-2, L-3.lvlx",
    "WSMBA - W-2, L-4.lvlx",
    "WSMBA - W-2, L-Boss.lvlx",
    "WSMBA - W-2, L-Castle.lvlx",
    "WSMBA - W-2, L-Hammer Bros 1.lvlx",
    "WSMBA - W-2, L-Hammer Bros 2.lvlx",
    "WSMBA - W-3, L-1.lvlx",
    "WSMBA - W-3, L-2.lvlx",
    "WSMBA - W-4, L-1.lvlx",
    "WSMBA - W-4, L-2.lvlx",
    "WSMBA - W-4, L-3.lvlx",
    "WSMBA - W-4, L-4.lvlx",
    "WSMBA - W-5, L-1.lvlx",
    "WSMBA - W-5, L-2.lvlx",
    "WSMBA - W-5, L-3.lvlx",
    "WSMBA - W-6, L-1.lvlx",
    "WSMBA - W-6, L-2.lvlx",
    "WSMBA - W-6, L-3.lvlx",
    "WSMBA - W-7, L-1.lvlx",
    "WSMBA - W-7, L-2.lvlx",
    "WSMBA - W-7, L-3.lvlx",
    "WSMBA - W-7, L-4.lvlx",
    "WSMBA - W-S, L-1.lvlx",
    "WSMBA - W-S, L-2.lvlx",
    "WSMBA - W-S, L-3.lvlx",
    "WSMBA - W-S, L-4.lvlx",
    "WSMBA - W-S, L-5.lvlx",
}

--All SMB Special levels, for many reasons.
smastables.__smbspecialLevels = {
    "SMBSp - W-1, L-1.lvlx",
    "SMBSp - W-1, L-2.lvlx",
    "SMBSp - W-1, L-3.lvlx",
    "SMBSp - W-1, L-4.lvlx",
}

--Friendly place table for Mother Brain Rinka
smastables._friendlyPlaces = {
    "SMAS - Start.lvlx",
    "map.lvlx",
    "intro_8bit.lvlx",
    "intro_theeditedboss.lvlx",
    "intro_jakebrito1.lvlx",
    "intro_marioforever.lvlx",
    "intro_S!TS!.lvlx",
    "intro_scrollingheights.lvlx",
    "intro_SMAS.lvlx",
    "intro_SMBX1.0.lvlx",
    "intro_SMBX1.1.lvlx",
    "intro_SMBX1.2.lvlx",
    "intro_SMBX1.3.lvlx",
    "intro_SMBX1.3og.lvlx",
    "intro_SMBX2.lvlx",
    "intro_SMBX2b3.lvlx",
    "intro_sunsetbeach.lvlx",
    "intro_WSMBA.lvlx",
    "MALC - HUB.lvlx",
    "SMAS - Credits.lvlx",
    "SMAS - DLC Levels.lvlx",
    "SMAS - Intro.lvlx",
    "SMAS - Online (Menu).lvlx",
    "SMAS - Test Level.lvlx",
    "SMAS - True Ending.lvlx",
    "SMAS - World Map Warp.lvlx",
    "SMB1 - Level Backtrack 1.lvlx",
    "SMB1 - Level Backtrack 2.lvlx",
    "SMB1 - Level Backtrack 3.lvlx",
    "SMB1 - Level Backtrack 4.lvlx",
    "SMB1 - Level Backtrack 5.lvlx",
    "SMB1 - Level Backtrack 6.lvlx",
    "SMB1 - Level Backtrack 7.lvlx",
    "SMB2 - Ending.lvlx",
    "SMB2 - Level Backtrack 1.lvlx",
    "SMB2 - Level Backtrack 2.lvlx",
    "SMB2 - Level Backtrack 3.lvlx",
    "SMB2 - Level Backtrack 4.lvlx",
    "SMB2 - Level Backtrack 5.lvlx",
    "SMB2 - Level Backtrack 6.lvlx",
    "SMBLL - Level Backtrack 1.lvlx",
    "SMBLL - Level Backtrack 2.lvlx",
    "SMBLL - Level Backtrack 3.lvlx",
    "SMBLL - Level Backtrack 4.lvlx",
    "SMBLL - Level Backtrack 5.lvlx",
    "SMBLL - Level Backtrack 6.lvlx",
    "SMBLL - Level Backtrack 7.lvlx",
    "SMBS - Opening.lvlx",
    "SMW - W-0, L-Green Switch.lvlx",
    "SMW - W-0, L-Yellow Switch.lvlx",
    "SMW - W-0, L-Blue Switch.lvlx",
    "SMAS - Rush Mode Results.lvlx",
    "SMAS - Opening Cutscene.lvlx",
}

--Menu table for any costume with troublesome sounds
smastables._noLevelPlaces = {
    "SMAS - Start.lvlx",
    "map.lvlx",
    "intro_8bit.lvlx",
    "intro_theeditedboss.lvlx",
    "intro_jakebrito1.lvlx",
    "intro_marioforever.lvlx",
    "intro_S!TS!.lvlx",
    "intro_scrollingheights.lvlx",
    "intro_SMAS.lvlx",
    "intro_SMBX1.0.lvlx",
    "intro_SMBX1.1.lvlx",
    "intro_SMBX1.2.lvlx",
    "intro_SMBX1.3.lvlx",
    "intro_SMBX1.3og.lvlx",
    "intro_SMBX2.lvlx",
    "intro_SMBX2b3.lvlx",
    "intro_sunsetbeach.lvlx",
    "intro_WSMBA.lvlx",
    "intro_metroidprime2.lvlx",
    "SMAS - Credits.lvlx",
    "SMAS - Intro.lvlx",
    "SMAS - Online (Menu).lvlx",
    "SMB2 - Ending.lvlx",
    "SMAS - Rush Mode Results.lvlx",
    "SMAS - Opening Cutscene.lvlx",
}

smastables._noLevelPlacesPlusOtherLevels = {
    "SMAS - Start.lvlx",
    "map.lvlx",
    "intro_8bit.lvlx",
    "intro_theeditedboss.lvlx",
    "intro_jakebrito1.lvlx",
    "intro_marioforever.lvlx",
    "intro_S!TS!.lvlx",
    "intro_scrollingheights.lvlx",
    "intro_SMAS.lvlx",
    "intro_SMBX1.0.lvlx",
    "intro_SMBX1.1.lvlx",
    "intro_SMBX1.2.lvlx",
    "intro_SMBX1.3.lvlx",
    "intro_SMBX1.3og.lvlx",
    "intro_SMBX2.lvlx",
    "intro_SMBX2b3.lvlx",
    "intro_sunsetbeach.lvlx",
    "intro_WSMBA.lvlx",
    "MALC - HUB.lvlx",
    "SMAS - Credits.lvlx",
    "SMAS - DLC Levels.lvlx",
    "SMAS - Intro.lvlx",
    "SMAS - Online (Menu).lvlx",
    "SMAS - Test Level.lvlx",
    "SMAS - True Ending.lvlx",
    "SMAS - World Map Warp.lvlx",
    "SMB1 - Level Backtrack 1.lvlx",
    "SMB1 - Level Backtrack 2.lvlx",
    "SMB1 - Level Backtrack 3.lvlx",
    "SMB1 - Level Backtrack 4.lvlx",
    "SMB1 - Level Backtrack 5.lvlx",
    "SMB1 - Level Backtrack 6.lvlx",
    "SMB1 - Level Backtrack 7.lvlx",
    "SMB2 - Ending.lvlx",
    "SMB2 - Level Backtrack 1.lvlx",
    "SMB2 - Level Backtrack 2.lvlx",
    "SMB2 - Level Backtrack 3.lvlx",
    "SMB2 - Level Backtrack 4.lvlx",
    "SMB2 - Level Backtrack 5.lvlx",
    "SMB2 - Level Backtrack 6.lvlx",
    "SMBLL - Level Backtrack 1.lvlx",
    "SMBLL - Level Backtrack 2.lvlx",
    "SMBLL - Level Backtrack 3.lvlx",
    "SMBLL - Level Backtrack 4.lvlx",
    "SMBLL - Level Backtrack 5.lvlx",
    "SMBLL - Level Backtrack 6.lvlx",
    "SMBLL - Level Backtrack 7.lvlx",
    "SMBS - Opening.lvlx",
    "SMW - W-0, L-Green Switch.lvlx",
    "SMW - W-0, L-Yellow Switch.lvlx",
    "SMW - W-0, L-Blue Switch.lvlx",
    "SMAS - Rush Mode Results.lvlx",
    "battle_battleshrooms.lvlx",
    "battle_battle-zone.lvlx",
    "battle_classic-castle-battle.lvlx",
    "battle_dry-dry-desert.lvlx",
    "battle_hyrule-temple.lvlx",
    "battle_invasion-battlehammer.lvlx",
    "battle_lakitu-mechazone.lvlx",
    "battle_lethal-lava-level.lvlx",
    "battle_slippy-slap-snowland.lvlx",
    "battle_woody-warzone.lvlx",
    "battle_retroville-underground.lvlx",
    "battle_testlevel.lvlx",
    "battle_nsmbds1.lvlx",
    "battle_nsmbds2.lvlx",
    "battle_nsmbds3.lvlx",
    "SMAS - Opening Cutscene.lvlx",
}

smastables._noTransitionLevels = { --This one will prevent transitions from happening via warpTransition
    "SMAS - Start.lvlx",
    "SMAS - Intro.lvlx",
    "SMAS - Credits.lvlx",
    "map.lvlx",
    "SMAS - Raca's World (Part 0).lvlx",
    "SMAS - Raca's World (Part 1).lvlx",
    "intro_8bit.lvlx",
    "intro_theeditedboss.lvlx",
    "intro_circuitcity.lvlx",
    "intro_jakebrito1.lvlx",
    "intro_jakebrito2.lvlx",
    "intro_marioforever.lvlx",
    "intro_S!TS!.lvlx",
    "intro_scrollingheights.lvlx",
    "intro_SMAS.lvlx",
    "intro_SMBX1.0.lvlx",
    "intro_SMBX1.1.lvlx",
    "intro_SMBX1.2.lvlx",
    "intro_SMBX1.3.lvlx",
    "intro_SMBX1.3og.lvlx",
    "intro_SMBX2.lvlx",
    "intro_SMBX2b3.lvlx",
    "intro_sunsetbeach.lvlx",
    "intro_WSMBA.lvlx",
    "intro_metroidprime2.lvlx",
    "SMAS - Opening Cutscene.lvlx",
}

smastables.__classicBattleModeLevels = { --All Classic Battle Mode levels, used for RNG and for a general list.
    "battle_battleshrooms.lvlx",
    "battle_battle-zone.lvlx",
    "battle_classic-castle-battle.lvlx",
    "battle_dry-dry-desert.lvlx",
    "battle_hyrule-temple.lvlx",
    "battle_invasion-battlehammer.lvlx",
    "battle_lakitu-mechazone.lvlx",
    "battle_lethal-lava-level.lvlx",
    "battle_slippy-slap-snowland.lvlx",
    "battle_woody-warzone.lvlx",
    "battle_retroville-underground.lvlx",
    "battle_testlevel.lvlx",
    "battle_nsmbds1.lvlx",
    "battle_nsmbds2.lvlx",
    "battle_nsmbds3.lvlx",
}

smastables.__mainMenuThemes = {
    "intro_SMAS.lvlx",
    "intro_SMBX1.0.lvlx",
    "intro_SMBX1.1.lvlx",
    "intro_SMBX1.2.lvlx",
    "intro_SMBX1.3.lvlx",
    "intro_WSMBA.lvlx",
    "intro_SMBX2.lvlx",
    "intro_theeditedboss.lvlx",
    "intro_SMBX1.3og.lvlx",
    "intro_SMBX2b3.lvlx",
    "intro_8bit.lvlx",
    "intro_S!TS!.lvlx",
    "intro_sunsetbeach.lvlx",
    "intro_scrollingheights.lvlx",
    "intro_jakebrito1.lvlx",
    "intro_marioforever.lvlx",
    "intro_jakebrito2.lvlx",
    "intro_circuitcity.lvlx",
    "intro_metroidprime2.lvlx",
}

smastables.__allMandatoryLevels = { --All Rush Mode levels.
    "SMB1 - W-1, L-1.lvlx",
    "SMB1 - W-1, L-2.lvlx",
    "SMB1 - W-1, L-3.lvlx",
    "SMB1 - W-1, L-4.lvlx",
    "SMB1 - W-2, L-1.lvlx",
    "SMB1 - W-2, L-2.lvlx",
    "SMB1 - W-2, L-3.lvlx",
    "SMB1 - W-2, L-4.lvlx",
    "SMB1 - W-3, L-1.lvlx",
    "SMB1 - W-3, L-2.lvlx",
    "SMB1 - W-3, L-3.lvlx",
    "SMB1 - W-3, L-4.lvlx",
    "SMB1 - W-4, L-1.lvlx",
    "SMB1 - W-4, L-2.lvlx",
    "SMB1 - W-4, L-3.lvlx",
    "SMB1 - W-4, L-4.lvlx",
    "SMB1 - W-5, L-1.lvlx",
    "SMB1 - W-5, L-2.lvlx",
    "SMB1 - W-5, L-3.lvlx",
    "SMB1 - W-5, L-4.lvlx",
    "SMB1 - W-6, L-1.lvlx",
    "SMB1 - W-6, L-2.lvlx",
    "SMB1 - W-6, L-3.lvlx",
    "SMB1 - W-6, L-4.lvlx",
    "SMB1 - W-7, L-1.lvlx",
    "SMB1 - W-7, L-2.lvlx",
    "SMB1 - W-7, L-3.lvlx",
    "SMB1 - W-7, L-4.lvlx",
    "SMB1 - W-8, L-1.lvlx",
    "SMB1 - W-8, L-2.lvlx",
    "SMB1 - W-8, L-3.lvlx",
    "SMB1 - W-8, L-4.lvlx",
    "SMB1 - W-9, L-1.lvlx",
    "SMB1 - W-9, L-2.lvlx",
    "SMB1 - W-9, L-3.lvlx",
    "SMB1 - W-9, L-4.lvlx",
    "SMB2 - W-1, L-1.lvlx",
    "SMB2 - W-1, L-2.lvlx",
    "SMB2 - W-1, L-3.lvlx",
    "SMB2 - W-2, L-1.lvlx",
    "SMB2 - W-2, L-2.lvlx",
    "SMB2 - W-2, L-3.lvlx",
    "SMB2 - W-3, L-1.lvlx",
    "SMB2 - W-3, L-2.lvlx",
    "SMB2 - W-3, L-3.lvlx",
    "SMB2 - W-4, L-1.lvlx",
    "SMB2 - W-4, L-2.lvlx",
    "SMB2 - W-4, L-3.lvlx",
    "SMB2 - W-5, L-1.lvlx",
    "SMB2 - W-5, L-2.lvlx",
    "SMB2 - W-5, L-3.lvlx",
    "SMB2 - W-6, L-1.lvlx",
    "SMB2 - W-6, L-2.lvlx",
    "SMB2 - W-6, L-3.lvlx",
    "SMB2 - W-7, L-1.lvlx",
    "SMB2 - W-7, L-2.lvlx",
}

smastables.__allLevelsOptional = { --All optional levels.
    "SMBLL - W-1, L-1.lvlx",
    "SMBLL - W-1, L-2.lvlx",
    "SMBLL - W-1, L-3.lvlx",
    "SMBLL - W-1, L-4.lvlx",
    "SMBLL - W-2, L-1.lvlx",
    "SMBLL - W-2, L-2.lvlx",
    "SMBLL - W-2, L-3.lvlx",
    "SMBLL - W-2, L-4.lvlx",
    "SMBLL - W-3, L-1.lvlx",
    "SMBLL - W-3, L-2.lvlx",
    "SMBLL - W-3, L-3.lvlx",
    "SMBLL - W-3, L-4.lvlx",
    "SMBLL - W-4, L-1.lvlx",
    "SMBLL - W-4, L-2.lvlx",
    "SMBLL - W-4, L-3.lvlx",
    "SMBLL - W-4, L-4.lvlx",
    "SMBLL - W-5, L-1.lvlx",
    "SMBLL - W-5, L-2.lvlx",
    "SMBLL - W-5, L-3.lvlx",
    "SMBLL - W-5, L-4.lvlx",
    "SMBLL - W-6, L-1.lvlx",
    "SMBLL - W-6, L-2.lvlx",
    "SMBLL - W-6, L-3.lvlx",
    "SMBLL - W-6, L-4.lvlx",
    "SMBLL - W-7, L-1.lvlx",
    "SMBLL - W-7, L-2.lvlx",
    "SMBLL - W-7, L-3.lvlx",
    "SMBLL - W-7, L-4.lvlx",
    "SMBLL - W-8, L-1.lvlx",
    "SMBLL - W-8, L-2.lvlx",
    "SMBLL - W-8, L-3.lvlx",
    "SMBLL - W-8, L-4.lvlx",
    "SMBLL - W-9, L-1.lvlx",
    "SMBLL - W-9, L-2.lvlx",
    "SMBLL - W-9, L-3.lvlx",
    "SMBLL - W-9, L-4.lvlx",
    "SMBLL - W-A, L-1.lvlx",
    "SMBLL - W-A, L-2.lvlx",
    "SMBLL - W-A, L-3.lvlx",
    "SMBLL - W-A, L-4.lvlx",
    "SMBLL - W-B, L-1.lvlx",
    "SMBLL - W-B, L-2.lvlx",
    "SMBLL - W-B, L-3.lvlx",
    "SMBLL - W-B, L-4.lvlx",
    "SMBLL - W-C, L-1.lvlx",
    "SMBLL - W-C, L-2.lvlx",
    "SMBLL - W-C, L-3.lvlx",
    "SMBLL - W-C, L-4.lvlx",
    "SMBLL - W-D, L-1.lvlx",
    "SMBLL - W-D, L-2.lvlx",
    "SMBLL - W-D, L-3.lvlx",
    "SMBLL - W-D, L-4.lvlx",
    "MALC - L-1.lvlx",
    "MALC - L-2, P-1.lvlx",
    "MALC - L-3.lvlx",
    "MALC - L-4.lvlx",
    "MALC - L-5.lvlx",
    "MALC - L-6.lvlx",
    "MALC - L-7.lvlx",
    "MALC - L-8.lvlx",
    "MALC - L-9.lvlx",
    "MALC - L-10.lvlx",
    "SMBSp - W-1, L-1.lvlx",
    "SMBSp - W-1, L-2.lvlx",
    "SMBSp - W-1, L-3.lvlx",
    "SMBSp - W-1, L-4.lvlx",
}

smastables.__allLevels = { --All levels.
    "SMB1 - W-1, L-1.lvlx",
    "SMB1 - W-1, L-2.lvlx",
    "SMB1 - W-1, L-3.lvlx",
    "SMB1 - W-1, L-4.lvlx",
    "SMB1 - W-1, L-Mushroom.lvlx",
    "SMB1 - W-2, L-1.lvlx",
    "SMB1 - W-2, L-2.lvlx",
    "SMB1 - W-2, L-3.lvlx",
    "SMB1 - W-2, L-4.lvlx",
    "SMB1 - W-2, L-Mushroom.lvlx",
    "SMB1 - W-3, L-1.lvlx",
    "SMB1 - W-3, L-2.lvlx",
    "SMB1 - W-3, L-3.lvlx",
    "SMB1 - W-3, L-4.lvlx",
    "SMB1 - W-3, L-Mushroom.lvlx",
    "SMB1 - W-4, L-1.lvlx",
    "SMB1 - W-4, L-2.lvlx",
    "SMB1 - W-4, L-3.lvlx",
    "SMB1 - W-4, L-4.lvlx",
    "SMB1 - W-5, L-1.lvlx",
    "SMB1 - W-5, L-2.lvlx",
    "SMB1 - W-5, L-3.lvlx",
    "SMB1 - W-5, L-4.lvlx",
    "SMB1 - W-6, L-1.lvlx",
    "SMB1 - W-6, L-2.lvlx",
    "SMB1 - W-6, L-3.lvlx",
    "SMB1 - W-6, L-4.lvlx",
    "SMB1 - W-7, L-1.lvlx",
    "SMB1 - W-7, L-2.lvlx",
    "SMB1 - W-7, L-3.lvlx",
    "SMB1 - W-7, L-4.lvlx",
    "SMB1 - W-8, L-1.lvlx",
    "SMB1 - W-8, L-2.lvlx",
    "SMB1 - W-8, L-3.lvlx",
    "SMB1 - W-8, L-4.lvlx",
    "SMB1 - W-9, L-1.lvlx",
    "SMB1 - W-9, L-2.lvlx",
    "SMB1 - W-9, L-3.lvlx",
    "SMB1 - W-9, L-4.lvlx",
    "SMB2 - W-1, L-1.lvlx",
    "SMB2 - W-1, L-2.lvlx",
    "SMB2 - W-1, L-3.lvlx",
    "SMB2 - W-2, L-1.lvlx",
    "SMB2 - W-2, L-2.lvlx",
    "SMB2 - W-2, L-3.lvlx",
    "SMB2 - W-3, L-1.lvlx",
    "SMB2 - W-3, L-2.lvlx",
    "SMB2 - W-3, L-3.lvlx",
    "SMB2 - W-4, L-1.lvlx",
    "SMB2 - W-4, L-2.lvlx",
    "SMB2 - W-4, L-3.lvlx",
    "SMB2 - W-5, L-1.lvlx",
    "SMB2 - W-5, L-2.lvlx",
    "SMB2 - W-5, L-3.lvlx",
    "SMB2 - W-6, L-1.lvlx",
    "SMB2 - W-6, L-2.lvlx",
    "SMB2 - W-6, L-3.lvlx",
    "SMB2 - W-7, L-1.lvlx",
    "SMB2 - W-7, L-2.lvlx",
    "SMB3 - W-1, L-1.lvlx",
    "SMB3 - W-1, L-2.lvlx",
    "SMB3 - W-1, L-3.lvlx",
    "SMB3 - W-1, L-4.lvlx",
    "SMB3 - W-1, L-5.lvlx",
    "SMB3 - W-1, L-6.lvlx",
    "SMB3 - W-1, L-Airship.lvlx",
    "SMB3 - W-1, L-Fortress.lvlx",
    "SMB3 - W-2, L-1.lvlx",
    "SMB3 - W-2, L-2.lvlx",
    "SMB3 - W-2, L-3.lvlx",
    "SMB3 - W-2, L-4.lvlx",
    "SMB3 - W-2, L-5.lvlx",
    "SMB3 - W-2, L-Airship.lvlx",
    "SMB3 - W-2, L-Fortress.lvlx",
    "SMB3 - W-2, L-Pyramid.lvlx",
    "SMB3 - W-2, L-Quicksand.lvlx",
    "SMB3 - W-3, L-1.lvlx",
    "SMB3 - W-3, L-2.lvlx",
    "SMB3 - W-3, L-3.lvlx",
    "SMB3 - W-3, L-4.lvlx",
    "SMB3 - W-3, L-5.lvlx",
    "SMB3 - W-3, L-6.lvlx",
    "SMB3 - W-3, L-7.lvlx",
    "SMB3 - W-3, L-8.lvlx",
    "SMB3 - W-3, L-9.lvlx",
    "SMB3 - W-3, L-Fortress1.lvlx",
    "SMB3 - W-3, L-Fortress2.lvlx",
    "SMB3 - W-3, L-Airship.lvlx",
    "SMB3 - W-4, L-1.lvlx",
    "SMB3 - W-4, L-2.lvlx",
    "SMB3 - W-4, L-3.lvlx",
    "SMB3 - W-8, L-C.lvlx",
    "SMB3 - W-8, L-Castle.lvlx",
    "SMW - W-1, L-YI1.lvlx",
    "SMW - W-1, L-YI2.lvlx",
    "SMW - W-1, L-YI3.lvlx",
    "SMW - W-1, L-YI4.lvlx",
    "SMW - W-1, L-YIIC.lvlx",
    "SMW - W-2, L-DP1.lvlx",
    "SMW - W-2, L-DP2.lvlx",
    "SMW - W-2, L-DS1.lvlx",
    "SMW - W-8, L-BVLC.lvlx",
    "SMBS - W-1, L-1.lvlx",
    "SMBS - W-1, L-2.lvlx",
    "SMBS - W-1, L-3.lvlx",
    "SMBS - W-1, L-4.lvlx",
    "SMBS - W-1, L-5.lvlx",
    "SMBS - W-1, L-6.lvlx",
    "SMBS - W-1, L-A.lvlx",
    "SMBS - W-1, L-Castle.lvlx",
    "SMBS - W-1, L-Tower.lvlx",
    "SMBS - W-2, L-1.lvlx",
    "SMBS - W-2, L-2.lvlx",
    "SMBS - W-2, L-3.lvlx",
    "SMBS - W-2, L-4.lvlx",
    "SMBS - W-2, L-5.lvlx",
    "SMBS - W-2, L-A.lvlx",
    "SMBS - W-2, L-Tower.lvlx",
    "WSMBA - W-0, L-Bonus.lvlx",
    "WSMBA - W-2, L-1.lvlx",
    "WSMBA - W-2, L-2.lvlx",
    "WSMBA - W-2, L-3.lvlx",
    "WSMBA - W-2, L-4.lvlx",
    "WSMBA - W-2, L-Boss.lvlx",
    "WSMBA - W-2, L-Hammer Bros 1.lvlx",
    "WSMBA - W-2, L-Hammer Bros 2.lvlx",
    "WSMBA - W-3, L-1.lvlx",
    "WSMBA - W-3, L-2.lvlx",
    "WSMBA - W-4, L-1.lvlx",
    "WSMBA - W-4, L-2.lvlx",
    "WSMBA - W-4, L-3.lvlx",
    "WSMBA - W-4, L-4.lvlx",
    "WSMBA - W-5, L-1.lvlx",
    "WSMBA - W-5, L-2.lvlx",
    "WSMBA - W-5, L-3.lvlx",
    "WSMBA - W-6, L-1.lvlx",
    "WSMBA - W-6, L-2.lvlx",
    "WSMBA - W-7, L-1.lvlx",
    "WSMBA - W-7, L-2.lvlx",
    "WSMBA - W-7, L-4.lvlx",
    "WSMBA - W-S, L-2.lvlx",
    "WSMBA - W-S, L-4.lvlx",
}

--All SMB1 levels with an -3, listed here for many reasons
smastables.__smb1Dash3Levels = {
    "SMB1 - W-1, L-3.lvlx",
    "SMB1 - W-2, L-3.lvlx",
    "SMB1 - W-3, L-3.lvlx",
    "SMB1 - W-4, L-3.lvlx",
    "SMB1 - W-5, L-3.lvlx",
    "SMB1 - W-6, L-3.lvlx",
    "SMB1 - W-7, L-3.lvlx",
}

--All SMB1 levels with an -3, listed here for many reasons
smastables.__smb1Dash3LevelsNumbered = {
    [1] = "SMB1 - W-1, L-3.lvlx",
    [2] = "SMB1 - W-2, L-3.lvlx",
    [3] = "SMB1 - W-3, L-3.lvlx",
    [4] = "SMB1 - W-4, L-3.lvlx",
    [5] = "SMB1 - W-5, L-3.lvlx",
    [6] = "SMB1 - W-6, L-3.lvlx",
    [7] = "SMB1 - W-7, L-3.lvlx",
}

--All SMB1 levels with an -1, listed here for many reasons
smastables.__smb1Dash1Levels = {
    "SMB1 - W-1, L-1.lvlx",
    "SMB1 - W-2, L-1.lvlx",
    "SMB1 - W-3, L-1.lvlx",
    "SMB1 - W-4, L-1.lvlx",
    "SMB1 - W-5, L-1.lvlx",
    "SMB1 - W-6, L-1.lvlx",
    "SMB1 - W-7, L-1.lvlx",
}

--All SMB1 levels with an -1, listed here for many reasons
smastables.__smb1Dash1LevelsNumbered = {
    [1] = "SMB1 - W-1, L-1.lvlx",
    [2] = "SMB1 - W-2, L-1.lvlx",
    [3] = "SMB1 - W-3, L-1.lvlx",
    [4] = "SMB1 - W-4, L-1.lvlx",
    [5] = "SMB1 - W-5, L-1.lvlx",
    [6] = "SMB1 - W-6, L-1.lvlx",
    [7] = "SMB1 - W-7, L-1.lvlx",
}

smastables.allGoombaNPCIDs = table.map{1,2,27,71,89,242,243,379,392,393,466,467}
smastables.allKoopaNPCIDs = table.map{4,5,6,7,55,72,73,76,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,161,172,173,174,175,176,177,194,578,920,921}
smastables.allShellNPCIDs = table.map{5,7,24,73,113,114,115,116,172,174,194,195}
smastables.allStarmanNPCIDs = table.map{293,559,994,996}
smastables.allCollectableStarNPCIDs = table.map{97,196,1000}
smastables.allCoinNPCIDs = table.map{10,33,88,103,138,152,251,252,253,258,411,528} --378 is a dash coin. Perhaps we should make it compatible with it soon...?
smastables.allMushroomNPCIDs = table.map{9,184,185,249}
smastables.allFireFlowerNPCIDs = table.map{14,182,183}
smastables.allThwompNPCIDs = table.map{37,180,437,295,435,432,301}
smastables.allEnemyFireballs = table.map{85,87,246,276}
smastables.allRupeeNPCIDs = table.map{251,252,253}

smastables.allInteractableNPCIDs = table.map{9,10,14,31,33,34,35,88,90,92,139,140,141,142,143,144,145,146,147,153,154,155,156,157,169,170,184,185,186,187,188,191,193,249,250,258,274,293,425,462,559,994,996,997}

smastables.allBaseGameKillableEnemyIDs = {1,2,4,5,6,7,8,12,15,17,18,19,20,23,24,25,27,28,29,36,37,38,39,43,43,44,47,48,51,52,53,54,55,59,61,63,65,71,72,73,74,76,77,86,89,93,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,135,136,137,161,162,163,164,165,166,167,168,172,173,174,175,176,177,179,180,189,194,195,199,200,201,203,204,205,206,207,210,229,230,231,232,233,234,235,236,242,243,244,245,247,256,257,261,262,267,268,270,271,272,275,280,281,284,285,286,294,295,296,297,298,299,301,302,303,304,305,307,309,311,312,313,314,315,316,317,318,323,324,333,334,345,346,347,350,351,352,357,366,368,369,371,372,373,374,375,376,377,379,382,383,386,388,389,392,393,395,401,406,407,408,409,413,415,417,431,432,435,437,444,446,447,448,449,459,460,461,463,464,466,467,469,470,471,472,485,486,487,490,491,492,493,509,510,512,513,514,515,516,517,518,519,520,521,522,523,524,529,530,539,562,563,564,572,578,579,580,586,587,588,589,590,610,611,612,613,614,616,617,618,623,624,667,920,921} --This is a list of all killable enemies for Frisk, and some etc. stuff

smastables.allLavaBlockIDs = {371,405,30,406,1268,404,420,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487}

smastables.stockSoundNumbersInOrder = table.map{2,3,5,6,9,11,12,13,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,34,35,37,38,40,41,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,78,79,80,82,83,84,85,86,87,88,89,90,91}

smastables.extrasoundsNumbersInOrder = table.map{1,4,7,8,10,14,15,18,33,39,42,43,59,77,81,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169}

smastables.allSoundNumbersInOrder = table.map{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169}

smastables.allVanillaSoundNumbersInOrder = table.map{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91}

smastables.soundNamesInOrder = {
    "player-jump", --1
    "stomped", --2
    "block-hit", --3
    "block-smash", --4
    "player-shrink", --5
    "player-grow", --6
    "mushroom", --7
    "player-died", --8
    "shell-hit", --9
    "player-slide", --10
    "item-dropped", --11
    "has-item", --12
    "camera-change", --13
    "coin", --14
    "1up", --15
    "lava", --16
    "warp", --17
    "fireball", --18
    "level-win", --19
    "boss-beat", --20
    "dungeon-win", --21
    "bullet-bill", --22
    "grab", --23
    "spring", --24
    "hammer", --25
    "slide", --26
    "newpath", --27
    "level-select", --28
    "do", --29
    "pause", --30
    "key", --31
    "pswitch", --32
    "tail", --33
    "racoon", --34
    "boot", --35
    "smash", --36
    "thwomp", --37
    "birdo-spit", --38
    "birdo-hit", --39
    "smb2-exit", --40
    "birdo-beat", --41
    "npc-fireball", --42
    "fireworks", --43
    "bowser-killed", --44
    "game-beat", --45
    "door", --46
    "message", --47
    "yoshi", --48
    "yoshi-hurt", --49
    "yoshi-tongue", --50
    "yoshi-egg", --51
    "got-star", --52
    "zelda-kill", --53
    "player-died2", --54
    "yoshi-swallow", --55
    "ring", --56
    "dry-bones", --57
    "smw-checkpoint", --58
    "dragon-coin", --59
    "smw-exit", --60
    "smw-blaarg", --61
    "wart-bubble", --62
    "wart-die", --63
    "sm-block-hit", --64
    "sm-killed", --65
    "sm-glass", --66
    "sm-hurt", --67
    "sm-boss-hit", --68
    "sm-cry", --69
    "sm-explosion", --70
    "climbing", --71
    "swim", --72
    "grab2", --73
    "smw-saw", --74
    "smb2-throw", --75
    "smb2-hit", --76
    "zelda-stab", --77
    "zelda-hurt", --78
    "zelda-heart", --79
    "zelda-died", --80
    "zelda-rupee", --81
    "zelda-fire", --82
    "zelda-item", --83
    "zelda-key", --84
    "zelda-shield", --85
    "zelda-dash", --86
    "zelda-fairy", --87
    "zelda-grass", --88
    "zelda-hit", --89
    "zelda-sword-beam", --90
    "bubble", --91
    "sprout-vine", --92
    "iceball", --93
    "yi-freeze", --94
    "yi-icebreak", --95
    "2up", --96
    "3up", --97
    "5up", --98
    "dragon-coin-get2", --99
    "dragon-coin-get3", --100
    "dragon-coin-get4", --101
    "dragon-coin-get5", --102
    "cherry", --103
    "explode", --104
    "hammerthrow", --105
    "combo1", --106
    "combo2", --107
    "combo3", --108
    "combo4", --109
    "combo5", --110
    "combo6", --111
    "combo7", --112
    "score-tally", --113
    "score-tally-end", --114
    "bowser-fire", --115
    "boomerang", --116
    "smb2-charge", --117
    "stopwatch", --118
    "whale-spout", --119
    "door-reveal", --120
    "p-wing", --121
    "wand-moving", --122
    "wand-whoosh", --123
    "hop", --124
    "smash-big", --125
    "smb2-hitenemy", --126
    "boss-fall", --127
    "boss-lava", --128
    "boss-shrink", --129
    "boss-shrink-done", --130
    "hp-get", --131
    "hp-max", --132
    "cape-feather", --133
    "cape-fly", --134
    "flag-slide", --135
    "smb1-exit", --136
    "smb2-clear", --137
    "smb1-world-clear", --138
    "smb1-underground-overworld", --139
    "smb1-underground-desert", --140
    "smb1-underground-sky", --141
    "goaltape-countdown-start", --142
    "goaltape-countdown-loop", --143
    "goaltape-countdown-end", --144
    "goaltape-irisout", --145
    "smw-exit-orb", --146
    "ace-coins-5", --147
    "door-close", --148
    "sprout-megashroom", --149
    "0up", --150
    "correct", --151
    "wrong", --152
    "castle-destroy", --153
    "twirl", --154
    "fireball-hit", --155
    "shell-grab", --156
    "ice-melt", --157
    "player-jump2", --158
    "ground-pound", --159
    "ground-pound-hit", --160
    "zelda-fireball", --161
    "zelda-iceball", --162
    "pballoon", --163
    "peach-cry", --164
    "timeout", --165
    "flyinghammer-throw", --166
    "fireball2", --167
    "fireball3", --168
    "fireball-hit-hammershield", --169
}

smastables.keyboardMap = {
    "", -- [1]
    "", -- [2]
    VK_CNCL, -- [3]
    "", -- [4]
    "", -- [5]
    VK_HELP, -- [6]
    "", -- [7]
    VK_BCKS, -- [8]
    VK_TAB, -- [9]
    "", -- [10]
    "", -- [11]
    VK_CLR, -- [12]
    VK_ENTR, -- [13]
    VK_ENTRS, -- [14]
    "", -- [15]
    VK_SHFT, -- [16]
    VK_CTRL, -- [17]
    VK_ALT, -- [18]
    VK_PAUS, -- [19]
    VK_CAPS, -- [20]
    VK_KANA, -- [21]
    VK_EISU, -- [22]
    VK_JNJA, -- [23]
    VK_FIN, -- [24]
    VK_HNJA, -- [25]
    "", -- [26]
    VK_ESC, -- [27]
    VK_CONV, -- [28]
    VK_NONC, -- [29]
    VK_ACC, -- [30]
    VK_MODE, -- [31]
    VK_SPACE, -- [32]
    VK_PGUP, -- [33]
    VK_PGDWN, -- [34]
    VK_END, -- [35]
    VK_HOME, -- [36]
    VK_LEFT, -- [37]
    VK_UP, -- [38]
    VK_RIGHT, -- [39]
    VK_DOWN, -- [40]
    VK_SEL, -- [41]
    VK_PRNT, -- [42]
    VK_EXE, -- [43]
    VK_PRNT, -- [44]
    VK_INS, -- [45]
    VK_DEL, -- [46]
    "", -- [47]
    VK_0, -- [48]
    VK_1, -- [49]
    VK_2, -- [50]
    VK_3, -- [51]
    VK_4, -- [52]
    VK_5, -- [53]
    VK_6, -- [54]
    VK_7, -- [55]
    VK_8, -- [56]
    VK_9, -- [57]
    VK_OEM_1, -- [58]
    VK_OEM_1, -- [59]
    VK_OEM_102, -- [60]
    "VK_=", -- [61]
    VK_OEM_102, -- [62]
    VK_OEM_2, -- [63]
    "VK_@", -- [64]
    VK_A, -- [65]
    VK_B, -- [66]
    VK_C, -- [67]
    VK_D, -- [68]
    VK_E, -- [69]
    VK_F, -- [70]
    VK_G, -- [71]
    VK_H, -- [72]
    VK_I, -- [73]
    VK_J, -- [74]
    VK_K, -- [75]
    VK_L, -- [76]
    VK_M, -- [77]
    VK_N, -- [78]
    VK_O, -- [79]
    VK_P, -- [80]
    VK_Q, -- [81]
    VK_R, -- [82]
    VK_S, -- [83]
    VK_T, -- [84]
    VK_U, -- [85]
    VK_V, -- [86]
    VK_W, -- [87]
    VK_X, -- [88]
    VK_Y, -- [89]
    VK_Z, -- [90]
    VK_OS, -- [91] Windows Key (Windows) or Command Key (Mac)
    "", -- [92]
    VK_MENU, -- [93]
    "", -- [94]
    VK_SLP, -- [95]
    VK_0, -- [96]
    VK_1, -- [97]
    VK_2, -- [98]
    VK_3, -- [99]
    VK_4, -- [100]
    VK_5, -- [101]
    VK_6, -- [102]
    VK_7, -- [103]
    VK_8, -- [104]
    VK_9, -- [105]
    "VK_*", -- [106]
    VK_OEM_PLUS, -- [107]
    VK_SEP, -- [108]
    VK_OEM_MINUS, -- [109]
    VK_OEM_PERIOD, -- [110]
    VK_OEM_2, -- [111]
    VK_F1, -- [112]
    VK_F2, -- [113]
    VK_F3, -- [114]
    VK_F4, -- [115]
    VK_F5, -- [116]
    VK_F6, -- [117]
    VK_F7, -- [118]
    VK_F8, -- [119]
    VK_F9, -- [120]
    VK_F10, -- [121]
    VK_F11, -- [122]
    VK_F12, -- [123]
    VK_F13, -- [124]
    VK_F14, -- [125]
    VK_F15, -- [126]
    VK_F16, -- [127]
    VK_F17, -- [128]
    VK_F18, -- [129]
    VK_F19, -- [130]
    VK_F20, -- [131]
    VK_F21, -- [132]
    VK_F22, -- [133]
    VK_F23, -- [134]
    VK_F24, -- [135]
    "", -- [136]
    "", -- [137]
    "", -- [138]
    "", -- [139]
    "", -- [140]
    "", -- [141]
    "", -- [142]
    "", -- [143]
    VK_NUM, -- [144]
    VK_SCROLL, -- [145]
    VK_JISHO, -- [146]
    VK_MASSHOU, -- [147]
    VK_TOUROKU, -- [148]
    VK_LOYA, -- [149]
    VK_ROYA, -- [150]
    "", -- [151]
    "", -- [152]
    "", -- [153]
    "", -- [154]
    "", -- [155]
    "", -- [156]
    "", -- [157]
    "", -- [158]
    "", -- [159]
    "VK_^", -- [160]
    "VK_!", -- [161]
    VK_OEM_5, -- [162]
    "VK_#", -- [163]
    "VK_$", -- [164]
    "VK_%", -- [165]
    "VK_&", -- [166]
    "VK__", -- [167]
    "VK_(", -- [168]
    "VK_)", -- [169]
    "VK_*", -- [170]
    "VK_+", -- [171]
    "VK_|", -- [172]
    "VK_-", -- [173]
    VK_OEM_4, -- [174]
    VK_OEM_6, -- [175]
    VK_OEM_3, -- [176]
    "", -- [177]
    "", -- [178]
    "", -- [179]
    "", -- [180]
    VK_MUTE, -- [181]
    VK_VDOWN, -- [182]
    VK_VUP, -- [183]
    "", -- [184]
    "", -- [185]
    "VK_;", -- [186]
    "VK_=", -- [187]
    "VK_,", -- [188]
    "VK_-", -- [189]
    "VK_.", -- [190]
    "VK_/", -- [191]
    VK_OEM_5, -- [192]
    "", -- [193]
    "", -- [194]
    "", -- [195]
    "", -- [196]
    "", -- [197]
    "", -- [198]
    "", -- [199]
    "", -- [200]
    "", -- [201]
    "", -- [202]
    "", -- [203]
    "", -- [204]
    "", -- [205]
    "", -- [206]
    "", -- [207]
    "", -- [208]
    "", -- [209]
    "", -- [210]
    "", -- [211]
    "", -- [212]
    "", -- [213]
    "", -- [214]
    "", -- [215]
    "", -- [216]
    "", -- [217]
    "", -- [218]
    VK_OEM_4, -- [219]
    VK_OEM_5, -- [220]
    VK_OEM_6, -- [221]
    VK_OEM_5, -- [222]
    "", -- [223]
    VK_META, -- [224]
    VK_ALTG, -- [225]
    "", -- [226]
    VK_HELP, -- [227]
    VK_00, -- [228]
    "", -- [229]
    VK_CLEAR, -- [230]
    "", -- [231]
    "", -- [232]
    VK_RESET, -- [233]
    VK_JUMP, -- [234]
    VK_PA1, -- [235]
    VK_PA2, -- [236]
    VK_PA3, -- [237]
    VK_WCTRL, -- [238]
    VK_CUSEL, -- [239]
    VK_ATTN, -- [240]
    VK_FIN, -- [241]
    VK_COPY, -- [242]
    VK_AUTO, -- [243]
    VK_ENLW, -- [244]
    VK_BTAB, -- [245]
    VK_ATTN, -- [246]
    VK_CRSEL, -- [247]
    VK_EXSEL, -- [248]
    VK_EREOF, -- [249]
    VK_PLAY, -- [250]
    VK_ZOOM, -- [251]
    "", -- [252]
    VK_PA1, -- [253]
    VK_CLR, -- [254]
    "" -- [255]
}

smastables.mario3AroundTheWorldMusicRng = {
    "_OST/Mario 3 - Around the World (Bootleg)/03 - Music 1 (Forget Him).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/04 - Music 2 (Through the Night).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/05 - Music 3 (Quick Fix).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/06 - Music 4 (Lost Forest).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/07 - Music 5 (Lame Bells).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/08 - Music 6 (FM Acid).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/09 - Music 7 (SMB Tepples).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/10 - Music 8 (Uzhos).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/11 - Music 9 (Space Standart).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/12 - Music 10 (Another It).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/13 - Music 11 (Nonamed).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/14 - Music 12 (Class11.Time Flies).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/15 - Music 13 (Wizardry).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/16 - Music 14 (Ending Theme).vgm",
    "_OST/Mario 3 - Around the World (Bootleg)/17 - Music 15 (SMB).vgm",
}

--This will be used for an SEE Mod-only feature where it'll compare what sounds were in the previously cached sound file table when changing sounds. If anything that's currently changed isn't matching the sounds on the previously cached sound file table, it'll clear the unmatched sounds that are specified from the SMBX2 cache.
for k,v in ipairs(smastables.soundNamesInOrder) do
    smastables.previouslyCachedSoundFiles = {}
    smastables.currentlyCachedSoundFiles = {}
    smastables.previouslyCachedSoundFiles[k] = v
    smastables.currentlyCachedSoundFiles[k] = v
end

return smastables