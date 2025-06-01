local LSU = select(2, ...)
local L = LSU.L
local openGossipFrameButton
local button = {
    type        = "ActionButton",
    name        = "LSUGetGossipInfoButton",
    parent      = UIParent,
    scale       = 1.05,
    texture     = 2056011,
    tooltipText = L.TOOLTIP_GOSSIPS_OPEN_BUTTON
}

GossipFrame:HookScript("OnShow", function()
    if not openGossipFrameButton then
        openGossipFrameButton = LSU.CreateButton(button)
    end

    openGossipFrameButton:ClearAllPoints()
    openGossipFrameButton:SetPoint("TOPLEFT", GossipFrame, "TOPRIGHT", 5, 0)
    openGossipFrameButton:SetScript("OnClick", LSU.OpenGossipFrame)

    openGossipFrameButton:Show()
end)

GossipFrame:HookScript("OnHide", function()
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

    local options = C_GossipInfo.GetOptions()
    if options and #options > 0 then
        local newName
        for _, frame in self.GreetingPanel.ScrollBox:EnumerateFrames() do
            local frameData = frame:GetData()
            if frameData and frameData.info then
                newName = string.format("[|cffBA45A0%s|r] %s", frameData.info.gossipOptionID, frameData.info.name)
            end
            if frame.SetTextAndResize then
                frame:SetTextAndResize(newName)
            end
        end
        self.GreetingPanel.ScrollBox:FullUpdateInternal() -- this is necessary because the scrollbox doesn't automatically update when the children are resized
    end
end)