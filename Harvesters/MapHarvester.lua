local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")
local recheckMapTypes = { [3]=true, [4]=true, [5]=true, [6]=true }

local function GetContinentMapID(mapID)
    while mapID do
        local mapInfo = C_Map.GetMapInfo(mapID)
        if not mapInfo then break end
        if recheckMapTypes[mapInfo.mapType] then
            mapID = mapInfo.parentMapID
        else
            addonTable.Map.ContinentMapID = mapInfo.mapID
            addonTable.Map.ContinentMapName = mapInfo.name
            break
        end
    end
end

local function UpdateMap()
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID then
        addonTable.Map.CurrentMapID = mapID
        GetContinentMapID(mapID)
    end
end

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(_, event)
    if not addonTable.Map then addonTable.Map = {} end
    UpdateMap()
end)