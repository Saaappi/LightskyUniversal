local LSU = select(2, ...)
local L = LSU.L
local frame

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

            -- Layout: Adding widgets to the frame...
            local prev = {}
            local columnCount = 6
            local xSpacing = 180
            local ySpacing = -10
            for i, data in ipairs({
                {label = L.LABEL_SETTINGS_ACCEPT_QUESTS, tooltipText = L.TOOLTIP_SETTINGS_ACCEPT_QUESTS, savedVarKey = "AcceptQuests.Enabled"},
                {label = L.LABEL_SETTINGS_AUTO_REPAIR, tooltipText = L.TOOLTIP_SETTINGS_AUTO_REPAIR, savedVarKey = "AutoRepair.Enabled"},
                {label = L.LABEL_SETTINGS_AUTO_TRAIN, tooltipText = L.TOOLTIP_SETTINGS_AUTO_TRAIN, savedVarKey = "AutoTrain.Enabled"},
                {label = L.LABEL_SETTINGS_BUY_QUEST_ITEMS, tooltipText = L.TOOLTIP_SETTINGS_BUY_QUEST_ITEMS, savedVarKey = "BuyQuestItems.Enabled"},
                {label = L.LABEL_SETTINGS_CHAT_ICONS, tooltipText = L.TOOLTIP_SETTINGS_CHAT_ICONS, savedVarKey = "ChatIcons.Enabled"},
                {label = L.LABEL_SETTINGS_COMPLETE_QUESTS, tooltipText = L.TOOLTIP_SETTINGS_COMPLETE_QUESTS, savedVarKey = "CompleteQuests.Enabled"},
                {label = L.LABEL_SETTINGS_GOSSIP, tooltipText = L.TOOLTIP_SETTINGS_GOSSIP, savedVarKey = "Gossip.Enabled"},
                {label = L.LABEL_SETTINGS_PLAYER_TALENTS, tooltipText = L.TOOLTIP_SETTINGS_PLAYER_TALENTS, savedVarKey = "PlayerTalents.Enabled"},
                {label = L.LABEL_SETTINGS_RARES, tooltipText = L.TOOLTIP_SETTINGS_RARES, savedVarKey = "Rares.Enabled"},
                {label = L.LABEL_SETTINGS_READY_CHECKS, tooltipText = L.TOOLTIP_SETTINGS_READY_CHECKS, savedVarKey = "ReadyChecks.Enabled"},
                {label = L.LABEL_SETTINGS_ROLE_CHECKS, tooltipText = L.TOOLTIP_SETTINGS_ROLE_CHECKS, savedVarKey = "RoleChecks.Enabled"},
                {label = L.LABEL_SETTINGS_SKIP_CINEMATICS, tooltipText = L.TOOLTIP_SETTINGS_SKIP_CINEMATICS, savedVarKey = "SkipCinematics.Enabled"}
            }) do
                local checkbox = LSU.GetCheckbox(frame, data.label, data.tooltipText, data.savedVarKey)
                local column = math.floor((i-1) / columnCount)
                local row = (i-1) % columnCount

                if row == 0 then
                    checkbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 36 + column * xSpacing, -100)
                    prev[column+1] = checkbox
                else
                    checkbox:SetPoint("TOPLEFT", prev[column+1], "BOTTOMLEFT", 0, ySpacing)
                    prev[column+1] = checkbox
                end
            end

            frame:Show()
        else
            frame:Show()
        end
    end
end

SLASH_LIGHTSKYUNIVERSAL1 = L.SLASH_CMD_LSU
SlashCmdList["LIGHTSKYUNIVERSAL"] = SlashHandler