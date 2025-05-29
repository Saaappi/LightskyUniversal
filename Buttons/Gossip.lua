local LSU = select(2, ...)
local L = LSU.L
local getGossipInfoButton
local button = {
    type        = "ActionButton",
    name        = "LSUGetGossipInfoButton",
    parent      = UIParent,
    scale       = 1.05,
    texture     = 4549145,
    tooltipText = L.GOSSIP_INFO_BUTTON_TOOLTIP
}

GossipFrame:HookScript("OnShow", function()
    if not getGossipInfoButton then
        getGossipInfoButton = LSU.CreateButton(button)
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

    getGossipInfoButton:Show()
end)

GossipFrame:HookScript("OnHide", function()
    getGossipInfoButton:Hide()
end)