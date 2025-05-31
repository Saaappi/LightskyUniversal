local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")
local gossipFrame = LSU.CreateFrame("Portrait", {
    name = "LSUGossipFrame",
    parent = UIParent,
    width = 650,
    height = 500,
    movable = true
})
local L = LSU.L

local function IsValidGossipNPC(id)
    if LSUDB.Gossips[id] then
        return true, LSUDB.Gossips[id]
    end
    return false
end

eventFrame:RegisterEvent("GOSSIP_SHOW")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "GOSSIP_SHOW" then
        C_Timer.After(0.35, function()
            local numActiveQuests = C_GossipInfo.GetNumActiveQuests()
            local numAvailableQuests = C_GossipInfo.GetNumAvailableQuests()
            if numActiveQuests > 0 then
                local activeQuests = C_GossipInfo.GetActiveQuests()
                for i = 1, numActiveQuests do
                    local quest = activeQuests[i]
                    if quest.isComplete then
                        C_GossipInfo.SelectActiveQuest(quest.questID)
                    end
                end
            end
            if numAvailableQuests > 0 then
                local availableQuests = C_GossipInfo.GetAvailableQuests()
                for i = 1, numAvailableQuests do
                    local quest = availableQuests[i]
                    local isIgnored, response = LSU.IsQuestIgnored(quest.questID)
                    if not isIgnored and not C_QuestLog.IsOnQuest(quest.questID) then
                        C_GossipInfo.SelectAvailableQuest(quest.questID)
                    else
                        if response then
                            local func = loadstring(response)
                            if func then
                                func()
                            end
                        end
                    end
                end
            end

            local options = C_GossipInfo.GetOptions()
            if options then
                if #options == 1 and options[1].icon == 132060 then -- The only option is "Show me your wares" or some other variant, so just pick it automatically
                    C_GossipInfo.SelectOption(options[1].gossipOptionID)
                else
                    local guid = UnitGUID("npc")
                    if guid then
                        local id = LSU.Split(guid, "-", 6)
                        if id then
                            local isValid, gossips = IsValidGossipNPC(id)
                            if isValid and gossips then
                                for _, gossip in ipairs(gossips) do
                                    local isAllowed = LSU.EvaluateConditions(gossip.conditions)
                                    if isAllowed then
                                        C_GossipInfo.SelectOption(gossip.gossipOptionID)
                                        C_Timer.After(.2, function()
                                            StaticPopup1Button1:Click("LeftButton")
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

local allGossipTextCache = "" -- Holds the full, unfiltered text for merge logic
LSU.OpenGossipFrame = function()
    local function ValidateGossipEntries(text)
        local isValid = true
        local errors = {}

        for lineNum, line in ipairs({strsplit("\n", text)}) do
            line = strtrim(line)
            if line ~= "" then
                local npcID, gossipOptionID, conditions = line:match("^(%d+),(%d+),?%s*(.*)$")
                if not npcID or not gossipOptionID then
                    table.insert(errors, ("Line %d: Invalid format. Expected: <npcID>,<gossipOptionID>,[,\"CONDITION;VALUE,...\"]"):format(lineNum))
                    isValid = false
                elseif conditions ~= "" and not conditions:match('^".*"$') then
                    table.insert(errors, ("Line %d: If conditions are present, they must be in quotes."):format(lineNum))
                    isValid = false
                end
            end
        end
        return isValid, errors
    end

    local function SyncGossipsFromText(text)
        local newGossips = {}

        -- Parse each line and build the new table
        for lineNum, line in ipairs({strsplit("\n", text)}) do
            line = strtrim(line)
            if line ~= "" then
                local npcID, gossipOptionID, conditionsText = line:match('^(%d+),(%d+),?%s*(.*)$')
                if npcID and gossipOptionID then
                    npcID = tonumber(npcID)
                    gossipOptionID = tonumber(gossipOptionID)
                    local entry = { gossipOptionID = gossipOptionID }
                    if conditionsText and conditionsText ~= "" then
                        local raw = conditionsText:match('^"(.*)"$')
                        if raw then
                            entry.conditions = {}
                            for cond in string.gmatch(raw, '[^,]+') do
                                table.insert(entry.conditions, strtrim(cond))
                            end
                        end
                    end
                    newGossips[npcID] = newGossips[npcID] or {}
                    table.insert(newGossips[npcID], entry)
                end
            end
        end

        -- Overwrite the DB with the new table
        LSUDB.Gossips = newGossips

        -- Quality of life: The GossipFrame is likely open, so process the new options immediately
        if GossipFrame and GossipFrame:IsShown() then
            local guid = UnitGUID("npc")
            local id = LSU.Split(guid, "-", 6)
            if id and LSUDB.Gossips[id] then
                local gossips = LSUDB.Gossips[id]
                local options = C_GossipInfo.GetOptions()
                for _, entry in ipairs(gossips) do
                    for _, option in ipairs(options) do
                        if option.gossipOptionID == entry.gossipOptionID then
                            C_GossipInfo.SelectOption(option.gossipOptionID)
                            return
                        end
                    end
                end
            end
        end
    end

    local function GossipsToText()
        local lines = {}
        if LSUDB and LSUDB.Gossips then
            local npcIDs = {}
            for npcID in pairs(LSUDB.Gossips) do
                table.insert(npcIDs, npcID)
            end
            table.sort(npcIDs, function(a, b) return tonumber(a) < tonumber(b) end)

            -- Output the gossips in order
            for _, npcID in ipairs(npcIDs) do
                for _, entry in ipairs(LSUDB.Gossips[npcID]) do
                    local line = tostring(npcID) .. "," .. tostring(entry.gossipOptionID)
                    if entry.conditions and #entry.conditions > 0 then
                        line = line .. ',\"' .. table.concat(entry.conditions, ",") .. '\"'
                    end
                    table.insert(lines, line)
                end
            end
        end
        return table.concat(lines, "\n")
    end

    local function FilteredGossipsToText(filter, sourceText)
        local allText = sourceText or GossipsToText()
        if not filter or filter == "" then
            return allText
        end
        local filteredLines = {}
        filter = filter:lower()
        for line in allText:gmatch("[^\r\n]+") do
            if line:lower():find(filter, 1, true) then
                table.insert(filteredLines, line)
            end
        end
        return table.concat(filteredLines, "\n")
    end

    gossipFrame:SetTitle(L.TITLE_GOSSIPS)
    gossipFrame:SetPortraitToAsset(2056011)

    if not gossipFrame.childrenCreated then
        local scrollFrame = CreateFrame("ScrollFrame", nil, gossipFrame, "UIPanelScrollFrameTemplate")
        scrollFrame:SetWidth(590)
        scrollFrame:SetHeight(400)

        scrollFrame:ClearAllPoints()
        scrollFrame:SetPoint("TOPLEFT", gossipFrame, "TOPLEFT", 20, -60)
        scrollFrame:SetPoint("BOTTOMRIGHT", gossipFrame, "BOTTOMRIGHT", -40, 40)

        local scrollBG = scrollFrame:CreateTexture(nil, "BACKGROUND")
        scrollBG:SetAllPoints(scrollFrame)
        scrollBG:SetColorTexture(0.1, 0.1, 0.1, 0.3)

        scrollFrame:EnableMouseWheel(true)
        scrollFrame:SetScript("OnMouseWheel", function(self, delta)
            local min, max = self.ScrollBar:GetMinMaxValues()
            local curr = self.ScrollBar:GetValue()
            if delta < 0 and curr < max then
                self.ScrollBar:SetValue(curr + 20)
            elseif delta > 0 and curr > min then
                self.ScrollBar:SetValue(curr - 20)
            end
        end)

        local font = CreateFont("MyEditBoxFont")
        font:SetFont("Fonts\\ARIALN.TTF", 14, "")
        font:SetSpacing(7.5)

        local paddingX = 5
        local paddingY = 5
        local paddingFrame = CreateFrame("Frame", nil, scrollFrame)
        paddingFrame:SetWidth(scrollFrame:GetWidth())
        paddingFrame:SetHeight(scrollFrame:GetHeight())

        local editBox = CreateFrame("EditBox", nil, paddingFrame)
        editBox:SetMultiLine(true)
        editBox:SetFontObject(font)
        editBox:SetWidth(scrollFrame:GetWidth() - 30)
        editBox:SetHeight(scrollFrame:GetHeight() - 30)
        editBox:SetPoint("TOPLEFT", paddingFrame, "TOPLEFT", paddingX, -paddingY)
        editBox:SetPoint("BOTTOMRIGHT", paddingFrame, "BOTTOMRIGHT", -paddingX, paddingY)
        editBox:SetAutoFocus(false)
        editBox:EnableMouse(true)
        editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        editBox:SetScript("OnTextChanged", function(self, userInput)
            if not userInput then -- Only auto-scroll when programmatically changed (e.g., paste)
                local sf = scrollFrame
                local _, max = sf.ScrollBar:GetMinMaxValues()
                sf:SetVerticalScroll(max)
            end
        end)

        scrollFrame:EnableMouse(true)
        scrollFrame:SetScript("OnMouseDown", function(self, button)
            if gossipFrame.editBox then
                gossipFrame.editBox:SetFocus()
            end
        end)

        scrollFrame:SetScrollChild(paddingFrame)

        -- Search/filter box
        local searchBox = CreateFrame("EditBox", nil, gossipFrame, "InputBoxTemplate")
        searchBox:SetSize(200, 25)
        searchBox:SetPoint("TOPLEFT", scrollFrame, "BOTTOMLEFT", 5, -5)
        searchBox:SetAutoFocus(false)
        searchBox:SetMaxLetters(30)
        searchBox:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(C_AddOns.GetAddOnMetadata(addonName, "Title"), nil, nil, nil, 1, true)
            GameTooltip:AddLine(L.TOOLTIP_GOSSIPS_SEARCHBOX, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        searchBox:SetScript("OnLeave", function() GameTooltip:Hide() end)
        searchBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        searchBox:SetScript("OnTextChanged", function(self)
            local filter = self:GetText()
            gossipFrame.editBox:SetText(FilteredGossipsToText(filter, allGossipTextCache))
        end)

        local submitButton = LSU.CreateButton({
            type = "BasicButton",
            name = "LSUGossipSubmitButton",
            parent = gossipFrame,
            width = 80,
            height = 25,
            text = SUBMIT,
            tooltipText = L.TOOLTIP_GOSSIPS_SUBMIT_BUTTON
        })
        submitButton:SetPoint("TOPRIGHT", scrollFrame, "BOTTOMRIGHT", 0, -5)
        submitButton:SetScript("OnClick", function()
            local filter = searchBox:GetText() or ""
            local editedText = editBox:GetText()
            local isValid, errors = ValidateGossipEntries(editedText)
            if not isValid then
                for _, error in ipairs(errors) do
                    print(error)
                end
                return
            end

            PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK, "Master")
            if filter ~= "" then
                local fullLines = {}
                for line in allGossipTextCache:gmatch("[^\r\n]+") do
                    table.insert(fullLines, line)
                end
                local filteredSet = {}
                for line in editedText:gmatch("[^\r\n]+") do
                    filteredSet[line] = true
                end

                local mergedLines = {}
                for _, line in ipairs(fullLines) do
                    if line:lower():find(filter:lower(), 1, true) then
                        if filteredSet[line] then
                            table.insert(mergedLines, line) -- line wasn't deleted, else line was deleted; don't keep it
                        end
                    else
                        table.insert(mergedLines, line) -- line wasn't filtered, so keep as is
                    end
                end
                SyncGossipsFromText(table.concat(mergedLines, "\n"))
                -- refresh the cache and editbox
                allGossipTextCache = GossipsToText()
                gossipFrame.editBox:SetText(FilteredGossipsToText(filter, allGossipTextCache))
            else
                SyncGossipsFromText(editedText)
                allGossipTextCache = GossipsToText()
                gossipFrame.editBox:SetText(FilteredGossipsToText(filter, allGossipTextCache))
            end
        end)

        local helpIcon = gossipFrame:CreateTexture(nil, "OVERLAY")
        helpIcon:SetTexture("Interface\\COMMON\\help-i")
        helpIcon:SetSize(32, 32)
        helpIcon:SetPoint("TOPRIGHT", gossipFrame, "TOPRIGHT", -6, -25)

        helpIcon:EnableMouse(true)
        helpIcon:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(C_AddOns.GetAddOnMetadata(addonName, "Title"), nil, nil, nil, 1, true)
            GameTooltip:AddLine(L.TOOLTIP_GOSSIPS_HELP_BUTTON, 1,1,1, true)
            GameTooltip:Show()
        end)
        helpIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)

        gossipFrame.editBox = editBox
        gossipFrame.childrenCreated = true
    end

    -- On show: always refresh the cache and show the filtered text for the current filter
    allGossipTextCache = GossipsToText()
    local filter = gossipFrame.searchBox and gossipFrame.searchBox:GetText() or ""
    gossipFrame.editBox:SetText(FilteredGossipsToText(filter, allGossipTextCache))

    gossipFrame:ClearAllPoints()
    gossipFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 160)
    gossipFrame:Show()
end