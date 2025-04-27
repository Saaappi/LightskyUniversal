local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

local function GetParentMapID(mapID)
    local mapInfo = C_Map.GetMapInfo(mapID)
    if mapInfo then
        if mapInfo.mapType == 3 or mapInfo.mapType == 4 or mapInfo.mapType == 5 then
            GetParentMapID(mapInfo.parentMapID)
        end
        LSU.mapID = mapInfo.parentMapID
    end
end

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LOGIN" then
        C_Timer.After(3, function()
            local mapID = C_Map.GetBestMapForUnit("player")
            if mapID then
                local parentMapID = GetParentMapID(mapID)
                if parentMapID then
                    LSU.mapID = parentMapID
                end
            end
        end)
    end
    if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            local parentMapID = GetParentMapID(mapID)
            if parentMapID then
                LSU.mapID = parentMapID
            end
        end
    end
end)