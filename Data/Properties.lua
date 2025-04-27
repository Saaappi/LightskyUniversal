local addonName, LSU = ...

local Properties = {
    ["About"] = {
        ["Version"] = C_AddOns.GetAddOnMetadata(addonName, "Version"),
        ["Author"] = C_AddOns.GetAddOnMetadata(addonName, "Author")
    }
}
LSU.Properties = Properties