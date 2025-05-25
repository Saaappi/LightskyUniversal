local addonName, LSU = ...
local secureMountButton = CreateFrame("Button", "LSUSecureMountButton", UIParent, "SecureActionButtonTemplate")
secureMountButton:SetSize(1, 1)
secureMountButton:RegisterForClicks("AnyUp", "AnyDown")

local function IsPlayerUnderwater()
    local timerName, _, maxBreath = GetMirrorTimerInfo(2)
    if timerName and timerName ~= "UNKNOWN" then
        local currentBreath = GetMirrorTimerProgress(timerName)
        if currentBreath < maxBreath then
            return true
        end
    end
    return false
end

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
    if IsPlayerUnderwater() then
        C_MountJournal.SummonByID(800) -- Brinedeep Bottom-Feeder
    end

    -- Player is in Ahn'Qiraj
    local ahnQiraj = { 319, 320, 321 }
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID and LSU.Contains(ahnQiraj, mapID) then
        C_MountJournal.SummonByID(936) -- Red Qiraji Battle Tank
    end

    -- Check player's inventory and if their bags are full, then mount a vendor mount.
    local function GetAvailableInventorySpace()
        local numSlots = 0
        local numFreeSlots = 0
        for i = 0, NUM_BAG_SLOTS do
            numSlots = numSlots + C_Container.GetContainerNumSlots(i)
            numFreeSlots = numFreeSlots + C_Container.GetContainerNumFreeSlots(i)
        end

        local availableSpace = (numFreeSlots / numSlots) * 100
        if availableSpace <= 5 then
            LSU.Print(LSU.Locale.STDOUT_LOW_INVENTORY_SPACE)
            C_MountJournal.SummonByID(2237) -- Grizzly Hills Packmaster
        end
    end
    GetAvailableInventorySpace()

    local classMounts = {
        { mountID = 867 },      -- Warrior, Battlelord's Bloodthirsty War Wyrm
        { mountID = 893 },      -- Paladin, Highlord's Vigilant Charger
        { mountID = 865 },      -- Hunter, Huntmaster's Loyal Wolfhawk
        { mountID = 884 },      -- Rogue, Shadowblade's Murderous Omen
        { mountID = 861 },      -- Priest, High Priest's Lightsworn Seeker
        { mountID = 236 },      -- Death Knight, Winged Steed of the Ebon Blade
        { mountID = 888 },      -- Shaman, Farseer's Raging Tempest
        { mountID = 860 },      -- Mage, Archmage's Prismatic Disc
        { mountID = 930 },      -- Warlock, Netherlord's Brimstone Wrathsteed
        { mountID = 864 },      -- Monk, Ban-Lu, Grandmaster's Companion
        --{ mountID = 0 },      -- Druid, Travel Form
        { mountID = 868 },      -- Demon Hunter, Slayer's Felbroken Shrieker
        --{ mountID = 0 },      -- Evoker, Soar
    }

    if LSU.Character.ClassID == 11 then -- Druid
        if LSU.Character.Level >= 10 then
            SetOverrideBindingClick(secureMountButton, true, GetBindingKey("LSU_MOUNTUP"), "LSUSecureMountButton", nil)
            local travelFormIndex = 0
            local numShapeshiftForms = GetNumShapeshiftForms()
            for i = 1, numShapeshiftForms do
                local icon = GetShapeshiftFormInfo(i)
                if icon == 132144 then
                    travelFormIndex = i
                    break
                end
            end
            secureMountButton:SetAttribute("type", "macro")
            secureMountButton:SetAttribute("macrotext", string.format("/cast [nostance] Travel Form; [stance:%d] !Travel Form", travelFormIndex))
        end
    elseif LSU.Character.ClassID == 13 then -- Evoker
        SetOverrideBindingClick(secureMountButton, true, GetBindingKey("LSU_MOUNTUP"), "LSUSecureMountButton", nil)
        secureMountButton:SetAttribute("type", "macro")
        secureMountButton:SetAttribute("macrotext", "/cast Soar")
    else
        C_MountJournal.SummonByID(classMounts[LSU.Character.ClassID].mountID)
    end
end