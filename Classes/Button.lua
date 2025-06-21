local LSU = select(2, ...)
local L = LSU.L

local function SetTooltipScripts(button, tooltipText)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L.TITLE_ADDON, nil, nil, nil, 1, true)
        if tooltipText then
            GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

function LSU.NewBasicButton(data)
    local button = CreateFrame("Button", data.name, data.parent, "UIPanelButtonTemplate")
    button:SetSize(data.width, data.height)
    button:RegisterForClicks("LeftButtonUp")
    button:SetText(data.label)
    if data.tooltipText then
        SetTooltipScripts(button, data.tooltipText)
    end
    return button
end

function LSU.NewInsecureBasicButton(data)
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