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
                local name = layouts[i].layoutName
                local foundIndex = nil

                for idx, layout in ipairs(LSUDB.EditModeLayouts) do
                    if layout[1] == name then
                        foundIndex = idx
                        break
                    end
                end

                if foundIndex then
                    table.remove(LSUDB.EditModeLayouts, foundIndex)
                    table.insert(LSUDB.EditModeLayouts, foundIndex, { name, i })
                else
                    table.insert(LSUDB.EditModeLayouts, { name, i })
                end
            end
        end

        eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)