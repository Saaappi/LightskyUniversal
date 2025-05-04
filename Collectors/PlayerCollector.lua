local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        LSU.Character.Level = newLevel
    end
    if event == "PLAYER_LOGIN" then
        if not LSU.Character then
            LSU.Character = {}
        end

        local name = UnitName("player")
        local className, _, classID = UnitClass("player"); className = className:gsub("%s+", "")
        local level = UnitLevel("player")
        local color = C_ClassColor.GetClassColor(className)

        LSU.Character.Name = name
        LSU.Character.ClassName = className
        LSU.Character.ClassID = classID
        LSU.Character.Level = level
        LSU.Character.ClassColor = color
        eventFrame:UnregisterEvent(event)
    end
end)