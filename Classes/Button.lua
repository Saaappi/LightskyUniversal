local addonTable = select(2, ...)

local function SetTooltipScripts(button, tooltipText)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(addonTable.Locales.ADDON_TITLE, nil, nil, nil, 1, true)
        if tooltipText then
            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

function addonTable.NewBasicButton(data)
    local button = CreateFrame("Button", data.name, data.parent, "UIPanelButtonTemplate")
    button:SetSize(data.width, data.height)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetText(data.label)
    if data.tooltipText then
        SetTooltipScripts(button, data.tooltipText)
    end
    return button
end

function addonTable.NewInsecureBasicButton(data)
    local button = CreateFrame("Button", data.name, data.parent, "UIPanelButtonTemplate, InsecureActionButtonTemplate")
    button:SetSize(data.width, data.height)
    button:RegisterForClicks("AnyUp")
    button:SetAttribute("type", data.attributeType)
    button:SetAttribute(data.attributeType, data.attributeValue)
    button:SetText(data.label)
    if data.tooltipText then
        SetTooltipScripts(button, data.tooltipText)
    end
    return button
end