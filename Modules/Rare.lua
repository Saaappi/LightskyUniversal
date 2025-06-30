local LSU = select(2, ...)
local L = LSU.L
local eventFrame = CreateFrame("Frame")
local seen = {}

local npcFrame = CreateFrame("DressUpModel", nil, UIParent)
npcFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT")
npcFrame:SetSize(1, 1)
npcFrame:Hide()

eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        if not LSUDB.Settings["Rares.Enabled"] then return end

        local unitToken = ...
        local unitGuid = UnitGUID(unitToken)
        if not (unitToken and unitGuid) then return end

        if seen[unitGuid] then return end

        local classification = UnitClassification(unitToken)
        if classification ~= "rare" and classification ~= "rareelite" then return end

        local unitID = LSU.Split(unitGuid, "-", 6)
        local unitName = UnitName(unitToken)
        if not (unitID and unitName) then return end

        local targetIndex = math.random(1, 8)
        SetRaidTarget(unitToken, targetIndex)

        local position = C_Map.GetPlayerMapPosition(LSU.Map.CurrentMapID, "player")
        if position then
            local x, y = position:GetXY()
            local link = LinkUtil.FormatLink("addonLSU", "[/" .. LSU.Locales.WAY .."]", LSU.Map.CurrentMapID, x, y, unitName, unitID)
            LSU.Print(string.format("|cffFFD700%s|r %s! %s", unitName, LSU.Locales.HAS_BEEN_SPOTTED, BATTLENET_FONT_COLOR:WrapTextInColorCode(link)))
        end

        PlaySound(17318, "Master")
        seen[unitGuid] = true
    end
end)

local function GetNPCDisplayByID(npcID)
    if not npcFrame then
        return 132911
    end
    npcFrame:SetUnit("none")
    npcFrame:SetCreature(npcID)
    local displayID = npcFrame:GetDisplayInfo()
    if not displayID or displayID == 0 then
        return 132911
    end
    return displayID
end

local function HandleLinkClick(_, link)
	local linkType, linkData = LinkUtil.SplitLinkData(link)
	if linkType == "addonLSU" then
        local mapID, x, y, unitName, unitID = strsplit(":", linkData)
        mapID = tonumber(mapID)
        x = tonumber(x)
        y = tonumber(y)
        if not (mapID and x and y and unitName and unitID) then return end

		if C_AddOns.IsAddOnLoaded("TomTom") then
            local displayID = GetNPCDisplayByID(unitID)
			local size = 16
			TomTom:AddWaypoint(mapID, x, y, {
				title = unitName .. "\n" .. LSU.Locales.ADDON_TITLE,
				minimap_displayID = displayID,
				minimap_icon_size = size,
				worldmap_displayID = displayID,
				worldmap_icon_size = size,
				from = LSU.Locales.ADDON_TITLE,
				minimap = true
			})
		else
			if C_Map.CanSetUserWaypointOnMap(mapID) then
				local mapPoint = UiMapPoint.CreateFromCoordinates(mapID, x, y)
				PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CLICK_TO_PLACE)
				C_Map.SetUserWaypoint(mapPoint)
				C_SuperTrack.SetSuperTrackedUserWaypoint(true)
			end
		end
	end
end

EventRegistry:RegisterCallback("SetItemRef", HandleLinkClick)