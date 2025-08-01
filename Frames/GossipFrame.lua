local addonName, addonTable = ...
local gossipFrame = addonTable.CreateFrame("Portrait", {
    name = "LSUGossipFrame",
    parent = UIParent,
    width = 650,
    height = 500,
    movable = true
})
local fontSize = 14
local fontPadding = 7.5
local history = {}
local historyPos = 0

addonTable.IsValidGossipNPC = function(id)
    if LSUDB.Gossips[id] then
        return true, LSUDB.Gossips[id]
    end
    return false
end

local function RemoveDuplicateEntries(text)
    -- Map: npcID:gossipOptionID -> { index, line, length }
    local best = {}
    local lines = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    for i, line in ipairs(lines) do
        local npcID, gossipOptionID, conditions = line:match('^(%d+),(%d+),?%s*(.*)$')
        if npcID and gossipOptionID then
            local key = npcID .. "," .. gossipOptionID
            -- Length = total characters (longer includes more conditions)
            local len = #conditions
            if not best[key] or len > best[key].length or (len == best[key].length and i > best[key].index) then
                best[key] = { index = i, line = line, length = len }
            end
        end
    end
    -- Only keep "best" lines
    local keep = {}
    for _, v in pairs(best) do
        keep[v.index] = true
    end
    local result = {}
    for i, line in ipairs(lines) do
        if keep[i] then
            table.insert(result, line)
        end
    end
    return table.concat(result, "\n")
end

-- HelpMePlay table-to-text importer helper
local function HMPGossipsToText(hmpGossips)
    local lines = {}
    for id, gossips in pairs(hmpGossips) do
        for _, gossipID in ipairs(gossips) do
            local line = tostring(id) .. "," .. tostring(gossipID)
            table.insert(lines, line)
        end
    end
    return table.concat(lines, "\n")
end

local allGossipTextCache = "" -- Holds the full, unfiltered text for merge logic
addonTable.OpenGossipFrame = function()
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
            local id = addonTable.Split(guid, "-", 6)
            if id and LSUDB.Gossips[id] then
                local gossips = LSUDB.Gossips[id]
                local options = C_GossipInfo.GetOptions()
                for _, entry in ipairs(gossips) do
                    for _, option in ipairs(options) do
                        if option.gossipOptionID == entry.gossipOptionID then
                            local isAllowed = addonTable.EvaluateConditions(entry.conditions)
                            if isAllowed then
                                C_GossipInfo.SelectOption(option.gossipOptionID)
                            end
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
                local entries = LSUDB.Gossips[npcID]
                table.sort(entries, function(a, b)
                    return tonumber(a.gossipOptionID) < tonumber(b.gossipOptionID)
                end)
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

    gossipFrame:SetTitle(addonTable.Locales.GOSSIP .. " " .. addonTable.Locales.SETTINGS)
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

        local gossipCountText = scrollFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        gossipCountText:SetPoint("BOTTOMRIGHT", scrollFrame, "TOPRIGHT", 0, 5)
        gossipCountText:SetText(string.format("%s %s", "0", addonTable.Locales.LINES))

        local function UpdateGossipCount()
            local editBox = gossipFrame.editBox
            if not editBox then return end
            local text = editBox:GetText() or ""
            local count = 0
            for line in text:gmatch("[^\r\n]+") do
                if strtrim(line) ~= "" then count = count + 1 end
            end
            gossipCountText:SetText(string.format("%d %s", count, addonTable.Locales.LINES))
        end
        gossipFrame.UpdateGossipCount = UpdateGossipCount

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
        font:SetFont("Fonts\\ARIALN.TTF", fontSize, "")
        font:SetSpacing(fontPadding)

        local paddingX = 5
        local paddingY = 5
        local paddingFrame = CreateFrame("Frame", nil, scrollFrame)
        paddingFrame:SetWidth(scrollFrame:GetWidth())

        local editBox = addonTable.CreateFrame("EditBox", {
            parent = paddingFrame,
            width = scrollFrame:GetWidth() - 30,
            isMultiLine = true,
            font = font,
            template = ""
        })
        editBox:SetPoint("TOPLEFT", paddingFrame, "TOPLEFT", paddingX, -paddingY)
        editBox:SetPoint("BOTTOMRIGHT", paddingFrame, "BOTTOMRIGHT", -paddingX, paddingY)

        local function UpdateEditBoxHeight()
            local minHeight = scrollFrame:GetHeight() - 30
            local text = editBox:GetText() or ""
            -- count number of lines (at least 1, even when empty)
            local lines = 1
            for _ in text:gmatch("\n") do lines = lines + 1 end

            -- the editbox uses a custom font and size (14), plus some padding (7.5)
            local fontHeight = fontSize + fontPadding
            local ebHeight = math.max(minHeight, lines * fontHeight + 20) -- 20 is for padding

            editBox:SetHeight(ebHeight)
            paddingFrame:SetHeight(ebHeight + 10)
        end

        editBox:SetScript("OnTextChanged", function(self, userInput)
            UpdateEditBoxHeight()
            if userInput then
                local text = self:GetText()

                -- avoid duplicates for minor moves
                if history[#history] ~= text then
                    table.insert(history, text)
                    historyPos = #history -- keep track of current position
                end

                local cursorPos = editBox:GetCursorPosition()
                -- find the line the cursor is on
                local beforeCursor = text:sub(1, cursorPos)
                local cursorLine = select(2, beforeCursor:gsub("\n", "\n")) + 1

                -- get scrollFrame's visible region
                local scrollY = scrollFrame:GetVerticalScroll()
                local viewHeight = scrollFrame:GetHeight()
                local fontHeight = fontSize + fontPadding

                local cursorY = (cursorLine - 1) * fontHeight -- this is the y offset of the cursor line

                -- if the cursor is above or below the visible area, then scroll to make it visible
                if cursorY < scrollY then
                    scrollFrame:SetVerticalScroll(cursorY)
                elseif cursorY + fontHeight > scrollY + viewHeight then
                    scrollFrame:SetVerticalScroll(cursorY + fontHeight - viewHeight)
                end
            end
            UpdateGossipCount()
        end)

        editBox:HookScript("OnKeyDown", function(self, key)
            if IsControlKeyDown() and (key == "z" or key == "Z") then
                local cursorPos = self:GetCursorPosition()
                if historyPos > 1 then
                    historyPos = historyPos - 1
                    self:SetText(history[historyPos])
                    self:SetCursorPosition(cursorPos)
                end
            elseif IsControlKeyDown() and (key == "y" or key == "Y") then
                local cursorPos = self:GetCursorPosition()
                if historyPos < #history then
                    historyPos = historyPos + 1
                    self:SetText(history[historyPos])
                    self:SetCursorPosition(cursorPos)
                end
            end
        end)

        local lastClickTime = 0
        local lastClickX, lastClickY = nil, nil
        local DOUBLE_CLICK_DELAY = 0.3
        local DOUBLE_CLICK_PIXEL_TOLERANCE = 5
        editBox:SetScript("OnMouseUp", function(self, button)
            if button ~= "LeftButton" then return end

            local clickTime = GetTime()
            local x, y = GetCursorPosition()

            if lastClickTime and (clickTime - lastClickTime) < DOUBLE_CLICK_DELAY
                and lastClickX and lastClickY
                and math.abs(x - lastClickX) < DOUBLE_CLICK_PIXEL_TOLERANCE
                and math.abs(y - lastClickY) < DOUBLE_CLICK_PIXEL_TOLERANCE
            then
                local text = self:GetText() or ""
                if text == "" then return end

                local cursorPos = self:GetCursorPosition() -- 0-based: position *after* the char you clicked

                local wordCharIndex = cursorPos
                local len = #text
                local function isWord(i)
                    return i >= 1 and i <= len and text:sub(i, i):match("[%w_]")
                end

                -- Step 1: is the char at cursor a word character?
                if not isWord(wordCharIndex) then
                    -- Step 2: is the char to the right a word character?
                    if isWord(wordCharIndex + 1) then
                        wordCharIndex = wordCharIndex + 1
                    else
                        lastClickTime = 0
                        lastClickX, lastClickY = nil, nil
                        return
                    end
                end

                -- Expand left
                local left = wordCharIndex
                while left > 1 and isWord(left - 1) do
                    left = left - 1
                end

                -- Expand right
                local right = wordCharIndex
                while right < len and isWord(right + 1) do
                    right = right + 1
                end

                -- Highlight the word
                self:HighlightText(left - 1, right)
                lastClickTime = 0
                lastClickX, lastClickY = nil, nil
            else
                lastClickTime = clickTime
                lastClickX, lastClickY = GetCursorPosition()
            end
        end)

        scrollFrame:SetScrollChild(paddingFrame)

        -- Search/filter box
        local searchBox = addonTable.CreateFrame("EditBox", {
            parent = scrollFrame,
            width = 200,
            height = 25,
            maxLetters = 30,
            tooltipText = addonTable.Locales.GOSSIP_SEARCH_BOX_TOOLTIP
        })
        searchBox:SetPoint("TOPLEFT", scrollFrame, "BOTTOMLEFT", 5, -5)
        searchBox:SetScript("OnTextChanged", function(self)
            local filter = self:GetText()
            gossipFrame.editBox:SetText(FilteredGossipsToText(filter, allGossipTextCache))
            if gossipFrame.UpdateGossipCount then gossipFrame.UpdateGossipCount() end
            UpdateEditBoxHeight()
        end)

        local submitButton = addonTable.CreateButton({
            type = "BasicButton",
            name = "LSUGossipSubmitButton",
            parent = gossipFrame,
            width = 80,
            height = 25,
            text = SUBMIT,
            tooltipText = addonTable.Locales.GOSSIP_SUBMIT_BUTTON_TOOLTIP
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
                            table.insert(mergedLines, line)
                        end
                    else
                        table.insert(mergedLines, line)
                    end
                end
                local deduped = RemoveDuplicateEntries(table.concat(mergedLines, "\n"))
                SyncGossipsFromText(deduped)
                allGossipTextCache = GossipsToText()
                gossipFrame.editBox:SetText(FilteredGossipsToText(filter, allGossipTextCache))
                if gossipFrame.UpdateGossipCount then gossipFrame.UpdateGossipCount() end
            else
                local deduped = RemoveDuplicateEntries(editedText)
                SyncGossipsFromText(deduped)
                allGossipTextCache = GossipsToText()
                gossipFrame.editBox:SetText(FilteredGossipsToText(filter, allGossipTextCache))
                if gossipFrame.UpdateGossipCount then gossipFrame.UpdateGossipCount() end
            end
        end)

        local importFromHMPButton = addonTable.CreateButton({
            type = "BasicButton",
            name = "LSUImportFromHMPButton",
            parent = gossipFrame,
            width = 80,
            height = 25,
            text = addonTable.Locales.IMPORT,
            tooltipText = addonTable.Locales.GOSSIP_IMPORT_BUTTON_TOOLTIP
        })
        importFromHMPButton:SetPoint("RIGHT", submitButton, "LEFT", -5, 0)
        importFromHMPButton:SetScript("OnClick", function()
            if C_AddOns.IsAddOnLoaded("HelpMePlay") then
                if HelpMePlayDB.PlayerGossips and next(HelpMePlayDB.PlayerGossips) then
                    local importedText = HMPGossipsToText(HelpMePlayDB.PlayerGossips)
                    local currentText = GossipsToText()
                    local combinedText = currentText .. "\n" .. importedText
                    local deduped = RemoveDuplicateEntries(combinedText)
                    SyncGossipsFromText(deduped)
                    allGossipTextCache = GossipsToText()
                    gossipFrame.editBox:SetText(FilteredGossipsToText(gossipFrame.searchBox and gossipFrame.searchBox:GetText() or "", allGossipTextCache))
                    if gossipFrame.UpdateGossipCount then gossipFrame.UpdateGossipCount() end
                    submitButton:Click()
                    HelpMePlayDB.PlayerGossips = nil
                end
            else
                addonTable.PrintError(string.format(addonTable.Locales.ADDON_NOT_FOUND, "HelpMePlay"))
            end
        end)

        local helpButton = CreateFrame("Button", nil, gossipFrame)
        helpButton:SetSize(28, 28)

        local icon = helpButton:CreateTexture(nil, "OVERLAY")
        icon:SetTexture("Interface\\COMMON\\help-i")

        local highlight = helpButton:CreateTexture(nil, "HIGHLIGHT")
        highlight:SetTexture("Interface\\COMMON\\help-i")
        highlight:SetAlpha(0.25)
        highlight:SetAllPoints(icon)

        helpButton:SetNormalTexture(icon)
        helpButton:SetHighlightTexture(highlight, "ADD")

        helpButton:SetPoint("TOPRIGHT", gossipFrame, "TOPRIGHT", -8, -25)

        helpButton:EnableMouse(true)
        helpButton:SetScript("OnClick", function()
            addonTable.NewStaticPopup(
                "GossipFrameHelpButtonPopup",
                addonTable.Locales.USE_CTRLC_TO_COPY_THE_LINK_BELOW,
                {
                    button1Text = DONE,
                    hasEditBox = 1,
                    onShow = function(self)
                        self.editBox:SetText("https://github.com/Saaappi/LightskyUniversal/wiki/Gossip-Conditions")
                        self.editBox:HighlightText()
                        self.editBox:SetScript("OnKeyUp", function(_, key)
                            if IsControlKeyDown() and key == "C" then StaticPopup_Hide("GossipFrameHelpButtonPopup") end
                        end)
                    end,
                    onAccept = function() end,
                }
            )
            StaticPopup_Show("GossipFrameHelpButtonPopup")
        end)
        helpButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(C_AddOns.GetAddOnMetadata(addonName, "Title"), nil, nil, nil, 1, true)
            GameTooltip:AddLine(addonTable.Locales.GOSSIP_HELP_BUTTON_TOOLTIP, 1,1,1, true)
            GameTooltip:Show()
        end)
        helpButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

        gossipFrame.editBox = editBox
        gossipFrame.gossipCountText = gossipCountText
        gossipFrame.childrenCreated = true
    end

    -- On show: always refresh the cache and show the filtered text for the current filter
    allGossipTextCache = GossipsToText()
    local filter = gossipFrame.searchBox and gossipFrame.searchBox:GetText() or ""
    gossipFrame.editBox:SetText(FilteredGossipsToText(filter, allGossipTextCache))
    history = {gossipFrame.editBox:GetText() or ""}
    historyPos = 1

    gossipFrame:ClearAllPoints()
    gossipFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 160)
    gossipFrame:Show()
end