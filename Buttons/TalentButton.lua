local addonName, LSU = ...
local applyTalentsButton

EventRegistry:RegisterCallback("PlayerSpellsFrame.TalentTab.Show", function()
    if not applyTalentsButton then
        local button = {
            type = "BasicButton",
            name = "LSUApplyTalentsButton",
            width = 120,
            height = 25,
            text = "Apply Talents",
            point = "LEFT",
            parent = PlayerSpellsFrame.TalentsFrame.SearchBox
        }
        applyTalentsButton = LSU.CreateButton(button)
    end
    applyTalentsButton:ClearAllPoints()
    applyTalentsButton:SetPoint("LEFT", applyTalentsButton:GetParent(), "RIGHT", 2.5, 0)
    applyTalentsButton:Show()

    applyTalentsButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(LSU.Locale.BUTTON_DESCRIPTION_APPLYTALENTS, 1, 1, 1, 1, true)
    end)
    applyTalentsButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
end)

EventRegistry:RegisterCallback("PlayerSpellsFrame.TalentTab.Hide", function()
    applyTalentsButton:Hide()
end)

--[[getGossipInfoButton:ClearAllPoints()
getGossipInfoButton:SetPoint("TOPLEFT", GossipFrame, "TOPRIGHT", 5, 0)
getGossipInfoButton.icon:SetTexture(136243)]]


--[[getGossipInfoButton:SetScript("OnClick", function()
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
end)]]