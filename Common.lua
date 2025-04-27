local addonName, LSU = ...

LSU.iContains = function(tbl, value)
    if tbl then
        for _, v in ipairs(tbl) do
            if v == value then
                return true
            end
        end
        return false
    end
end

-- Splits a string by the provider delimiter, then
-- returns the nth value. If the value is a number,
-- then it's converted to a number.
--
-- If * is provided for the nth value, then the entire
-- split string is returned.
LSU.Split = function(str, delimiter, nth)
    local strings = {}
    local pattern = ("([^%s]+)"):format(delimiter)
    for string in str:gmatch(pattern) do
        table.insert(strings, string)
    end

    if tonumber(strings[nth]) then
        return tonumber(strings[nth])
    elseif nth == "*" then
        return unpack(strings)
    end
    return strings[nth]
end