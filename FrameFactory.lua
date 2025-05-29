local LSU = select(2, ...)

LSU.CreateFrame = function(frameType, frameData)
    assert(type(frameData) == "table", "frameData must be a table!")
    assert(frameType == "Portrait", "Currently only 'Portrait' frames are supported.")

    -- Set some default values for safety
    local name = frameData.name or ("LSUFrameAnon" .. math.random(100000))
    local parent = frameData.parent or UIParent
    local width = frameData.width or 200
    local height = frameData.height or 200

    local frame = CreateFrame("Frame", name, parent, "PortraitFrameTemplate")
    frame:SetSize(width, height)
    frame:SetClampedToScreen(true)
    frame:Hide() -- Hide until explicitly shown

    -- Allow the frame to be closed with the escape key
    table.insert(UISpecialFrames, frame:GetName())

    -- Give the frame sound when being opened and closed
    frame:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
    end)
    frame:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
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

    return frame
end