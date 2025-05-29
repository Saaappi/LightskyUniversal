local eventFrame = CreateFrame("Frame")

local maps = {
    {
        id = 2276, -- Khaz Algar
        quests = {
            83552, -- Azj-Kahet
            83551, -- Hallowfall
            83550, -- The Ringing Deeps
            83548 -- Isle of Dorn
        }
    }
}

local function IsAdventureMapSupported(mapID)
    for _, map in ipairs(maps) do
        if map.id == mapID then
            return true, map.quests
        end
    end
    return false
end

eventFrame:RegisterEvent("ADVENTURE_MAP_OPEN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADVENTURE_MAP_OPEN" then
        C_Timer.After(0.2, function()
            local adventureMapID = C_AdventureMap.GetMapID()
            if adventureMapID then
                local isSupported, quests = IsAdventureMapSupported(adventureMapID)
                if isSupported and quests then
                    for _, questID in ipairs(quests) do
                        if not C_QuestLog.IsQuestFlaggedCompleted(questID) then
                            C_AdventureMap.StartQuest(questID)
                        end
                    end
                end
            end
        end)
    end
end)