local addonTable = select(2, ...)
local eventFrame = CreateFrame("Frame")

local inventoryValueToSlotID = {
    [1]     = 1,        -- INVTYPE_HEAD
    [2]     = 2,        -- INVTYPE_NECK
    [3]     = 3,        -- INVTYPE_SHOULDER
    [5]     = 5,        -- INVTYPE_CHEST
    [6]     = 6,        -- INVTYPE_WAIST
    [7]     = 7,        -- INVTYPE_LEGS
    [8]     = 8,        -- INVTYPE_FEET
    [9]     = 9,        -- INVTYPE_WRIST
    [10]    = 10,       -- INVTYPE_HAND
    [11]    = {11,12},  -- INVTYPE_FINGER
    [12]    = {13,14},  -- INVTYPE_TRINKET
    [13]    = {16,17},  -- INVTYPE_WEAPON
    [14]    = 17,       -- INVTYPE_SHIELD
    [15]    = 16,       -- INVTYPE_RANGED
    [16]    = 15,       -- INVTYPE_CLOAK
    [17]    = 16,       -- INVTYPE_2HWEAPON
    [20]    = 5,        -- INVTYPE_ROBE
    [21]    = 16,       -- INVTYPE_WEAPONMAINHAND
    [22]    = 16,       -- INVTYPE_WEAPONOFFHAND
    [23]    = 17,       -- INVTYPE_HOLDABLE
    [26]    = 16,       -- INVTYPE_RANGEDRIGHT
}

local allowedWeaponTypesBySpecID = {
    -- Death Knight
    [250] = {0, 1, 4, 5, 6, 7, 8}, -- Blood
    [251] = {0, 1, 4, 5, 6, 7, 8}, -- Frost
    [252] = {0, 1, 4, 5, 6, 7, 8}, -- Unholy
    [1455] = {0, 1, 4, 5, 6, 7, 8}, -- Initial
    -- Demon Hunter
    [577] = {0, 7, 9, 11, 12, 13}, -- Havoc
    [581] = {0, 7, 9, 11, 12, 13}, -- Vengeance
    [1456] = {0, 7, 9, 11, 12, 13}, -- Inital
    -- Druid
    [102] = {4, 5, 6, 10, 11, 12, 13, 15}, -- Balance
    [103] = {4, 5, 6, 10, 11, 12, 13, 15}, -- Feral
    [104] = {4, 5, 6, 10, 11, 12, 13, 15}, -- Guardian
    [105] = {4, 5, 6, 10, 11, 12, 13, 15}, -- Restoration
    [1447] = {4, 5, 6, 10, 11, 12, 13, 15}, -- Initial
    -- Evoker
    [1467] = {0, 1, 4, 5, 7, 8, 10, 11, 12, 13, 15}, -- Devastation
    [1468] = {0, 1, 4, 5, 7, 8, 10, 11, 12, 13, 15}, -- Preservation
    [1473] = {0, 1, 4, 5, 7, 8, 10, 11, 12, 13, 15}, -- Augmentation
    [1465] = {0, 1, 4, 5, 7, 8, 10, 11, 12, 13, 15}, -- Initial
    -- Hunter
    [253] = {2, 3, 18}, -- Beast Mastery
    [254] = {2, 3, 18}, -- Marksmanship
    [255] = {6, 10}, -- Survival
    [1448] = {2, 3, 18}, -- Initial
    -- Mage
    [62] = {7, 10, 15}, -- Arcane
    [63] = {7, 10, 15}, -- Fire
    [64] = {7, 10, 15}, -- Frost
    [1449] = {7, 10, 15}, -- Initial
    -- Monk
    [268] = {0, 4, 6, 7, 10, 11, 12, 13}, -- Brewmaster
    [269] = {0, 4, 6, 7, 10, 11, 12, 13}, -- Windwalker
    [270] = {0, 4, 6, 7, 10, 11, 12, 13}, -- Mistweaver
    [1450] = {0, 4, 6, 7, 10, 11, 12, 13}, -- Initial
    -- Paladin
    [65] = {0, 1, 4, 5, 6, 7, 8}, -- Holy
    [66] = {0, 4, 7}, -- Protection
    [70] = {1, 5, 8}, -- Retribution
    [1451] = {1, 5, 8}, -- Initial
    -- Priest
    [256] = {4, 10, 15}, -- Discipline
    [257] = {4, 10, 15}, -- Holy
    [258] = {4, 10, 15}, -- Shadow
    [1452] = {10}, -- Initial
    -- Rogue
    [259] = {15}, -- Assassination
    [260] = {0, 4, 7, 11, 12, 13}, -- Outlaw
    [261] = {15}, -- Subtlety
    [1453] = {15}, -- Initial
    -- Shaman
    [262] = {0, 4, 10, 15}, -- Elemental
    [263] = {4, 11, 12, 13}, -- Enhancement
    [264] = {0, 4, 10, 15}, -- Restoration
    [1444] = {0, 4, 10, 15}, -- Initial
    -- Warlock
    [265] = {7, 10, 15}, -- Affliction
    [266] = {7, 10, 15}, -- Demonology
    [267] = {7, 10, 15}, -- Destruction
    [1454] = {7, 10, 15}, -- Initial
    -- Warrior
    [71] = {0, 1, 4, 5, 6, 7, 8}, -- Arms
    [72] = {0, 1, 4, 5, 6, 7, 8}, -- Fury
    [73] = {0, 4, 7}, -- Protection
    [1446] = {0, 1, 4, 5, 6, 7, 8}, -- Initial
}

local function GetAllowedWeaponTypes()
    local specID = PlayerUtil.GetCurrentSpecID()
    if specID and allowedWeaponTypesBySpecID[specID] then
        return allowedWeaponTypesBySpecID[specID]
    end
    return nil
end

local function IsWeapon(itemLink)
    local classID, subClassID = select(12, C_Item.GetItemInfo(itemLink))
    return classID == 2, subClassID
end

local function GetSellPrice(itemLink)
    return (select(11, C_Item.GetItemInfo(itemLink))) or 0
end

local function GetEquippedItemLevel(slot)
    local link = GetInventoryItemLink("player", slot)
    if not link then return nil end
    return C_Item.GetDetailedItemLevelInfo(link)
end

local function IsValidWeapon(itemLink, allowedWeaponTypes)
    local isWeapon, subClassID = IsWeapon(itemLink)
    if not isWeapon then return false end
    if not allowedWeaponTypes then return false end
    return allowedWeaponTypes[subClassID] == true
end

local handlers = {
    QUEST_COMPLETE = function(...)
        if not LSUDB.Settings["CompleteQuests.Enabled"] then return end
        if not LSUDB.Settings["QuestRewards.Enabled"] then return end
        local numRewards = GetNumQuestChoices()
        if numRewards <= 1 then
            GetQuestReward(1)
            QuestFrameCompleteQuestButton:Click()
        elseif numRewards > 1 then
            local allowedWeaponTypes = GetAllowedWeaponTypes()
            local bestIndex, bestUpgrade, bestSellIndex, bestSellPrice, bestItemLink, globalInvSlotID = 1, -math.huge, 1, 0, "", 0
            for i = 1, numRewards do
                local link = GetQuestItemLink("choice", i)
                if link then
                    local rewardLevel = C_Item.GetDetailedItemLevelInfo(link)
                    local loc = select(9, C_Item.GetItemInfo(link))
                    if loc ~= "INVTYPE_NON_EQUIP_IGNORE" then
                        local rewardInventoryTypeValue = C_Item.GetItemInventoryTypeByID(link)
                        local invSlotID = inventoryValueToSlotID[rewardInventoryTypeValue]
                        if invSlotID and type(invSlotID) == table then
                            -- The reward is a ring, trinket, or a dual wield weapon
                            for _, slot in ipairs(invSlotID) do
                                local equippedLevel, equippedLink = GetEquippedItemLevel(slot)
                                if not equippedLink and not (rewardInventoryTypeValue == 16 or rewardInventoryTypeValue == 17) then
                                    -- Empty slots are always an upgrade (except weapons)
                                    if not (rewardInventoryTypeValue == 16 or rewardInventoryTypeValue == 17) then
                                        if rewardLevel > bestUpgrade then
                                            bestIndex = i
                                            bestItemLink = link
                                            globalInvSlotID = invSlotID
                                            bestUpgrade = rewardLevel
                                        end
                                    end
                                elseif equippedLevel and rewardLevel > equippedLevel then
                                    if (rewardLevel - equippedLevel) > bestUpgrade then
                                        bestIndex = i
                                        bestItemLink = link
                                        globalInvSlotID = invSlotID
                                        bestUpgrade = rewardLevel - equippedLevel
                                    end
                                end
                            end
                        elseif invSlotID and type(invSlotID) == number then
                            if rewardInventoryTypeValue == 16 or rewardInventoryTypeValue == 17 then
                                if IsValidWeapon(link, allowedWeaponTypes) then
                                    local equippedLevel, equippedLink = GetEquippedItemLevel(invSlotID)
                                    if not equippedLink then
                                        if rewardLevel > bestUpgrade then
                                            bestIndex = i
                                            bestItemLink = link
                                            globalInvSlotID = invSlotID
                                            bestUpgrade = rewardLevel
                                        end
                                    elseif equippedLevel and rewardLevel > equippedLevel then
                                        if (rewardLevel - equippedLevel) > bestUpgrade then
                                            bestIndex = i
                                            bestItemLink = link
                                            globalInvSlotID = invSlotID
                                            bestUpgrade = rewardLevel - equippedLevel
                                        end
                                    end
                                end
                            else
                                local equippedLevel, equippedLink = GetEquippedItemLevel(invSlotID)
                                if not equippedLink then
                                    if rewardLevel > bestUpgrade then
                                        bestIndex = i
                                        bestItemLink = link
                                        globalInvSlotID = invSlotID
                                        bestUpgrade = rewardLevel
                                    end
                                elseif equippedLevel and rewardLevel > equippedLevel then
                                    if (rewardLevel - equippedLevel) > bestUpgrade then
                                        bestIndex = i
                                        bestItemLink = link
                                        globalInvSlotID = invSlotID
                                        bestUpgrade = rewardLevel - equippedLevel
                                    end
                                end
                            end
                        elseif invSlotID and (not inventoryValueToSlotID[invSlotID]) then
                            addonTable.PrintWarning("Unsupported item type detected:" .. rewardInventoryTypeValue)
                        end
                    end
                end
                local price = GetSellPrice(link)
                if price > bestSellPrice then
                    bestSellIndex = i
                    bestItemLink = link
                    bestSellPrice = price
                end
            end
            if bestUpgrade > 0 then
                GetQuestReward(bestIndex)
            else
                GetQuestReward(bestSellIndex)
                --C_Timer.After(0.15, function(bestItemLink) C_Item.EquipItemByName(bestItemLink, globalInvSlotID) end)
            end
            --QuestFrameCompleteQuestButton:Click()
        end
    end,
    QUEST_PROGRESS = function(...)
        if not LSUDB.Settings["CompleteQuests.Enabled"] then return end
        if IsQuestCompletable() then
            CompleteQuest()
        end
    end
}

eventFrame:RegisterEvent("QUEST_COMPLETE")
eventFrame:RegisterEvent("QUEST_PROGRESS")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    local handler = handlers[event]
    if handler then
        handler(...)
    end
end)