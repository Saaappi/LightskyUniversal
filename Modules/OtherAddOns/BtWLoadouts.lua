local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")
local className = ""
local loadouts = {
    DeathKnight =   { specID = 252, loadoutName = "Leveling - Unholy Death Knight"    },
    DemonHunter =   { specID = 581, loadoutName = "Leveling - Vengeance Demon Hunter" },
    Druid =         { specID = 104, loadoutName = "Leveling - Guardian Druid"         },
    Hunter =        { specID = 254, loadoutName = "Leveling - Marksmanship Hunter"    },
    Mage =          { specID = 62,  loadoutName = "Leveling - Arcane Mage"            },
    Monk =          { specID = 268, loadoutName = "Leveling - Brewmaster Monk"        },
    Paladin =       { specID = 66,  loadoutName = "Leveling - Protection Paladin"     },
    Priest =        { specID = 258, loadoutName = "Leveling - Shadow Priest"          },
    Rogue =         { specID = 261, loadoutName = "Leveling - Subtlety Rogue"         },
    Shaman =        { specID = 263, loadoutName = "Leveling - Enhancement Shaman"     },
    Warlock =       { specID = 267, loadoutName = "Leveling - Destruction Warlock"    },
    Warrior =       { specID = 72,  loadoutName = "Leveling - Fury Warrior"           },
}

local function ActivateLoadoutByName(name)
    SlashCmdList["BTWLOADOUTS"]("activate loadout " .. name)
end

eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LEVEL_UP" then
        ActivateLoadoutByName(loadouts[className].loadoutName)
    end
    if event == "PLAYER_LOGIN" then
        C_Timer.After(5, function()
            className = LSU.Character.ClassName; className = className:gsub("%s+", "")
            if C_AddOns.IsAddOnLoaded("BtWLoadouts") and LSU.Between(LSU.Character.Level, 10, 70) then
                if loadouts[className] then
                    if LSU.Character.SpecID == loadouts[className].specID then
                        ActivateLoadoutByName(loadouts[className].loadoutName)
                    else
                        -- The loadout must be activated twice because in some cases the loadout isn't
                        -- loaded completely on the first attempt (after the specialization and talents are selected.)
                        ActivateLoadoutByName(loadouts[className].loadoutName)
                        C_Timer.After(5.5, function()
                            ActivateLoadoutByName(loadouts[className].loadoutName)
                        end)
                    end
                end
            else
                LSU.PrintWarning("BtWLoadouts addon not loaded.")
            end
            eventFrame:UnregisterEvent(event)
        end)
    end
end)