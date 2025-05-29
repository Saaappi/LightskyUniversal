local LSU = select(2, ...)

BINDING_HEADER_LIGHTSKY_UNIVERSAL = "Lightsky Universal"
BINDING_NAME_LSU_MOUNTUP = "Mount Up"
BINDING_NAME_LSU_GETITEM = "Get Item"

function LSUKeybindHandler(key)
    if key == GetBindingKey("LSU_MOUNTUP") then
        LSU.Mount()
    elseif key == GetBindingKey("LSU_GETITEM") then
        local itemName, itemLink = GameTooltip:GetItem()
        if itemName and itemLink then
            local itemID = C_Item.GetItemInfoInstant(itemLink)
            if itemID then
                if LSU.IsJunk(itemID) then
                    LSUDB.Junk[itemID] = nil
                else
                    LSUDB.Junk[itemID] = true
                end
            end
        end
    end
end