local addonName, LSU = ...

LSU.iContains = function(tbl, value)
    if tbl then
        for _, v in ipairs(tbl) do
            if v == value then
                return true
            end
        end
        return false
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
            if conditionType == "OBJECTIVE_INCOMPLETE" then
                local questID, objectiveIndex = LSU.Split(condition, ";", "2*")
                if C_QuestLog.IsOnQuest(questID) and objectiveIndex then
                    local objectives = C_QuestLog.GetQuestObjectives(questID)
                    if objectives and objectives[objectiveIndex] then
                        if not objectives[objectiveIndex].finished then
                            numConditions = numConditions - 1
                        end
                    end
                end
            end
        end
        if numConditions == 0 then
            return true
        end
        return false
    end
end