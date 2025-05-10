local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")
local loadouts = {
    DeathKnight = "1",
    --DemonHunter = "2",
    Druid = "2",
    Hunter = "3",
    Mage = "4",
    Monk = "5",
    Paladin = "6",
    Priest = "7",
    Rogue = "8",
    Shaman = "9",
    Warlock = "10",
    Warrior = "11"
}

local function ActivateLoadoutByID(id)
    SlashCmdList["BTWLOADOUTS"]("activate loadout " .. id)
end

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LOGIN" then
        C_Timer.After(5, function()
            local className = UnitClass("player")
            className = className:gsub("%s+", "")
            if C_AddOns.IsAddOnLoaded("BtWLoadouts") and LSU.Between(LSU.Character.Level, 10, 70) then
                if loadouts[className] then
                    ActivateLoadoutByID(loadouts[className])
                    C_Timer.After(5.5, function()
                        -- Call the function again to double check the action bar is correct.
                        ActivateLoadoutByID(loadouts[className])
                    end)
                end
            else
                LSU.PrintWarning("BtWLoadouts addon not loaded.")
            end
            eventFrame:UnregisterEvent(event)
        end)
    end
end)