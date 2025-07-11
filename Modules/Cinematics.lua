local addonTable = select(2, ...)

local function IsCutsceneProtected()
    local currentMapID = C_Map.GetBestMapForUnit("player")
    if addonTable.Enum.Blacklisted.Cinematics[currentMapID] then
        if addonTable.EvaluateConditions(addonTable.Enum.Blacklisted.Cinematics[currentMapID]) then
            return true
        end
        return false
    end
end

CinematicFrame:HookScript("OnShow", function(self, ...)
    if not LSUDB.Settings["SkipCinematics.Enabled"] then return end
	if not IsCutsceneProtected() and not IsShiftKeyDown() then
		CinematicFrame_CancelCinematic()
	end
end)

hooksecurefunc("MovieFrame_PlayMovie", function(self, movieID)
    if not LSUDB.Settings["SkipCinematics.Enabled"] then return end
	if not IsCutsceneProtected() and not IsShiftKeyDown() then
		MovieFrame:Hide()
	end
end)