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
local formatters = {
    [3] = function(info) return string.format("[|cffBA45A0%s|r] %s", info.gossipOptionID, info.name) end,
    [4] = function(info) return string.format("[|cffBA45A0%s|r] %s", info.questID, info.title) end,
}

local function SetTextAndResize(frame, text)
    frame:SetText(text)
    frame:Resize()
end

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

    local options = C_GossipInfo.GetOptions()
    if options and #options > 0 then
        for _, frame in self.GreetingPanel.ScrollBox:EnumerateFrames() do
            local frameData = frame:GetData()
            if frameData and frameData.info then
                local formatter = formatters[frameData.buttonType]
                if formatter then
                    SetTextAndResize(frame, formatter(frameData.info))
                end
            end
        end
        self.GreetingPanel.ScrollBox:FullUpdateInternal() -- this is necessary to inform the view that the data provider has been updated and it should be resized
    end
end)