local addonName, addonTable = ...
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == addonName then
            if LSUDB == nil then
                LSUDB = {}
                LSUDB.AdventureMaps = {
                    [2276] = {
                        [83548] = false,
                        [83550] = false,
                        [83551] = false,
                        [83552] = false,
                    },
                    [2057] = {
                        [72266] = false,
                        [72267] = false,
                        [72268] = false,
                        [72269] = false,
                    }
                }
                LSUDB.Characters = {}
                LSUDB.Gossips = {}
                LSUDB.Junk = {}
                LSUDB.PlayerTalents = {}
                LSUDB.Settings = {
                    ["AcceptQuests.Enabled"] = false,
                    ["AutoRepair.Enabled"] = false,
                    ["AutoShareQuests.Enabled"] = false,
                    ["AutoTrain.Enabled"] = false,
                    ["BuyQuestItems.Enabled"] = false,
                    ["ChromieTimeExpansionID"] = 0,
                    ["CompleteQuests.Enabled"] = false,
                    ["EditModeLayoutID"] = 1,
                    ["Gossip.Enabled"] = false,
                    ["NewCharacter.ActionBar2.Enabled"] = false,
                    ["NewCharacter.ActionBar3.Enabled"] = false,
                    ["NewCharacter.ActionBar4.Enabled"] = false,
                    ["NewCharacter.ActionBar5.Enabled"] = false,
                    ["NewCharacter.ActionBar6.Enabled"] = false,
                    ["NewCharacter.ActionBar7.Enabled"] = false,
                    ["NewCharacter.ActionBar8.Enabled"] = false,
                    ["NewCharacter.AlwaysCompareItems.Enabled"] = false,
                    ["NewCharacter.AlwaysShowActionBars.Enabled"] = false,
                    ["NewCharacter.ArachnophobiaMode.Enabled"] = false,
                    ["NewCharacter.AssistedCombatHighlight.Enabled"] = false,
                    ["NewCharacter.AutoDismountFlying.Enabled"] = false,
                    ["NewCharacter.AutoInteract.Enabled"] = false,
                    ["NewCharacter.AutoLootDefault.Enabled"] = false,
                    ["NewCharacter.AutoPushSpellToActionBar.Enabled"] = false,
                    ["NewCharacter.ClearAllTracking.Enabled"] = false,
                    ["NewCharacter.CooldownViewer.Enabled"] = false,
                    ["NewCharacter.DisableSkyridingFullScreenEffects.Enabled"] = false,
                    ["NewCharacter.DisableSkyridingVelocityVFX.Enabled"] = false,
                    ["NewCharacter.DisableUserAddonsByDefault.Enabled"] = false,
                    ["NewCharacter.Enabled"] = false,
                    ["NewCharacter.EnableFloatingCombatText.Enabled"] = false,
                    ["NewCharacter.FootstepSounds.Enabled"] = false,
                    ["NewCharacter.LootUnderMouse.Enabled"] = false,
                    ["NewCharacter.MountJournalShowPlayer.Enabled"] = false,
                    ["NewCharacter.OccludedSilhouettePlayer.Enabled"] = false,
                    ["NewCharacter.ProfanityFilter.Enabled"] = false,
                    ["NewCharacter.PvPFramesDisplayClassColor.Enabled"] = false,
                    ["NewCharacter.QuestTextContrast.Enabled"] = false,
                    ["NewCharacter.RaidFramesDisplayClassColor.Enabled"] = false,
                    ["NewCharacter.ReplaceMyPlayerPortrait.Enabled"] = false,
                    ["NewCharacter.ReplaceOtherPlayerPortraits.Enabled"] = false,
                    ["NewCharacter.ShowScriptErrors.Enabled"] = false,
                    ["NewCharacter.ShowTargetOfTarget.Enabled"] = false,
                    ["NewCharacter.ShowTutorials.Enabled"] = false,
                    ["NewCharacter.SoftTargetEnemy.Enabled"] = false,
                    ["NewCharacter.SpellBookHidePassives.Enabled"] = false,
                    ["PlayerTalents.Enabled"] = false,
                    ["QuestRewards.Enabled"] = false,
                    ["Rares.Enabled"] = false,
                    ["Rares.NotificationSoundID"] = 0,
                    ["SkipCinematics.Enabled"] = false,
                    ["TalkingHead.Disabled"] = false,
                }
            else
                local oldVariables = {
                    "Junk"
                }
                local oldSettingVariables = {
                    "ChatIcons.Enabled",
                    "WarbankDepositInCopper",
                    "ReadyChecks.Enabled",
                    "RoleChecks.Enabled"
                }
                for _, variable in ipairs(oldVariables) do
                    LSUDB[variable] = nil
                end
                for _, variable in ipairs(oldSettingVariables) do
                    LSUDB.Settings[variable] = nil
                end

                local newVariables = {
                    AdventureMaps = {
                        [2276] = {
                            [83548] = false,
                            [83550] = false,
                            [83551] = false,
                            [83552] = false,
                        },
                        [2057] = {
                            [72266] = false,
                            [72267] = false,
                            [72268] = false,
                            [72269] = false,
                        }
                    }
                }
                for variableName, variableData in pairs(newVariables) do
                    if not LSUDB[variableName] then
                        LSUDB[variableName] = {}
                    end
                    for k, v in pairs(variableData) do
                        if not LSUDB[variableName][k] then
                            LSUDB[variableName][k] = v
                        end
                    end
                end
            end
        end
    end
end)