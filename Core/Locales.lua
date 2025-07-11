local addonName, addonTable = ...
addonTable.Locales = CopyTable(LIGHTSKYUNIVERSAL_LOCALES.enUS)

for key, translation in pairs(LIGHTSKYUNIVERSAL_LOCALES[GetLocale()]) do
    addonTable.Locales[key] = translation
end

for key, translation in pairs(addonTable.Locales) do
    _G["LIGHTSKYUNIVERSAL_L_" .. key] = translation
end