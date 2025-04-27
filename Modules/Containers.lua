--[[local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")
local lsuSecureOpenButton = CreateFrame("ItemButton", "LSUSecureOpenButton", UIParent, "SecureActionButtonTemplate")
lsuSecureOpenButton:SetScale(1.25, 1.25)

eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "BAG_UPDATE" then
        lsuSecureOpenButton:SetAttribute("type", "item")
        lsuSecureOpenButton:SetAttribute("item", nil)
        local autoLootState = C_CVar.GetCVar("autoLootDefault")
            if autoLootState == "1" then
                for bagID = NUM_BAG_SLOTS, 0, -1 do
                    for slotID = C_Container.GetContainerNumSlots(bagID), 1, -1 do
                        local item = C_Container.GetContainerItemInfo(bagID, slotID)
                        if item then
                            if LSU.iContains(LSU.Containers, item.itemID) then
                                lsuSecureOpenButton:SetItemButtonTexture(item.iconFileID)
                                lsuSecureOpenButton:SetItemButtonQuality(item.quality, item.hyperlink, false, item.isBound)
                                lsuSecureOpenButton:SetAttribute("item", bagID .. " " .. slotID)
                                lsuSecureOpenButton:SetScript("OnEnter", function(self)
                                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                                    GameTooltip:SetItemByID(item.itemID)
                                end)
                            end
                        end
                    end
                end
            end
    elseif event == "PLAYER_LOGIN" then
        lsuSecureOpenButton:RegisterForClicks("AnyUp", "AnyDown")

        lsuSecureOpenButton:ClearAllPoints()
        lsuSecureOpenButton:SetPoint("TOP", UIParent, "TOP", 0, -75)

        eventFrame:UnregisterEvent(event)
    end
end)

lsuSecureOpenButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
lsuSecureOpenButton:SetItemButtonTexture(236997)
SetOverrideBindingClick(lsuSecureOpenButton, true, "F1", "LSUSecureOpenButton", nil)
]]