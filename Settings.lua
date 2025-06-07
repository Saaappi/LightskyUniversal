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

            local checkbox1 = LSU.NewCheckbox({
                id = 1,
                parent = frame,
                label = L.LABEL_SETTINGS_ACCEPT_QUESTS,
                savedVarKey = "AcceptQuests.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_ACCEPT_QUESTS
            })
            checkbox1:SetPoint("TOPLEFT", frame, "TOPLEFT", 50, -100)
            checkbox1:Show()

            local checkbox2 = LSU.NewCheckbox({
                id = 2,
                parent = frame,
                label = L.LABEL_SETTINGS_AUTO_REPAIR,
                savedVarKey = "AutoRepair.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_AUTO_REPAIR
            })
            checkbox2:SetPoint("TOPLEFT", checkbox1, "BOTTOMLEFT", 0, -ySpacing)
            checkbox2:Show()

            local checkbox3 = LSU.NewCheckbox({
                id = 3,
                parent = frame,
                label = L.LABEL_SETTINGS_AUTO_TRAIN,
                savedVarKey = "AutoTrain.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_AUTO_TRAIN
            })
            checkbox3:SetPoint("TOPLEFT", checkbox2, "BOTTOMLEFT", 0, -ySpacing)
            checkbox3:Show()

            local checkbox4 = LSU.NewCheckbox({
                id = 4,
                parent = frame,
                label = L.LABEL_SETTINGS_BUY_QUEST_ITEMS,
                savedVarKey = "BuyQuestItems.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_BUY_QUEST_ITEMS
            })
            checkbox4:SetPoint("TOPLEFT", checkbox3, "BOTTOMLEFT", 0, -ySpacing)
            checkbox4:Show()

            local checkbox5 = LSU.NewCheckbox({
                id = 5,
                parent = frame,
                label = L.LABEL_SETTINGS_CHAT_ICONS,
                savedVarKey = "ChatIcons.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_CHAT_ICONS
            })
            checkbox5:SetPoint("TOPLEFT", checkbox4, "BOTTOMLEFT", 0, -ySpacing)
            checkbox5:Show()

            local checkbox6 = LSU.NewCheckbox({
                id = 6,
                parent = frame,
                label = L.LABEL_SETTINGS_COMPLETE_QUESTS,
                savedVarKey = "CompleteQuests.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_COMPLETE_QUESTS
            })
            checkbox6:SetPoint("TOPLEFT", checkbox5, "BOTTOMLEFT", 0, -ySpacing)
            checkbox6:Show()

            local checkbox7 = LSU.NewCheckbox({
                id = 7,
                parent = frame,
                label = L.LABEL_SETTINGS_GOSSIP,
                savedVarKey = "Gossip.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_GOSSIP
            })
            checkbox7:SetPoint("TOPLEFT", frame, "TOPLEFT", 50 + 1 * 180, -100)
            checkbox7:Show()

            local checkbox8 = LSU.NewCheckbox({
                id = 8,
                parent = frame,
                label = L.LABEL_SETTINGS_PLAYER_TALENTS,
                savedVarKey = "PlayerTalents.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_PLAYER_TALENTS
            })
            checkbox8:SetPoint("TOPLEFT", checkbox7, "BOTTOMLEFT", 0, -ySpacing)
            checkbox8:Show()

            local checkbox9 = LSU.NewCheckbox({
                id = 9,
                parent = frame,
                label = L.LABEL_SETTINGS_RARES,
                savedVarKey = "Rares.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_RARES
            })
            checkbox9:SetPoint("TOPLEFT", checkbox8, "BOTTOMLEFT", 0, -ySpacing)
            checkbox9:Show()

            local checkbox10 = LSU.NewCheckbox({
                id = 10,
                parent = frame,
                label = L.LABEL_SETTINGS_READY_CHECKS,
                savedVarKey = "ReadyChecks.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_READY_CHECKS
            })
            checkbox10:SetPoint("TOPLEFT", checkbox9, "BOTTOMLEFT", 0, -ySpacing)
            checkbox10:Show()

            local checkbox11 = LSU.NewCheckbox({
                id = 11,
                parent = frame,
                label = L.LABEL_SETTINGS_ROLE_CHECKS,
                savedVarKey = "RoleChecks.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_ROLE_CHECKS
            })
            checkbox11:SetPoint("TOPLEFT", checkbox10, "BOTTOMLEFT", 0, -ySpacing)
            checkbox11:Show()

            local checkbox12 = LSU.NewCheckbox({
                id = 12,
                parent = frame,
                label = L.LABEL_SETTINGS_SKIP_CINEMATICS,
                savedVarKey = "SkipCinematics.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_SKIP_CINEMATICS
            })
            checkbox12:SetPoint("TOPLEFT", checkbox11, "BOTTOMLEFT", 0, -ySpacing)
            checkbox12:Show()

            local checkbox13 = LSU.NewCheckbox({
                id = 13,
                parent = frame,
                label = L.LABEL_SETTINGS_NEW_CHARACTER,
                savedVarKey = "NewCharacter.Enabled",
                tooltipText = L.TOOLTIP_SETTINGS_NEW_CHARACTER
            })
            checkbox13:SetPoint("TOPLEFT", frame, "TOPLEFT", 50 + 2 * 180, -100)
            checkbox13:Show()

            local chromieTimeDropdown = LSU.NewRadioDropdown({
                parent = checkbox6,
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
            chromieTimeDropdown:SetPoint("TOPLEFT", checkbox6, "BOTTOMLEFT", 0, -50)
            chromieTimeDropdown:SetText(LSU.Enum.Expansions[LSUDB.Settings["ChromieTimeExpansionID"]] or DISABLE)
            chromieTimeDropdown:Show()

            local questRewardDropdown = LSU.NewRadioDropdown({
                parent = chromieTimeDropdown,
                label = L.LABEL_SETTINGS_QUEST_REWARDS,
                tooltipText = L.TOOLTIP_SETTINGS_QUEST_REWARDS,
                savedVarKey = "QuestRewardSelectionID",
                options = {
                    { DISABLE, 0 },
                    { L.LABEL_SETTINGS_SELL_PRICE, 1 },
                    { L.LABEL_SETTINGS_ITEM_LEVEL, 2 },
                }
            })
            questRewardDropdown:SetPoint("TOPLEFT", chromieTimeDropdown, "TOPRIGHT", 25, 0)
            questRewardDropdown:SetText(LSU.Enum.QuestRewardSelections[LSUDB.Settings["QuestRewardSelectionID"]])
            chromieTimeDropdown:Show()

            local warbankDepositEditBox = LSU.NewEditBox({
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
            warbankDepositEditBox:Show()
        else
            frame:Show()
        end
    end
end

SLASH_LIGHTSKYUNIVERSAL1 = L.SLASH_CMD_LSU
SlashCmdList["LIGHTSKYUNIVERSAL"] = SlashHandler