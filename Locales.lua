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

L["JOINED_GROUP"] = "You've joined or are joining a group while Auto Share Quests is enabled.\n\n" ..
                    "Would you like to disable this feature now? (No reload necessary!)"

L["IMPORT"]             = "Import"
L["IMPORT_TOOLTIP"]     = "Quickly import gossips in the Player Gossips table from the HelpMePlay addon.\n\n" ..
                      "|cffFF474CNOTE:|r This will WIPE the gossips from HelpMePlay. This action is irreversible!"

L["AUTO_SHARE_QUESTS"]          = "Auto Share Quests"
L["AUTO_SHARE_QUESTS_TOOLTIP"]  = "Automatically share quests with your party when you accept them."