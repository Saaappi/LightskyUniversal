local addonTable = select(2, ...)

-- API for GOSSIP_SHOW event
addonTable.QuestGossipShowAPI = function()
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
addonTable.QuestGreetingAPI = function()
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

addonTable.ProcessQuestsAndGossipsSequentially = function(API)
    -- Turn in completed quests first, then accept new ones
    local function ProcessActiveQuests(i, callback)
        if not LSUDB.Settings["CompleteQuests.Enabled"] then return end
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
        if not LSUDB.Settings["AcceptQuests.Enabled"] then return end
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
            local isIgnored, response = addonTable.IsQuestIgnored(questID)
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
        if not LSUDB.Settings["Gossip.Enabled"] then return end
        local options = C_GossipInfo.GetOptions()
        if options then
            local guid = UnitGUID("npc")
            if guid then
                local id = addonTable.Split(guid, "-", 6)
                if id then
                    local isValid, gossips = addonTable.IsValidGossipNPC(id)
                    if isValid and gossips then
                        for _, gossip in ipairs(gossips) do
                            local isAllowed = addonTable.EvaluateConditions(gossip.conditions)
                            if isAllowed then
                                C_GossipInfo.SelectOption(gossip.gossipOptionID)
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