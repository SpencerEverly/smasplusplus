local smasglobals = {}

--***GLOBAL CONSTANTS***

--Layer globals
_G.Layer_Globals = {
    LAYER_NONE = -1,
    LAYER_DEFAULT = 0,
    LAYER_DESTROYED_BLOCKS = 1,
    LAYER_SPAWNED_NPCS = 2,
}

--Event globals
_G.Event_Globals = {
    EVENT_NONE = -1,
    EVENT_LEVEL_START = 0,
    EVENT_PSWITCH_START = 1,
    EVENT_PSWITCH_END = 2,
}

_G.MaxLevelStrings = 65535

--"was previously changed to 10000; now only used for certain NPC bounds checking.
--returned to 8000." -Wohlstand
_G.FLBlocks = 8000
_G.vScreenYOffset = 0

--Number of things to use with levels/worlds
_G.maxLocalPlayers = 4 --Original is 2
_G.maxPlayerFrames = 750
_G.numBackground2 = 200 --Original is 100
_G.numCharacters = 18 --Original is 5
_G.numStates = 7
_G.numSounds = 169 --Original is 200, will be increased if any new sounds get added
_G.MaxSavedEvents = 5000 --Original is 200
_G.maxCreditsLines = 200
_G.maxSaveSlots = 36757 --Original is 3
_G.maxWorldCredits = 100
_G.maxYoshiGfx = 10
_G.maxStarsNum = 9999 --Original is 1000

--Max a level/world can have
_G.maxBlocks = 20000
_G.maxPlayers = 200
_G.maxEffects = 1000
_G.maxNPCs = 5000
_G.maxWarps = 2000
_G.maxBackgrounds = 4000
_G.maxWater = 1000
_G.maxQuicksand = 1000
_G.maxWorldLevels = 4000 --Original is 400
_G.maxWorldPaths = 6000 --Original is 2000
_G.maxWorldMusic = 2000 --Original is 1000
_G.maxSections = 20
_G.maxTiles = 30000 --Original is 20000
_G.maxScenes = 5000

--Max types
_G.maxBlockType = 4000 --Original is 700
_G.maxBackgroundType = 200
_G.maxSceneType = 100
_G.maxNPCType = 4000 --Original is 302
_G.maxEffectType = 4000 --Original is 200
_G.maxTileType = 4000 --Original is 400
_G.maxLevelType = 100
_G.maxPathType = 200 --Original is 100

--Resolution
_G.ScreenW = 800
_G.ScreenH = 600

--***GLOBALS MAIN***

_G.GameIsActive = false
_G.AppPath = Misc.episodePath()

_G.numSavedEvents = 0

_G.numCredits = 0
_G.numBlock = 0
_G.numBackground = 0
_G.numNPCs = 0
_G.numEffects = 0
_G.numPlayers = 0
_G.numWorldLevels = 0
_G.numWorldMusic = 0

_G.NPC_Globals = {
    id = 0, --ID of the NPC (Type)
    x = 0, --X Position for the NPC
    y = 0, --Y position for the NPC
    width = 0, --Width of the NPC.
    height = 0, --Height of the NPC.
    speedX = 0, --Speed X for the NPC
    speedY = 0, --Speed Y for the NPC
    direction = 0, --The direction of the NPC.
    ai1 = 0, --The AIs of the NPC.
    ai2 = 0,
    ai3 = 0,
    ai4 = 0,
    ai5 = 0,
    ai6 = 0,
    ai7 = 0,
    
    spawnId = 0, --ID of the NPC when spawning
    spawnX = 0, --X position when it originally spawned
    spawnY = 0, --Y position when it originally spawned
    spawnWidth = 0, --Width when it originally spawned
    spawnHeight = 0, --Height when it originally spawned
    spawnSpeedX = 0, --Speed X when it originally spawned
    spawnSpeedY = 0, --Speed Y when it originally spawned
    spawnDirection = 0, --Direction when it originally spawned
    spawnAi1 = 0, --The AIs of the NPC when it originally spawned.
    spawnAi2 = 0,
    spawnAi3 = 0,
    spawnAi4 = 0,
    spawnAi5 = 0,
    spawnAi6 = 0,
    spawnAi7 = 0,
    
    animationFrame = 0, --Frame to show
    animationTimer = 0, --The timer of each frame.
    
    isValid = false, --Whether valid on the level or not.
    isOnScreen = false, --Whether on the screen or not.
    
    canTurnAround = false, --Whether to turn around or not.
    
    killFlag = 0, --Whether the NPC should die or not
    
    quicksand = 0, --Is the NPC in quicksand?
    underwater = false, --Is the NPC in water?
    
    despawnTimer = 0, --Timer until NPC despawns. (TimeLeft?)
    
    bouce = false, --Unknown(?)
    
    blockSlope = 0, --The block that the NPC is on a slope with
    isSemiSlope = false, --Whether the slope is a semi-solid or not
    
    noLavaSplash = false, --True for no lava splash when dying
    canGetHitByTail = true, --If false, the player can't hit the NPC with it's tail
    
    isShadowStarred = false, --If true, then the NPC is black and will allow it to pass through walls. Only used for the cheat code "shadowstar".
    
    activateEventName = Event_Globals.EVENT_NONE, --For events: Triggers when NPC gets activated
    deathEventName = Event_Globals.EVENT_NONE, --Triggers when NPC dies
    talkEventName = Event_Globals.EVENT_NONE, --Triggers when you talk to the NPC
    noMoreObjInLayer = Event_Globals.EVENT_NONE, --Trigger when this is the last NPC in a layer to die
    
    attachedLayerName = Layer_Globals.LAYER_NONE, --The name of the NPC's attached layer.
    layerName = Layer_Globals.LAYER_NONE, --The layer name that the NPC is in
    layerObj = Layer_Globals.LAYER_NONE, --The layer for the NPC.
    isHidden = false, --If the NPC is hidden or not
    
    legacyBoss = false, --Legacy Boss
    
    hasMessage = false, --For talking to the NPC
    friendly = false, --The friendly toggle. makes the NPC not do anything (Inert)
    dontMove = false, --The 'don't move' toggle. forces the NPC not to move (Stuck)
    defaultFriendly = false, --The friendly toggle, which this one will be true when it was originally toggled on start (DefaultStuck).
    msg = "", --The text that is displayed when you talk to the NPC
    
    beltSpeed = 0, --The speed of the object this NPC is standing on
    
    isGenerator = false, --For spawning new NPCs with generators.
    generatorInterval = 0, --Generator time before execution.
    generatorTimer = 0, --The timer of the generator.
    generatorDirection = 0, --The direction the generator is firing.
    generatorType = 0, --The type of the generator.
    generatorActive = false, --Whether the generator is active or not.
    
    scoreMultiplier = 0, --For upping the points the player recieves
}

return smasglobals