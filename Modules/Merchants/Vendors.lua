local addonName, LSU = ...
local L = LSU.L
--[[local sellJunkButton
local button = {
    type        = "ActionButton",
    name        = "LSUSellJunkButton",
    parent      = MerchantFrame,
    scale       = 0.75,
    texture     = 133785,
    tooltipText = L.SELL_JUNK_BUTTON_TOOLTIP
}]]

--[[local function AddTextToTooltip(tooltip)
	local frame, text
	for i = 1, 30 do
		frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		if frame then text = frame:GetText() end
		if text and string.find(text, addonName) then return end
	end

	tooltip:AddLine("\n")
	tooltip:AddLine(CreateAtlasMarkup("auctionhouse-icon-coin-gold") .. " " .. L.SELL_JUNK_TOOLTIP)
	tooltip:Show()
end

local function OnTooltipSetItem(tooltip)
	if tooltip then
		local _, _, itemID = TooltipUtil.GetDisplayedItem(tooltip)
		if not itemID then return end

        if LSU.IsJunk(itemID) then
            AddTextToTooltip(tooltip)
            return
        end
	end
end]]

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

    --[[if not sellJunkButton then
        sellJunkButton = LSU.CreateButton(button)
        if sellJunkButton then
            sellJunkButton:ClearAllPoints()
            sellJunkButton:SetPoint("BOTTOMLEFT", sellJunkButton:GetParent(), "BOTTOMRIGHT", 5, 0)
            sellJunkButton:SetScript("OnClick", function()
                if not InCombatLockdown() then
                    local character = Syndicator.API.GetByCharacterFullName(Syndicator.API.GetCurrentCharacter())
                    for index, bag in pairs(character.bags) do
                        for slotID, item in pairs(bag) do
                            if item and item.itemLink then
                                local bagID = Syndicator.Constants.AllBagIndexes[index]
                                if LSU.IsJunk(item.itemID) then
                                    C_Container.UseContainerItem(bagID, slotID)
                                end
                            end
                        end
                    end
                end
            end)
            sellJunkButton:Show()
        end
    else
        sellJunkButton:Show()
    end]]
end)

--[[MerchantFrame:HookScript("OnHide", function()
    sellJunkButton:Hide()
end)

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)]]