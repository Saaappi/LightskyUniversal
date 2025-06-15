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
                label = L.LABEL_SETTINGS_DISCORD
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
                    self.editBox:SetText("https://coff.ee/lightskygg")
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
                label = L.LABEL_SETTINGS_DONATE
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

            local checkboxData = {
                {L.LABEL_SETTINGS_ACCEPT_QUESTS,   "AcceptQuests.Enabled",    L.TOOLTIP_SETTINGS_ACCEPT_QUESTS},
                {L.LABEL_SETTINGS_AUTO_REPAIR,     "AutoRepair.Enabled",      L.TOOLTIP_SETTINGS_AUTO_REPAIR},
                {L.LABEL_SETTINGS_AUTO_TRAIN,      "AutoTrain.Enabled",       L.TOOLTIP_SETTINGS_AUTO_TRAIN},
                {L.LABEL_SETTINGS_BUY_QUEST_ITEMS, "BuyQuestItems.Enabled",   L.TOOLTIP_SETTINGS_BUY_QUEST_ITEMS},
                {L.LABEL_SETTINGS_CHAT_ICONS,      "ChatIcons.Enabled",       L.TOOLTIP_SETTINGS_CHAT_ICONS},
                {L.LABEL_SETTINGS_COMPLETE_QUESTS, "CompleteQuests.Enabled",  L.TOOLTIP_SETTINGS_COMPLETE_QUESTS},
                {L.LABEL_SETTINGS_GOSSIP,          "Gossip.Enabled",          L.TOOLTIP_SETTINGS_GOSSIP},
                {L.LABEL_SETTINGS_PLAYER_TALENTS,  "PlayerTalents.Enabled",   L.TOOLTIP_SETTINGS_PLAYER_TALENTS},
                {L.LABEL_SETTINGS_QUEST_REWARDS,   "QuestRewards.Enabled",    L.TOOLTIP_SETTINGS_QUEST_REWARDS},
                {L.LABEL_SETTINGS_RARES,           "Rares.Enabled",           L.TOOLTIP_SETTINGS_RARES},
                {L.LABEL_SETTINGS_READY_CHECKS,    "ReadyChecks.Enabled",     L.TOOLTIP_SETTINGS_READY_CHECKS},
                {L.LABEL_SETTINGS_ROLE_CHECKS,     "RoleChecks.Enabled",      L.TOOLTIP_SETTINGS_ROLE_CHECKS},
                {L.LABEL_SETTINGS_SKIP_CINEMATICS, "SkipCinematics.Enabled",  L.TOOLTIP_SETTINGS_SKIP_CINEMATICS},
                {L.LABEL_SETTINGS_NEW_CHARACTER,   "NewCharacter.Enabled",    L.TOOLTIP_SETTINGS_NEW_CHARACTER},
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
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", x, y)
                cb:Show()
                checkboxes[i] = cb
            end

            local chromieTimeModuleFS = scrollChild:CreateFontString()
            chromieTimeModuleFS:SetFontObject("ChatBubbleFont")
            chromieTimeModuleFS:SetText("Chromie Time")
            chromieTimeModuleFS:SetPoint("TOPLEFT", checkboxes[13], "BOTTOMLEFT", 0, -50)

            local chromieTimeDropdown = LSU.NewRadioDropdown({
                parent = scrollChild,
                label = L.LABEL_SETTINGS_CHROMIE_TIME,
                tooltipText = L.TOOLTIP_SETTINGS_CHROMIE_TIME,
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
            chromieTimeDropdown:SetPoint("TOPLEFT", chromieTimeModuleFS, "BOTTOMLEFT", 0, -10)
            chromieTimeDropdown:SetText(LSU.Enum.Expansions[LSUDB.Settings["ChromieTimeExpansionID"]] or DISABLE)
            chromieTimeDropdown.label:Hide()
            chromieTimeDropdown:Show()

            --[[local warbankDepositEditBox = LSU.NewEditBox({
                name = "LSUWarbankDepositEditBox",
                parent = chromieTimeDropdown,
                width = 200,
                height = 25,
                maxLetters = 7,
                label = L.LABEL_SETTINGS_DEPOSIT_KEEP_AMOUNT,
                tooltipText = L.TOOLTIP_SETTINGS_DEPOSIT_KEEP_AMOUNT
            })
            warbankDepositEditBox:SetPoint("TOPLEFT", chromieTimeDropdown, "BOTTOMLEFT", 0, -50)
            warbankDepositEditBox:SetText(C_CurrencyInfo.GetCoinTextureString(LSUDB.Settings["WarbankDepositInCopper"] or 0))
            warbankDepositEditBox:SetScript("OnEnterPressed", function(self)
                local amount = tonumber(self:GetText()) or 0
                amount = math.max(amount, 0)
                amount = amount * 10000
                LSUDB.Settings["WarbankDepositInCopper"] = amount
                warbankDepositEditBox:SetText(C_CurrencyInfo.GetCoinTextureString(amount))
                self:ClearFocus()
            end)
            warbankDepositEditBox:Show()]]

            local newCharacterModuleFS = scrollChild:CreateFontString()
            newCharacterModuleFS:SetFontObject("ChatBubbleFont")
            newCharacterModuleFS:SetText("New Character Module")
            newCharacterModuleFS:SetPoint("TOPLEFT", chromieTimeDropdown, "BOTTOMLEFT", 0, -25)

            local newCharacterModuleCheckboxData = {
                {"Always Compare Items", "NewCharacter.AlwaysCompareItems.Enabled", "<PH>"},
                {"Always Show Action Bars", "NewCharacter.AlwaysShowActionBars.Enabled", "<PH>"},
                {"Arachnophobia Mode", "NewCharacter.ArachnophobiaMode.Enabled", "<PH>"},
                {"Auto Dismount Flying", "NewCharacter.AutoDismountFlying.Enabled", "<PH>"},
                {"Auto Interact", "NewCharacter.AutoInteract.Enabled", "<PH>"},
                {"Auto Loot", "NewCharacter.AutoLootDefault.Enabled", "<PH>"},
                {"Auto Push Spells", "NewCharacter.AutoPushSpellToActionBar.Enabled", "<PH>"},
                {"Cooldown Viewer", "NewCharacter.CooldownViewer.Enabled", "<PH>"},
                {"Disable Skyriding Full Screen Effects", "NewCharacter.DisableSkyridingFullScreenEffects.Enabled", "<PH>"},
                {"Disable Skyriding Velocity VFX", "NewCharacter.DisableSkyridingVelocityVFX.Enabled", "<PH>"},
                {"Disable User Addons By Default", "NewCharacter.DisableUserAddonsByDefault.Enabled", "<PH>"},
                {"Enable Floating Combat Text", "NewCharacter.EnableFloatingCombatText.Enabled", "<PH>"},
                {"Footstep Sounds", "NewCharacter.FootstepSounds.Enabled", "<PH>"},
                {"Loot Under Mouse", "NewCharacter.LootUnderMouse.Enabled", "<PH>"},
                {"Mount Journal Show Player", "NewCharacter.MountJournalShowPlayer.Enabled", "<PH>"},
                {"Occluded Silhouette Player", "NewCharacter.OccludedSilhouettePlayer.Enabled", "<PH>"},
                {"Profanity Filter", "NewCharacter.ProfanityFilter.Enabled", "<PH>"},
                {"PvP Frames Display Class Color", "NewCharacter.PvPFramesDisplayClassColor.Enabled", "<PH>"},
                {"Quest Text Contrast", "NewCharacter.QuestTextContrast.Enabled", "<PH>"},
                {"Raid Frames Display Class Color", "NewCharacter.RaidFramesDisplayClassColor.Enabled", "<PH>"},
                {"Replace My Player Portrait", "NewCharacter.ReplaceMyPlayerPortrait.Enabled", "<PH>"},
                {"Replace Other Player Portraits", "NewCharacter.ReplaceOtherPlayerPortraits.Enabled", "<PH>"},
                {"Show Script Errors", "NewCharacter.ShowScriptErrors.Enabled", "<PH>"},
                {"Show Target of Target", "NewCharacter.ShowTargetOfTarget.Enabled", "<PH>"},
                {"Show Tutorials", "NewCharacter.ShowTutorials.Enabled", "<PH>"},
                {"Show Tutorials", "NewCharacter.ShowTutorials.Enabled", "<PH>"},
                {"Soft Target Enemy", "NewCharacter.SoftTargetEnemy.Enabled", "<PH>"},
                {"Spellbook Hide Passives", "NewCharacter.SpellBookHidePassives.Enabled", "<PH>"},
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
                cb:SetPoint("TOPLEFT", newCharacterModuleFS, "BOTTOMLEFT", x, y)
                cb:Show()
                checkboxes[i] = cb
            end

            --lastWidget = warbankDepositEditBox
            lastWidget = chromieTimeDropdown
            scrollChild:SetSize(scrollFrame:GetWidth()-20, math.abs(lastWidget:GetBottom() - scrollChild:GetTop()) + 30)
        else
            frame:Show()
        end
    end
end

SLASH_LIGHTSKYUNIVERSAL1 = L.SLASH_CMD_LSU
SlashCmdList["LIGHTSKYUNIVERSAL"] = SlashHandler