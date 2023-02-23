local smasglobals = {}

--Max powerup slot global
_G.Main_Globals = {
    MAX_POWERUP_ID = 7,
}

--Layer globals
_G.Layer_Globals = {
    LAYER_NONE = 0,
    LAYER_DEFAULT = 1,
    LAYER_DESTROYED_BLOCKS = 2,
    LAYER_SPAWNED_NPCS = 3,
}

--Event globals
_G.Event_Globals = {
    EVENT_NONE = 0,
    EVENT_LEVEL_START = 1,
    EVENT_PSWITCH_START = 2,
    EVENT_PSWITCH_END = 3,
}

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