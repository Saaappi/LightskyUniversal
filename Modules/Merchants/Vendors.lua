local addonName, addonTable = ...

local function GetRequiredQuestItemCountByName(itemName)
    local requiredCount = 0
    local questLogEntries = C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetNumQuestLogEntries() or GetNumQuestLogEntries()
    for questIndex = 1, questLogEntries do
        local questID = C_QuestLog.GetQuestIDForLogIndex and C_QuestLog.GetQuestIDForLogIndex(questIndex)
        if questID then
            local objectives = C_QuestLog.GetQuestObjectives(questID)
            if objectives then
                for _, objective in ipairs(objectives) do
                    if objective.type == "item" and objective.text and string.find(objective.text, itemName, 1, true) then
                        requiredCount = requiredCount + (objective.numRequired or 0)
                    end
                end
            end
        end
    end
    return requiredCount
end

MerchantFrame:HookScript("OnShow", function()
    if CanMerchantRepair() then
        if not LSUDB.Settings["AutoRepair.Enabled"] then return end
        local cost = GetRepairAllCost()
        local money = GetMoney()
        local reservePercent = 0.33 -- Keep at least 33% of money
        if cost > 0 and (money - cost) > (money * reservePercent) then
            RepairAllItems(false)
        end
    end

    if not LSUDB.Settings["BuyQuestItems.Enabled"] then return end
    for index = 1, GetMerchantNumItems() do
        local itemLink = GetMerchantItemLink(index)
        if itemLink then
            local itemName, _, _, _, _, itemType, itemSubType = C_Item.GetItemInfo(itemLink)
            if itemType == "Quest" and itemSubType == "Quest" then
                local itemID = GetMerchantItemID(index)
                local requiredCount = GetRequiredQuestItemCountByName(itemName)
                local ownedCount = C_Item.GetItemCount(itemID, false, false)
                local toBuy = requiredCount - ownedCount
                local maxStackCount = GetMerchantItemMaxStack(index)
                if toBuy > 0 then
                    while toBuy > 0 do
                        local purchaseAmount = math.min(toBuy, maxStackCount)
                        BuyMerchantItem(index, purchaseAmount)
                        toBuy = toBuy - purchaseAmount
                    end
                end
            end
        end
    end
end)