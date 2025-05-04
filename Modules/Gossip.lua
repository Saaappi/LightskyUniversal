local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

local function IsValidGossipNPC(id)
    if LSU.Gossips[LSU.Map.ID] then
        if LSU.Gossips[LSU.Map.ID][id] then
            return true, LSU.Gossips[LSU.Map.ID][id]
        end
    end
    return false
end

eventFrame:RegisterEvent("GOSSIP_SHOW")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "GOSSIP_SHOW" then
        local options = C_GossipInfo.GetOptions()
        if options and (#options > 1) then
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
        elseif options and (#options == 1) then
            if options[1].icon == 132060 then -- The only option is "Show me your wares" or some other variant, so just pick it automatically
                C_GossipInfo.SelectOption(options[1].gossipOptionID)
            end
        end
    end
end)