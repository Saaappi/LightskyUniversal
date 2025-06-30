local LSU = select(2, ...)
local importerButton
local applyTalentsButton

EventRegistry:RegisterCallback("PlayerSpellsFrame.TalentTab.Show", function()
    if not LSUDB.Settings["PlayerTalents.Enabled"] then return end
    local parentFrame = PlayerSpellsFrame
    local talentsFrame = parentFrame.TalentsTab or PlayerSpellsFrame.TalentsFrame
    if not importerButton then
        local button = {
            type = "ActionButton",
            name = "LSUOpenImporterButton",
            parent = talentsFrame.SearchBox,
            scale = 0.5,
            texture = 132222,
            tooltipText = LSU.Locales.TALENT_IMPORTER_BUTTON_TOOLTIP
        }
        importerButton = LSU.CreateButton(button)
        importerButton:SetScript("OnClick", function()
            HideUIPanel(PlayerSpellsFrame)
            LSUOpenTalentImporter()
        end)
    end
    importerButton:ClearAllPoints()
    importerButton:SetPoint("LEFT", talentsFrame.SearchBox, "RIGHT", 2.5, 0)
    importerButton:Show()

    if not applyTalentsButton then
        local button = {
            type = "BasicButton",
            name = "LSUApplyTalentsButton",
            width = 120,
            height = 25,
            text = LSU.Locales.APPLY_TALENTS,
            tooltipText = LSU.Locales.APPLY_TALENTS_TOOLTIP,
            point = "LEFT",
            parent = talentsFrame.SearchBox
        }
        applyTalentsButton = LSU.CreateButton(button)
    end
    applyTalentsButton:ClearAllPoints()
    applyTalentsButton:SetPoint("LEFT", applyTalentsButton:GetParent(), "RIGHT", 27.5, 0)
    applyTalentsButton:Show()
    applyTalentsButton:SetScript("OnClick", function()
        local class = LSUDB.PlayerTalents[LSU.Character.ClassID]
        if class then
            local talents = class and class[LSU.Character.SpecID]
            if talents then
                LSU.ImportText(talents.importString)
            end
        end
    end)
end)

EventRegistry:RegisterCallback("PlayerSpellsFrame.TalentTab.Hide", function()
    if not LSUDB.Settings["PlayerTalents.Enabled"] then return end
    applyTalentsButton:Hide()
end)