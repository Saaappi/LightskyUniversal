local function GetReadableCinematicName()
    local zone = GetZoneText() or "UnknownZone"
    local subzone = GetSubZoneText() or ""
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player") or 0
    local posX, posY = 0, 0
    if mapID and mapID ~= 0 and C_Map and C_Map.GetPlayerMapPosition then
        local pos = C_Map.GetPlayerMapPosition(mapID, "player")
        if pos then
            posX, posY = pos:GetXY()
        end
    end
    posX = math.floor((posX or 0) * 100)
    posY = math.floor((posY or 0) * 100)
    local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    local nameParts = {}
    if instanceName and instanceName ~= "" then
        table.insert(nameParts, instanceName)
    elseif zone and zone ~= "" then
        table.insert(nameParts, zone)
    end
    if subzone and subzone ~= "" then
        table.insert(nameParts, subzone)
    end
    table.insert(nameParts, string.format("(%d,%d)", posX, posY))
    if instanceID and instanceID ~= 0 then
        table.insert(nameParts, "InstanceID:"..instanceID)
    end
    return table.concat(nameParts, " - ")
end

local function HashCinematicContext(context)
    local hash = 5381
    for i = 1, #context do
        hash = hash * 33 + context:byte(i)
    end
    return hash
end

--[[local function IsCutsceneProtected()
    local currentMapID = C_Map.GetBestMapForUnit("player")
    if addonTable.Enum.Blacklisted.Cinematics[currentMapID] then
        if addonTable.EvaluateConditions(addonTable.Enum.Blacklisted.Cinematics[currentMapID]) then
            return true
        end
        return false
    end
end]]

CinematicFrame:HookScript("OnShow", function(self, ...)
    local cinematicName = GetReadableCinematicName()
    local cinematicUniqueID = HashCinematicContext(cinematicName)
    if not LSUDB.Cinematics[cinematicUniqueID] then
        LSUDB.Cinematics[cinematicUniqueID] = {
            name = cinematicName,
            skip = true
        }
    else
        CinematicFrame_CancelCinematic()
    end
end)

hooksecurefunc("MovieFrame_PlayMovie", function(self, movieID)
    --if not LSUDB.Settings["SkipCinematics.Enabled"] then return end
    if LSUDB.Movies[movieID] then return end
	if not IsCutsceneProtected() then
        if not LSUDB.Movies[movieID] then LSUDB.Movies[movieID] = true end
		MovieFrame:Hide()
	end
end)