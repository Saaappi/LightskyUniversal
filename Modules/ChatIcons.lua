local addonName = ...
local iconPath = string.format("Interface\\AddOns\\%s\\Data\\Icons", addonName)

local function IsAppearanceCollected(visualID)
    local sources = C_TransmogCollection.GetAppearanceSources(visualID)
    if sources then
        for _, source in next, sources do
            if source.isCollected then
                return true
            end
        end
    end
    return false
end

local function Main(_, _, msg, ...)
    local function GetCollectedStatusIcon(bindType, isCollected, canCollect, path)
        if isCollected then
            return string.format("%s\\KNOWN", path)
        end

        if bindType == 1 then
            if canCollect then
                return string.format("%s\\UNKNOWN", path)
            else
                return string.format("%s\\UNKNOWABLE_SOULBOUND", path)
            end
        elseif bindType == 2 then
            if canCollect then
                return string.format("%s\\UNKNOWN", path)
            else
                return string.format("%s\\UNKNOWABLE_BY_CHARACTER", path)
            end
        end
    end

    local function GetAppearanceAndCollectedInfoByItemLink(itemLink)
        local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemLink))
        if not sourceID then return false end

        local visualID = select(2, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
        if not visualID then return false end

        local isCollected = IsAppearanceCollected(visualID)
        local canCollectAppearance = select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID))

        return isCollected, canCollectAppearance
    end

    local function GetItemIcon(itemLink)
        local texture = C_Item.GetItemIconByID(itemLink)
        local itemType, _, _, _, _, _, _, _, bindType = select(6, C_Item.GetItemInfo(itemLink))
        if texture and (itemType == "Armor" or itemType == "Weapon") then
            local isCollected, canCollectAppearance = GetAppearanceAndCollectedInfoByItemLink(itemLink)
            if isCollected ~= nil then
                local collectedTexture = GetCollectedStatusIcon(bindType, isCollected, canCollectAppearance, iconPath)
                return string.format("\124T%s:12\124t %s \124T%s:12\124t", texture, itemLink, collectedTexture)
            end
        end
        return string.format("\124T%s:12\124t %s", texture, itemLink)
    end
    msg = msg:gsub("(|H([^:|]+):([^|]-)|h(.-)|h)", GetItemIcon)
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