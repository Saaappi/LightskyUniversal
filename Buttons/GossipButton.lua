local addonTable = select(2, ...)
local openGossipFrameButton
local button = {
    type        = "ActionButton",
    name        = "LSUGetGossipInfoButton",
    parent      = UIParent,
    scale       = 1.05,
    texture     = 2056011,
    tooltipText = addonTable.Locales.GOSSIP_BUTTON_TOOLTIP
}
local formatters = {
    [3] = function(info) return string.format("[|cffBA45A0%s|r] %s", info.gossipOptionID, info.name) end,
    [4] = function(info) return string.format("[|cffBA45A0%s|r] %s", info.questID, info.title) end,
}

GossipFrame:HookScript("OnShow", function()
    if not LSUDB.Settings["Gossip.Enabled"] then return end
    if not openGossipFrameButton then
        openGossipFrameButton = addonTable.CreateButton(button)
    end

    openGossipFrameButton:ClearAllPoints()
    openGossipFrameButton:SetPoint("TOPLEFT", GossipFrame, "TOPRIGHT", 5, 0)
    openGossipFrameButton:SetScript("OnClick", addonTable.OpenGossipFrame)

    openGossipFrameButton:Show()
end)

GossipFrame:HookScript("OnHide", function()
    if not LSUDB.Settings["Gossip.Enabled"] then return end
    openGossipFrameButton:Hide()
end)