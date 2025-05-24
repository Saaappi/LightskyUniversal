local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")
local recheckMapTypes = { [3]=true, [4]=true, [5]=true, [6]=true }

local function GetContinentMapID(mapID)
    while mapID do
        local mapInfo = C_Map.GetMapInfo(mapID)
        if not mapInfo then break end
        if recheckMapTypes[mapInfo.mapType] then
            mapID = mapInfo.parentMapID
        else
            LSU.Map.ContinentMapID = mapInfo.mapID
            LSU.Map.ContinentMapName = mapInfo.name
            break
        end
    end
end

local function UpdateMap()
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID then
        LSU.Map.CurrentMapID = mapID
        GetContinentMapID(mapID)
    end
end

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(_, event)
    if not LSU.Map then LSU.Map = {} end
    UpdateMap()
end)