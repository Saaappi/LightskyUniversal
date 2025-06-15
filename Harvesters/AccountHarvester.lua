local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        if not LSUDB.EditModeLayouts then
            LSUDB.EditModeLayouts = {}
        end

        local layouts = (C_EditMode.GetLayouts()).layouts
        if layouts then
            for i = 1, #layouts do
                table.insert(LSUDB.EditModeLayouts, { layouts[i].layoutName, i })
            end
        end

        eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)