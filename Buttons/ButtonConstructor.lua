local addonName, LSU = ...

--[[
    Creates a button frame and returns it to the calling module.

    @param button table: The attributes for the table.
]]
LSU.CreateButton = function(button)
    local newButton
    if button.type == "BasicButton" then
        newButton = CreateFrame("Button", button.name, button.parent, "UIPanelButtonTemplate")
        newButton:SetSize(button.width, button.height)
        newButton:RegisterForClicks("LeftButtonUp")
        newButton:SetText(button.text)
        newButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(C_AddOns.GetAddOnMetadata(addonName, "Title"), nil, nil, nil, 1, true)
            GameTooltip:AddLine(button.tooltipText, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        newButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    elseif button.type == "ActionButton" then
        newButton = CreateFrame("Button", button.name, button.parent, "ActionButtonTemplate")
        newButton:SetScale(button.scale)

        if type(button.texture) == "string" then
            newButton.icon = newButton:CreateTexture(string.format("%sIcon", newButton:GetName()), "OVERLAY")
            newButton.icon:SetAtlas(button.texture)
            newButton:SetNormalTexture(newButton.icon)
            newButton:SetHighlightAtlas(button.texture, "ADD")
            newButton:SetPushedAtlas(button.texture)
        elseif type(button.texture) == "number" then
            newButton.icon:SetTexture(button.texture)
        else
            LSU.PrintWarning("The texture should be a string or number.")
            return nil
        end

        newButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(C_AddOns.GetAddOnMetadata(addonName, "Title"), nil, nil, nil, 1, true)
            GameTooltip:AddLine(button.tooltipText, 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        newButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    elseif button.type == "InsecureItemActionButton" then
        newButton = CreateFrame("ItemButton", button.name, button.parent, "InsecureActionButtonTemplate")
        newButton:SetScale(button.scale)
        newButton:RegisterForClicks("AnyUp", "AnyDown")

        if type(button.texture) == "string" then
            newButton.icon = newButton:CreateTexture(string.format("%sIcon", newButton:GetName()), "OVERLAY")
            newButton.icon:SetAtlas(button.texture)
            newButton:SetNormalTexture(newButton.icon)
            newButton:SetHighlightAtlas(button.texture, "ADD")
            newButton:SetPushedAtlas(button.texture)
        elseif type(button.texture) == "number" then
            newButton.icon:SetTexture(button.texture)
        else
            LSU.PrintWarning("The texture should be a string or number.")
            return nil
        end

        newButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(C_AddOns.GetAddOnMetadata(addonName, "Title"), nil, nil, nil, 1, true)
            GameTooltip:AddLine(button.tooltipText, 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        newButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end
    return newButton or nil
end