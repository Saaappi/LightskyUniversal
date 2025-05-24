local LSU = select(2, ...)
local getGossipInfoButton = CreateFrame("Button", "LSUGetGossipInfoButton", GossipFrame, "ActionButtonTemplate")
getGossipInfoButton:SetScale(1.05)

getGossipInfoButton:ClearAllPoints()
getGossipInfoButton:SetPoint("TOPLEFT", GossipFrame, "TOPRIGHT", 5, 0)
getGossipInfoButton.icon:SetTexture(4549145)
getGossipInfoButton:Hide()

getGossipInfoButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(LSU.Locale.BUTTON_DESCRIPTION_GOSSIPINFO, 1, 1, 1, 1, true)
end)
getGossipInfoButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
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

GossipFrame:HookScript("OnShow", function()
    getGossipInfoButton:Show()
end)

GossipFrame:HookScript("OnHide", function()
    getGossipInfoButton:Hide()
end)