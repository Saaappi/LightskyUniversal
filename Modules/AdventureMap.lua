local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADVENTURE_MAP_OPEN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADVENTURE_MAP_OPEN" then
        C_Timer.After(0.5, function()
            local mapID = C_AdventureMap.GetMapID()
            if LSUDB.AdventureMaps[mapID] then
                for questID in pairs(LSUDB.AdventureMaps[mapID]) do
                    if not C_QuestLog.IsQuestFlaggedCompleted(questID) then
                        C_AdventureMap.StartQuest(questID)
                    end
                end
            end
        end)
    end
end)

