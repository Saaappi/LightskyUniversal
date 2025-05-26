local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")
local character

local function GetPlayerSpecializationID()
    if PlayerUtil and PlayerUtil.GetCurrentSpecID then
        return PlayerUtil.GetCurrentSpecID()
    end
    return 0
end

local function OnPlayerEnteringWorld()
    if not LSU.Character then LSU.Character = {} end
    character = LSU.Character

    character.Name = UnitName("player")
    character.Realm = GetRealmName(); character.Realm = character.Realm:gsub(" ", "")
    local className, classID = select(2, UnitClass("player"))
    character.ClassName = className
    character.ClassID = classID

    local specID = GetPlayerSpecializationID()
    character.SpecID = specID

    character.Level = UnitLevel("player")

    local color = C_ClassColor.GetClassColor(className)
    character.ClassColor = color or { r=1, g=1, b=1, colorStr="ffffffff" }

    local chromieTimeExpansionID = UnitChromieTimeID("player")
    character.chromieTimeExpansionID = chromieTimeExpansionID

    local characterFullName = character.Name .. "-" .. character.Realm
    character.FullName = characterFullName

    eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function OnPlayerLevelUp(newLevel)
    if LSU.Character then
        LSU.Character.Level = newLevel
    end
end

local function OnSpecializationChanged()
    local specID = GetPlayerSpecializationID()
    character.SpecID = specID
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