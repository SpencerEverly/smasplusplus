local smasmemoryaddresses = {}

_G.GM_SCRN_HDC = 0x00B25028 --Unknown
_G.GM_DO_SCREENSHOT = 0x00B2504C --FIELD_DWORD

_G.GM_CREDITS_MODE = 0x00B2C89C --FIELD_WORD
_G.GM_EPISODE_MODE = 0x00B2C5B4 --FIELD_WORD
_G.GM_LEVEL_MODE = 0x00B2C620 --FIELD_WORD

--[[GM_CREDITS_MODE == -1                        --> Credits
    GM_LEVEL_MODE   == -1                        --> Intro (Main Menu)
    GM_EPISODE_MODE == -1                        --> Overworld
    GM_EPISODE_MODE == -1 && GM_LEVEL_MODE == -1 --> Level]]

_G.GM_STR_NULL = 0x00423D00 --FIELD_STRING

_G.GM_PLAYERS_COUNT = 0x00B2595E --FIELD_WORD
_G.GM_BATTLE_MODE_ACTIVE = 0x00B2D740 --FIELD_BOOL

return smasmemoryaddresses