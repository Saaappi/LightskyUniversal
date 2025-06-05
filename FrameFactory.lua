local addonName, LSU = ...

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

LSU.CreateCheckbox = function(parent, label, spacing, callback, tooltip)
    spacing = spacing or 0
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetHeight(40)
    holder:SetPoint("LEFT", parent, "LEFT", 30, 0)
    holder:SetPoint("RIGHT", parent, "RIGHT", -15, 0)
    local checkBox = CreateFrame("CheckButton", nil, holder, "SettingsCheckboxTemplate")

    checkBox:SetPoint("LEFT", holder, "CENTER", -15 - spacing, 0)
    checkBox:SetText(label)
    checkBox:SetNormalFontObject(GameFontHighlight)
    checkBox:GetFontString():SetPoint("RIGHT", holder, "CENTER", -30 - spacing, 0)

    function holder:SetValue(value)
        checkBox:SetChecked(value)
    end

    holder:SetScript("OnEnter", function(self)
        if tooltip then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(tooltip, 1, 1, 1, true)
            GameTooltip:Show()
        end
        checkBox:OnEnter()
    end)

    holder:SetScript("OnLeave", function()
        if tooltip then
            GameTooltip:Hide()
        end
        checkBox:OnLeave()
    end)

    holder:SetScript("OnMouseUp", function()
        checkBox:Click()
    end)

    checkBox:SetScript("OnClick", function()
        callback(checkBox:GetChecked())
    end)

    return holder
end

LSU.CreateDropdown = function(parent, labelText, isSelectedCallback, onSelectionCallback)
    local frame = CreateFrame("Frame", nil, parent)
    local dropdown = CreateFrame("DropdownButton", nil, frame, "WowStyle1DropdownTemplate")
    dropdown:SetWidth(250)
    dropdown:SetPoint("LEFT", frame, "CENTER", -32, 0)
    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("LEFT", 20, 0)
    label:SetPoint("RIGHT", frame, "CENTER", -50, 0)
    label:SetJustifyH("RIGHT")
    label:SetText(labelText)
    frame:SetPoint("LEFT", 30, 0)
    frame:SetPoint("RIGHT", -30, 0)
    frame.Init = function(_, entryLabels, values)
    local entries = {}
    for index = 1, #entryLabels do
        table.insert(entries, {entryLabels[index], values[index]})
    end
    MenuUtil.CreateRadioMenu(dropdown, isSelectedCallback, onSelectionCallback, unpack(entries))
    end
    frame.SetValue = function(_, _)
    dropdown:GenerateMenu()
    end
    frame.Label = label
    frame.DropDown = dropdown
    frame:SetHeight(40)

    return frame
end