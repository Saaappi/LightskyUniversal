local addonTable = select(2, ...)
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
            tooltipText = addonTable.Locales.TALENT_IMPORTER_BUTTON_TOOLTIP
        }
        importerButton = addonTable.CreateButton(button)
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
            text = addonTable.Locales.APPLY_TALENTS,
            tooltipText = addonTable.Locales.APPLY_TALENTS_TOOLTIP,
            point = "LEFT",
            parent = talentsFrame.SearchBox
        }
        applyTalentsButton = addonTable.CreateButton(button)
    end
    applyTalentsButton:ClearAllPoints()
    applyTalentsButton:SetPoint("LEFT", applyTalentsButton:GetParent(), "RIGHT", 27.5, 0)
    applyTalentsButton:Show()
    applyTalentsButton:SetScript("OnClick", function()
        local class = LSUDB.PlayerTalents[addonTable.Character.ClassID]
        if class then
            local talents = class and class[addonTable.Character.SpecID]
            if talents then
                addonTable.ImportText(talents.importString)
            end
        end
    end)
end)

EventRegistry:RegisterCallback("PlayerSpellsFrame.TalentTab.Hide", function()
    if not LSUDB.Settings["PlayerTalents.Enabled"] then return end
    applyTalentsButton:Hide()
end)