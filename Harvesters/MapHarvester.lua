local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")
local recheckMapTypes = { [3]=true, [4]=true, [5]=true, [6]=true }

local function GetContinentMapID(mapID)
    --[[local mapInfo = C_Map.GetMapInfo(mapID)
    if mapInfo then
        if LSU.Contains(recheckMapTypes, mapInfo.mapType) then
            GetContinentMapID(mapInfo.parentMapID)
        else
            LSU.Map.ContinentMapID = mapInfo.mapID
            LSU.Map.ContinentMapName = mapInfo.name
        end
    end]]
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
        return true
    end
    return false
end

local function TryGetPlayerMap(maxAttempts, delay)
    local attempts = 0
    local function attempt()
        attempts = attempts + 1
        if UpdateMap() then
            return
        elseif attempts < maxAttempts then
            C_Timer.After(delay, attempt)
        else
            LSU.PrintWarning("Unable to determine player map after login. Please reload the UI or change areas.")
        end
    end
    attempt()
end

local function OnPlayerLogin()
    --[[if not LSU.Map then LSU.Map = {} end
    C_Timer.After(3, function()
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            LSU.Map.CurrentMapID = mapID
            GetContinentMapID(mapID)
        end
    end)]]
    LSU.Map = LSU.Map or {}
    TryGetPlayerMap(3, 1)
    eventFrame:UnregisterEvent("PLAYER_LOGIN")
end

--[[local function OnZoneChanged()
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID then
        LSU.Map.CurrentMapID = mapID
        GetContinentMapID(mapID)
    end
end]]

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin()
    else
        UpdateMap()
    end
    --[[if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
        --OnZoneChanged()
    end]]
end)