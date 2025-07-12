local addonTable = select(2, ...)

function addonTable.NewCheckboxDropdown(dropdownData)
    local dropdown = CreateFrame("DropdownButton", nil, dropdownData.parent or UIParent, "WowStyle1DropdownTemplate")
    dropdown:SetWidth(180)
    dropdown:SetDefaultText(DISABLE)

    dropdown.label = dropdown:CreateFontString()
    dropdown.label:SetFontObject(GameFontHighlight)
    dropdown.label:SetText(dropdownData.label)
    dropdown.label:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 0, 3)

    dropdown:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(addonTable.Locales.ADDON_TITLE)
        GameTooltip:AddLine(dropdownData.tooltipText, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)

    dropdown:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    local function IsSelected(value)
        return LSUDB[dropdownData.savedVarTable][value[1]][value[2]] ~= false
    end
    local function SetSelected(value)
        LSUDB[dropdownData.savedVarTable][value[1]][value[2]] = not LSUDB[dropdownData.savedVarTable][value[1]][value[2]]
    end

    MenuUtil.CreateCheckboxMenu(dropdown, IsSelected, dropdownData.setSelectedFunc or SetSelected, unpack(dropdownData.options))

    return dropdown
end

function addonTable.NewRadioDropdown(dropdownData)
    local dropdown = CreateFrame("DropdownButton", nil, dropdownData.parent or UIParent, "WowStyle1DropdownTemplate")
    dropdown:SetWidth(180)
    dropdown:SetDefaultText(DISABLE)

    dropdown.label = dropdown:CreateFontString()
    dropdown.label:SetFontObject(GameFontHighlight)
    dropdown.label:SetText(dropdownData.label)
    dropdown.label:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 0, 3)

    dropdown:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(addonTable.Locales.ADDON_TITLE)
        GameTooltip:AddLine(dropdownData.tooltipText, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)

    dropdown:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    local function IsSelected(value)
        return value == LSUDB.Settings[dropdownData.savedVarKey]
    end
    local function SetSelected(value)
        LSUDB.Settings[dropdownData.savedVarKey] = value
        dropdown:SetText(value)
    end

    MenuUtil.CreateRadioMenu(dropdown, IsSelected, dropdownData.setSelectedFunc or SetSelected, unpack(dropdownData.options))

    return dropdown
end