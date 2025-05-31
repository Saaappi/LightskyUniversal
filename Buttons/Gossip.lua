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
            local guid = UnitGUID("npc")
            local name = UnitName("npc")
            if guid and name then
                local id = LSU.Split(guid, "-", 6)
                print(id .. " - |cff45BA5F" .. name .. "|r")
                for _, option in ipairs(options) do
                    print(string.format("|cffBA45A0%s|r - %s", option.gossipOptionID, option.name))
                end
            else
                LSU.PrintWarning(L.TEXT_COULD_NOT_RETRIEVE_NPC_INFO)
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