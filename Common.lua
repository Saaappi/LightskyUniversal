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

LSU.Between = function(value, min, max)
    if value >= min and value <= max then
        return true
    end
    return false
end

LSU.EvaluateConditions = function(conditions)
    -- Keep the gossips as clean as possible, only using
    -- a conditions table if needed. As such, if there isn't
    -- a conditions table, then simply return true.
    if conditions == nil then
        return true
    end
    local numConditions = #conditions
    if numConditions and numConditions > 0 then
        for _, condition in ipairs(conditions) do
            local conditionType = LSU.Split(condition, ";", 1)
            if conditionType == "!CT_EXPANSION" then
                local expansionID = LSU.Split(condition, ";", 2)
                if UnitChromieTimeID("player") ~= expansionID and UnitLevel("player") < (GetMaxLevelForPlayerExpansion() - 10) then
                    numConditions = numConditions - 1
                end
            elseif conditionType == "OBJECTIVE_INCOMPLETE" then
                local questID, objectiveIndex = LSU.Split(condition, ";", "2*")
                if C_QuestLog.IsOnQuest(questID) and objectiveIndex then
                    local objectives = C_QuestLog.GetQuestObjectives(questID)
                    if objectives and objectives[objectiveIndex] then
                        if not objectives[objectiveIndex].finished then
                            numConditions = numConditions - 1
                        end
                    end
                end
            elseif conditionType == "QUEST_ACTIVE" then
                local questID = LSU.Split(condition, ";", 2)
                if C_QuestLog.IsOnQuest(questID) then
                    numConditions = numConditions - 1
                end
            end
        end
        if numConditions == 0 then
            return true
        end
        return false
    end
end