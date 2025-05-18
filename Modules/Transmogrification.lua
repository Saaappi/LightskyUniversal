local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")
local transmogrificationButton
local button = {
    type        = "ActionButton",
    name        = "LSUTransmogrificationButton",
    parent      = Baganator_SingleViewBackpackViewFrameblizzard,
    scale       = 0.50,
    texture     = 1723993,
    tooltipText = LSU.Locale.BUTTON_DESCRIPTION_TRANSMOGRIFICATION
}
local transmogrificationSlotIDs = { 1, 3, 4, 5, 6, 7, 8, 9, 10, 15, 16, 17, 18, 19 }

MerchantFrame:HookScript("OnShow", function()
    if MerchantFrame.FilterDropdown then
        SetMerchantFilter(LE_LOOT_FILTER_ALL)
    end
end)

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        if C_AddOns.IsAddOnLoaded("Baganator") then
            C_Timer.After(1, function()
                local characterFullName = Syndicator.API.GetCurrentCharacter()
                Baganator_SingleViewBackpackViewFrameblizzard:HookScript("OnShow", function()
                    if not transmogrificationButton then
                        transmogrificationButton = LSU.CreateButton(button)
                    end

                    if transmogrificationButton then
                        transmogrificationButton:ClearAllPoints()
                        transmogrificationButton:SetPoint("TOPRIGHT", Baganator_SingleViewBackpackViewFrameblizzard, "TOPLEFT", -5, 0)
                        transmogrificationButton:SetScript("OnClick", function()
                            if not InCombatLockdown() then
                                local character = Syndicator.API.GetByCharacterFullName(characterFullName)
                                local equippedItems = {}
                                for _, equippedItem in pairs(character.equipped) do
                                    if equippedItem and equippedItem.itemLink then
                                        table.insert(equippedItems, { itemLink = equippedItem.itemLink })
                                    end
                                end
                                for index, bag in pairs(character.bags) do
                                    for slotID, item in pairs(bag) do
                                        if item and item.itemLink then
                                            local bagID = Syndicator.Constants.AllBagIndexes[index]
                                            local itemLocation = ItemLocation:CreateFromBagAndSlot(bagID, slotID)
                                            local sourceID = C_Item.GetBaseItemTransmogInfo(itemLocation).appearanceID
                                            if sourceID then
                                                local isCollected = select(5, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
                                                if not isCollected then
                                                    local canCollectSource = select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID))
                                                    if canCollectSource then
                                                        C_Item.EquipItemByName(item.itemLink)
                                                        if StaticPopup1:IsVisible() then
                                                            local text = StaticPopup1Text:GetText()
                                                            if text == CONVERT_TO_BIND_TO_ACCOUNT_CONFIRM then
                                                                StaticPopup1Button1:Click("LeftButton")
                                                                ClearCursor()
                                                            else
                                                                StaticPopup1Button1:Click("LeftButton")
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                C_Timer.After(1, function()
                                    for _, item in ipairs(equippedItems) do
                                        C_Item.EquipItemByName(item.itemLink)
                                    end
                                end)
                            end
                        end)
                        transmogrificationButton:Show()
                    end
                end)
                Baganator_SingleViewBackpackViewFrameblizzard:HookScript("OnHide", function()
                    if transmogrificationButton then
                        transmogrificationButton:Hide()
                    end
                end)
            end)
            eventFrame:UnregisterEvent(event)
        end
    end
end)