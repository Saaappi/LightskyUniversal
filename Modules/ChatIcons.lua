local addonName = ...
local iconPath = string.format("Interface\\AddOns\\%s\\Data\\Icons", addonName)

local function Main(_, _, msg, ...)
    local function GetCollectedStatusIcon(isCollected, path)
        if isCollected then
            return string.format("%s\\KNOWN", path)
        end
        return string.format("%s\\UNKNOWN", path)
    end

    local function GetAppearanceAndCollectedInfoByItemLink(itemLink)
        local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemLink))
        if not sourceID then return false end

        local isCollected = select(5, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
        if not isCollected then return false end

        return isCollected
    end

    local function GetItemIcon(itemLink)
        local texture = C_Item.GetItemIconByID(itemLink)
        local itemType = select(6, C_Item.GetItemInfo(itemLink))
        if texture and (itemType == "Armor" or itemType == "Weapon") then
            local isCollected = GetAppearanceAndCollectedInfoByItemLink(itemLink)
            if isCollected ~= nil then
                local collectedTexture = GetCollectedStatusIcon(isCollected, iconPath)
                return string.format("\124T%s:12\124t %s \124T%s:12\124t", texture, itemLink, collectedTexture)
            end
        end
        return string.format("\124T%s:12\124t %s", texture, itemLink)
    end

    local function GetAchievementIcon(achievementLink)
        local achievementID = string.match(achievementLink, "|Hachievement:(%d+):"); achievementID = tonumber(achievementID)
        local icon = select(10, GetAchievementInfo(achievementID))
        if icon then
            return string.format("\124T%s:12\124t %s", icon, achievementLink)
        end
    end

    local function GetSpellIcon(spellLink)
        local spellID = string.match(spellLink, "|Hspell:(%d+):"); spellID = tonumber(spellID)
        local icon = (C_Spell.GetSpellInfo(spellID)).iconID
        if icon then
            return string.format("\124T%s:12\124t %s", icon, spellLink)
        end
    end

    if string.find(msg, "achievement") then
        msg = msg:gsub("(|H([^:|]+):([^|]-)|h(.-)|h)", GetAchievementIcon)
    elseif string.find(msg, "item") then
        msg = msg:gsub("(|H([^:|]+):([^|]-)|h(.-)|h)", GetItemIcon)
    elseif string.find(msg, "spell") then
        msg = msg:gsub("(|H([^:|]+):([^|]-)|h(.-)|h)", GetSpellIcon)
    end
    return false, msg, ...
end

local events = {
    "CHAT_MSG_GUILD",
    "CHAT_MSG_LOOT",
    "CHAT_MSG_SAY"
}

for _, event in ipairs(events) do
    ChatFrame_AddMessageEventFilter(event, Main)
end