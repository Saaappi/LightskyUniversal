local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("QUEST_DETAIL")
eventFrame:RegisterEvent("QUEST_GREETING")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "QUEST_DETAIL" then
        C_Timer.After(0.2, function()
            local questID = GetQuestID()
            if questID and (not LSU.IsQuestIgnored(questID) and not C_QuestLog.IsRepeatableQuest(questID) and not QuestIsWeekly()) then
                AcceptQuest()
            end
        end)
    end
    if event == "QUEST_GREETING" then
        C_Timer.After(0.2, function()
            for i = 1, GetNumActiveQuests() do
                local questID = GetActiveQuestID(i)
                if not LSU.IsQuestIgnored(questID) then
                    local isComplete = select(2, GetActiveTitle(i))
                    if isComplete and not C_QuestLog.IsWorldQuest(questID) then
                        SelectActiveQuest(i)
                    end
                end
            end

            for i = 1, GetNumAvailableQuests() do
                local questID = select(5, GetAvailableQuestInfo(i))
                if questID and not LSU.IsQuestIgnored(questID) then
                    if not QuestIsDaily() and (not QuestIsWeekly() and not C_QuestLog.IsRepeatableQuest(questID)) then
                        SelectAvailableQuest(i)
                    end
                end
            end
        end)
    end
end)