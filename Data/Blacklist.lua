local LSU = select(2, ...)

LSU.Enum.Blacklisted = {}
LSU.Enum.Blacklisted.Cinematics = {
    [1] = { -- Durotar
        "QUEST_ACTIVE;25187" -- Lost in the Floods
    }
}
LSU.Enum.Blacklisted.Quests = {
    [59583] = {
        isIgnored = true,
        response = ""
    }
}