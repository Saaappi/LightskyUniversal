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
                    ["ChromieTimeExpansionID"] = 0,
                    ["CompleteQuests.Enabled"] = false,
                    ["Gossip.Enabled"] = false,
                    ["NewCharacter.Enabled"] = false,
                    ["PlayerTalents.Enabled"] = false,
                    ["QuestRewards.Enabled"] = false,
                    ["Rares.Enabled"] = false,
                    ["ReadyChecks.Enabled"] = false,
                    ["RoleChecks.Enabled"] = false,
                    ["SkipCinematics.Enabled"] = false,
                    ["WarbankDepositInCopper"] = 0
                }
            end
        end
    end
end)