local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("QUEST_COMPLETE")
eventFrame:RegisterEvent("QUEST_PROGRESS")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "QUEST_COMPLETE" then
        C_Timer.After(0.2, function()
            local numRewardChoices = GetNumQuestChoices()
            if numRewardChoices <= 1 then
                GetQuestReward(1)
                QuestFrameCompleteQuestButton:Click("LeftButton")
            end
        end)
    end
    if event == "QUEST_PROGRESS" then
        C_Timer.After(0.2, function()
            if IsQuestCompletable() then
                CompleteQuest()
            end
        end)
    end
end)