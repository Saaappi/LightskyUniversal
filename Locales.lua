local addonName, LSU = ...
local Locales = {
    enUS = {},
    enGB = {},
    deDE = {},
    esES = {},
    esMX = {},
    frFR = {},
    itIT = {},
    koKR = {},
    ptBR = {},
    ruRU = {},
    zhCN = {},
    zhTW = {}
}

LIGHTSKYUNIVERSAL_LOCALES = Locales

local L = Locales.enUS

-- Error Messages
L["ADDON_NOT_FOUND"] = "%s not found! Are you sure it's loaded?"

L["IMPORT"]         = "Import"
L["IMPORT_DESC"]    = "Quickly import gossips in the Player Gossips table from the HelpMePlay addon.\n\n" ..
                      "|cffFF474CNOTE:|r This will WIPE the gossips from HelpMePlay. This action is irreversible!"