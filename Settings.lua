local addonName, addonTable = ...
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

            frame:SetTitle(addonTable.Locales.ADDON_TITLE .. " " .. addonTable.Locales.SETTINGS)

            local discordLinkDialog = "LSU_SETTINGS_DISCORD_LINK_DIALOG"
            addonTable.NewStaticPopup(
                discordLinkDialog,
                addonTable.Locales.USE_CTRLC_TO_COPY_THE_LINK_BELOW,
                {
                    button1Text = DONE,
                    hasEditBox = 1,
                    onShow = function(self)
                        self.editBox:SetText("https://discord.gg/2Q3DKhu9HT")
                        self.editBox:HighlightText()
                        self.editBox:SetScript("OnKeyUp", function(_, key)
                            if IsControlKeyDown() and key == "C" then StaticPopup_Hide(discordLinkDialog) end
                        end)
                    end,
                }
            )
            local discordButton = addonTable.NewBasicButton({
                name = "LSUDiscordButton",
                parent = frame,
                width = 120,
                height = 25,
                label = addonTable.Locales.DISCORD
            })
            discordButton:SetPoint("TOP", frame, "TOP", -65, -30)
            discordButton:SetScript("OnClick", function()
                StaticPopup_Show(discordLinkDialog)
            end)

            local donateLinkDialog = "LSU_SETTINGS_DONATE_LINK_DIALOG"
            addonTable.NewStaticPopup(
                donateLinkDialog,
                addonTable.Locales.USE_CTRLC_TO_COPY_THE_LINK_BELOW,
                {
                    button1Text = DONE,
                    hasEditBox = 1,
                    onShow = function(self)
                        self.editBox:SetText("https://linktr.ee/lightskygg")
                        self.editBox:HighlightText()
                        self.editBox:SetScript("OnKeyUp", function(_, key)
                            if IsControlKeyDown() and key == "C" then StaticPopup_Hide(donateLinkDialog) end
                        end)
                    end,
                }
            )
            local donateButton = addonTable.NewBasicButton({
                name = "LSUDonateButton",
                parent = frame,
                width = 120,
                height = 25,
                label = addonTable.Locales.DONATE
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
            generalModulesFS:SetText(addonTable.Locales.GENERAL_MODULES)
            generalModulesFS:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 20, -30)

            local checkboxData = {
                { addonTable.Locales.ACCEPT_QUESTS,     "AcceptQuests.Enabled",    addonTable.Locales.ACCEPT_QUESTS_TOOLTIP      },
                { addonTable.Locales.AUTO_REPAIR,       "AutoRepair.Enabled",      addonTable.Locales.AUTO_REPAIR_TOOLTIP        },
                { addonTable.Locales.AUTO_SHARE_QUESTS, "AutoShareQuests.Enabled", addonTable.Locales.AUTO_SHARE_QUESTS_TOOLTIP  },
                { addonTable.Locales.AUTO_TRAIN,        "AutoTrain.Enabled",       addonTable.Locales.AUTO_TRAIN_TOOLTIP         },
                { addonTable.Locales.BUY_QUEST_ITEMS,   "BuyQuestItems.Enabled",   addonTable.Locales.BUY_QUEST_ITEMS_TOOLTIP    },
                { addonTable.Locales.COMPLETE_QUESTS,   "CompleteQuests.Enabled",  addonTable.Locales.COMPLETE_QUESTS_TOOLTIP    },
                { addonTable.Locales.NEW_CHARACTER,     "NewCharacter.Enabled",    addonTable.Locales.NEW_CHARACTER_TOOLTIP,
                  function(state)
                    if state then
                        addonTable.ConfigureNewCharacter()
                    end
                  end
                },
                { addonTable.Locales.PLAYER_TALENTS,    "PlayerTalents.Enabled",   addonTable.Locales.PLAYER_TALENTS_TOOLTIP  },
                { addonTable.Locales.QUEST_REWARDS,     "QuestRewards.Enabled",    addonTable.Locales.QUEST_REWARDS_TOOLTIP   },
                { addonTable.Locales.SKIP_CINEMATICS,   "SkipCinematics.Enabled",  addonTable.Locales.SKIP_CINEMATICS_TOOLTIP },
                { addonTable.Locales.TALKING_HEAD,      "TalkingHead.Disabled",    addonTable.Locales.TALKING_HEAD_TOOLTIP    },
            }

            local columnWidth = 180
            local rowHeight = 25 + ySpacing
            local startX = 20
            local startY = -10
            local checkboxes = {}
            for i, data in ipairs(checkboxData) do
                local col = ((i-1) % 3) + 1
                local row = math.floor((i-1) / 3) + 1

                local cb = addonTable.NewCheckbox({
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

            -- QUESTS --
            local questModuleFontString = scrollChild:CreateFontString()
            questModuleFontString:SetFontObject("ChatBubbleFont")
            questModuleFontString:SetText(addonTable.Locales.QUESTS)
            questModuleFontString:SetPoint("TOPLEFT", checkboxes[10], "BOTTOMLEFT", -20, -50)

            local adventureMapsDropdown = addonTable.NewCheckboxDropdown({
                parent = scrollChild,
                label = addonTable.Locales.ADVENTURE_MAPS,
                tooltipText = addonTable.Locales.ADVENTURE_MAPS_TOOLTIP,
                savedVarTable = "AdventureMaps",
                options = {
                    -- The first entry in the value table is the continent map ID used in the Adventure Map.
                    -- The second is the quest ID.
                    { addonTable.GetQuestIconByID(83548) .. addonTable.Locales.ZONE_ISLE_OF_DORN,       {2276, 83548} },
                    { addonTable.GetQuestIconByID(83550) .. addonTable.Locales.ZONE_THE_RINGING_DEEPS,  {2276, 83550} },
                    { addonTable.GetQuestIconByID(83551) .. addonTable.Locales.ZONE_HALLOWFALL,         {2276, 83551} },
                    { addonTable.GetQuestIconByID(83552) .. addonTable.Locales.ZONE_AZJ_KAHET,          {2276, 83552} },
                    { addonTable.GetQuestIconByID(72266) .. addonTable.Locales.ZONE_THE_WAKING_SHORES,  {2057, 72266} },
                    { addonTable.GetQuestIconByID(72267) .. addonTable.Locales.ZONE_OHNAHRAN_PLAINS,    {2057, 72267} },
                    { addonTable.GetQuestIconByID(72268) .. addonTable.Locales.ZONE_THE_AZURE_SPAN,     {2057, 72268} },
                    { addonTable.GetQuestIconByID(72269) .. addonTable.Locales.ZONE_THALDRASZUS,        {2057, 72269} },
                    { addonTable.GetQuestIconByID(62275) .. addonTable.Locales.ZONE_BASTION,            {1550, 62275} },
                    { addonTable.GetQuestIconByID(62278) .. addonTable.Locales.ZONE_MALDRAXXUS,         {1550, 62278} },
                    { addonTable.GetQuestIconByID(62277) .. addonTable.Locales.ZONE_ARDENWEALD,         {1550, 62277} },
                    { addonTable.GetQuestIconByID(62279) .. addonTable.Locales.ZONE_REVENDRETH,         {1550, 62279} },
                }
            })
            adventureMapsDropdown:SetPoint("TOPLEFT", questModuleFontString, "BOTTOMLEFT", 20, -10)
            adventureMapsDropdown.label:Hide()
            adventureMapsDropdown:Show()
            ------------

            local gossipModuleFS = scrollChild:CreateFontString()
            gossipModuleFS:SetFontObject("ChatBubbleFont")
            gossipModuleFS:SetText(addonTable.Locales.GOSSIP_MODULE)
            gossipModuleFS:SetPoint("TOPLEFT", questModuleFontString, "BOTTOMLEFT", 0, -120)

            local openGossipsFrameButton = addonTable.NewBasicButton({
                name = "LSUOpenGossipsFrameButton",
                parent = scrollChild,
                width = 120,
                height = 25,
                label = addonTable.Locales.OPEN_GOSSIPS
            })
            openGossipsFrameButton:SetPoint("TOPLEFT", gossipModuleFS, "BOTTOMLEFT", 20, -10)
            openGossipsFrameButton:SetScript("OnClick", function()
                frame:Hide()
                addonTable.OpenGossipFrame()
            end)

            local gossipCheckbox = addonTable.NewCheckbox({
                id = 20,
                parent = scrollChild,
                label = addonTable.Locales.GOSSIP,
                savedVarKey = "Gossip.Enabled",
                tooltipText = addonTable.Locales.GOSSIP_TOOLTIP
            })
            gossipCheckbox:SetPoint("TOPLEFT", openGossipsFrameButton, "BOTTOMLEFT", 0, -10)

            local chromieTimeModuleFS = scrollChild:CreateFontString()
            chromieTimeModuleFS:SetFontObject("ChatBubbleFont")
            chromieTimeModuleFS:SetText(addonTable.Locales.CHROMIE_TIME_MODULE)
            chromieTimeModuleFS:SetPoint("TOPLEFT", gossipModuleFS, "BOTTOMLEFT", 0, -125)

            local chromieTimeDropdown = addonTable.NewRadioDropdown({
                parent = scrollChild,
                label = addonTable.Locales.CHROMIE_TIME,
                tooltipText = addonTable.Locales.CHROMIE_TIME_TOOLTIP,
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
            chromieTimeDropdown:SetText(addonTable.Enum.Expansions[LSUDB.Settings["ChromieTimeExpansionID"]] or DISABLE)
            chromieTimeDropdown.label:Hide()
            chromieTimeDropdown:Show()

            -- RARES --
            local raresFontString = scrollChild:CreateFontString()
            raresFontString:SetFontObject("ChatBubbleFont")
            raresFontString:SetText(addonTable.Locales.RARES)
            raresFontString:SetPoint("TOPLEFT", chromieTimeDropdown, "BOTTOMLEFT", -20, -50)

            local raresCheckbox = addonTable.NewCheckbox({
                id = 20,
                parent = scrollChild,
                label = addonTable.Locales.RARES,
                savedVarKey = "Rares.Enabled",
                tooltipText = addonTable.Locales.RARES_TOOLTIP
            })
            raresCheckbox:SetPoint("TOPLEFT", raresFontString, "BOTTOMLEFT", 20, -10)

            local rareNotificationDropdown = addonTable.NewRadioDropdown({
                parent = scrollChild,
                label = addonTable.Locales.RARES,
                tooltipText = addonTable.Locales.RARES_DD_TOOLTIP,
                savedVarKey = "Rares.NotificationSoundID",
                options = {
                    { DISABLE, 0 },
                    { addonTable.Locales.RARES_DD_OPTION1, 17318 },
                    { addonTable.Locales.RARES_DD_OPTION2, SOUNDKIT.MAP_PING },
                    { addonTable.Locales.RARES_DD_OPTION3, SOUNDKIT.ALARM_CLOCK_WARNING_3 },
                },
                setSelectedFunc = function(value)
                    LSUDB.Settings["Rares.NotificationSoundID"] = value
                    PlaySound(value, "Master")
                end,
            })
            rareNotificationDropdown:SetPoint("TOPLEFT", raresCheckbox, "BOTTOMLEFT", 0, -10)
            rareNotificationDropdown.label:Hide()
            rareNotificationDropdown:Show()
            -----------

            -- NEW CHARACTER --
            local newCharacterModuleFS = scrollChild:CreateFontString()
            newCharacterModuleFS:SetFontObject("ChatBubbleFont")
            newCharacterModuleFS:SetText(addonTable.Locales.NEW_CHARACTER_MODULE)
            newCharacterModuleFS:SetPoint("TOPLEFT", rareNotificationDropdown, "BOTTOMLEFT", -20, -50)

            local warbandMapButton = addonTable.NewInsecureBasicButton({
                name = "LSUUseWarbandMapButton",
                parent = scrollChild,
                width = 120,
                height = 25,
                attributeType = "spell",
                attributeValue = 431280,
                label = addonTable.Locales.WARBAND_MAP
            })
            warbandMapButton:SetPoint("TOPLEFT", newCharacterModuleFS, "BOTTOMLEFT", 20, -10)
            warbandMapButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(addonTable.Locales.ADDON_TITLE)
                GameTooltip:AddLine(addonTable.Locales.WARBAND_MAP_TOOLTIP, 1, 1, 1, 1, true)
                GameTooltip:Show()
            end)
            warbandMapButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

            local wipeConfigurationButton = addonTable.NewBasicButton({
                name = "LSUWipeNCCButton",
                parent = scrollChild,
                width = 130,
                height = 25,
                label = addonTable.Locales.WIPE_CONFIGURATION
            })
            wipeConfigurationButton:SetPoint("LEFT", warbandMapButton, "RIGHT", 10, 0)
            wipeConfigurationButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(addonTable.Locales.ADDON_TITLE)
                GameTooltip:AddLine(addonTable.Locales.WIPE_CONFIGURATION_TOOLTIP, 1, 1, 1, 1, true)
                GameTooltip:Show()
            end)
            wipeConfigurationButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
            wipeConfigurationButton:SetScript("OnClick", function(_, button)
                local found = false
                if button == "LeftButton" then
                    for guid, _ in pairs(LSUDB.Characters) do
                        if guid == addonTable.Player["GUID"] then
                            LSUDB.Characters[guid] = nil
                            found = true
                            break
                        end
                    end

                    if found then
                        local nccWipeCompleteDialog = "LSU_NewCharacterWiped"
                        addonTable.NewStaticPopup(
                            nccWipeCompleteDialog,
                            addonTable.Locales.NEW_CHARACTER_WIPED,
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
                            addonTable.NewStaticPopup(
                                nccWipeAllCompleteDialog,
                                addonTable.Locales.NEW_CHARACTER_ALL_WIPED,
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
                { addonTable.Locales.ALWAYS_COMPARE_ITEMS,                  "NewCharacter.AlwaysCompareItems.Enabled",                addonTable.Locales.ALWAYS_COMPARE_ITEMS_TOOLTIP                   },
                { addonTable.Locales.ALWAYS_SHOW_ACTION_BARS,               "NewCharacter.AlwaysShowActionBars.Enabled",              addonTable.Locales.ALWAYS_SHOW_ACTION_BARS_TOOLTIP                },
                { addonTable.Locales.ARACHNOPHOBIA_MODE,                    "NewCharacter.ArachnophobiaMode.Enabled",                 addonTable.Locales.ARACHNOPHOBIA_MODE_TOOLTIP                     },
                { addonTable.Locales.ASSISTED_COMBAT_HIGHLIGHT,             "NewCharacter.AssistedCombatHighlight.Enabled",           addonTable.Locales.ASSISTED_COMBAT_HIGHLIGHT_TOOLTIP              },
                { addonTable.Locales.AUTO_DISMOUNT_FLYING,                  "NewCharacter.AutoDismountFlying.Enabled",                addonTable.Locales.AUTO_DISMOUNT_FLYING_TOOLTIP                   },
                { addonTable.Locales.AUTO_INTERACT,                         "NewCharacter.AutoInteract.Enabled",                      addonTable.Locales.AUTO_INTERACT_TOOLTIP                          },
                { addonTable.Locales.AUTO_LOOT ,                            "NewCharacter.AutoLootDefault.Enabled",                   addonTable.Locales.AUTO_LOOT_TOOLTIP                              },
                { addonTable.Locales.AUTO_PUSH_SPELLS_TO_ACTION_BAR,        "NewCharacter.AutoPushSpellToActionBar.Enabled",          addonTable.Locales.AUTO_PUSH_SPELLS_TO_ACTION_BAR_TOOLTIP         },
                { addonTable.Locales.CLEAR_ALL_TRACKING,                    "NewCharacter.ClearAllTracking.Enabled",                  addonTable.Locales.CLEAR_ALL_TRACKING_TOOLTIP                     },
                { addonTable.Locales.COOLDOWN_VIEWER,                       "NewCharacter.CooldownViewer.Enabled",                    addonTable.Locales.COOLDOWN_VIEWER_TOOLTIP                        },
                { addonTable.Locales.DISABLE_SKYRIDING_FULL_SCREEN_EFFECTS, "NewCharacter.DisableSkyridingFullScreenEffects.Enabled", addonTable.Locales.DISABLE_SKYRIDING_FULL_SCREEN_EFFECTS_TOOLTIP  },
                { addonTable.Locales.DISABLE_SKYRIDING_VELOCITY_VFX,        "NewCharacter.DisableSkyridingVelocityVFX.Enabled",       addonTable.Locales.DISABLE_SKYRIDING_VELOCITY_VFX_TOOLTIP         },
                { addonTable.Locales.DISABLE_USER_ADDONS_BY_DEFAULT,        "NewCharacter.DisableUserAddonsByDefault.Enabled",        addonTable.Locales.DISABLE_USER_ADDONS_BY_DEFAULT_TOOLTIP         },
                { addonTable.Locales.ENABLE_FLOATING_COMBAT_TEXT,           "NewCharacter.EnableFloatingCombatText.Enabled",          addonTable.Locales.ENABLE_FLOATING_COMBAT_TEXT_TOOLTIP            },
                { addonTable.Locales.DISABLE_FOOTSTEP_SOUNDS,               "NewCharacter.FootstepSounds.Enabled",                    addonTable.Locales.DISABLE_FOOTSTEP_SOUNDS_TOOLTIP                },
                { addonTable.Locales.LOOT_UNDER_MOUSE,                      "NewCharacter.LootUnderMouse.Enabled",                    addonTable.Locales.LOOT_UNDER_MOUSE_TOOLTIP                       },
                { addonTable.Locales.MOUNT_JOURNAL_SHOW_PLAYER,             "NewCharacter.MountJournalShowPlayer.Enabled",            addonTable.Locales.MOUNT_JOURNAL_SHOW_PLAYER_TOOLTIP              },
                { addonTable.Locales.OCCLUDED_SILHOUETTE_PLAYER,            "NewCharacter.OccludedSilhouettePlayer.Enabled",          addonTable.Locales.OCCLUDED_SILHOUETTE_PLAYER_TOOLTIP             },
                { addonTable.Locales.PROFANITY_FILTER,                      "NewCharacter.ProfanityFilter.Enabled",                   addonTable.Locales.PROFANITY_FILTER_TOOLTIP                       },
                { addonTable.Locales.PVP_FRAMES_DISPLAY_CLASS_COLOR,        "NewCharacter.PvPFramesDisplayClassColor.Enabled",        addonTable.Locales.PVP_FRAMES_DISPLAY_CLASS_COLOR_TOOLTIP         },
                { addonTable.Locales.QUEST_TEXT_CONTRAST,                   "NewCharacter.QuestTextContrast.Enabled",                 addonTable.Locales.QUEST_TEXT_CONTRAST_TOOLTIP                    },
                { addonTable.Locales.RAID_FRAMES_DISPLAY_CLASS_COLOR,       "NewCharacter.RaidFramesDisplayClassColor.Enabled",       addonTable.Locales.RAID_FRAMES_DISPLAY_CLASS_COLOR_TOOLTIP        },
                { addonTable.Locales.REPLACE_MY_PLAYER_PORTRAIT,            "NewCharacter.ReplaceMyPlayerPortrait.Enabled",           addonTable.Locales.REPLACE_MY_PLAYER_PORTRAIT_TOOLTIP             },
                { addonTable.Locales.REPLACE_OTHER_PLAYER_PORTRAITS,        "NewCharacter.ReplaceOtherPlayerPortraits.Enabled",       addonTable.Locales.REPLACE_OTHER_PLAYER_PORTRAITS_TOOLTIP         },
                { addonTable.Locales.SHOW_SCRIPT_ERRORS,                    "NewCharacter.ShowScriptErrors.Enabled",                  addonTable.Locales.SHOW_SCRIPT_ERRORS_TOOLTIP                     },
                { addonTable.Locales.SHOW_TARGET_OF_TARGET,                 "NewCharacter.ShowTargetOfTarget.Enabled",                addonTable.Locales.SHOW_TARGET_OF_TARGET_TOOLTIP                  },
                { addonTable.Locales.SHOW_TUTORIALS,                        "NewCharacter.ShowTutorials.Enabled",                     addonTable.Locales.SHOW_TUTORIALS_TOOLTIP                         },
                { addonTable.Locales.SOFT_TARGET_ENEMY,                     "NewCharacter.SoftTargetEnemy.Enabled",                   addonTable.Locales.SOFT_TARGET_ENEMY_TOOLTIP                      },
                { addonTable.Locales.SPELLBOOK_HIDE_PASSIVES,               "NewCharacter.SpellBookHidePassives.Enabled",             addonTable.Locales.SPELLBOOK_HIDE_PASSIVES_TOOLTIP                },
            }

            -- New Character Configuration
            checkboxes = {}
            for i, data in ipairs(newCharacterModuleCheckboxData) do
                local col = ((i-1) % 3) + 1
                local row = math.floor((i-1) / 3) + 1

                local cb = addonTable.NewCheckbox({
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

            -- Action Bars
            for i = 2, 8 do
                local idx = i - 2
                local col = ((idx) % 3) + 1
                local row = math.floor(idx / 3) + 1

                local cb = addonTable.NewCheckbox({
                    id = "_NCC_ActionBar"..i,
                    parent = scrollChild,
                    label = addonTable.Locales.ACTION_BAR .. " " .. i,
                    savedVarKey = "NewCharacter.ActionBar" .. i .. ".Enabled",
                    tooltipText = string.format(addonTable.Locales.ACTION_BAR_TOOLTIP, i),
                })
                local x = startX + (col-1)*columnWidth
                local y = startY - (row-1)*rowHeight
                cb:SetPoint("TOPLEFT", LSUCheckButton_NCC28, "BOTTOMLEFT", (x-20), y)
                cb:Show()
            end

            local editModeLayoutDropdown = addonTable.NewRadioDropdown({
                parent = scrollChild,
                label = addonTable.Locales.EDIT_MODE_LAYOUT,
                tooltipText = addonTable.Locales.EDIT_MODE_LAYOUT_TOOLTIP,
                savedVarKey = "EditModeLayoutID",
                options = LSUDB.EditModeLayouts
            })
            --editModeLayoutDropdown:SetPoint("TOPLEFT", checkboxes[28], "BOTTOMLEFT", 0, -30)
            editModeLayoutDropdown:SetPoint("TOPLEFT", LSUCheckButton_NCC_ActionBar8, "BOTTOMLEFT", 0, -30)
            editModeLayoutDropdown:SetText(LSUDB.EditModeLayouts[LSUDB.Settings["EditModeLayoutID"]][1])
            editModeLayoutDropdown:Show()
            -------------------

            lastWidget = editModeLayoutDropdown
            scrollChild:SetSize(scrollFrame:GetWidth()-20, math.abs(lastWidget:GetBottom() - scrollChild:GetTop()) + 30)
        else
            frame:Show()
        end
    end
end

SLASH_LIGHTSKYUNIVERSAL1 = addonTable.Locales.SLASH_COMMAND1
SLASH_LIGHTSKYUNIVERSAL2 = addonTable.Locales.SLASH_COMMAND2
SlashCmdList["LIGHTSKYUNIVERSAL"] = SlashHandler