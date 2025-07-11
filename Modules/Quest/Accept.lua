local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("GROUP_JOINED")
eventFrame:RegisterEvent("QUEST_ACCEPTED")
eventFrame:RegisterEvent("QUEST_DETAIL")
eventFrame:RegisterEvent("QUEST_GREETING")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "GROUP_JOINED" then
        if not LSUDB.Settings["AutoShareQuests.Enabled"] then return end

        local joinedGroupDialog = "LSU_JoinedGroup"
        addonTable.NewStaticPopup(
            joinedGroupDialog,
            addonTable.Locales.JOINED_GROUP,
            {
                button2Text = NO,
                onAccept = function()
                    LSUDB.Settings["AutoShareQuests.Enabled"] = false
                end,
            }
        )
        StaticPopup_Show(joinedGroupDialog)
    end
    if event == "QUEST_ACCEPTED" then
        if not LSUDB.Settings["AutoShareQuests.Enabled"] then return end
        local questID = ...
        if questID then
            if UnitInParty("player") then
                if C_QuestLog.IsPushableQuest(questID) then
                    C_Timer.After(0.15, function()
                        C_QuestLog.SetSelectedQuest(questID)
                        QuestLogPushQuest()
                    end)
                end
            end
        end
    end
    if event == "QUEST_DETAIL" then
        if not LSUDB.Settings["AcceptQuests.Enabled"] then return end
        C_Timer.After(0.1, function()
            local questID = GetQuestID()
            if questID and (not addonTable.IsQuestIgnored(questID) and not C_QuestLog.IsRepeatableQuest(questID) and not QuestIsWeekly()) then
                AcceptQuest()
            end
        end)
    end
    if event == "QUEST_GREETING" then
        if not LSUDB.Settings["AcceptQuests.Enabled"] then return end
        C_Timer.After(0.1, function()
            addonTable.ProcessQuestsAndGossipsSequentially(addonTable.QuestGreetingAPI())
        end)
    end
end)