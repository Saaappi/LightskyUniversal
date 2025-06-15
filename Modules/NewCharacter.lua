local LSU = select(2, ...)
local L = LSU.L
local eventFrame = CreateFrame("Frame")
local newCharacterSetupButton
local button = {
    type = "BasicButton",
    name = "LSUNewCharacterSetupButton",
    width = 170,
    height = 25,
    text = L.LABEL_NEWCHARACTER_BUTTON,
    point = "CENTER",
    parent = UIParent
}

local consoleVariables = {
    { name = "alwaysCompareItems", savedVarKey = "NewCharacter.AlwaysCompareItems.Enabled", value = "0" },
    { name = "alwaysShowActionBars", savedVarKey = "NewCharacter.AlwaysShowActionBars.Enabled", value = "1" },
    { name = "arachnophobiaMode", savedVarKey = "NewCharacter.ArachnophobiaMode.Enabled", value = "1" },
    { name = "autoDismountFlying", savedVarKey = "NewCharacter.AutoDismountFlying.Enabled", value = "0" },
    { name = "autoInteract", savedVarKey = "NewCharacter.AutoInteract.Enabled", value = "1" },
    { name = "autoLootDefault", savedVarKey = "NewCharacter.AutoLootDefault.Enabled", value = "1" },
    { name = "AutoPushSpellToActionBar", savedVarKey = "NewCharacter.AutoPushSpellToActionBar.Enabled", value = "0" },
    { name = "cooldownViewerEnabled", savedVarKey = "NewCharacter.CooldownViewer.Enabled", value = "1" },
    { name = "DisableAdvancedFlyingFullScreenEffects", savedVarKey = "NewCharacter.DisableSkyridingFullScreenEffects.Enabled", value = "1" },
    { name = "DisableAdvancedFlyingVelocityVFX", savedVarKey = "NewCharacter.DisableSkyridingVelocityVFX.Enabled", value = "1" },
    { name = "disableUserAddonsByDefault", savedVarKey = "NewCharacter.DisableUserAddonsByDefault.Enabled", value = "1" },
    { name = "enableFloatingCombatText", savedVarKey = "NewCharacter.EnableFloatingCombatText.Enabled", value = "1" },
    { name = "FootstepSounds", savedVarKey = "NewCharacter.FootstepSounds.Enabled", value = "0" },
    { name = "lootUnderMouse", savedVarKey = "NewCharacter.LootUnderMouse.Enabled", value = "1" },
    { name = "mountJournalShowPlayer", savedVarKey = "NewCharacter.MountJournalShowPlayer.Enabled", value = "1" },
    { name = "occludedSilhouettePlayer", savedVarKey = "NewCharacter.OccludedSilhouettePlayer.Enabled", value = "1" },
    { name = "profanityFilter", savedVarKey = "NewCharacter.ProfanityFilter.Enabled", value = "0" },
    { name = "pvpFramesDisplayClassColor", savedVarKey = "NewCharacter.PvPFramesDisplayClassColor.Enabled", value = "1" },
    { name = "questTextContrast", savedVarKey = "NewCharacter.QuestTextContrast.Enabled", value = "1" },
    { name = "raidFramesDisplayClassColor", savedVarKey = "NewCharacter.RaidFramesDisplayClassColor.Enabled", value = "1" },
    { name = "ReplaceMyPlayerPortrait", savedVarKey = "NewCharacter.ReplaceMyPlayerPortrait.Enabled", value = "1" },
    { name = "ReplaceOtherPlayerPortraits", savedVarKey = "NewCharacter.ReplaceOtherPlayerPortraits.Enabled", value = "1" },
    { name = "scriptErrors", savedVarKey = "NewCharacter.ShowScriptErrors.Enabled", value = "1" },
    { name = "showTargetOfTarget", savedVarKey = "NewCharacter.ShowTargetOfTarget.Enabled", value = "1" },
    { name = "showTutorials", savedVarKey = "NewCharacter.ShowTutorials.Enabled", value = "0" },
    { name = "SoftTargetEnemy", savedVarKey = "NewCharacter.SoftTargetEnemy.Enabled", value = "2" },
    { name = "SoftTargetEnemyArc", savedVarKey = "NewCharacter.SoftTargetEnemy.Enabled", value = "1" },
    { name = "SoftTargetIconEnemy", savedVarKey = "NewCharacter.SoftTargetEnemy.Enabled", value = "1" },
    { name = "spellBookHidePassives", savedVarKey = "NewCharacter.SpellBookHidePassives.Enabled", value = "1" },
}

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LOGIN" then
        C_Timer.After(3, function()
            if not LSUDB.Settings["NewCharacter.Enabled"] then return end
            local guid = UnitGUID("player")
            if not LSUDB.Characters[guid] then
                -- This must be added after the Player Collector has a chance to harvest its data.
                button.tooltipText = string.format("%s |c%s%s|r.", L.NEW_CHARACTER_BUTTON_TOOLTIP, LSU.Character.ClassColor:GenerateHexColor(), LSU.Character.Name)
                newCharacterSetupButton = LSU.CreateButton(button)
                if newCharacterSetupButton then
                    newCharacterSetupButton:ClearAllPoints()
                    newCharacterSetupButton:SetPoint("CENTER", newCharacterSetupButton:GetParent(), "CENTER", 0, 0)
                    newCharacterSetupButton:SetScript("OnClick", function()
                        newCharacterSetupButton:Hide()

                        if LSUDB.Settings["NewCharacter.ClearAllTracking.Enabled"] then
                            C_Minimap.ClearAllTracking()
                        end

                        C_EditMode.SetActiveLayout(LSUDB.Settings["EditModeLayoutID"] + 2)

                        for _, consoleVariable in ipairs(consoleVariables) do
                            if consoleVariable.savedVarKey then
                                if C_CVar.GetCVar(consoleVariable.name) ~= consoleVariable.value then
                                    C_CVar.SetCVar(consoleVariable.name, consoleVariable.value)
                                end
                            end
                        end

                        StaticPopupDialogs["LSU_NewCharacterConfigurationCompleted"] = {
                            text = L.POPUP_NEWCHARACTER_TEXT,
                            button1 = YES,
                            button2 = NO,
                            explicitAcknowledge = true,
                            OnAccept = function()
                                LSUDB.Characters[guid] = LSU.Character.Name
                                C_UI.Reload()
                            end,
                            OnCancel = function() end,
                            preferredIndex = 3
                        }
                        StaticPopup_Show("LSU_NewCharacterConfigurationCompleted")
                    end)
                else
                    LSU.PrintError(string.format("%s: %s", L.TEXT_BUTTON_CREATION_FAILED, button.name))
                end
            end
        end)
        eventFrame:UnregisterEvent(event)
    end
end)