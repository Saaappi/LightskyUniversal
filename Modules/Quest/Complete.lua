local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")

--[[local function IsWeapon(itemLink)
    local classID = select(12, C_Item.GetItemInfo(itemLink))
    return classID == 2
end

local function GetSellPrice(itemLink)
    return (select(11, C_Item.GetItemInfo(itemLink)))
end

local function GetEquippedItemLevel(loc)
    if not loc then return 0 end

end]]

--[[local LSU = select(2, ...)
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
        local itemLevels = {}
        for _, invSlot in pairs(slot) do
            local equippedLink = GetInventoryItemLink("player", invSlot)
            table.insert(itemLevels, C_Item.GetDetailedItemLevelInfo(equippedLink) or 0)
        end
        return itemLevels
    else
        local equippedLink = GetInventoryItemLink("player", slot) or ""
        return C_Item.GetDetailedItemLevelInfo(equippedLink) or 0
    end
end]]

local inventoryValueToSlotID = {
    [17] = 16, -- INVTYPE_2HWEAPON
    [21] = 16, -- INVTYPE_WEAPONMAINHAND
}

QuestFrame:HookScript("OnShow", function()
    if not LSUDB.Settings["CompleteQuests.Enabled"] then return end
    if IsQuestCompletable() then
        CompleteQuest()
    else
        local numRewards = GetNumQuestChoices()
        if numRewards <= 1 then
            GetQuestReward(1)
            QuestFrameCompleteQuestButton:Click()
        elseif numRewards > 1 then
            local bestIndex, bestUpgrade = 1, -math.huge
            for i = 1, numRewards do
                local link = GetQuestItemLink("choice", i)
                if link then
                    local rewardLevel = C_Item.GetDetailedItemLevelInfo(link)
                    local loc = select(9, C_Item.GetItemInfo(link))
                    if loc ~= "INVTYPE_NON_EQUIP_IGNORE" then
                        local rewardInventoryTypeValue = C_Item.GetItemInventoryTypeByID(link)
                        if inventoryValueToSlotID[rewardInventoryTypeValue] then
                            local invSlotID = inventoryValueToSlotID[rewardInventoryTypeValue]
                            local equippedLink = GetInventoryItemLink("player", invSlotID)
                            local equippedLevel = C_Item.GetDetailedItemLevelInfo(equippedLink)
                            local equippedInventoryTypeValue = C_Item.GetItemInventoryTypeByID(equippedLink)
                            if equippedInventoryTypeValue == rewardInventoryTypeValue then
                                print(link, " is the same inventory type!")
                            end
                        end
                    end
                end
            end
        end
    end
end)
--[[eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "QUEST_COMPLETE" then
        if not LSUDB.Settings["CompleteQuests.Enabled"] then return end
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

                if not LSUDB.Settings["QuestRewardSelectionID"] or LSUDB.Settings["QuestRewardSelectionID"] == 0 then return end
                local numBetterRewards = #bestRewardIndices
                if numBetterRewards > 0 then
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
        if not LSUDB.Settings["CompleteQuests.Enabled"] then return end
        C_Timer.After(0.2, function()
            if IsQuestCompletable() then
                CompleteQuest()
            end
        end)
    end
end)]]