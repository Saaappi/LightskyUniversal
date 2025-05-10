local addonName, LSU = ...

LSU.Blacklist = {}
LSU.Blacklist.Quests = {
    [59583] = { -- Welcome to Stormwind
        isIgnored = true,
        response = "C_GossipInfo.SelectOption(51396)"
    }
}