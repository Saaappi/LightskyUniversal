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

-- This is how the gossip entry IDs are placed in the gossip buttons
-- within Blizzard's GossipFrame.
hooksecurefunc(GossipFrame, "Update", function(self)
    if not LSUDB.Settings["Gossip.Enabled"] then return end
    local guid = UnitGUID("npc")
    if guid then
        local id = addonTable.Split(guid, "-", 6)
        local text = self.TitleContainer.TitleText:GetText()
        if text and tonumber(id) then
            text = string.format("[|cffFFFFFF%d|r] ", id) .. text
            self:SetGossipTitle(text)
        end
    end

    local dataProvider = self.GreetingPanel.ScrollBox:GetDataProvider()
    if dataProvider and next(dataProvider.collection) then
        local modifiedData = {}
        for k, v in ipairs(dataProvider.collection) do
            local entry = v
            if entry then
                if entry.info then
                    local newEntry = {}
                    for i, j in pairs(entry) do newEntry[i] = j end

                    local formatter = formatters[entry.buttonType]
                    if formatter then
                        newEntry.info.name = formatter(entry.info)
                    end
                    table.insert(modifiedData, newEntry)
                else
                    table.insert(modifiedData, entry) -- preserves the entries like the gossip text at the top of the frame
                end
            end
        end
        dataProvider:Flush()
        dataProvider:InsertTable(modifiedData)
    end
end)