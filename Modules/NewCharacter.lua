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
    { name = "alwaysCompareItems", value = "0" },
    { name = "alwaysShowActionBars", value = "1" },
    { name = "arachnophobiaMode", value = "1" },
    { name = "autoDismountFlying", value = "0" },
    { name = "autoInteract", value = "1" },
    { name = "autoLootDefault", value = "1" },
    { name = "AutoPushSpellToActionBar", value = "0" },
    { name = "autoQuestProgress", value = "1" },
    { name = "autoQuestWatch", value = "1" },
    { name = "bankConfirmTabCleanUp", value = "0" },
    { name = "cameraIndirectVisibility", value = "0" },
    { name = "cameraIndirectOffset", value = "10" },
    { name = "calendarShowLockouts", value = "0" },
    { name = "chatBubblesParty", value = "0" },
    { name = "cooldownViewerEnabled", value = "1" },
    { name = "countdownForCooldowns", value = "1" },
    { name = "DisableAdvancedFlyingFullScreenEffects", value = "1" },
    { name = "DisableAdvancedFlyingVelocityVFX", value = "1" },
    { name = "disableUserAddonsByDefault", value = "1" },
    { name = "enableFloatingCombatText", value = "1" },
    { name = "findYourselfAnywhereOnlyInCombat", value = "1" },
    { name = "FootstepSounds", value = "0" },
    { name = "graphicsDepthEffects", value = "2" },
    { name = "graphicsEnvironmentDetail", value = "7" },
    { name = "graphicsGroundClutter", value = "3" },
    { name = "graphicsParticleDensity", value = "3" },
    { name = "graphicsShadowQuality", value = "1" },
    { name = "graphicsSpellDensity", value = "2" },
    { name = "lootUnderMouse", value = "1" },
    { name = "mountJournalShowPlayer", value = "1" },
    { name = "movieSubtitleBackgroundAlpha", value = "85" },
    { name = "nameplateShowSelf", value = "0" },
    { name = "occludedSilhouettePlayer", value = "1" },
    { name = "profanityFilter", value = "0" },
    { name = "pvpFramesDisplayClassColor", value = "1" },
    { name = "questTextContrast", value = "1" },
    { name = "raidFramesDisplayClassColor", value = "1" },
    { name = "ReplaceMyPlayerPortrait", value = "1" },
    { name = "ReplaceOtherPlayerPortraits", value = "1" },
    { name = "screenshotQuality", value = "6" },
    { name = "scriptErrors", value = "1" },
    { name = "scrollToLogQuest", value = "1" },
    { name = "showTargetOfTarget", value = "1" },
    { name = "showTutorials", value = "0" },
    { name = "SoftTargetEnemy", value = "2" },
    { name = "SoftTargetEnemyArc", value = "1" },
    { name = "SoftTargetIconEnemy", value = "1" },
    { name = "spellBookHidePassives", value = "1" },
    { name = "whisperMode", value = "inline" },
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

                        C_Minimap.ClearAllTracking()
                        C_EditMode.SetActiveLayout(3)

                        local t1, t2, t3 = GetActionBarToggles()
                        if not (t1 and t2 and t3) then
                            SetActionBarToggles(true, true, true, false, false, false, false, false)
                        end

                        for _, consoleVariable in ipairs(consoleVariables) do
                            if C_CVar.GetCVar(consoleVariable.name) ~= consoleVariable.value then
                                C_CVar.SetCVar(consoleVariable.name, consoleVariable.value)
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