local LSU = select(2, ...)

local classButtons = {
    {
        ["id"] = 1,
        ["atlas"] = "classicon-deathknight",
        ["classID"] = 6,
        ["className"] = "Death Knight",
        ["classColor"] = C_ClassColor.GetClassColor("DEATHKNIGHT"),
    },
    {
        ["id"] = 2,
        ["atlas"] = "classicon-demonhunter",
        ["classID"] = 12,
        ["className"] = "Demon Hunter",
        ["classColor"] = C_ClassColor.GetClassColor("DEMONHUNTER"),
    },
    {
        ["id"] = 3,
        ["atlas"] = "classicon-druid",
        ["classID"] = 11,
        ["className"] = "Druid",
        ["classColor"] = C_ClassColor.GetClassColor("DRUID"),
    },
    {
        ["id"] = 4,
        ["atlas"] = "classicon-evoker",
        ["classID"] = 13,
        ["className"] = "Evoker",
        ["classColor"] = C_ClassColor.GetClassColor("EVOKER"),
    },
    {
        ["id"] = 5,
        ["atlas"] = "classicon-hunter",
        ["classID"] = 3,
        ["className"] = "Hunter",
        ["classColor"] = C_ClassColor.GetClassColor("HUNTER"),
    },
    {
        ["id"] = 6,
        ["atlas"] = "classicon-mage",
        ["classID"] = 8,
        ["className"] = "Mage",
        ["classColor"] = C_ClassColor.GetClassColor("MAGE"),
    },
    {
        ["id"] = 7,
        ["atlas"] = "classicon-monk",
        ["classID"] = 10,
        ["className"] = "Monk",
        ["classColor"] = C_ClassColor.GetClassColor("MONK"),
    },
    {
        ["id"] = 8,
        ["atlas"] = "classicon-paladin",
        ["classID"] = 2,
        ["className"] = "Paladin",
        ["classColor"] = C_ClassColor.GetClassColor("PALADIN"),
    },
    {
        ["id"] = 9,
        ["atlas"] = "classicon-priest",
        ["classID"] = 5,
        ["className"] = "Priest",
        ["classColor"] = C_ClassColor.GetClassColor("PRIEST"),
    },
    {
        ["id"] = 10,
        ["atlas"] = "classicon-rogue",
        ["classID"] = 4,
        ["className"] = "Rogue",
        ["classColor"] = C_ClassColor.GetClassColor("ROGUE"),
    },
    {
        ["id"] = 11,
        ["atlas"] = "classicon-shaman",
        ["classID"] = 7,
        ["className"] = "Shaman",
        ["classColor"] = C_ClassColor.GetClassColor("SHAMAN"),
    },
    {
        ["id"] = 12,
        ["atlas"] = "classicon-warlock",
        ["classID"] = 9,
        ["className"] = "Warlock",
        ["classColor"] = C_ClassColor.GetClassColor("WARLOCK"),
    },
    {
        ["id"] = 13,
        ["atlas"] = "classicon-warrior",
        ["classID"] = 1,
        ["className"] = "Warrior",
        ["classColor"] = C_ClassColor.GetClassColor("WARRIOR"),
    },
}

local specEditBoxes = {
    { -- Death Knight
        {
            ["id"] = 250,
            ["name"] = "Blood",
        },
        {
            ["id"] = 251,
            ["name"] = "Frost",
        },
        {
            ["id"] = 252,
            ["name"] = "Unholy",
        }
    },
    { -- Demon Hunter
        {
            ["id"] = 577,
            ["name"] = "Havoc",
        },
        {
            ["id"] = 581,
            ["name"] = "Vengeance",
        }
    },
    { -- Druid
        {
            ["id"] = 102,
            ["name"] = "Balance",
        },
        {
            ["id"] = 103,
            ["name"] = "Feral",
        },
        {
            ["id"] = 104,
            ["name"] = "Guardian",
        },
        {
            ["id"] = 105,
            ["name"] = "Restoration",
        },
    },
    { -- Evoker
        {
            ["id"] = 1473,
            ["name"] = "Augmentation",
        },
        {
            ["id"] = 1467,
            ["name"] = "Devastation",
        },
        {
            ["id"] = 1468,
            ["name"] = "Preservation",
        },
    },
    { -- Hunter
        {
            ["id"] = 253,
            ["name"] = "Beast Mastery",
        },
        {
            ["id"] = 254,
            ["name"] = "Marksmanship",
        },
        {
            ["id"] = 255,
            ["name"] = "Survival",
        },
    },
    { -- Mage
        {
            ["id"] = 62,
            ["name"] = "Arcane",
        },
        {
            ["id"] = 63,
            ["name"] = "Fire",
        },
        {
            ["id"] = 64,
            ["name"] = "Frost",
        },
    },
    { -- Monk
        {
            ["id"] = 268,
            ["name"] = "Brewmaster",
        },
        {
            ["id"] = 270,
            ["name"] = "Mistweaver",
        },
        {
            ["id"] = 269,
            ["name"] = "Windwalker",
        },
    },
    { -- Paladin
        {
            ["id"] = 65,
            ["name"] = "Holy",
        },
        {
            ["id"] = 66,
            ["name"] = "Protection",
        },
        {
            ["id"] = 70,
            ["name"] = "Retribution",
        },
    },
    { -- Priest
        {
            ["id"] = 256,
            ["name"] = "Discipline",
        },
        {
            ["id"] = 257,
            ["name"] = "Holy",
        },
        {
            ["id"] = 258,
            ["name"] = "Shadow",
        },
    },
    { -- Rogue
        {
            ["id"] = 259,
            ["name"] = "Assassination",
        },
        {
            ["id"] = 260,
            ["name"] = "Outlaw",
        },
        {
            ["id"] = 261,
            ["name"] = "Subtlety",
        },
    },
    { -- Shaman
        {
            ["id"] = 262,
            ["name"] = "Elemental",
        },
        {
            ["id"] = 263,
            ["name"] = "Enhancement",
        },
        {
            ["id"] = 264,
            ["name"] = "Restoration",
        },
    },
    { -- Warlock
        {
            ["id"] = 265,
            ["name"] = "Affliction",
        },
        {
            ["id"] = 266,
            ["name"] = "Demonology",
        },
        {
            ["id"] = 267,
            ["name"] = "Destruction",
        },
    },
    { -- Warrior
        {
            ["id"] = 71,
            ["name"] = "Arms",
        },
        {
            ["id"] = 72,
            ["name"] = "Fury",
        },
        {
            ["id"] = 73,
            ["name"] = "Protection",
        },
    },
}

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
        state.frame:SetTitle("Talent Importer") -- LOCALIZE!
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

    for index, btn in ipairs(classButtons) do
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

            for i, spec in ipairs(specEditBoxes[self.ID]) do
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
                SetPortraitToTexture(specTexture, select(4, GetSpecializationInfoByID(spec.id)))

                -- Border for the spec icons
                local border = editBox:CreateTexture(nil, "BORDER")
                border:SetPoint("CENTER", specTexture, "CENTER", 0, 0)
                border:SetSize(28, 28)
                border:SetAtlas("Artifacts-PerkRing-Final", false)
            end

            -- Editbox position
            LayoutGridVertical(state.editBoxes, frame, 50, 80, 20)

            frame.classNameText:SetText(("|cff%02x%02x%02x%s|r"):format(
                btn.classColor.r*255, btn.classColor.g*255, btn.classColor.b*255, btn.className
            ))
            frame.classNameText:Show()

            if not state.backButton then
                state.backButton = LSU.CreateButton({
                    type = "BasicButton",
                    name = "LSUTalentImporterBackButton",
                    parent = frame,
                    width = 80,
                    height = 25,
                    text = "Back",
                    tooltipText = "Return to class selection." -- LOCALIZE!
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

LSUOpenTalentImporter()