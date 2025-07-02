local LSU = select(2, ...)
local openGossipFrameButton
local button = {
    type        = "ActionButton",
    name        = "LSUGetGossipInfoButton",
    parent      = UIParent,
    scale       = 1.05,
    texture     = 2056011,
    tooltipText = LSU.Locales.GOSSIP_BUTTON_TOOLTIP
}
local formatters = {
    [3] = function(info) return string.format("[|cffBA45A0%s|r] %s", info.gossipOptionID, info.name) end,
    [4] = function(info) return string.format("[|cffBA45A0%s|r] %s", info.questID, info.title) end,
}

GossipFrame:HookScript("OnShow", function()
    if not LSUDB.Settings["Gossip.Enabled"] then return end
    if not openGossipFrameButton then
        openGossipFrameButton = LSU.CreateButton(button)
    end

    openGossipFrameButton:ClearAllPoints()
    openGossipFrameButton:SetPoint("TOPLEFT", GossipFrame, "TOPRIGHT", 5, 0)
    openGossipFrameButton:SetScript("OnClick", LSU.OpenGossipFrame)

    openGossipFrameButton:Show()
end)

GossipFrame:HookScript("OnHide", function()
    if not LSUDB.Settings["Gossip.Enabled"] then return end
    openGossipFrameButton:Hide()
end)

hooksecurefunc(GossipFrame, "Update", function(self)
    if not LSUDB.Settings["Gossip.Enabled"] then return end
    local guid = UnitGUID("npc")
    if guid then
        local id = LSU.Split(guid, "-", 6)
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