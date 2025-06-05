local LSU = select(2, ...)
local L = LSU.L
local frame = CreateFrame("Frame", nil, UIParent, "ButtonFrameTemplate")

frame:SetToplevel(true)
table.insert(UISpecialFrames, frame:GetName())
frame:SetSize(600, 700)
frame:SetPoint("CENTER")
frame:Raise()

frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function()
frame:StartMoving()
frame:SetUserPlaced(false)
end)
frame:SetScript("OnDragStop", function()
frame:StopMovingOrSizing()
frame:SetUserPlaced(false)
end)

ButtonFrameTemplate_HidePortrait(frame)
ButtonFrameTemplate_HideButtonBar(frame)
frame.Inset:Hide()
frame:EnableMouse(true)
frame:SetScript("OnMouseWheel", function() end)

frame:SetTitle(L.TITLE_ADDON .. " " .. L.TITLE_SETTINGS)

-- Layout: Adding widgets to the frame...
local checkboxContainer = CreateFrame("Frame", nil, frame)
checkboxContainer:SetPoint("TOPLEFT", 20, -60)
checkboxContainer:SetSize(560, 600)

local prev
for i, data in ipairs({
    {label = "Accept Quests", callback = function(val) print("Accept Quests: " .. tostring(val)) end},
    {label = "Auto Repair", callback = function(val) print("Auto Repair: " .. tostring(val)) end, "Test"},
    {label = "Auto Train", callback = function(val) print("Auto Train: " .. tostring(val)) end},
    {label = "Buy Quest Items", callback = function(val) print("Buy Quest Items: " .. tostring(val)) end},
    {label = "Chat Icons", callback = function(val) print("Chat Icons: " .. tostring(val)) end},
    {label = "Complete Quests", callback = function(val) print("Complete Quests: " .. tostring(val)) end},
    {label = "Gossip", callback = function(val) print("Gossip: " .. tostring(val)) end},
    {label = "Player Talents", callback = function(val) print("Player Talents: " .. tostring(val)) end},
    {label = "Rares", callback = function(val) print("Skip Cinematics: " .. tostring(val)) end},
    {label = "Ready Checks", callback = function(val) print("Ready Checks: " .. tostring(val)) end},
    {label = "Role Checks", callback = function(val) print("Role Checks: " .. tostring(val)) end},
    {label = "Skip Cinematics", callback = function(val) print("Skip Cinematics: " .. tostring(val)) end}
}) do
    local checkBox = LSU.CreateCheckbox(checkboxContainer, data.label, 0, data.callback)
    if prev then
        checkBox:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -10)
    else
        checkBox:SetPoint("TOPLEFT", checkboxContainer, "TOPLEFT", 0, 0)
    end
    prev = checkBox
end

frame:Show()