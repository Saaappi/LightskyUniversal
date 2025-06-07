local LSU = select(2, ...)
local L = LSU.L
local eventFrame = CreateFrame("Frame")
local seen = {}

eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        if not LSUDB.Settings["Rares.Enabled"] then return end
        local unitToken = ...
        local unitGuid = UnitGUID(unitToken)
        if unitToken and unitGuid then
            local classification = UnitClassification(unitToken)
            if classification == "rare" or classification == "rareelite" then
                if not seen[unitGuid] then
                    local unitName = UnitName(unitToken)
                    local targetIndex = math.random(1, 8)
                    PlaySound(17318, "Master")
                    SetRaidTarget(unitToken, targetIndex)
                    LSU.Print(string.format("|cffFFD700%s|r %s!", unitName, L.TEXT_RARE_SPOTTED))
                    seen[unitGuid] = true
                end
            end
        end
    end
end)