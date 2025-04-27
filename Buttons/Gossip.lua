local addonName, LSU = ...
local getGossipInfoButton = CreateFrame("Button", "LSUGetGossipInfoButton", GossipFrame, "ActionButtonTemplate")
getGossipInfoButton:SetScale(1.05)

getGossipInfoButton:ClearAllPoints()
getGossipInfoButton:SetPoint("TOPLEFT", GossipFrame, "TOPRIGHT", 5, 0)
getGossipInfoButton.icon:SetTexture(136243)

getGossipInfoButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(LSU.Locale.BUTTON_DESCRIPTION_GOSSIPINFO, 1, 1, 1, 1, true)
end)
getGossipInfoButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
getGossipInfoButton:SetScript("OnClick", function()
    local options = C_GossipInfo.GetOptions()
    if options and options ~= {} then
        local guid = UnitGUID("npc")
        local name = UnitName("npc")
        if guid and name then
            local id = LSU.Split(guid, "-", 6)
            print(id .. " - |cff45BA5F" .. name .. "|r")
            for _, option in ipairs(options) do
                print("  " .. "|cffBA45A0" .. option.gossipOptionID .. "|r")
                print("    " .. option.name)
            end
        end
    end
end)

GossipFrame:HookScript("OnShow", function()
    getGossipInfoButton:Show()
end)

GossipFrame:HookScript("OnHide", function()
    getGossipInfoButton:Hide()
end)