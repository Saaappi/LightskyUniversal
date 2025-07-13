local addonTable = select(2, ...)

function addonTable.EvaluateConditions(conditions)
    if not conditions or #conditions == 0 then
        return true
    end

    for _, condition in ipairs(conditions) do
        local parts = { strsplit(";", condition) }
        local conditionType = parts[1] and string.upper(parts[1])

        if conditionType == "!CT_EXPANSION" then
            local expansionID = tonumber(parts[2])
            if addonTable.Player.ChromieTimeExpansionID == expansionID or addonTable.Player.Level >= (GetMaxLevelForPlayerExpansion() - 10) then
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
        --new
        elseif conditionType == "QUEST_INACTIVE" then
            local questID = tonumber(parts[2])
            if not questID or C_QuestLog.IsOnQuest(questID) then
                return false
            end
        elseif conditionType == "LEVEL_LOWER" then
            local level = tonumber(parts[2])
            if not level or addonTable.Player.Level > level then
                return false
            end
        elseif conditionType == "LEVEL_BETWEEN" then
            local minLevel, maxLevel = tonumber(parts[2]), tonumber(parts[3])
            if (not minLevel or not maxLevel) or (addonTable.Player.Level < minLevel) or (addonTable.Player.Level > maxLevel) then
                return false
            end
        elseif conditionType == "LEVEL_HIGHER" then
            local level = tonumber(parts[2])
            if not level or addonTable.Player.Level < level then
                return false
            end
        end
        return true
    end
end