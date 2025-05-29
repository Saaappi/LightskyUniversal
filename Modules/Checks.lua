local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("LFG_ROLE_CHECK_SHOW")
eventFrame:RegisterEvent("READY_CHECK")
eventFrame:SetScript("OnEvent", function(_, event, ...)
	if event == "LFG_ROLE_CHECK_SHOW" then
		CompleteLFGRoleCheck(1)
		return
    elseif event == "READY_CHECK" then
        ConfirmReadyCheck(1)
		CompleteLFGReadyCheck(1)
	end
end)