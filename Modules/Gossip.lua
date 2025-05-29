local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")
local gossipFrame = LSU.CreateFrame("Portrait", {
    name = "LSUGossipFrame",
    parent = UIParent,
    width = 500,
    height = 400,
    movable = true
})

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

function LSUOpenGossipsFrame()
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

    local function InsertOrUpdateGossipsToDB(text)
        for lineNum, line in ipairs({strsplit("\n", text)}) do
            line = strtrim(line)
            if line ~= "" then
                local npcID, gossipOptionID, conditionsText = line:match("^(%d+),(%d+),?%s*(.*)$")
                if npcID and gossipOptionID then
                    npcID = tonumber(npcID)
                    gossipOptionID = tonumber(gossipOptionID)
                    local newConditions = nil
                    if conditionsText and conditionsText ~= "" then
                        -- Remove enclosing quotes if present
                        local raw = conditionsText:match('^"(.*)"$')
                        if raw then
                            newConditions = {}
                            -- Split on commas, trim the spaces
                            for condition in string.gmatch(raw, '[^,]+') do
                                table.insert(newConditions, strtrim(condition))
                            end
                        end
                    end

                    LSUDB.Gossips[npcID] = LSUDB.Gossips[npcID] or {}
                    local found = false
                    for _, entry in ipairs(LSUDB.Gossips[npcID]) do
                        if entry.gossipOptionID == gossipOptionID then
                            found = true
                            -- Only update if there are new conditions
                            if newConditions then
                                entry.conditions = newConditions
                            end
                            break
                        end
                    end
                    -- If not found, add a new entry
                    if not found then
                        local newEntry = { gossipOptionID = gossipOptionID }
                        if newConditions then
                            newEntry.conditions = newConditions
                        end
                        table.insert(LSUDB.Gossips[npcID], newEntry)
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

    gossipFrame:SetTitle("Gossips") -- LOCALIZE!
    gossipFrame:SetPortraitToAsset(2056011)

    local scrollFrame = CreateFrame("ScrollFrame", nil, gossipFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetWidth(440)
    scrollFrame:SetHeight(300)

    scrollFrame:ClearAllPoints()
    scrollFrame:SetPoint("TOPLEFT", gossipFrame, "TOPLEFT", 20, -60)
    scrollFrame:SetPoint("BOTTOMRIGHT", gossipFrame, "BOTTOMRIGHT", -40, 40)

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

    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetWidth(scrollFrame:GetWidth() - 30)
    editBox:SetHeight(scrollFrame:GetHeight() -30)
    editBox:SetAutoFocus(false)
    editBox:EnableMouse(true)
    editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    editBox:SetText(GossipsToText())

    scrollFrame:SetScrollChild(editBox)

    local submitButton = LSU.CreateButton({
        type = "BasicButton",
        name = "LSUGossipSubmitButton",
        parent = gossipFrame,
        width = 80,
        height = 25,
        text = SUBMIT,
        tooltipText = "test!" -- LOCALIZE!
    })
    submitButton:SetPoint("BOTTOM", gossipFrame, "BOTTOM", 0, 10)
    submitButton:SetScript("OnClick", function()
        local text = editBox:GetText()
        local isValid, errors = ValidateGossipEntries(text)
        if isValid then
            InsertOrUpdateGossipsToDB(text)
        else
            for _, error in ipairs(errors) do
                print(error)
            end
        end
    end)

    gossipFrame:ClearAllPoints()
    gossipFrame:SetPoint("CENTER", UIParent, "CENTER")
    gossipFrame:Show()
end