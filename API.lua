local LSU = select(2, ...)

-- API for GOSSIP_SHOW event
LSU.QuestGossipShowAPI = function()
    return {
        getNumActive = C_GossipInfo.GetNumActiveQuests,
        getActive = C_GossipInfo.GetActiveQuests,
        selectActive = function(quest) C_GossipInfo.SelectActiveQuest(quest.questID) end,
        getNumAvailable = C_GossipInfo.GetNumAvailableQuests,
        getAvailable = C_GossipInfo.GetAvailableQuests,
        selectAvailable = function(quest) C_GossipInfo.SelectAvailableQuest(quest.questID) end,
        isComplete = function(quest) return quest.isComplete end,
        getQuestID = function(quest) return quest.questID end
    }
end

-- API for QUEST_GREETING event
LSU.QuestGreetingAPI = function()
    return {
        getNumActive = GetNumActiveQuests,
        getActive = function()
            local quests = {}
            for index = 1, GetNumActiveQuests() do
                quests[index] = {
                    questID = GetActiveQuestID(index),
                    isComplete = select(2, GetActiveTitle(index)),
                    index = index
                }
            end
            return quests
        end,
        selectActive = function(quest) SelectActiveQuest(quest.index) end,
        getNumAvailable = GetNumAvailableQuests,
        getAvailable = function()
            local quests = {}
            for index = 1, GetNumAvailableQuests() do
                local questID = select(5, GetAvailableQuestInfo(index))
                quests[index] = {
                    questID = questID,
                    index = index
                }
            end
            return quests
        end,
        selectAvailable = function(quest) SelectAvailableQuest(quest.index) end,
        isComplete = function(quest) return quest.isComplete end,
        getQuestID = function(quest) return quest.questID end
    }
end

LSU.ProcessQuestsAndGossipsSequentially = function(API)
    -- Turn in completed quests first, then accept new ones
    local function ProcessActiveQuests(i, callback)
        local numActive = API.getNumActive()
        if i > numActive then
            if callback then
                callback()
            end
            return
        end
        local activeQuests = API.getActive()
        local quest = activeQuests[i]
        if quest and API.isComplete(quest) then
            API.selectActive(quest)
            C_Timer.After(0.15, function()
                ProcessActiveQuests(i+1, callback)
            end)
        else
            ProcessActiveQuests(i+1, callback)
        end
    end

    local function ProcessAvailableQuests(i, callback)
        local numAvailable = API.getNumAvailable()
        if i > numAvailable then
            if callback then
                callback()
            end
            return
        end
        local availableQuests = API.getAvailable()
        local quest = availableQuests[i]
        if quest then
            local questID = API.getQuestID(quest)
            local isIgnored, response = LSU.IsQuestIgnored(questID)
            if not isIgnored and not C_QuestLog.IsOnQuest(questID) then
                API.selectAvailable(quest)
                C_Timer.After(0.15, function()
                    ProcessAvailableQuests(i+1, callback)
                end)
            else
                if response then
                    local func = loadstring(response)
                    if func then func() end
                end
                ProcessAvailableQuests(i+1, callback)
            end
        else
            ProcessAvailableQuests(i+1, callback)
        end
    end

    local function ProcessAvailableGossips()
        local options = C_GossipInfo.GetOptions()
        if options then
            if #options == 1 and options[1].icon == 132060 then -- The only option is "Show me your wares" or some other variant, so just pick it automatically
                C_GossipInfo.SelectOption(options[1].gossipOptionID)
            else
                local guid = UnitGUID("npc")
                if guid then
                    local id = LSU.Split(guid, "-", 6)
                    if id then
                        local isValid, gossips = LSU.IsValidGossipNPC(id)
                        if isValid and gossips then
                            for _, gossip in ipairs(gossips) do
                                local isAllowed = LSU.EvaluateConditions(gossip.conditions)
                                if isAllowed then
                                    C_GossipInfo.SelectOption(gossip.gossipOptionID)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    ProcessActiveQuests(1, function()
        C_Timer.After(0.25, function()
            ProcessAvailableQuests(1, function()
                C_Timer.After(0.25, ProcessAvailableGossips)
            end)
        end)
    end)
end