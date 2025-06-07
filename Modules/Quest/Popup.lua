local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "QUEST_LOG_UPDATE" then
        if not LSUDB.Settings["AcceptQuests.Enabled"] and not LSUDB.Settings["CompleteQuests.Enabled"] then return end
        C_Timer.After(0.2, function()
            if GetNumAutoQuestPopUps() > 0 then
                if not UnitIsDeadOrGhost("player") then
                    local questID, popupType = GetAutoQuestPopUp(1)
                    if questID and popupType == "OFFER" then
                        ShowQuestOffer(questID)
                    elseif questID and popupType == "COMPLETE" then
                        ShowQuestComplete(questID)
                    end
                    RemoveAutoQuestPopUp(questID)
                end
            end
        end)
    end
end)