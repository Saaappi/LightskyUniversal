local addonName, LSU = ...
local L = LSU.L

LSU.CreateFrame = function(frameType, frameData)
    assert(type(frameData) == "table", "frameData must be a table!")
    assert(frameType == "Portrait" or frameType == "EditBox", "Only 'Portrait' and 'EditBox' frames are supported.")

    -- Set some default values for safety
    local name = frameData.name or ("LSUFrameAnon" .. math.random(100000))
    local parent = frameData.parent or UIParent
    local width = frameData.width or parent:GetWidth()
    local height = frameData.height or 0

    local frame
    if frameType == "Portrait" then
        frame = CreateFrame("Frame", name, parent, "PortraitFrameTemplate")
        frame:SetSize(width, height)
        frame:SetClampedToScreen(true)
        frame:Hide() -- Hide until explicitly shown

        -- Allow the frame to be closed with the escape key
        table.insert(UISpecialFrames, frame:GetName())

        -- Give the frame sound when being opened and closed
        frame:SetScript("OnShow", function()
            PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master")
        end)
        frame:SetScript("OnHide", function()
            PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE, "Master")
        end)

        if frameData.movable then
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", function(self)
            self:StartMoving()
        end)
        frame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
        end)
    end
    elseif frameType == "EditBox" then
        local autoFocus = frameData.autoFocus or false
        local isMultiLine = frameData.isMultiLine or false
        local font = frameData.font or "ChatFontNormal"
        local maxLetters = frameData.maxLetters or 2^25
        local template = frameData.template or "InputBoxTemplate"

        frame = CreateFrame("EditBox", name, parent, template) -- not every edit box needs the InputBoxTemplate
        frame:SetSize(width, height)
        frame:SetAutoFocus(autoFocus)
        frame:SetFontObject(font)
        frame:SetMultiLine(isMultiLine)
        frame:EnableMouse(true)
        frame:SetMaxLetters(maxLetters)
        frame:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        if frameData.tooltipText then
            frame:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(frameData.tooltipHeader or C_AddOns.GetAddOnMetadata(addonName, "Title"), nil, nil, nil, 1, true)
                GameTooltip:AddLine(frameData.tooltipText, 1, 1, 1, true)
                GameTooltip:Show()
            end)
            frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
        end
    end
    return frame
end

function LSU.GetCheckbox(parent, num, label, tooltipText, savedVarKey)
    local checkbox = CreateFrame("CheckButton", "LSUCheckButton"..num, parent, "SettingsCheckboxTemplate")
    checkbox:SetText(label)
    checkbox:SetNormalFontObject(GameFontHighlight)
    checkbox:GetFontString():SetPoint("LEFT", checkbox, "RIGHT", 5, 0)

    checkbox:SetChecked(LSUDB.Settings[savedVarKey] and true or false)

    checkbox:SetScript("OnClick", function(self)
        LSUDB.Settings[savedVarKey] = self:GetChecked() and true or false
    end)

    if tooltipText then
        checkbox:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(L.TITLE_ADDON)
            GameTooltip:AddLine(tooltipText, 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        checkbox:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    return checkbox
end

function LSU.CreateDivider(parent, width, thickness, xOffset, yOffset, anchor)
    width = width or 200
    thickness = thickness or 3
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    anchor = anchor or "TOPLEFT"

    local divider = parent:CreateTexture(nil, "ARTWORK")
    divider:SetColorTexture(1, 1, 1, 1)
    divider:SetSize(width, thickness)
    divider:SetPoint(anchor, xOffset, yOffset)

    return divider
end

function LSU.CreateDropdown2()
    
end

function LSU.CreateDropdown(parent, args)
    local width = args.width or 200

    local dropdown = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
    dropdown:SetWidth(width)
    dropdown:SetPoint("CENTER", parent, "CENTER")

    dropdown.label = dropdown:CreateFontString()
    dropdown.label:SetFontObject(GameFontHighlight)
    dropdown.label:SetText(L.LABEL_SETTINGS_CHROMIE_TIME)
    dropdown.label:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 0, 3)

    dropdown.options = args.options
    dropdown.selectedIndex = 1

    local function GeneratorFunc(_, rootDescription)
        for i, label in ipairs(dropdown.options) do
            rootDescription:CreateRadio(
                label,
                function() return dropdown.selectedIndex == i end,
                function()
                    dropdown.selectedIndex = i
                    dropdown:SetDefaultText(label)
                    print("Selected radio index: ", i)
                end,
                i
            )
        end
    end

    dropdown:SetupMenu(GeneratorFunc)
    dropdown:SetDefaultText(dropdown.options[dropdown.selectedIndex])

    dropdown:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L.TITLE_ADDON)
        GameTooltip:AddLine(args.tooltipText, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)

    dropdown:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end