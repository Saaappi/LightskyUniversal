local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")
local newCharacterSetupButton
local button = {
    type = "BasicButton",
    name = "LSUNewCharacterSetupButton",
    width = 170,
    height = 25,
    text = addonTable.Locales.CONFIGURE_NEW_CHARACTER,
    point = "CENTER",
    parent = UIParent
}

local consoleVariables = {
    { name = "alwaysCompareItems",                     savedVarKey = "NewCharacter.AlwaysCompareItems.Enabled",                trueValue = "1", falseValue = "0" },
    { name = "alwaysShowActionBars",                   savedVarKey = "NewCharacter.AlwaysShowActionBars.Enabled",              trueValue = "1", falseValue = "0" },
    { name = "arachnophobiaMode",                      savedVarKey = "NewCharacter.ArachnophobiaMode.Enabled",                 trueValue = "1", falseValue = "0" },
    { name = "assistedCombatHighlight",                savedVarKey = "NewCharacter.AssistedCombatHighlight.Enabled",           trueValue = "1", falseValue = "0" },
    { name = "autoDismountFlying",                     savedVarKey = "NewCharacter.AutoDismountFlying.Enabled",                trueValue = "1", falseValue = "0" },
    { name = "autoInteract",                           savedVarKey = "NewCharacter.AutoInteract.Enabled",                      trueValue = "1", falseValue = "0" },
    { name = "autoLootDefault",                        savedVarKey = "NewCharacter.AutoLootDefault.Enabled",                   trueValue = "1", falseValue = "0" },
    { name = "AutoPushSpellToActionBar",               savedVarKey = "NewCharacter.AutoPushSpellToActionBar.Enabled",          trueValue = "1", falseValue = "0" },
    { name = "cooldownViewerEnabled",                  savedVarKey = "NewCharacter.CooldownViewer.Enabled",                    trueValue = "1", falseValue = "0" },
    { name = "DisableAdvancedFlyingFullScreenEffects", savedVarKey = "NewCharacter.DisableSkyridingFullScreenEffects.Enabled", trueValue = "1", falseValue = "0" },
    { name = "DisableAdvancedFlyingVelocityVFX",       savedVarKey = "NewCharacter.DisableSkyridingVelocityVFX.Enabled",       trueValue = "1", falseValue = "0" },
    { name = "disableUserAddonsByDefault",             savedVarKey = "NewCharacter.DisableUserAddonsByDefault.Enabled",        trueValue = "1", falseValue = "0" },
    { name = "enableFloatingCombatText",               savedVarKey = "NewCharacter.EnableFloatingCombatText.Enabled",          trueValue = "1", falseValue = "0" },
    { name = "FootstepSounds",                         savedVarKey = "NewCharacter.FootstepSounds.Enabled",                    trueValue = "0", falseValue = "1" },
    { name = "lootUnderMouse",                         savedVarKey = "NewCharacter.LootUnderMouse.Enabled",                    trueValue = "1", falseValue = "0" },
    { name = "mountJournalShowPlayer",                 savedVarKey = "NewCharacter.MountJournalShowPlayer.Enabled",            trueValue = "1", falseValue = "0" },
    { name = "occludedSilhouettePlayer",               savedVarKey = "NewCharacter.OccludedSilhouettePlayer.Enabled",          trueValue = "1", falseValue = "0" },
    { name = "profanityFilter",                        savedVarKey = "NewCharacter.ProfanityFilter.Enabled",                   trueValue = "1", falseValue = "0" },
    { name = "pvpFramesDisplayClassColor",             savedVarKey = "NewCharacter.PvPFramesDisplayClassColor.Enabled",        trueValue = "1", falseValue = "0" },
    { name = "questTextContrast",                      savedVarKey = "NewCharacter.QuestTextContrast.Enabled",                 trueValue = "1", falseValue = "0" },
    { name = "raidFramesDisplayClassColor",            savedVarKey = "NewCharacter.RaidFramesDisplayClassColor.Enabled",       trueValue = "1", falseValue = "0" },
    { name = "ReplaceMyPlayerPortrait",                savedVarKey = "NewCharacter.ReplaceMyPlayerPortrait.Enabled",           trueValue = "1", falseValue = "0" },
    { name = "ReplaceOtherPlayerPortraits",            savedVarKey = "NewCharacter.ReplaceOtherPlayerPortraits.Enabled",       trueValue = "1", falseValue = "0" },
    { name = "scriptErrors",                           savedVarKey = "NewCharacter.ShowScriptErrors.Enabled",                  trueValue = "1", falseValue = "0" },
    { name = "showTargetOfTarget",                     savedVarKey = "NewCharacter.ShowTargetOfTarget.Enabled",                trueValue = "1", falseValue = "0" },
    { name = "showTutorials",                          savedVarKey = "NewCharacter.ShowTutorials.Enabled",                     trueValue = "1", falseValue = "0" },
    { name = "SoftTargetEnemy",                        savedVarKey = "NewCharacter.SoftTargetEnemy.Enabled",                   trueValue = "2", falseValue = "1" },
    { name = "SoftTargetEnemyArc",                     savedVarKey = "NewCharacter.SoftTargetEnemy.Enabled",                   trueValue = "1", falseValue = "2" },
    { name = "SoftTargetIconEnemy",                    savedVarKey = "NewCharacter.SoftTargetEnemy.Enabled",                   trueValue = "1", falseValue = "0" },
    { name = "spellBookHidePassives",                  savedVarKey = "NewCharacter.SpellBookHidePassives.Enabled",             trueValue = "1", falseValue = "0" },
}

function addonTable.ConfigureNewCharacter()
    local guid = UnitGUID("player")
    if not LSUDB.Characters[guid] then
        -- This must be added after the Player Collector has a chance to harvest its data.
        button.tooltipText = string.format(addonTable.Locales.NEW_CHARACTER_BUTTON_TOOLTIP, addonTable.Character.ClassColor:GenerateHexColor(), addonTable.Character.Name)
        newCharacterSetupButton = addonTable.CreateButton(button)
        if newCharacterSetupButton then
            newCharacterSetupButton:ClearAllPoints()
            newCharacterSetupButton:SetPoint("CENTER", newCharacterSetupButton:GetParent(), "CENTER", 0, 0)
            newCharacterSetupButton:SetScript("OnClick", function()
                newCharacterSetupButton:Hide()

                if LSUDB.Settings["NewCharacter.ClearAllTracking.Enabled"] then
                    C_Minimap.ClearAllTracking()
                end

                SetActionBarToggles(
                    LSUDB.Settings["NewCharacter.ActionBar2.Enabled"],
                    LSUDB.Settings["NewCharacter.ActionBar3.Enabled"],
                    LSUDB.Settings["NewCharacter.ActionBar4.Enabled"],
                    LSUDB.Settings["NewCharacter.ActionBar5.Enabled"],
                    LSUDB.Settings["NewCharacter.ActionBar6.Enabled"],
                    LSUDB.Settings["NewCharacter.ActionBar7.Enabled"],
                    LSUDB.Settings["NewCharacter.ActionBar8.Enabled"],
                    LSUDB.Settings["NewCharacter.AlwaysShowActionBars.Enabled"]
                )

                C_EditMode.SetActiveLayout(LSUDB.Settings["EditModeLayoutID"] + 2)

                for _, consoleVariable in ipairs(consoleVariables) do
                    if LSUDB.Settings[consoleVariable.savedVarKey] then
                        if C_CVar.GetCVar(consoleVariable.name) ~= consoleVariable.trueValue then
                            C_CVar.SetCVar(consoleVariable.name, consoleVariable.trueValue)
                        end
                    else
                        if C_CVar.GetCVar(consoleVariable.name) ~= consoleVariable.falseValue then
                            C_CVar.SetCVar(consoleVariable.name, consoleVariable.falseValue)
                        end
                    end
                end

                local nccCompleteDialog = "LSU_NewCharacterConfigurationCompleted"
                addonTable.NewStaticPopup(
                    nccCompleteDialog,
                    string.format(addonTable.Locales.NEW_CHARACTER_TEXT, addonTable.Character.ClassColor:GenerateHexColor(), addonTable.Character.Name),
                    {
                        button2Text = NO,
                        onAccept = function()
                            LSUDB.Characters[guid] = addonTable.Character.Name
                            C_UI.Reload()
                        end
                    }
                )
                StaticPopup_Show(nccCompleteDialog)
            end)
        else
            addonTable.PrintError(string.format(addonTable.Locales.BUTTON_FAILED_TO_CREATE, button.name))
        end
    end
end

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LOGIN" then
        C_Timer.After(3, function()
            if not LSUDB.Settings["NewCharacter.Enabled"] then return end
            addonTable.ConfigureNewCharacter()
        end)
        eventFrame:UnregisterEvent(event)
    end
end)

hooksecurefunc(NamePlateDriverFrame, "OnSoftTargetUpdate", function()
    if not LSUDB.Settings["NewCharacter.SoftTargetEnemy.Enabled"] then return end
    if UnitExists("softenemy") and (not GetRaidTargetIndex("softenemy")) then
        SetRaidTarget("softenemy", 8)
    end
end)