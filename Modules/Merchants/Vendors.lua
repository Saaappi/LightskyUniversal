local function IsObjectiveMatch(itemName, objectiveText)
    -- Case-insensitive comparison
    local itemNameLower = itemName:lower()
    local objectiveTextLower = objectiveText:lower()

    -- Full name match
    if string.find(objectiveTextLower, itemNameLower) then
        return true
    end

    -- Split itemName into words
    local words = {}
    for word in itemNameLower:gmatch("%w+") do
        table.insert(words, word)
    end

    -- Require at least one significant word to match
    local significantWordCount = 0
    for _, word in ipairs(words) do
        -- Skip very short/common words
        if #word > 2 and not (word == "the" or word == "of" or word == "and") then
            if string.find(objectiveTextLower, word) then
                significantWordCount = significantWordCount + 1
            end
        end
    end

    -- You can adjust threshold if needed (e.g., at least 1 or 2 words must match)
    return significantWordCount > 0
end

local function GetRequiredQuestItemCountByName(itemName)
    local requiredCount = 0
    local questLogEntries = C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetNumQuestLogEntries() or GetNumQuestLogEntries()
    for questIndex = 1, questLogEntries do
        local questID = C_QuestLog.GetQuestIDForLogIndex and C_QuestLog.GetQuestIDForLogIndex(questIndex)
        if questID then
            local objectives = C_QuestLog.GetQuestObjectives(questID)
            if objectives then
                for _, objective in ipairs(objectives) do
                    if objective.type == "item" and (objective.text and IsObjectiveMatch(itemName, objective.text)) then
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
            if itemType == "Quest" or itemType == "Miscellaneous" then
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