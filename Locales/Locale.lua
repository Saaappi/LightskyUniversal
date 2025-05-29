local LSU = select(2, ...)
local locale = GetLocale()

local L = LSU.L or {}

local L_locale = LSU["L_" .. locale]
if L_locale then
    setmetatable(L_locale, { __index = L })
    L = L_locale
end

LSU.L = L