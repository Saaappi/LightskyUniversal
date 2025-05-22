local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

local function GetContinentMapID(mapID)
    local recheckMapTypes = { 3, 4, 5, 6 }
    local mapInfo = C_Map.GetMapInfo(mapID)
    if mapInfo then
        if LSU.Contains(recheckMapTypes, mapInfo.mapType) then
            GetContinentMapID(mapInfo.parentMapID)
        else
            LSU.Map.ContinentMapID = mapInfo.mapID
            LSU.Map.ContinentMapName = mapInfo.name
        end
    end
end

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LOGIN" then
        if not LSU.Map then
            LSU.Map = {}
        end
        C_Timer.After(3, function()
            local mapID = C_Map.GetBestMapForUnit("player")
            if mapID then
                LSU.Map.CurrentMapID = mapID
                GetContinentMapID(mapID)
            end
        end)
    end
    if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            LSU.Map.CurrentMapID = mapID
            GetContinentMapID(mapID)
        end
    end
end)