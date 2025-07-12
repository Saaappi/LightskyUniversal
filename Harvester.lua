local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")
local player

local function GetPlayerSpecializationID()
    if PlayerUtil and PlayerUtil.GetCurrentSpecID then
        return PlayerUtil.GetCurrentSpecID()
    end
    return 0
end

local function OnPlayerEnteringWorld()
    if not addonTable.Player then addonTable.Player = {} end
    player = addonTable.Player

    -- PLAYER INFORMATION --
    player.Name = UnitName("player")
    player.RealmName, player.NormalizedRealmName = GetRealmName()
    local className, classID = select(2, UnitClass("player"))
    player.ClassName = className
    player.ClassID = classID
    player.GUID = UnitGUID("player")

    local specID = GetPlayerSpecializationID()
    player.SpecID = specID

    player.Level = UnitLevel("player")

    local color = C_ClassColor.GetClassColor(className)
    player.ClassColor = color or { r=1, g=1, b=1, colorStr="ffffffff" }

    local chromieTimeExpansionID = UnitChromieTimeID("player")
    player.ChromieTimeExpansionID = chromieTimeExpansionID

    player.FullName = player.Name .. "-" .. (player.NormalizedRealmName or player.RealmName)
    ------------------------

    -- MAP --
    local currentMapID = C_Map.GetBestMapForUnit("player")
    if currentMapID then
        player.CurrentMapID = currentMapID
    end
    ---------

    -- EDIT MODE --
    if not LSUDB.EditModeLayouts then
        LSUDB.EditModeLayouts = {}
    end

    local layouts = (C_EditMode.GetLayouts()).layouts
    if layouts then
        for i = 1, #layouts do
            local name = layouts[i].layoutName
            local foundIndex = nil

            for idx, layout in ipairs(LSUDB.EditModeLayouts) do
                if layout[1] == name then
                    foundIndex = idx
                    break
                end
            end

            if foundIndex then
                table.remove(LSUDB.EditModeLayouts, foundIndex)
                table.insert(LSUDB.EditModeLayouts, foundIndex, { name, i })
            else
                table.insert(LSUDB.EditModeLayouts, { name, i })
            end
        end
    end
    ---------------

    eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function OnPlayerLevelUp(newLevel)
    if addonTable.Player then
        player.Level = newLevel
    end
end

local function OnSpecializationChanged()
    local specID = GetPlayerSpecializationID()
    player.SpecID = specID
end

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        OnPlayerEnteringWorld()
    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        OnPlayerLevelUp(newLevel)
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
        OnSpecializationChanged()
    elseif event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
        C_Timer.After(0.25, function()
            local currentMapID = C_Map.GetBestMapForUnit("player")
            if currentMapID then
                player.CurrentMapID = currentMapID
            end
        end)
    end
end)