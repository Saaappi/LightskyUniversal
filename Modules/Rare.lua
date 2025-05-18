local LSU = select(2, ...)
local eventFrame = CreateFrame("Frame")
local seen = {}

eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local unitToken = ...
        local unitGuid = UnitGUID(unitToken)
        if unitToken and unitGuid then
            local classification = UnitClassification(unitToken)
            if classification == "rare" or classification == "rareelite" then
                if not seen[unitGuid] then
                    local unitName = UnitName(unitToken)
                    local raidTarget = math.random(1, 8)
                    PlaySound(17318, "Master")
                    SetRaidTarget(unitToken, raidTarget)
                    LSU.Print(unitName .. " has been spotted! " .. raidTarget)
                    seen[unitGuid] = true
                end
            end
        end
    end
end)