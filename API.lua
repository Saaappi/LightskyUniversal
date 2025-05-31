local addonName, LSU = ...

-- Adapter for GOSSIP_SHOW event
LSU.GossipAPI = function()
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

-- Adapter for QUEST_GREETING event
LSU.ClassicAPI = function()
    return {
        getNumActive = GetNumActiveQuests,
        getActive = function()
            local quests = {}
            for i = 1, GetNumActiveQuests() do
                quests[i] = {
                    questID = GetActiveQuestID(i),
                    isComplete = select(2, GetActiveTitle(i))
                }
            end
            return quests
        end,
        selectActive = function(quest) SelectActiveQuest(quest.questID) end,
        getNumAvailable = GetNumAvailableQuests,
        getAvailable = function()
            local quests = {}
            for i = 1, GetNumAvailableQuests() do
                local questID = select(5, GetAvailableQuestInfo(i))
                quests[i] = { questID = questID }
            end
            return quests
        end,
        selectAvailable = function(quest) SelectAvailableQuest(quest.questID) end,
        isComplete = function(quest) return quest.isComplete end,
        getQuestID = function(quest) return quest.questID end
    }
end

LSU.ProcessQuestsSequentially = function(API)
    -- Turn in completed quests first, then accept new ones
    local function ProcessActiveQuests(i, callback)
        local numActive = API.getNumActive()
        if i > numActive then
            callback()
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

    local function ProcessAvailableQuests(i)
        local numAvailable = API.getNumAvailable()
        if i > numAvailable then return end
        local availableQuests = API.getAvailable()
        local quest = availableQuests[i]
        if quest then
            local questID = API.getQuestID(quest)
            local isIgnored, response = LSU.IsQuestIgnored(questID)
            if not isIgnored and not C_QuestLog.IsOnQuest(questID) then
                API.selectAvailable(quest)
                C_Timer.After(0.15, function()
                    ProcessAvailableQuests(i+1)
                end)
            else
                if response then
                    local func = loadstring(response)
                    if func then func() end
                end
                ProcessAvailableQuests(i+1)
            end
        else
            ProcessAvailableQuests(i+1)
        end
    end

    ProcessActiveQuests(1, function()
        ProcessAvailableQuests(1)
    end)
end