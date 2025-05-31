local LSU = select(2, ...)
local L = LSU.L
local openGossipFrameButton
local getGossipInfoButton
local button = {
    type        = "ActionButton",
    name        = "LSUGetGossipInfoButton",
    parent      = UIParent,
    scale       = 1.05,
    texture     = 4549145,
    tooltipText = L.GOSSIP_INFO_BUTTON_TOOLTIP
}
local openGossipFrameButtonData = {
    type = "BasicButton",
    name = "LSUOpenGossipFrameButton",
    width = 170,
    height = 25,
    text = L.LABEL_OPEN_GOSSIPS_BUTTON,
    point = "CENTER",
    parent = UIParent
}

GossipFrame:HookScript("OnShow", function()
    if not getGossipInfoButton then
        getGossipInfoButton = LSU.CreateButton(button)
    end

    if not openGossipFrameButton then
        openGossipFrameButton = LSU.CreateButton(openGossipFrameButtonData)
    end

    getGossipInfoButton:ClearAllPoints()
    getGossipInfoButton:SetPoint("TOPLEFT", GossipFrame, "TOPRIGHT", 5, 0)
    getGossipInfoButton:SetScript("OnClick", function()
        local options = C_GossipInfo.GetOptions()
        if options and #options > 0 then
            for _, option in ipairs(options) do
                print(string.format("|cffBA45A0%s|r - %s", option.gossipOptionID, option.name))
            end
        else
            LSU.PrintWarning(L.TEXT_NO_GOSSIP_OPTIONS_AVAILABLE)
        end
    end)

    openGossipFrameButton:ClearAllPoints()
    openGossipFrameButton:SetPoint("BOTTOM", GossipFrame, "TOP", 0, 5)
    openGossipFrameButton:SetScript("OnClick", LSU.OpenGossipFrame)

    getGossipInfoButton:Show()
    openGossipFrameButton:Show()
end)

GossipFrame:HookScript("OnHide", function()
    getGossipInfoButton:Hide()
    openGossipFrameButton:Hide()
end)

hooksecurefunc(GossipFrame, "Update", function(self)
    local guid = UnitGUID("npc")
    if guid then
        local id = LSU.Split(guid, "-", 6)
        local text = self.TitleContainer.TitleText:GetText()
        if text and tonumber(id) then
            text = string.format("[|cffFFFFFF%d|r] ", id) .. text
            self:SetGossipTitle(text)
        end
    end
    --[[local name
    for i, option in ipairs(self.gossipOptions) do
        name = option.name .. ","
        self.gossipOptions[i].name:SetText(name)
    end]]
end)