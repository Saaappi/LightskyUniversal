local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("QUEST_DETAIL")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "QUEST_DETAIL" then
        C_Timer.After(0.2, function()
            AcceptQuest()
        end)
    end
end)