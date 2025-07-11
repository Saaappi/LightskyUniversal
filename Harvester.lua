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

    player.FullName = player.Name .. "-" .. player.NormalizedRealmName

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
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        OnPlayerEnteringWorld()
    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        OnPlayerLevelUp(newLevel)
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
        OnSpecializationChanged()
    end
end)