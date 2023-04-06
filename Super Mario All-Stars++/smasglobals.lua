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

--*UNUSED, FOR NOW*

_G.NPC_Globals = {
    AttLayer = Layer_Globals.LAYER_NONE,
    Quicksand = 0,
    RespawnDelay = 0,
    Bouce = false,
    RealSpeedX = 0,
    Wet = false, --True if in water
    NoLavaSplash = false, --True for no lava splash
    BlockSlope = 0, --The block that the NPC is on a slope with
    ScoreMultiplier = 0, --For upping the points the player recieves
    CanTailHit = true, --If false, the player can't hit the NPC with it's tail
    Shadow = false, --If true, then the NPC is black and will allow it to pass through walls. Only used for the cheat code "shadowstar".
    TriggerActivate = Event_Globals.EVENT_NONE, --For events: Triggers when NPC gets activated
    TriggerDeath = Event_Globals.EVENT_NONE, --Triggers when NPC dies
    TriggerTalk = Event_Globals.EVENT_NONE, --Triggers when you talk to the NPC
    TriggerLast = Event_Globals.EVENT_NONE, --Trigger when this is the last NPC in a layer to die
    Layer = Layer_Globals.LAYER_NONE, --The layer name that the NPC is in
    Hidden = false, --If the NPC is hidden or not
    Legacy = false, --Legacy Boss
    Chat = false, --For talking to the NPC
    Inert = false, --The friendly toggle. makes the NPC not do anything
    Stuck = false, --The 'don't move' toggle. forces the NPC not to move
    DefaultStuck = false,
    Text = "", --The text that is displayed when you talk to the NPC
    BeltSpeed = 0, --The speed of the object this NPC is standing on
    Generator = false, --For spawning new NPCs
    GeneratorTimeMax = 0,
    GeneratorTime = 0,
    GeneratorDirection = 0,
    GeneratorEffect = 0,
    GeneratorActive = false,
    
}

return smasglobals