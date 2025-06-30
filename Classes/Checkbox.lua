local LSU = select(2, ...)
local L = LSU.L

function LSU.NewCheckbox(data)
    local checkbox = CreateFrame("CheckButton", "LSUCheckButton"..data.id, data.parent, "SettingsCheckboxTemplate")
    checkbox:SetText(data.label)

    local label = checkbox:GetFontString()
    label:SetWidth(100)
    label:SetWordWrap(true)
    label:SetJustifyH("LEFT")
    label:SetJustifyV("MIDDLE")
    label:SetPoint("LEFT", checkbox, "RIGHT", 3, 0)
    checkbox:SetNormalFontObject(GameFontHighlight)

    checkbox:SetChecked(LSUDB.Settings[data.savedVarKey] and true or false)

    checkbox:SetScript("OnClick", function(self)
        LSUDB.Settings[data.savedVarKey] = self:GetChecked() and true or false
    end)

    if data.tooltipText then
        checkbox:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(LSU.Locales.ADDON_TITLE)
            GameTooltip:AddLine(data.tooltipText, 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        checkbox:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    return checkbox
end