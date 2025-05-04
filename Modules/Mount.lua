local addonName, LSU = ...

LSU.Mount = function()
    if InCombatLockdown() and (not IsMounted()) then return end
    if IsFlying() then return end
    if IsIndoors() then return end
    if IsMounted() then Dismount() return end

    -- Chauffered mount for characters under level 10.
    if LSU.Character.Level < 10 then
        local faction = UnitFactionGroup("player")
        if faction == "Alliance" then
            C_MountJournal.SummonByID(679)
        elseif faction == "Horde" then
            C_MountJournal.SummonByID(678)
        end
    end

    -- Aquatic mount for characters that are submerged.
    if IsSubmerged("player") then
        C_MountJournal.SummonByID(800)
    end

    -- Player is in Ahn'Qiraj
    local ahnQiraj = { 319, 320, 321 }
    local mapID = C_Map.GetBestMapForUnit("player")
    if LSU.Contains(ahnQiraj, mapID) then
        C_MountJournal.SummonByID(936)
    end

    local classMounts = {
        { classID = 1, mountID = 0 },
        { classID = 2, mountID = 893 }, -- Highlord's Vigilant Charger
        { classID = 3, mountID = 0 },
        { classID = 4, mountID = 0 },
        { classID = 5, mountID = 0 },
        { classID = 6, mountID = 0 },
        { classID = 7, mountID = 0 },
        { classID = 8, mountID = 0 },
        { classID = 9, mountID = 930 }, -- Netherlord's Brimstone Wrathsteed
        { classID = 10, mountID = 0 },
        { classID = 11, mountID = 0 },
        { classID = 12, mountID = 0 },
        { classID = 13, mountID = 0 },
    }
    C_MountJournal.SummonByID(classMounts[LSU.Character.ClassID].mountID)
end