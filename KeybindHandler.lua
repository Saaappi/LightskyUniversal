local addonName, LSU = ...

BINDING_HEADER_LIGHTSKY_UNIVERSAL = "Lightsky Universal"
BINDING_NAME_LSU_MOUNTUP = "Mount Up"

function LSUKeybindHandler(key)
    if key == GetBindingKey("LSU_MOUNTUP") then
        LSU.Mount()
    end
end