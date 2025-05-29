local LSU = select(2, ...)
local L = LSU.L

local defaults = {
    FRAME_BASE_WIDTH = 230,
    FRAME_BASE_HEIGHT = 300,
    FRAME_EXTENDED_WIDTH = 315,
    FRAME_EXTENDED_HEIGHT = 275,
}

local state = {
    frame = nil,
    backButton = nil,
    editBoxes = {},
    classButtons = {}
}

local function EnsureTalentDB(classID, specID)
    LSUDB.PlayerTalents = LSUDB.PlayerTalents or {}
    LSUDB.PlayerTalents[classID] = LSUDB.PlayerTalents[classID] or {}
    LSUDB.PlayerTalents[classID][specID] = LSUDB.PlayerTalents[classID][specID] or {}
    return LSUDB.PlayerTalents[classID][specID]
end

-- Hide all the elements in the table and wipe it
local function HideAndWipe(tbl)
    for i, v in ipairs(tbl) do
        if v and v.Hide then v:Hide() end
        tbl[i] = nil
    end
end

-- Lays out the class buttons in a grid inside the frame.
-- Params:
--   buttons: table of button frames
--   frame: parent frame
--   cols: number of columns in the grid
--   xPadding, yPadding: space between buttons
--   left, top: offset from frame's TOPLEFT corner
local function LayoutGrid(buttons, frame, cols, xPadding, yPadding, left, top)
    for index, button in ipairs(buttons) do
        local col = (index - 1) % cols
        local row = math.floor((index - 1) / cols)
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", frame, "TOPLEFT",
            left + col * (button:GetWidth() + xPadding),
            -(top + row * (button:GetHeight() + yPadding))
        )
    end
end

local function LayoutGridVertical(widgets, parent, xOffset, yOffset, spacing)
    for index, widget in ipairs(widgets) do
        widget:ClearAllPoints()
        if index == 1 then
            widget:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, -yOffset)
        else
            widget:SetPoint("TOPLEFT", widgets[index-1], "BOTTOMLEFT", 0, -spacing)
        end
    end
end

-- Hide the class buttons on the frame
local function HideClassButtons()
    for _, button in ipairs(state.classButtons) do
        if button:IsShown() then
            button:Hide()
        else
            button:Show()
        end
    end
end

-- Hide and clear the editboxes
local function HideEditBoxes()
    HideAndWipe(state.editBoxes)
end

-- Hide the class name text
local function HideClassNameText()
    if state.frame.classNameText:IsVisible() then
        state.frame.classNameText:Hide()
    end
end

local function GetOrCreateFrame()
    if not state.frame then
        state.frame = LSU.CreateFrame("Portrait", {
            name = "LSUTalentImporterFrame",
            parent = UIParent,
            height = defaults.FRAME_BASE_HEIGHT,
            width = defaults.FRAME_BASE_WIDTH,
            movable = true
        })
        state.frame:SetTitle(L.LABEL_TALENT_IMPORTER)
        state.frame:SetPortraitToAsset(132222)

        state.frame.classNameText = state.frame:CreateFontString(nil, "OVERLAY")
        state.frame.classNameText:SetFont("Fonts\\MORPHEUS.TTF", 24)
        state.frame.classNameText:SetPoint("TOP", state.frame, "TOP", 0, -35)
        state.frame.classNameText:SetText("")
    end
    return state.frame
end

-- Create the class buttons
local function CreateClassButtons(frame)
    if #state.classButtons > 0 then return end -- The class buttons already exist

    for index, btn in ipairs(LSU.Enum.PlayerTalents.ClassButtons) do
        local button = CreateFrame("Button", "LSUClassButton"..index, frame, "ActionButtonTemplate")
        button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

        button.ID = btn.id
        button.classID = btn.classID
        button.icon:SetAtlas(btn.atlas)

        button:SetScript("OnClick", function(self)
            frame:SetWidth(defaults.FRAME_EXTENDED_WIDTH)
            frame:SetHeight(defaults.FRAME_EXTENDED_HEIGHT)
            HideClassButtons()
            HideEditBoxes()

            for i, spec in ipairs(LSU.Enum.PlayerTalents.SpecEditBoxes[self.ID]) do
                local editBoxName = "LSUSpecEditBox" .. i
                local editBox = CreateFrame("EditBox", editBoxName, frame, "InputBoxTemplate")
                table.insert(state.editBoxes, editBox)
                editBox:SetAutoFocus(false)
                editBox:SetWidth(250)
                editBox:SetHeight(20)
                editBox:SetFontObject("ChatFontNormal")

                -- Spec icon
                local specTexture = editBox:CreateTexture(nil, "BACKGROUND")
                specTexture:SetPoint("CENTER", editBox, "LEFT", -specTexture:GetWidth()/2 - 20, 0)
                specTexture:SetSize(24, 24)
                specTexture:EnableMouse(true)
                specTexture:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetText(spec.name, btn.classColor.r, btn.classColor.g, btn.classColor.b)
                    GameTooltip:Show()
                end)
                specTexture:SetScript("OnLeave", function() GameTooltip:Hide() end)
                SetPortraitToTexture(specTexture, select(4, GetSpecializationInfoByID(spec.id)))

                -- Border for the spec icons
                local border = editBox:CreateTexture(nil, "BORDER")
                border:SetPoint("CENTER", specTexture, "CENTER", 0, 0)
                border:SetSize(28, 28)
                border:SetAtlas("Artifacts-PerkRing-Final", false)

                -- On load, set the text of the editboxes
                local db = EnsureTalentDB(btn.classID, spec.id)
                if db and db.importString then
                    editBox:SetText(db.importString)
                end

                -- Save on enter
                editBox:SetScript("OnEnterPressed", function(self)
                    self:ClearFocus()
                    local text = self:GetText()

                    if text == "" then
                        db.importString, db.date, db.patch = "", "", ""
                    else
                        db.importString = text
                        db.date = date("%m/%d/%Y")
                        db.patch = (GetBuildInfo())
                    end
                end)

                -- Editbox tooltip
                editBox:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
                    if not db or not next(db) then
                        GameTooltip:SetText(L.TEXT_LAST_UPDATED .. ": -")
                    else
                        GameTooltip:SetText(string.format("%s: %s (%s)", L.TEXT_LAST_UPDATED, db.date or "-", db.patch or "-"))
                    end
                    GameTooltip:Show()
                end)
                editBox:SetScript("OnLeave", function() GameTooltip:Hide() end)
            end

            -- Editbox position
            LayoutGridVertical(state.editBoxes, frame, 50, 80, 20)

            frame.classNameText:SetText(("|cff%02x%02x%02x%s|r"):format(
                btn.classColor.r * 255, btn.classColor.g * 255, btn.classColor.b * 255, btn.className
            ))
            frame.classNameText:Show()

            if not state.backButton then
                state.backButton = LSU.CreateButton({
                    type = "BasicButton",
                    name = "LSUTalentImporterBackButton",
                    parent = frame,
                    width = 80,
                    height = 25,
                    text = L.LABEL_TALENT_IMPORTER_BUTTON_BACK,
                    tooltipText = L.TALENT_IMPORTER_BUTTON_BACK_TOOLTIP
                })
                state.backButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 7)
                state.backButton:SetScript("OnClick", function()
                    frame:SetWidth(defaults.FRAME_BASE_WIDTH)
                    frame:SetHeight(defaults.FRAME_BASE_HEIGHT)
                    HideEditBoxes()
                    HideClassButtons()
                    HideClassNameText()
                    state.backButton:Hide()
                end)
            end
            state.backButton:Show()
        end)
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
            GameTooltip:SetText(btn.className, btn.classColor.r, btn.classColor.g, btn.classColor.b)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function() GameTooltip:Hide() end)

        state.classButtons[index] = button
    end

    LayoutGrid(state.classButtons, frame, 4, 10, 10, 10, 60)
end

function LSUOpenTalentImporter()
    local frame = GetOrCreateFrame()
    if frame:IsShown() then
        frame:Hide()
        return
    end

    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER")

    CreateClassButtons(frame)

    frame:Show()
end