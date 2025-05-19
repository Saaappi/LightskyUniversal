local addonName, LSU = ...
local sellJunkButton
local button = {
    type        = "ActionButton",
    name        = "LSUSellJunkButton",
    parent      = MerchantFrame,
    scale       = 0.75,
    texture     = 133785,
    tooltipText = LSU.Locale.BUTTON_DESCRIPTION_SELLJUNK
}

local function AddTextToTooltip(tooltip)
	local frame, text
	for i = 1, 30 do
		frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		if frame then text = frame:GetText() end
		if text and string.find(text, addonName) then return end
	end

	tooltip:AddLine("\n")
	tooltip:AddLine(CreateAtlasMarkup("auctionhouse-icon-coin-gold") .. " " .. LSU.Locale.TOOLTIP_TEXT_ISJUNK)
	tooltip:Show()
end

local function OnTooltipSetItem(tooltip)
	if tooltip then
		local _, _, itemID = TooltipUtil.GetDisplayedItem(tooltip)
		if not itemID then return end

        for _, id in ipairs(LSU.Enum.Junk) do
            if id == itemID then
                AddTextToTooltip(tooltip)
                return
            end
        end
	end
end

local function IsJunk(itemID)
    for _, id in ipairs(LSU.Enum.Junk) do
        if id == itemID then
            return true
        end
    end
    return false
end

MerchantFrame:HookScript("OnShow", function()
    if not sellJunkButton then
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
                                if IsJunk(item.itemID) then
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
    end
end)

MerchantFrame:HookScript("OnHide", function()
    sellJunkButton:Hide()
end)

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)