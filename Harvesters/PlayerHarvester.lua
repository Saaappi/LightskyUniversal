local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")

local function OnPlayerEnteringWorld()
    if not LSU.Character then LSU.Character = {} end
    local character = LSU.Character

    character.Name = UnitName("player")
    local className, classID = select(2, UnitClass("player"))
    character.ClassName = className
    character.ClassID = classID

    if PlayerUtil and PlayerUtil.GetCurrentSpecID then
        character.SpecID = PlayerUtil.GetCurrentSpecID()
    else
        character.SpecID = 0
    end

    character.Level = UnitLevel("player")

    local color = C_ClassColor.GetClassColor(className)
    character.ClassColor = color or { r=1, g=1, b=1, colorStr="ffffffff" }

    eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function OnPlayerLevelUp(newLevel)
    if LSU.Character then
        LSU.Character.Level = newLevel
    end
end

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        OnPlayerEnteringWorld()
    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        OnPlayerLevelUp(newLevel)
    end
end)