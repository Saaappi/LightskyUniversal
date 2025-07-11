local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
        if not LSUDB.Settings["ChromieTimeExpansionID"] or LSUDB.Settings["ChromieTimeExpansionID"] == 0 then return end
        local args = {...}
        C_Timer.After(0.15, function(...)
            local type = args[1]
            if type == 45 then
                if UnitChromieTimeID("player") ~= LSUDB.Settings["ChromieTimeExpansionID"] then
                    C_ChromieTime.SelectChromieTimeOption(LSUDB.Settings["ChromieTimeExpansionID"])
                end
            end
        end)
    end
end)