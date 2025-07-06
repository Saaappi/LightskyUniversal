local addonName, LSU = ...
local frame
local ySpacing = 10

local function SlashHandler(msg, editBox)
    local cmd, rest = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()

    if cmd == "" then
        if frame and frame:IsVisible() then frame:Hide(); return end
        if not frame then
            frame = CreateFrame("Frame", nil, UIParent, "ButtonFrameTemplate")

            frame:SetToplevel(true)
            table.insert(UISpecialFrames, frame:GetName())
            frame:SetSize(600, 700)
            frame:SetPoint("CENTER")
            frame:Raise()

            frame:SetMovable(true)
            frame:SetClampedToScreen(true)
            frame:RegisterForDrag("LeftButton")
            frame:SetScript("OnDragStart", function()
            frame:StartMoving()
            frame:SetUserPlaced(false)
            end)
            frame:SetScript("OnDragStop", function()
            frame:StopMovingOrSizing()
            frame:SetUserPlaced(false)
            end)

            ButtonFrameTemplate_HidePortrait(frame)
            ButtonFrameTemplate_HideButtonBar(frame)
            frame.Inset:Hide()
            frame:EnableMouse(true)
            frame:SetScript("OnMouseWheel", function() end)

            frame:SetTitle(LSU.Locales.ADDON_TITLE .. " " .. LSU.Locales.SETTINGS)

            local discordLinkDialog = "LSU_SETTINGS_DISCORD_LINK_DIALOG"
            LSU.NewStaticPopup(
                discordLinkDialog,
                LSU.Locales.USE_CTRLC_TO_COPY_THE_LINK_BELOW,
                {
                    button1Text = DONE,
                    hasEditBox = 1,
                    onShow = function(self)
                        self.editBox:SetText("https://discord.gg/2Q3DKhu9HT")
                        self.editBox:HighlightText()
                    end,
                }
            )
            local discordButton = LSU.NewBasicButton({
                name = "LSUDiscordButton",
                parent = frame,
                width = 120,
                height = 25,
                label = LSU.Locales.DISCORD
            })
            discordButton:SetPoint("TOP", frame, "TOP", -65, -30)
            discordButton:SetScript("OnClick", function()
                StaticPopup_Show(discordLinkDialog)
            end)

            local donateLinkDialog = "LSU_SETTINGS_DONATE_LINK_DIALOG"
            LSU.NewStaticPopup(
                donateLinkDialog,
                LSU.Locales.USE_CTRLC_TO_COPY_THE_LINK_BELOW,
                {
                    button1Text = DONE,
                    hasEditBox = 1,
                    onShow = function(self)
                        self.editBox:SetText("https://linktr.ee/lightskygg")
                        self.editBox:HighlightText()
                    end,
                }
            )
            local donateButton = LSU.NewBasicButton({
                name = "LSUDonateButton",
                parent = frame,
                width = 120,
                height = 25,
                label = LSU.Locales.DONATE
            })
            donateButton:SetPoint("LEFT", discordButton, "RIGHT", 10, 0)
            donateButton:SetScript("OnClick", function()
                StaticPopup_Show(donateLinkDialog)
            end)

            frame.versionLabel = frame:CreateFontString()
            frame.versionLabel:SetFontObject(GameFontHighlight)
            frame.versionLabel:SetText(C_AddOns.GetAddOnMetadata(addonName, "Version"))
            frame.versionLabel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, -30)

            local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
            scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -65)
            scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -35, 20)

            local scrollChild = CreateFrame("Frame", nil, scrollFrame)
            scrollChild:SetSize(1, 1)
            scrollFrame:SetScrollChild(scrollChild)

            local lastWidget = nil

            local generalModulesFS = scrollChild:CreateFontString()
            generalModulesFS:SetFontObject("ChatBubbleFont")
            generalModulesFS:SetText(LSU.Locales.GENERAL_MODULES)
            generalModulesFS:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 20, -30)

            local checkboxData = {
                { LSU.Locales.ACCEPT_QUESTS,     "AcceptQuests.Enabled",    LSU.Locales.ACCEPT_QUESTS_TOOLTIP      },
                { LSU.Locales.AUTO_REPAIR,       "AutoRepair.Enabled",      LSU.Locales.AUTO_REPAIR_TOOLTIP        },
                { LSU.Locales.AUTO_SHARE_QUESTS, "AutoShareQuests.Enabled", LSU.Locales.AUTO_SHARE_QUESTS_TOOLTIP  },
                { LSU.Locales.AUTO_TRAIN,        "AutoTrain.Enabled",       LSU.Locales.AUTO_TRAIN_TOOLTIP         },
                { LSU.Locales.BUY_QUEST_ITEMS,   "BuyQuestItems.Enabled",   LSU.Locales.BUY_QUEST_ITEMS_TOOLTIP    },
                { LSU.Locales.COMPLETE_QUESTS,   "CompleteQuests.Enabled",  LSU.Locales.COMPLETE_QUESTS_TOOLTIP    },
                { LSU.Locales.NEW_CHARACTER,     "NewCharacter.Enabled",    LSU.Locales.NEW_CHARACTER_TOOLTIP,
                  function(state)
                    if state then
                        LSU.ConfigureNewCharacter()
                    end
                  end
                },
                { LSU.Locales.PLAYER_TALENTS,    "PlayerTalents.Enabled",   LSU.Locales.PLAYER_TALENTS_TOOLTIP     },
                { LSU.Locales.QUEST_REWARDS,     "QuestRewards.Enabled",    LSU.Locales.QUEST_REWARDS_TOOLTIP      },
                { LSU.Locales.RARES,             "Rares.Enabled",           LSU.Locales.RARES_TOOLTIP              },
                { LSU.Locales.SKIP_CINEMATICS,   "SkipCinematics.Enabled",  LSU.Locales.SKIP_CINEMATICS_TOOLTIP    },
            }

            local columnWidth = 180
            local rowHeight = 25 + ySpacing
            local startX = 20
            local startY = -10
            local checkboxes = {}
            for i, data in ipairs(checkboxData) do
                local col = ((i-1) % 3) + 1
                local row = math.floor((i-1) / 3) + 1

                local cb = LSU.NewCheckbox({
                    id = "_GEN"..i,
                    parent = scrollChild,
                    label = data[1],
                    savedVarKey = data[2],
                    tooltipText = data[3],
                    onCallback = data[4]
                })
                local x = startX + (col-1)*columnWidth
                local y = startY - (row-1)*rowHeight
                cb:SetPoint("TOPLEFT", generalModulesFS, "BOTTOMLEFT", x, y)
                cb:Show()
                checkboxes[i] = cb
            end

            local gossipModuleFS = scrollChild:CreateFontString()
            gossipModuleFS:SetFontObject("ChatBubbleFont")
            gossipModuleFS:SetText(LSU.Locales.GOSSIP_MODULE)
            gossipModuleFS:SetPoint("TOPLEFT", checkboxes[10], "BOTTOMLEFT", -20, -50)

            local openGossipsFrameButton = LSU.NewBasicButton({
                name = "LSUOpenGossipsFrameButton",
                parent = scrollChild,
                width = 120,
                height = 25,
                label = LSU.Locales.OPEN_GOSSIPS
            })
            openGossipsFrameButton:SetPoint("TOPLEFT", gossipModuleFS, "BOTTOMLEFT", 20, -10)
            openGossipsFrameButton:SetScript("OnClick", function()
                frame:Hide()
                LSU.OpenGossipFrame()
            end)

            local gossipCheckbox = LSU.NewCheckbox({
                id = 20,
                parent = scrollChild,
                label = LSU.Locales.GOSSIP,
                savedVarKey = "Gossip.Enabled",
                tooltipText = LSU.Locales.GOSSIP_TOOLTIP
            })
            gossipCheckbox:SetPoint("TOPLEFT", openGossipsFrameButton, "BOTTOMLEFT", 0, -10)

            local chromieTimeModuleFS = scrollChild:CreateFontString()
            chromieTimeModuleFS:SetFontObject("ChatBubbleFont")
            chromieTimeModuleFS:SetText(LSU.Locales.CHROMIE_TIME_MODULE)
            chromieTimeModuleFS:SetPoint("TOPLEFT", gossipModuleFS, "BOTTOMLEFT", 0, -125)

            local chromieTimeDropdown = LSU.NewRadioDropdown({
                parent = scrollChild,
                label = LSU.Locales.CHROMIE_TIME,
                tooltipText = LSU.Locales.CHROMIE_TIME_TOOLTIP,
                savedVarKey = "ChromieTimeExpansionID",
                options = {
                    { DISABLE, 0 },
                    { EXPANSION_NAME1, 6 }, -- TBC
                    { EXPANSION_NAME2, 7 }, -- WotLK
                    { EXPANSION_NAME3, 5 }, -- Cata
                    { EXPANSION_NAME4, 8 }, -- MoP
                    { EXPANSION_NAME5, 9 }, -- WoD
                    { EXPANSION_NAME6, 10 }, -- Legion
                    { EXPANSION_NAME7, 15 }, -- Battle for Azeroth
                    { EXPANSION_NAME8, 14 }, -- Shadowlands
                    { EXPANSION_NAME9, 16 }, -- Dragonflight
                }
            })
            chromieTimeDropdown:SetPoint("TOPLEFT", chromieTimeModuleFS, "BOTTOMLEFT", 20, -10)
            chromieTimeDropdown:SetText(LSU.Enum.Expansions[LSUDB.Settings["ChromieTimeExpansionID"]] or DISABLE)
            chromieTimeDropdown.label:Hide()
            chromieTimeDropdown:Show()

            local newCharacterModuleFS = scrollChild:CreateFontString()
            newCharacterModuleFS:SetFontObject("ChatBubbleFont")
            newCharacterModuleFS:SetText(LSU.Locales.NEW_CHARACTER_MODULE)
            newCharacterModuleFS:SetPoint("TOPLEFT", chromieTimeDropdown, "BOTTOMLEFT", -20, -50)

            local warbandMapButton = LSU.NewInsecureBasicButton({
                name = "LSUUseWarbandMapButton",
                parent = scrollChild,
                width = 120,
                height = 25,
                attributeType = "spell",
                attributeValue = 431280,
                label = LSU.Locales.WARBAND_MAP
            })
            warbandMapButton:SetPoint("TOPLEFT", newCharacterModuleFS, "BOTTOMLEFT", 20, -10)
            warbandMapButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(LSU.Locales.ADDON_TITLE)
                GameTooltip:AddLine(LSU.Locales.WARBAND_MAP_TOOLTIP, 1, 1, 1, 1, true)
                GameTooltip:Show()
            end)
            warbandMapButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

            local wipeConfigurationButton = LSU.NewBasicButton({
                name = "LSUWipeNCCButton",
                parent = scrollChild,
                width = 130,
                height = 25,
                label = LSU.Locales.WIPE_CONFIGURATION
            })
            wipeConfigurationButton:SetPoint("LEFT", warbandMapButton, "RIGHT", 10, 0)
            wipeConfigurationButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(LSU.Locales.ADDON_TITLE)
                GameTooltip:AddLine(LSU.Locales.WIPE_CONFIGURATION_TOOLTIP, 1, 1, 1, 1, true)
                GameTooltip:Show()
            end)
            wipeConfigurationButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
            wipeConfigurationButton:SetScript("OnClick", function(_, button)
                local found = false
                if button == "LeftButton" then
                    for guid, _ in pairs(LSUDB.Characters) do
                        if guid == LSU.Character["GUID"] then
                            LSUDB.Characters[guid] = nil
                            found = true
                            break
                        end
                    end

                    if found then
                        local nccWipeCompleteDialog = "LSU_NewCharacterWiped"
                        LSU.NewStaticPopup(
                            nccWipeCompleteDialog,
                            LSU.Locales.NEW_CHARACTER_WIPED,
                            {
                                button2Text = NO,
                                onAccept = function()
                                    C_UI.Reload()
                                end,
                            }
                        )
                        StaticPopup_Show(nccWipeCompleteDialog)
                    end
                elseif button == "RightButton" then
                    if next(LSUDB.Characters) then
                        found = true
                        for guid, _ in pairs(LSUDB.Characters) do
                            LSUDB.Characters[guid] = nil
                        end

                        if found then
                            local nccWipeAllCompleteDialog = "LSU_NewCharacterAllWiped"
                            LSU.NewStaticPopup(
                                nccWipeAllCompleteDialog,
                                LSU.Locales.NEW_CHARACTER_ALL_WIPED,
                                {
                                    button2Text = NO,
                                    onAccept = function()
                                        C_UI.Reload()
                                    end,
                                }
                            )
                            StaticPopup_Show(nccWipeAllCompleteDialog)
                        end
                    end
                end
            end)

            -- Any of the tooltips formatted not using dot notation is due to some bug with the
            -- length of the string name.
            local newCharacterModuleCheckboxData = {
                { LSU.Locales.ALWAYS_COMPARE_ITEMS,                  "NewCharacter.AlwaysCompareItems.Enabled",                LSU.Locales.ALWAYS_COMPARE_ITEMS_TOOLTIP                   },
                { LSU.Locales.ALWAYS_SHOW_ACTION_BARS,               "NewCharacter.AlwaysShowActionBars.Enabled",              LSU.Locales.ALWAYS_SHOW_ACTION_BARS_TOOLTIP                },
                { LSU.Locales.ARACHNOPHOBIA_MODE,                    "NewCharacter.ArachnophobiaMode.Enabled",                 LSU.Locales.ARACHNOPHOBIA_MODE_TOOLTIP                     },
                { LSU.Locales.ASSISTED_COMBAT_HIGHLIGHT,             "NewCharacter.AssistedCombatHighlight.Enabled",           LSU.Locales.ASSISTED_COMBAT_HIGHLIGHT_TOOLTIP              },
                { LSU.Locales.AUTO_DISMOUNT_FLYING,                  "NewCharacter.AutoDismountFlying.Enabled",                LSU.Locales.AUTO_DISMOUNT_FLYING_TOOLTIP                   },
                { LSU.Locales.AUTO_INTERACT,                         "NewCharacter.AutoInteract.Enabled",                      LSU.Locales.AUTO_INTERACT_TOOLTIP                          },
                { LSU.Locales.AUTO_LOOT ,                            "NewCharacter.AutoLootDefault.Enabled",                   LSU.Locales.AUTO_LOOT_TOOLTIP                              },
                { LSU.Locales.AUTO_PUSH_SPELLS_TO_ACTION_BAR,        "NewCharacter.AutoPushSpellToActionBar.Enabled",          LSU.Locales.AUTO_PUSH_SPELLS_TO_ACTION_BAR_TOOLTIP         },
                { LSU.Locales.CLEAR_ALL_TRACKING,                    "NewCharacter.ClearAllTracking.Enabled",                  LSU.Locales.CLEAR_ALL_TRACKING_TOOLTIP                     },
                { LSU.Locales.COOLDOWN_VIEWER,                       "NewCharacter.CooldownViewer.Enabled",                    LSU.Locales.COOLDOWN_VIEWER_TOOLTIP                        },
                { LSU.Locales.DISABLE_SKYRIDING_FULL_SCREEN_EFFECTS, "NewCharacter.DisableSkyridingFullScreenEffects.Enabled", LSU.Locales.DISABLE_SKYRIDING_FULL_SCREEN_EFFECTS_TOOLTIP  },
                { LSU.Locales.DISABLE_SKYRIDING_VELOCITY_VFX,        "NewCharacter.DisableSkyridingVelocityVFX.Enabled",       LSU.Locales.DISABLE_SKYRIDING_VELOCITY_VFX_TOOLTIP         },
                { LSU.Locales.DISABLE_USER_ADDONS_BY_DEFAULT,        "NewCharacter.DisableUserAddonsByDefault.Enabled",        LSU.Locales.DISABLE_USER_ADDONS_BY_DEFAULT_TOOLTIP         },
                { LSU.Locales.ENABLE_FLOATING_COMBAT_TEXT,           "NewCharacter.EnableFloatingCombatText.Enabled",          LSU.Locales.ENABLE_FLOATING_COMBAT_TEXT_TOOLTIP            },
                { LSU.Locales.DISABLE_FOOTSTEP_SOUNDS,               "NewCharacter.FootstepSounds.Enabled",                    LSU.Locales.DISABLE_FOOTSTEP_SOUNDS_TOOLTIP                },
                { LSU.Locales.LOOT_UNDER_MOUSE,                      "NewCharacter.LootUnderMouse.Enabled",                    LSU.Locales.LOOT_UNDER_MOUSE_TOOLTIP                       },
                { LSU.Locales.MOUNT_JOURNAL_SHOW_PLAYER,             "NewCharacter.MountJournalShowPlayer.Enabled",            LSU.Locales.MOUNT_JOURNAL_SHOW_PLAYER_TOOLTIP              },
                { LSU.Locales.OCCLUDED_SILHOUETTE_PLAYER,            "NewCharacter.OccludedSilhouettePlayer.Enabled",          LSU.Locales.OCCLUDED_SILHOUETTE_PLAYER_TOOLTIP             },
                { LSU.Locales.PROFANITY_FILTER,                      "NewCharacter.ProfanityFilter.Enabled",                   LSU.Locales.PROFANITY_FILTER_TOOLTIP                       },
                { LSU.Locales.PVP_FRAMES_DISPLAY_CLASS_COLOR,        "NewCharacter.PvPFramesDisplayClassColor.Enabled",        LSU.Locales.PVP_FRAMES_DISPLAY_CLASS_COLOR_TOOLTIP         },
                { LSU.Locales.QUEST_TEXT_CONTRAST,                   "NewCharacter.QuestTextContrast.Enabled",                 LSU.Locales.QUEST_TEXT_CONTRAST_TOOLTIP                    },
                { LSU.Locales.RAID_FRAMES_DISPLAY_CLASS_COLOR,       "NewCharacter.RaidFramesDisplayClassColor.Enabled",       LSU.Locales.RAID_FRAMES_DISPLAY_CLASS_COLOR_TOOLTIP        },
                { LSU.Locales.REPLACE_MY_PLAYER_PORTRAIT,            "NewCharacter.ReplaceMyPlayerPortrait.Enabled",           LSU.Locales.REPLACE_MY_PLAYER_PORTRAIT_TOOLTIP             },
                { LSU.Locales.REPLACE_OTHER_PLAYER_PORTRAITS,        "NewCharacter.ReplaceOtherPlayerPortraits.Enabled",       LSU.Locales.REPLACE_OTHER_PLAYER_PORTRAITS_TOOLTIP         },
                { LSU.Locales.SHOW_SCRIPT_ERRORS,                    "NewCharacter.ShowScriptErrors.Enabled",                  LSU.Locales.SHOW_SCRIPT_ERRORS_TOOLTIP                     },
                { LSU.Locales.SHOW_TARGET_OF_TARGET,                 "NewCharacter.ShowTargetOfTarget.Enabled",                LSU.Locales.SHOW_TARGET_OF_TARGET_TOOLTIP                  },
                { LSU.Locales.SHOW_TUTORIALS,                        "NewCharacter.ShowTutorials.Enabled",                     LSU.Locales.SHOW_TUTORIALS_TOOLTIP                         },
                { LSU.Locales.SOFT_TARGET_ENEMY,                     "NewCharacter.SoftTargetEnemy.Enabled",                   LSU.Locales.SOFT_TARGET_ENEMY_TOOLTIP                      },
                { LSU.Locales.SPELLBOOK_HIDE_PASSIVES,               "NewCharacter.SpellBookHidePassives.Enabled",             LSU.Locales.SPELLBOOK_HIDE_PASSIVES_TOOLTIP                },
            }

            checkboxes = {}
            for i, data in ipairs(newCharacterModuleCheckboxData) do
                local col = ((i-1) % 3) + 1
                local row = math.floor((i-1) / 3) + 1

                local cb = LSU.NewCheckbox({
                    id = "_NCC"..i,
                    parent = scrollChild,
                    label = data[1],
                    savedVarKey = data[2],
                    tooltipText = data[3],
                })
                local x = startX + (col-1)*columnWidth
                local y = startY - (row-1)*rowHeight
                cb:SetPoint("TOPLEFT", warbandMapButton, "BOTTOMLEFT", (x-20), y)
                cb:Show()
                checkboxes[i] = cb
            end

            local editModeLayoutDropdown = LSU.NewRadioDropdown({
                parent = scrollChild,
                label = LSU.Locales.EDIT_MODE_LAYOUT,
                tooltipText = LSU.Locales.EDIT_MODE_LAYOUT_TOOLTIP,
                savedVarKey = "EditModeLayoutID",
                options = LSUDB.EditModeLayouts
            })
            editModeLayoutDropdown:SetPoint("TOPLEFT", checkboxes[28], "BOTTOMLEFT", 0, -30)
            editModeLayoutDropdown:SetText(LSUDB.EditModeLayouts[LSUDB.Settings["EditModeLayoutID"]][1])
            editModeLayoutDropdown:Show()

            lastWidget = editModeLayoutDropdown
            scrollChild:SetSize(scrollFrame:GetWidth()-20, math.abs(lastWidget:GetBottom() - scrollChild:GetTop()) + 30)
        else
            frame:Show()
        end
    end
end

SLASH_LIGHTSKYUNIVERSAL1 = LSU.Locales.SLASH_COMMAND1
SLASH_LIGHTSKYUNIVERSAL2 = LSU.Locales.SLASH_COMMAND2
SlashCmdList["LIGHTSKYUNIVERSAL"] = SlashHandler