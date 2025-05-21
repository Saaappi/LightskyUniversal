local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

local function IsValidGossipNPC(id)
    if LSU.Enum.Gossips[LSU.Map.ContinentMapID] then
        if LSU.Enum.Gossips[LSU.Map.ContinentMapID][id] then
            return true, LSU.Enum.Gossips[LSU.Map.ContinentMapID][id]
        end
    end
    return false
end

eventFrame:RegisterEvent("GOSSIP_SHOW")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "GOSSIP_SHOW" then
        C_Timer.After(0.35, function()
            local numActiveQuests = C_GossipInfo.GetNumActiveQuests()
            local numAvailableQuests = C_GossipInfo.GetNumAvailableQuests()
            if numActiveQuests > 0 then
                local activeQuests = C_GossipInfo.GetActiveQuests()
                for i = 1, numActiveQuests do
                    local quest = activeQuests[i]
                    if quest.isComplete then
                        C_GossipInfo.SelectActiveQuest(quest.questID)
                    end
                end
            end
            if numAvailableQuests > 0 then
                local availableQuests = C_GossipInfo.GetAvailableQuests()
                for i = 1, numAvailableQuests do
                    local quest = availableQuests[i]
                    local isIgnored, response = LSU.IsQuestIgnored(quest.questID)
                    if not isIgnored and not C_QuestLog.IsOnQuest(quest.questID) then
                        C_GossipInfo.SelectAvailableQuest(quest.questID)
                    else
                        if response then
                            local func = loadstring(response)
                            if func then
                                func()
                            end
                        end
                    end
                end
            end

            local options = C_GossipInfo.GetOptions()
            if options then
                if #options == 1 and options[1].icon == 132060 then -- The only option is "Show me your wares" or some other variant, so just pick it automatically
                    C_GossipInfo.SelectOption(options[1].gossipOptionID)
                else
                    local guid = UnitGUID("npc")
                    if guid then
                        local id = LSU.Split(guid, "-", 6)
                        if id then
                            local isValid, gossips = IsValidGossipNPC(id)
                            if isValid and gossips then
                                for _, gossip in ipairs(gossips) do
                                    local isAllowed = LSU.EvaluateConditions(gossip.conditions)
                                    if isAllowed then
                                        C_GossipInfo.SelectOption(gossip.optionID)
                                        C_Timer.After(.2, function()
                                            StaticPopup1Button1:Click("LeftButton")
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)