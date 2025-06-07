local LSU = select(2, ...)
local L = LSU.L

LSU.Enum = {}
LSU.Enum.Expansions = {
    [5] = EXPANSION_NAME3,
    [6] = EXPANSION_NAME1,
    [7] = EXPANSION_NAME2,
    [8] = EXPANSION_NAME4,
    [9] = EXPANSION_NAME5,
    [10] = EXPANSION_NAME6,
    [15] = EXPANSION_NAME7,
    [14] = EXPANSION_NAME8,
    [16] = EXPANSION_NAME9
}
LSU.Enum.QuestRewardSelections = {
    [1] = L.LABEL_SETTINGS_SELL_PRICE,
    [2] = L.LABEL_SETTINGS_ITEM_LEVEL
}