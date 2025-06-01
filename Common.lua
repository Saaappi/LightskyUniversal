local addonName, LSU = ...

--[[
    Checks if a value is present in a table.

    @param tbl table: The table to check.
    @param value [number|string]: The value to check for in the table.
]]
LSU.Contains = function(tbl, value)
    if tbl then
        for _, v in pairs(tbl) do
            if v == value then
                return true
            end
        end
        return false
    end
end

--[[
    Sends a message as stdout to the chat frame.

    @param str [string]: The text to send to the chat frame.
]]
LSU.Print = function(str)
    local name = C_AddOns.GetAddOnMetadata(addonName, "Title")
    if str and str ~= "" then
        str = string.format("|cff00CCFF[%s]|r : %s", name, str)
        print(str)
    end
end

--[[
    Sends a warning message as stdout to the chat frame.

    @param str [string]: The text to send to the chat frame.
]]
LSU.PrintWarning = function(str)
    local name = C_AddOns.GetAddOnMetadata(addonName, "Title")
    if str and str ~= "" then
        str = string.format("|cffFF8000[%s]|r : %s", name, str)
        print(str)
    end
end

--[[
    Sends an error message as stderr to the chat frame.

    @param str [string]: The text to send to the chat frame.
]]
LSU.PrintError = function(str)
    local name = C_AddOns.GetAddOnMetadata(addonName, "Title")
    if str and str ~= "" then
        str = string.format("|cffFF474C[%s]|r : %s", name, str)
        print(str)
    end
end

-- Splits a string by the provider delimiter, then
-- returns the nth value. If the value is a number,
-- then it's converted to a number.
--
-- If * is provided for the nth value, then the entire
-- split string is returned.
LSU.Split = function(str, delimiter, nth)
    local strings = {}
    local pattern = ("([^%s]+)"):format(delimiter)
    for string in str:gmatch(pattern) do
        table.insert(strings, string)
    end

    if nth == "*" then
        return unpack(strings)
    end

    if type(nth) == "string" and nth:match("^(%d+)%*$") then
        local startIndex = tonumber(nth:match("^(%d+)%*$"))
        local results = {}
        for i = startIndex, #strings do
            if tonumber(strings[i]) then
                strings[i] = tonumber(strings[i])
            end
            table.insert(results, strings[i])
        end
        return unpack(results)
    end

    if tonumber(strings[nth]) then
        return tonumber(strings[nth])
    end

    return strings[nth]
end

--[[
    Checks if a number is between two other numbers.

    @param num [number]: The number to check.
    @param min [number]: The minimum number in the range. (i.e. 10)
    @param max [number]: The maximum number in the range. (i.e. 70)
]]
LSU.Between = function(num, min, max)
    if num >= min and num <= max then
        return true
    end
    return false
end

--[[
    Checks if a quest is ignored and related automations should be halted against it.

    @param questID [number]: The ID of the quest to check.
]]
LSU.IsQuestIgnored = function(questID)
    local quest = LSU.Enum.Blacklisted.Quests[questID]
    if quest and quest.isIgnored then
        return quest.isIgnored, quest.response
    end
    return false
end

LSU.IsPlayerInCombat = function()
    if InCombatLockdown() then
        C_Timer.After(1, LSU.IsPlayerInCombat)
    else
        return false
    end
end

LSU.IsJunk = function(itemID)
    for id in pairs(LSUDB.Junk) do
        if id == itemID then
            return true
        end
    end
    return false
end

LSU.EvaluateConditions = function(conditions)
    if not conditions or #conditions == 0 then
        return true
    end

    for _, condition in ipairs(conditions) do
        local parts = { strsplit(";", condition) }
        local conditionType = parts[1]

        if conditionType == "!CT_EXPANSION" then
            local expansionID = tonumber(parts[2])
            if LSU.Character.ChromieTimeExpansionID == expansionID or LSU.Character.Level >= (GetMaxLevelForPlayerExpansion() - 10) then
                return false
            end
        elseif conditionType == "OBJECTIVE_COMPLETE" then
            local questID = tonumber(parts[2])
            local objectiveIndex = tonumber(parts[3])
            if questID and objectiveIndex then
                if C_QuestLog.IsOnQuest(questID) then
                    local objectives = C_QuestLog.GetQuestObjectives(questID)
                    if not (objectives and objectives[objectiveIndex] and objectives[objectiveIndex].finished) then
                        return false
                    end
                else
                    return false
                end
            end
        elseif conditionType == "OBJECTIVE_INCOMPLETE" then
            local questID = tonumber(parts[2])
            local objectiveIndex = tonumber(parts[3])
            if questID and objectiveIndex then
                if C_QuestLog.IsOnQuest(questID) then
                    local objectives = C_QuestLog.GetQuestObjectives(questID)
                    if objectives and objectives[objectiveIndex] and objectives[objectiveIndex].finished then
                        return false
                    end
                else
                    return false
                end
            end
        elseif conditionType == "QUEST_ACTIVE" then
            local questID = tonumber(parts[2])
            if not (questID and C_QuestLog.IsOnQuest(questID)) then
                return false
            end
        end
        return true
    end
end