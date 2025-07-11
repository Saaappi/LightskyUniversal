local addonName, addonTable = ...

addonTable.CreateFrame = function(frameType, frameData)
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