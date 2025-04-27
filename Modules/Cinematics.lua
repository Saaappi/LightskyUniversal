local addonName, LSU = ...

local function IsCutsceneProtected()
    local currentMapID = C_Map.GetBestMapForUnit("player")
    if LSU.Cinematics[currentMapID] then
        if LSU.EvaluateConditions(LSU.Cinematics[currentMapID]) then
            return true
        end
        return false

    end
end

CinematicFrame:HookScript("OnShow", function(self, ...)
	if not IsCutsceneProtected() then
		CinematicFrame_CancelCinematic()
	end
end)

hooksecurefunc("MovieFrame_PlayMovie", function(self, movieID)
	if not IsCutsceneProtected() then
		MovieFrame:Hide()
	end
end)