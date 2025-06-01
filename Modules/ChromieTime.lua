local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
        local args = {...}
        C_Timer.After(0.15, function(...)
            local type = args[1]
            if type == 45 then
                if UnitChromieTimeID("player") ~= 10 then
                    C_ChromieTime.SelectChromieTimeOption(10)
                end
            end
        end)
    end
end)