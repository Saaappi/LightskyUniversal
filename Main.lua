local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == addonName then
            if LSUDB == nil then
                LSUDB = {}
                LSUDB.Characters = {}
                LSUDB.Gossips = {}
                LSUDB.Junk = {}
                LSUDB.PlayerTalents = {}
                LSUDB.Settings = {
                    ["AcceptQuests.Enabled"] = false,
                    ["AutoRepair.Enabled"] = false,
                    ["AutoTrain.Enabled"] = false,
                    ["BuyQuestItems.Enabled"] = false,
                    ["ChatIcons.Enabled"] = false,
                    ["CompleteQuests.Enabled"] = false,
                    ["Gossip.Enabled"] = false,
                    ["PlayerTalents.Enabled"] = false,
                    ["Rares.Enabled"] = false,
                    ["ReadyChecks.Enabled"] = false,
                    ["RoleChecks.Enabled"] = false,
                    ["SkipCinematics.Enabled"] = false,
                }
            end
        end
    end
end)