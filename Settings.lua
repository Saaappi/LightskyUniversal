local addonName, LSU = ...
local L = LSU.L
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

            frame:SetTitle(L.TITLE_ADDON .. " " .. L.TITLE_SETTINGS)

            local discordLinkDialog = "LSU_SETTINGS_DISCORD_LINK_DIALOG"
            StaticPopupDialogs[discordLinkDialog] = {
                text = L.LABEL_POPUP_CTRLC_COPY,
                button1 = DONE,
                hasEditBox = 1,
                OnShow = function(self)
                    self.editBox:SetText("https://discord.gg/2Q3DKhu9HT")
                    self.editBox:HighlightText()
                end,
                EditBoxOnEnterPressed = function(self)
                    self:GetParent():Hide()
                end,
                EditBoxOnEscapePressed = StaticPopup_StandardEditBoxOnEscapePressed,
                editBoxWidth = 230,
                timeout = 0,
                hideOnEscape = 1,
            }
            local discordButton = LSU.NewBasicButton({
                name = "LSUDiscordButton",
                parent = frame,
                width = 120,
                height = 25,
                label = L.LABEL_DISCORD
            })
            discordButton:SetPoint("TOP", frame, "TOP", -65, -30)
            discordButton:SetScript("OnClick", function()
                StaticPopup_Show(discordLinkDialog)
            end)

            local donateLinkDialog = "LSU_SETTINGS_DONATE_LINK_DIALOG"
            StaticPopupDialogs[donateLinkDialog] = {
                text = L.LABEL_POPUP_CTRLC_COPY,
                button1 = DONE,
                hasEditBox = 1,
                OnShow = function(self)
                    self.editBox:SetText("https://linktr.ee/lightskygg")
                    self.editBox:HighlightText()
                end,
                EditBoxOnEnterPressed = function(self)
                    self:GetParent():Hide()
                end,
                EditBoxOnEscapePressed = StaticPopup_StandardEditBoxOnEscapePressed,
                editBoxWidth = 230,
                timeout = 0,
                hideOnEscape = 1,
            }
            local donateButton = LSU.NewBasicButton({
                name = "LSUDonateButton",
                parent = frame,
                width = 120,
                height = 25,
                label = L.LABEL_DONATE
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
            generalModulesFS:SetText(L.HEADER_GENERAL_MODULES)
            generalModulesFS:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 20, -30)

            local checkboxData = {
                {L.LABEL_ACCEPT_QUESTS,         "AcceptQuests.Enabled",    L.TOOLTIP_ACCEPT_QUESTS},
                {L.LABEL_AUTO_REPAIR,           "AutoRepair.Enabled",      L.TOOLTIP_AUTO_REPAIR},
                {L.LABEL_AUTO_TRAIN,            "AutoTrain.Enabled",       L.TOOLTIP_AUTO_TRAIN},
                {L.LABEL_BUY_QUEST_ITEMS,       "BuyQuestItems.Enabled",   L.TOOLTIP_BUY_QUEST_ITEMS},
                {L.LABEL_COMPLETE_QUESTS,       "CompleteQuests.Enabled",  L.TOOLTIP_COMPLETE_QUESTS},
                {L.LABEL_PLAYER_TALENTS,        "PlayerTalents.Enabled",   L.TOOLTIP_PLAYER_TALENTS},
                {L.LABEL_QUEST_REWARDS,         "QuestRewards.Enabled",    L.TOOLTIP_QUEST_REWARDS},
                {L.LABEL_RARES,                 "Rares.Enabled",           L.TOOLTIP_RARES},
                {L.LABEL_SKIP_CINEMATICS,       "SkipCinematics.Enabled",  L.TOOLTIP_SKIP_CINEMATICS},
                {L.LABEL_NEW_CHARACTER,         "NewCharacter.Enabled",    L.TOOLTIP_NEW_CHARACTER},
                {LSU.Locales.AUTO_SHARE_QUESTS, "AutoShareQuests.Enabled", LSU.Locales.AUTO_SHARE_QUESTS_TOOLTIP},
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
                    id = i,
                    parent = scrollChild,
                    label = data[1],
                    savedVarKey = data[2],
                    tooltipText = data[3],
                })
                local x = startX + (col-1)*columnWidth
                local y = startY - (row-1)*rowHeight
                cb:SetPoint("TOPLEFT", generalModulesFS, "BOTTOMLEFT", x, y)
                cb:Show()
                checkboxes[i] = cb
            end

            local gossipModuleFS = scrollChild:CreateFontString()
            gossipModuleFS:SetFontObject("ChatBubbleFont")
            gossipModuleFS:SetText(L.HEADER_GOSSIP_MODULE)
            gossipModuleFS:SetPoint("TOPLEFT", checkboxes[10], "BOTTOMLEFT", -20, -50)

            local openGossipsFrameButton = LSU.NewBasicButton({
                name = "LSUOpenGossipsFrameButton",
                parent = scrollChild,
                width = 120,
                height = 25,
                label = L.LABEL_OPEN_GOSSIPS
            })
            openGossipsFrameButton:SetPoint("TOPLEFT", gossipModuleFS, "BOTTOMLEFT", 20, -10)
            openGossipsFrameButton:SetScript("OnClick", function()
                frame:Hide()
                LSU.OpenGossipFrame()
            end)

            local gossipCheckbox = LSU.NewCheckbox({
                id = 20,
                parent = scrollChild,
                label = L.LABEL_GOSSIP,
                savedVarKey = "Gossip.Enabled",
                tooltipText = L.TOOLTIP_GOSSIP
            })
            gossipCheckbox:SetPoint("TOPLEFT", openGossipsFrameButton, "BOTTOMLEFT", 0, -10)

            local chromieTimeModuleFS = scrollChild:CreateFontString()
            chromieTimeModuleFS:SetFontObject("ChatBubbleFont")
            chromieTimeModuleFS:SetText(L.HEADER_CHROMIE_TIME_MODULE)
            chromieTimeModuleFS:SetPoint("TOPLEFT", gossipModuleFS, "BOTTOMLEFT", 0, -125)

            local chromieTimeDropdown = LSU.NewRadioDropdown({
                parent = scrollChild,
                label = L.LABEL_CHROMIE_TIME,
                tooltipText = L.TOOLTIP_CHROMIE_TIME,
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
            newCharacterModuleFS:SetText(L.HEADER_NEW_CHARACTER_MODULE)
            newCharacterModuleFS:SetPoint("TOPLEFT", chromieTimeDropdown, "BOTTOMLEFT", -20, -50)

            local warbandMapButton = LSU.NewInsecureBasicButton({
                name = "LSUUseWarbandMapButton",
                parent = scrollChild,
                width = 120,
                height = 25,
                attributeType = "spell",
                attributeValue = 431280,
                label = L.LABEL_WARBAND_MAP_TO_EVERYWHERE_ALL_AT_ONCE
            })
            warbandMapButton:SetPoint("TOPLEFT", newCharacterModuleFS, "BOTTOMLEFT", 20, -10)
            warbandMapButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(L.TITLE_ADDON)
                GameTooltip:AddLine(L.TOOLTIP_WARBAND_MAP_TO_EVERYWHERE_ALL_AT_ONCE, 1, 1, 1, 1, true)
                GameTooltip:Show()
            end)
            warbandMapButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

            local wipeCharacterButton = LSU.NewBasicButton({
                name = "LSUWipeCharacterAsNewCharacterButton",
                parent = scrollChild,
                width = 120,
                height = 25,
                label = L.LABEL_WIPE_CHARACTER
            })
            wipeCharacterButton:SetPoint("LEFT", warbandMapButton, "RIGHT", 10, 0)
            wipeCharacterButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(L.TITLE_ADDON)
                GameTooltip:AddLine(L.TOOLTIP_NEW_CHARACTER_WIPE_BUTTON, 1, 1, 1, 1, true)
                GameTooltip:Show()
            end)
            wipeCharacterButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
            wipeCharacterButton:SetScript("OnClick", function()
                local found = false
                for guid, _ in pairs(LSUDB.Characters) do
                    if guid == LSU.Character["GUID"] then
                        LSUDB.Characters[guid] = nil
                        found = true
                        break
                    end
                end

                if found then
                    StaticPopupDialogs["LSU_NewCharacterWiped"] = {
                        text = L.POPUP_NEW_CHARACTER_WIPED,
                        button1 = YES,
                        button2 = NO,
                        explicitAcknowledge = true,
                        OnAccept = function()
                            C_UI.Reload()
                        end,
                        OnCancel = function() end,
                        preferredIndex = 3
                    }
                    StaticPopup_Show("LSU_NewCharacterWiped")
                end
            end)

            local newCharacterModuleCheckboxData = {
                {L.LABEL_ALWAYS_COMPARE_ITEMS, "NewCharacter.AlwaysCompareItems.Enabled", L.TOOLTIP_ALWAYS_COMPARE_ITEMS},
                {L.LABEL_ALWAYS_SHOW_ACTION_BARS, "NewCharacter.AlwaysShowActionBars.Enabled", L.TOOLTIP_ALWAYS_SHOW_ACTION_BARS},
                {L.LABEL_ARACHNOPHOBIA_MODE, "NewCharacter.ArachnophobiaMode.Enabled", L.TOOLTIP_ARACHNOPHOBIA_MODE},
                {L.LABEL_ASSISTED_COMBAT_HIGHLIGHT, "NewCharacter.AssistedCombatHighlight.Enabled", L.TOOLTIP_ASSISTED_COMBAT_HIGHLIGHT},
                {L.LABEL_AUTO_DISMOUNT_FLYING, "NewCharacter.AutoDismountFlying.Enabled", L.TOOLTIP_AUTO_DISMOUNT_FLYING},
                {L.LABEL_AUTO_INTERACT, "NewCharacter.AutoInteract.Enabled", L.TOOLTIP_AUTO_INTERACT},
                {L.LABEL_AUTO_LOOT , "NewCharacter.AutoLootDefault.Enabled", L.TOOLTIP_AUTO_LOOT_DEFAULT},
                {L.LABEL_AUTO_PUSH_SPELLS_TO_ACTION_BAR, "NewCharacter.AutoPushSpellToActionBar.Enabled", L.TOOLTIP_AUTO_PUSH_SPELLS_TO_ACTION_BAR},
                {L.LABEL_CLEAR_ALL_TRACKING, "NewCharacter.ClearAllTracking.Enabled", L.TOOLTIP_CLEAR_ALL_TRACKING},
                {L.LABEL_COOLDOWN_VIEWER, "NewCharacter.CooldownViewer.Enabled", L.TOOLTIP_COOLDOWN_VIEWER},
                {L.LABEL_DISABLE_SKYRIDING_FULL_SCREEN, "NewCharacter.DisableSkyridingFullScreenEffects.Enabled", L.TOOLTIP_DISABLE_SKYRIDING_FULL_SCREEN_EFFECT},
                {L.LABEL_DISABLE_SKYRIDING_VELOCITY_VFX, "NewCharacter.DisableSkyridingVelocityVFX.Enabled", L.TOOLTIP_DISABLE_SKYRIDING_VFX},
                {L.LABEL_DISABLE_USER_ADDONS_BY_DEFAULT, "NewCharacter.DisableUserAddonsByDefault.Enabled", L.TOOLTIP_DISABLE_USER_ADDONS_BY_DEFAULT},
                {L.LABEL_ENABLE_FLOATING_COMBAT_TEXT, "NewCharacter.EnableFloatingCombatText.Enabled", L.TOOLTIP_ENABLE_FLOATING_COMBAT_TEXT},
                {L.LABEL_DISABLE_FOOTSTEP_SOUNDS, "NewCharacter.FootstepSounds.Enabled", L.TOOLTIP_DISABLE_FOOTSTEP_SOUNDS},
                {L.LABEL_LOOT_UNDER_MOUSE, "NewCharacter.LootUnderMouse.Enabled", L.TOOLTIP_LOOT_UNDER_MOUSE},
                {L.LABEL_MOUNT_JOURNAL_SHOW_PLAYER, "NewCharacter.MountJournalShowPlayer.Enabled", L.TOOLTIP_MOUNT_JOURNAL_SHOWS_PLAYER},
                {L.LABEL_OCCLUDED_SILHOUETTE_PLAYER, "NewCharacter.OccludedSilhouettePlayer.Enabled", L.TOOLTIP_OCCLUDED_SILHOUETTE_PLAYER},
                {L.LABEL_ENABLE_PROFANITY_FILTER, "NewCharacter.ProfanityFilter.Enabled", L.TOOLTIP_ENABLE_PROFANITY_FILTER},
                {L.LABEL_PVP_FRAMES_DISPLAY_CLASS_COLOR, "NewCharacter.PvPFramesDisplayClassColor.Enabled", L.TOOLTIP_PVP_FRAMES_DISPLAY_CLASS_COLOR},
                {L.LABEL_QUEST_TEXT_CONTRAST, "NewCharacter.QuestTextContrast.Enabled", L.TOOLTIP_QUEST_TEXT_CONTRAST},
                {L.LABEL_RAID_FRAMES_DISPLAY_CLASS_COLOR, "NewCharacter.RaidFramesDisplayClassColor.Enabled", L.TOOLTIP_RAID_FRAMES_DISPLAY_CLASS_COLOR},
                {L.LABEL_REPLACE_MY_PLAYER_PORTRAIT, "NewCharacter.ReplaceMyPlayerPortrait.Enabled", L.TOOLTIP_REPLACE_MY_PLAYER_PORTRAIT},
                {L.LABEL_REPLACE_OTHER_PLAYER_PORTRAITS, "NewCharacter.ReplaceOtherPlayerPortraits.Enabled", L.TOOLTIP_REPLACE_OTHER_PLAYER_PORTRAITS},
                {L.LABEL_SHOW_SCRIPT_ERRORS, "NewCharacter.ShowScriptErrors.Enabled", L.TOOLTIP_SHOW_SCRIPT_ERRORS},
                {L.LABEL_SHOW_TARGET_OF_TARGET, "NewCharacter.ShowTargetOfTarget.Enabled", L.TOOLTIP_SHOW_TARGET_OF_TARGET},
                {L.LABEL_SHOW_TUTORIALS, "NewCharacter.ShowTutorials.Enabled", L.TOOLTIP_SHOW_TUTORIALS},
                {L.LABEL_SOFT_TARGET_ENEMY, "NewCharacter.SoftTargetEnemy.Enabled", L.TOOLTIP_SOFT_TARGET_ENEMY},
                {L.LABEL_SPELLBOOK_HIDE_PASSIVES, "NewCharacter.SpellBookHidePassives.Enabled", L.TOOLTIP_SPELLBOOK_HIDE_PASSIVES},
            }

            checkboxes = {}
            for i, data in ipairs(newCharacterModuleCheckboxData) do
                local col = ((i-1) % 3) + 1
                local row = math.floor((i-1) / 3) + 1

                local cb = LSU.NewCheckbox({
                    id = i,
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
                label = L.LABEL_EDIT_MODE_LAYOUT,
                tooltipText = L.TOOLTIP_EDIT_MODE_LAYOUTS,
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

SLASH_LIGHTSKYUNIVERSAL1 = L.SLASH_CMD_LSU
SlashCmdList["LIGHTSKYUNIVERSAL"] = SlashHandler