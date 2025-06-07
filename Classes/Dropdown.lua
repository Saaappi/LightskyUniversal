local LSU = select(2, ...)
local L = LSU.L

function LSU.NewRadioDropdown(dropdownData)
    local dropdown = CreateFrame("DropdownButton", nil, dropdownData.parent or UIParent, "WowStyle1DropdownTemplate")

    dropdown.label = dropdown:CreateFontString()
    dropdown.label:SetFontObject(GameFontHighlight)
    dropdown.label:SetText(L.LABEL_SETTINGS_CHROMIE_TIME)
    dropdown.label:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 0, 3)

    dropdown:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L.TITLE_ADDON)
        GameTooltip:AddLine(L.TOOLTIP_SETTINGS_CHROMIE_TIME, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)

    dropdown:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    local selectedValue = LSUDB.Settings[dropdownData.savedVarKey]
    local function IsSelected(value)
        return value == selectedValue
    end
    local function SetSelected(value)
        selectedValue = value
        LSUDB.Settings[dropdownData.savedVarKey] = value
        dropdown:SetText(value)
    end

    MenuUtil.CreateRadioMenu(dropdown, IsSelected, SetSelected, unpack(dropdownData.options))

    return dropdown
end