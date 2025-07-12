local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADVENTURE_MAP_OPEN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADVENTURE_MAP_OPEN" then
        C_Timer.After(0.5, function()
            local numZoneChoices = C_AdventureMap.GetNumZoneChoices()
            for i = numZoneChoices, 1, -1 do
                local questID = C_AdventureMap.GetZoneChoiceInfo(i)
                if LSUDB.AdventureMaps[questID] then
                    C_AdventureMap.StartQuest(questID)
                end
            end
        end)
    end
end)

