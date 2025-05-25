local addonName = ...
local iconPath = string.format("Interface\\AddOns\\%s\\Data\\Icons", addonName)
local iconSize, yOffset = 14, -2
local excludedEquipLocs = {
    INVTYPE_FINGER = true,
    INVTYPE_TRINKET = true,
    INVTYPE_NECK = true
}

--[[ TODO
    - Cache items and use lookups to show icons 
]]

local function IconTag(path)
    return string.format("|T%s:%d:%d:0:%d|t", path, iconSize, iconSize, yOffset)
end

local function FormatWithIcons(texture, itemLink, collectedTexture)
    return string.format("%s %s %s", IconTag(texture), itemLink, IconTag(collectedTexture))
end

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
    local itemType, _, _, equipLoc = select(6, C_Item.GetItemInfo(itemLink))
    if texture
        and (itemType == "Armor" or itemType == "Weapon")
        and not excludedEquipLocs[equipLoc]
    then
        local isCollected = GetAppearanceAndCollectedInfoByItemLink(itemLink)
        if isCollected ~= nil then
            local collectedTexture = GetCollectedStatusIcon(isCollected, iconPath)
            local formattedString = FormatWithIcons(texture, itemLink, collectedTexture)
            return formattedString
        end
    end
    return IconTag(texture) .. " " .. itemLink
end

local function GetAchievementIcon(achievementLink)
    local achievementID = string.match(achievementLink, "|Hachievement:(%d+):"); achievementID = tonumber(achievementID)
    local icon = select(10, GetAchievementInfo(achievementID))
    if icon then
        return IconTag(icon) .. " " .. achievementLink
    end
end

local function GetSpellIcon(spellLink)
    local spellID = string.match(spellLink, "|Hspell:(%d+):"); spellID = tonumber(spellID)
    local icon = (C_Spell.GetSpellInfo(spellID)).iconID
    if icon then
        return IconTag(icon) .. " " .. spellLink
    end
end

local function Main(_, _, msg, ...)
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