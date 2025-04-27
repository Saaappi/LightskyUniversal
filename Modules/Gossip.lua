local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

local function IsValidGossipNPC(id)
    if LSU.Gossips[LSU.mapID] then
        if LSU.Gossips[LSU.mapID][id] then
            return true, LSU.Gossips[LSU.mapID][id]
        end
    end
    return false
end

eventFrame:RegisterEvent("GOSSIP_SHOW")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "GOSSIP_SHOW" then
        local options = C_GossipInfo.GetOptions()
        if options then
            local guid = UnitGUID("npc")
            if guid then
                local id = LSU.Split(guid, "-", 6)
                if id then
                    local isValid, gossips = IsValidGossipNPC(id)
                    if isValid and gossips then
                        for _, gossip in ipairs(gossips) do
                            local isAllowed = LSU.EvaluateConditions(gossip.conditions)
                            if isAllowed then
                                C_GossipInfo.SelectOption(gossip.optionID)
                                C_Timer.After(.2, function()
                                    StaticPopup1Button1:Click("LeftButton")
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)