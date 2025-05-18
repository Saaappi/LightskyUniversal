local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")
local openContainersButton
local button = {
    type        = "InsecureItemActionButton",
    name        = "LSUOpenContainersButton",
    parent      = Baganator_SingleViewBackpackViewFrameblizzard,
    scale       = 0.65,
    texture     = 132595,
    tooltipText = LSU.Locale.BUTTON_DESCRIPTION_CONTAINERS
}

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        if C_AddOns.IsAddOnLoaded("Baganator") then
            C_Timer.After(1, function()
                local characterFullName = Syndicator.API.GetCurrentCharacter()
                Baganator_SingleViewBackpackViewFrameblizzard:HookScript("OnShow", function()
                    if not openContainersButton then
                        openContainersButton = LSU.CreateButton(button)
                    end

                    if openContainersButton then
                        openContainersButton:ClearAllPoints()
                        openContainersButton:SetPoint("TOPRIGHT", Baganator_SingleViewBackpackViewFrameblizzard, "TOPLEFT", -5, -55)
                        openContainersButton:SetScript("PostClick", function()
                            openContainersButton:SetAttribute("type", "item")
                            openContainersButton:SetAttribute("item", nil)
                            if not InCombatLockdown() then
                                local character = Syndicator.API.GetByCharacterFullName(characterFullName)
                                if character then
                                    for index, bag in pairs(character.bags) do
                                        for slotID, item in pairs(bag) do
                                            if item and item.itemLink and item.hasLoot then
                                                local bagID = Syndicator.Constants.AllBagIndexes[index]
                                                openContainersButton:SetAttribute("item", bagID .. " " .. slotID)
                                            end
                                        end
                                    end
                                else
                                    LSU.PrintWarning("The {character} variable is nil. Please reload.")
                                end
                            end
                        end)
                        openContainersButton:Show()
                    end
                end)
                Baganator_SingleViewBackpackViewFrameblizzard:HookScript("OnHide", function()
                    if openContainersButton then
                        openContainersButton:Hide()
                    end
                end)
            end)
            eventFrame:UnregisterEvent(event)
        end
    end
end)