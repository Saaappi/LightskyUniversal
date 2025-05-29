local LSU = select(2, ...)

LSU.Enum.Blacklisted = {}
LSU.Enum.Blacklisted.Cinematics = {
    [1] = { -- Durotar
        "QUEST_ACTIVE;25187" -- Lost in the Floods
    }
}
LSU.Enum.Blacklisted.Quests = {
    [9217] = { -- More Rotting Hearts
        isIgnored = true,
        response = ""
    },
    [9219] = { -- More Spinal Dust
        isIgnored = true,
        response = ""
    },
    [59583] = { -- Welcome to Stormwind
        isIgnored = true,
        response = ""
    },
    [60343] = { -- Welcome to Orgrimmar
        isIgnored = true,
        response = ""
    }
}