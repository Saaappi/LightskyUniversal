local LSU = select(2, ...)
local getGossipInfoButton
local button = {
    type        = "ActionButton",
    name        = "LSUGetGossipInfoButton",
    parent      = UIParent,
    scale       = 1.05,
    texture     = 4549145,
    tooltipText = LSU.Locale.BUTTON_DESCRIPTION_GOSSIPINFO
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
                    print("  " .. "|cffBA45A0" .. option.gossipOptionID .. "|r")
                    print("    " .. option.name)
                end
            else
                LSU.PrintWarning("Could not retrieve NPC information.")
            end
        else
            LSU.PrintWarning("No gossip options available.")
        end
    end)

    getGossipInfoButton:Show()
end)

GossipFrame:HookScript("OnHide", function()
    getGossipInfoButton:Hide()
end)