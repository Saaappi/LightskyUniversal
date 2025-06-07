local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("QUEST_DETAIL")
eventFrame:RegisterEvent("QUEST_GREETING")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "QUEST_DETAIL" then
        if not LSUDB.Settings["AcceptQuests.Enabled"] then return end
        C_Timer.After(0.2, function()
            local questID = GetQuestID()
            if questID and (not LSU.IsQuestIgnored(questID) and not C_QuestLog.IsRepeatableQuest(questID) and not QuestIsWeekly()) then
                AcceptQuest()
            end
        end)
    end
    if event == "QUEST_GREETING" then
        if not LSUDB.Settings["AcceptQuests.Enabled"] then return end
        C_Timer.After(0.15, function()
            LSU.ProcessQuestsAndGossipsSequentially(LSU.QuestGreetingAPI())
        end)
    end
end)