local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")
local bestRewardIndices = {}
local bestRewardIndex, bestItemLevelDifference = 0, 0
local slots = {
    INVTYPE_HEAD        = 1,
    INVTYPE_NECK        = 2,
    INVTYPE_SHOULDER    = 3,
    INVTYPE_CHEST       = 5,
    INVTYPE_WAIST       = 6,
    INVTYPE_LEGS        = 7,
    INVTYPE_FEET        = 8,
    INVTYPE_HAND        = 10,
    INVTYPE_FINGER      = 11,
    INVTYPE_SHIELD      = 14,
    INVTYPE_CLOAK       = 16,
    INVTYPE_HOLDABLE    = 23,
}

local function IsWeapon(itemLink)
    local _, _, _, _, _, _, _, _, _, _, _, classID = C_Item.GetItemInfo(itemLink)
    if classID == 2 then
        return true
    end
    return false
end

local function GetEquippedItemLevel(equipLoc)
    local slot = slots[equipLoc]
    if not slot then return nil end
    if type(slot) == "table" then
        --[[local itemLevels = {}
        for _, invSlot in pairs(slot) do
            local equippedLink = GetInventoryItemLink("player", invSlot)
            table.insert(itemLevels, C_Item.GetDetailedItemLevelInfo(equippedLink) or 0)
        end
        return itemLevels]]
    else
        local equippedLink = GetInventoryItemLink("player", slot)
        return C_Item.GetDetailedItemLevelInfo(equippedLink) or 0
    end
end

eventFrame:RegisterEvent("QUEST_COMPLETE")
eventFrame:RegisterEvent("QUEST_PROGRESS")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "QUEST_COMPLETE" then
        C_Timer.After(0.2, function()
            local numRewardChoices = GetNumQuestChoices()
            if numRewardChoices <= 1 then
                GetQuestReward(1)
                QuestFrameCompleteQuestButton:Click("LeftButton")
            else
                for i = 1, numRewardChoices do
                    local rewardLink = GetQuestItemLink("choice", i)
                    if rewardLink and not IsWeapon(rewardLink) then
                        local rewardLevel = C_Item.GetDetailedItemLevelInfo(rewardLink)
                        local equipLoc = select(9, C_Item.GetItemInfo(rewardLink))

                        if equipLoc ~= "INVTYPE_NON_EQUIP_IGNORE" then
                            local equippedLevel = GetEquippedItemLevel(equipLoc)
                            if rewardLevel > equippedLevel then
                                local diff = rewardLevel - equippedLevel
                                if diff > bestItemLevelDifference then
                                    bestItemLevelDifference = diff
                                    table.insert(bestRewardIndices, i)
                                elseif diff == bestItemLevelDifference then
                                    table.insert(bestRewardIndices, i)
                                end
                            end
                        end
                    end
                end

                local numBetterRewards = #bestRewardIndices
                if numBetterRewards > 0 then
                    LSU.Print(LSU.Locale.STDOUT_QUEST_REWARD_SAME_DIFF)
                    local chosenIndex = bestRewardIndices[math.random(1, numBetterRewards)]
                    GetQuestReward(chosenIndex)
                else
                    -- Nothing is better than equipped, so just take the first reward.
                    GetQuestReward(1)
                end
            end
        end)
    end
    if event == "QUEST_PROGRESS" then
        C_Timer.After(0.2, function()
            if IsQuestCompletable() then
                CompleteQuest()
            end
        end)
    end
end)