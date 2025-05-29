local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == addonName then
            if LSUDB == nil then
                LSUDB = {}
                LSUDB.Characters = {}
                LSUDB.Gossips = {}
                LSUDB.Junk = {}
                LSUDB.PlayerTalents = {}
            end
        end
    end
end)