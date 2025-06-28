local addonName, LSU = ...
LSU.Locales = CopyTable(LIGHTSKYUNIVERSAL_LOCALES.enUS)

for key, translation in pairs(LIGHTSKYUNIVERSAL_LOCALES[GetLocale()]) do
    LSU.Locales[key] = translation
end

for key, translation in pairs(LSU.Locales) do
    _G["LIGHTSKYUNIVERSAL_L_" .. key] = translation
end