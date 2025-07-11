local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("GOSSIP_CONFIRM")
eventFrame:RegisterEvent("GOSSIP_SHOW")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "GOSSIP_CONFIRM" then
        C_Timer.After(0.1, function() StaticPopup1Button1:Click() end)
    elseif event == "GOSSIP_SHOW" then
        C_Timer.After(0.1, function()
            addonTable.ProcessQuestsAndGossipsSequentially(addonTable.QuestGossipShowAPI())
        end)
    end
end)