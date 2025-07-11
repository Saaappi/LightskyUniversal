local addonName, addonTable = ...

local function ValidateButtonConfig(button, required)
    for _, key in ipairs(required) do
        if button[key] == nil then
            addonTable.PrintError("Missing required button attribute: " .. key)
            return false
        end
    end
    return true
end

local function SetTooltipScripts(frame, tooltipText)
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(C_AddOns.GetAddOnMetadata(addonName, "Title"), nil, nil, nil, 1, true)
        if tooltipText then
            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function SetButtonTexture(frame, texture)
    if not frame.icon then
        frame.icon = frame:CreateTexture(frame:GetName().."Icon", "OVERLAY")
    end
    if type(texture) == "string" then
        frame.icon:SetAtlas(texture)
        frame:SetNormalTexture(frame.icon)
        frame:SetHighlightAtlas(texture, "ADD")
        frame:SetPushedAtlas(texture)
    elseif type(texture) == "number" then
        frame.icon:SetTexture(texture)
    else
        addonTable.PrintError("The texture should be a string or number.")
        return false
    end
    return true
end

--[[
    Creates a button frame and returns it to the calling module.

    @param button table: The attributes for the table.
]]
addonTable.CreateButton = function(button)
    if not button or type(button) ~= "table" then
        addonTable.PrintError("Button config is missing or not a table.")
        return nil
    end

    local newButton
    if button.type == "BasicButton" then
        if not ValidateButtonConfig(button, {"name", "parent", "width", "height", "text"}) then return nil end
        newButton = CreateFrame("Button", button.name, button.parent, "UIPanelButtonTemplate")
        newButton:SetSize(button.width, button.height)
        newButton:RegisterForClicks("LeftButtonUp")
        newButton:SetText(button.text)
        SetTooltipScripts(newButton, button.tooltipText)
    elseif button.type == "ActionButton" or button.type == "InsecureItemActionButton" then
        local template = button.type == "ActionButton" and "ActionButtonTemplate" or "InsecureActionButtonTemplate"
        if not ValidateButtonConfig(button, {"name", "parent", "texture", "scale"}) then return nil end
        local frameType = button.type == "InsecureItemActionButton" and "ItemButton" or "Button"
        newButton = CreateFrame(frameType, button.name, button.parent, template)
        newButton:SetScale(button.scale)
        if button.type == "InsecureItemActionButton" then
            newButton:RegisterForClicks("AnyUp", "AnyDown")
        end
        if not SetButtonTexture(newButton, button.texture) then return nil end
        SetTooltipScripts(newButton, button.tooltipText)
    else
        addonTable.PrintError("Unknown button type: " .. tostring(button.type))
        return nil
    end
    return newButton or nil
end