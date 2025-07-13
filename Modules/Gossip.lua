local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")
local formatters = {
    [3] = function(info) return string.format("[|cffBA45A0%s|r] %s", info.gossipOptionID, info.name) end,
    [4] = function(info) return string.format("[|cffBA45A0%s|r] %s", info.questID, info.title) end,
}
local gossipRawNames = {}

eventFrame:RegisterEvent("GOSSIP_CONFIRM")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "GOSSIP_CONFIRM" then
        C_Timer.After(0.1, function() StaticPopup1Button1:Click() end)
    end
end)

-- This is how the gossip entry IDs are placed in the gossip buttons
-- within Blizzard's GossipFrame.
hooksecurefunc(GossipFrame, "Update", function(self)
    if not LSUDB.Settings["Gossip.Enabled"] then return end

    -- Add the ID number to the frame's title container.
    local guid = UnitGUID("npc")
    if guid then
        local id = guid and addonTable.Split(guid, "-", 6)
        if tonumber(id) then
            local text = self:GetTitleText():GetText()
            if text then
                -- Always strip any existing [id] prefix from the title text first
                text = text:gsub("^%[|cffFFFFFF%d+|r%]%s*", "")
                local idPrefix = string.format("[|cffFFFFFF%d|r] ", id)
                text = idPrefix .. text
                self:SetGossipTitle(text)
            end
        end
    end

    -- Prefix each gossip button with its ID number, only if not already present.
    local dataProvider = self.GreetingPanel.ScrollBox:GetDataProvider()
    if dataProvider and next(dataProvider.collection) then
        local originalData = {}
        for i, v in ipairs(dataProvider.collection) do
            originalData[i] = v
        end

        dataProvider:Flush()

        local modifiedData = {}
        for k, v in ipairs(originalData) do
            local entry = v
            if entry and entry.info then
                local newEntry = {}
                for i, j in pairs(entry) do newEntry[i] = j end

                local gossipOptionID = entry.info.gossipOptionID
                if gossipOptionID then
                    -- If this is the first time we've seen this option, cache the original name (stripped of any [id])
                    if not gossipRawNames[gossipOptionID] then
                        local n = entry.info.name or ""
                        n = n:gsub("^%[|cffFFFFFF%d+|r%]%s*", "")
                        gossipRawNames[gossipOptionID] = n
                    end
                end

                local formatter = formatters[entry.buttonType]
                if formatter then
                    -- Always use the cached raw name (never a previously formatted one)
                    local rawName = gossipOptionID and gossipRawNames[gossipOptionID] or entry.info.name or ""
                    local newEntryInfo = {}
                    for kk, vv in pairs(entry.info) do newEntryInfo[kk] = vv end
                    newEntryInfo.name = rawName

                    local newName = formatter(newEntryInfo)
                    newEntry.info.name = newName
                end
                table.insert(modifiedData, newEntry)
            else
                table.insert(modifiedData, entry)
            end
        end
        dataProvider:InsertTable(modifiedData)
    end

    -- Select gossips, if appropriate.
    addonTable.ProcessQuestsAndGossipsSequentially(addonTable.QuestGossipShowAPI())
end)