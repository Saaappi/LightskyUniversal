local addonTable = select(2, ...)

function addonTable.GetQuestIconByID(questID)
    local icon = addonTable.Enum.QuestIcons[questID]
    if icon then
        return "|T" .. icon .. ":0|t "
    end
    return "|T" .. 1129713 .. ":0|t "
end