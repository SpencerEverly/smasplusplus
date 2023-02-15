local smasmemoryaddresses = {}




--MEMORY ADDRESSES
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

_G.GM_PSWITCH_COUNTER = 0x00B2C62C --FIELD_WORD
_G.GM_PSWITCH_LENGTH = 0x00B2C87C --FIELD_WORD
_G.GM_STOPWATCH_COUNTER = 0x00B2C62E --FIELD_WORD





--PLAYER ADDRESSES
_G.PLR_HEARTS = 0x16 --FIELD_WORD
_G.PLR_HOLDINGNPC = 0x154 --FIELD_WORD

return smasmemoryaddresses