local addonTable = select(2, ...)
local parentFrame
local talentsFrame

addonTable.GetValidationError = function(treeID, importStream, isTryRead)
    local version = C_Traits.GetLoadoutSerializationVersion and C_Traits.GetLoadoutSerializationVersion() or 1
    local headerValid, serializationVersion, specID, treeHash = talentsFrame:ReadLoadoutHeader(importStream)
    if not headerValid then
        return _G["LOADOUT_ERROR_BAD_STRING"]
    elseif serializationVersion ~= version then
        return _G["LOADOUT_ERROR_SERIALIZATION_VERSION_MISMATCH"]
    elseif specID ~= PlayerUtil.GetCurrentSpecID() then
        return _G["LOADOUT_ERROR_WRONG_SPEC"]
    elseif not talentsFrame:IsHashEmpty(treeHash) then
        if not talentsFrame:HashEquals(treeHash, C_Traits.GetTreeHash(treeID)) then
            return _G["LOADOUT_ERROR_TREE_CHANGED"]
        end
    end

    if isTryRead then
        local success = pcall(talentsFrame.ReadLoadoutContent, talentsFrame, importStream, treeID)
        if not success then
            return _G["LOADOUT_ERROR_BAD_STRING"]
        end
    end

    return nil
end

local nodesList = {}
addonTable.GetNodes = function(specID, configID, treeID)
    if nodesList[specID] then
        return nodesList[specID]
    end

    local nodeOrder = {}
    for _, nodeID in ipairs(C_Traits.GetTreeNodes(treeID)) do
        local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
        if nodeInfo.isVisible then
            table.insert(nodeOrder, {nodeInfo.posY, nodeInfo.posX, nodeID})
        end
    end

    table.sort(
        nodeOrder,
        function(a, b)
            if a[1] ~= b[1] then
                return a[1] < b[1]
            else
                return a[2] < b[2]
            end
        end
    )

    local nodeIDs = {}
    for _, node in ipairs(nodeOrder) do
        table.insert(nodeIDs, node[3])
    end

    nodesList[specID] = nodeIDs
    return nodeIDs
end

local nodeOrderList = {}
addonTable.GetNodeOrder = function(specID, configID, treeID)
    if nodeOrderList[specID] then
        return nodeOrderList[specID]
    end

    local order = {}
    for i, nodeID in ipairs(addonTable.GetNodes(specID, configID, treeID)) do
        order[nodeID] = i
    end

    nodeOrderList[specID] = order
    return order
end

addonTable.ConvertToImportLoadoutEntryInfo = function(specID, configID, treeID, loadoutContent)
    local loadoutEntryInfo = talentsFrame:ConvertToImportLoadoutEntryInfo(configID, treeID, loadoutContent)
    local nodeOrder = addonTable.GetNodeOrder(specID, configID, treeID)

    for _, node in pairs(loadoutEntryInfo) do
        if not nodeOrder[node.nodeID] then
            return false
        end
    end

    table.sort(
        loadoutEntryInfo,
        function(a, b)
            return nodeOrder[a.nodeID] < nodeOrder[b.nodeID]
        end
    )

    return loadoutEntryInfo
end

local loadoutEntryInfoCache = {}
addonTable.GetLoadoutEntryInfo = function(importText, configID)
    local loadoutEntryInfo = loadoutEntryInfoCache[importText]
    if loadoutEntryInfo then
        return loadoutEntryInfo
    end

    local specID = PlayerUtil.GetCurrentSpecID()
    local treeID = C_ClassTalents.GetTraitTreeForSpec(specID)
    if not treeID then
        addonTable.PrintError(L.TEXT.TREEID_IS_NIL)
    end

    local importStream = ExportUtil.MakeImportDataStream(importText)
    if not importStream or not importStream.currentRemainingValue then
        return false
    end

    local errorMessage = addonTable.GetValidationError(treeID, importStream)
    if errorMessage then
        return false
    end

    local success, loadoutContent = pcall(talentsFrame.ReadLoadoutContent, talentsFrame, importStream, treeID)
    if not success then
        return false
    end

    loadoutEntryInfo = addonTable.ConvertToImportLoadoutEntryInfo(specID, configID, treeID, loadoutContent)
    if not loadoutEntryInfo then
        return false
    end

    loadoutEntryInfoCache[importText] = loadoutEntryInfo
    return loadoutEntryInfo
end

addonTable.ResetTree = function()
    local configID = C_ClassTalents.GetActiveConfigID()
    if not configID then
        addonTable.PrintError(addonTable.Locales.CONFIG_ID_IS_NIL)
        return false
    end

    local specID = PlayerUtil.GetCurrentSpecID()
    local treeID = C_ClassTalents.GetTraitTreeForSpec(specID)
    if not treeID then
        addonTable.PrintError(addonTable.Locales.TREE_ID_IS_NIL)
        return false
    end

    C_Traits.ResetTree(configID, treeID)
    return true
end

addonTable.ImportText = function(importText)
    parentFrame = PlayerSpellsFrame
    talentsFrame = parentFrame.TalentsTab or PlayerSpellsFrame.TalentsFrame

    local configID = C_ClassTalents.GetActiveConfigID()
    if not configID then
        addonTable.PrintError(addonTable.Locales.CONFIG_ID_IS_NIL)
        return
    end

    local loadoutEntryInfo = addonTable.GetLoadoutEntryInfo(importText, configID)
    if not loadoutEntryInfo then
        return
    end

    local hasError = false

    if not addonTable.ResetTree() then
        return
    end

    for _, entry in ipairs(loadoutEntryInfo) do
        local result = true
        local errorRank = nil
        local nodeInfo = C_Traits.GetNodeInfo(configID, entry.nodeID)
        if nodeInfo.type == Enum.TraitNodeType.Single or nodeInfo.type == Enum.TraitNodeType.Tiered then
            for rank = 1, entry.ranksPurchased do
                result = C_Traits.PurchaseRank(configID, entry.nodeID)
                if not result then
                    errorRank = rank
                    break
                end
            end
        else
            result = C_Traits.SetSelection(configID, entry.nodeID, entry.selectionEntryID)
        end

        if not result then
            hasError = true
            local entryInfo = entry.selectionEntryID and C_Traits.GetEntryInfo(configID, entry.selectionEntryID)
            local definitionInfo = entryInfo and entryInfo.definitionID and C_Traits.GetDefinitionInfo(entryInfo.definitionID)

            if definitionInfo then
                local name = definitionInfo.overrideName
                if not name then
                    local spellInfo = definitionInfo.spellID and C_Spell.GetSpellInfo(definitionInfo.spellID)
                    name = spellInfo and spellInfo.name
                end

                if not name then
                    addonTable.PrintError(addonTable.Locales.THIS_IS_A_BAD_LOADOUT)
                    DevTools_Dump(entry)
                    break
                elseif errorRank and entry.ranksPurchased > 1 then
                    --addonTable.PrintWarning(string.format("Cannot learn %s (%d)", name, errorRank))
                else
                    --addonTable.PrintWarning(string.format("Cannot learn %s", name))
                end
            end
        end
    end

    C_Traits.CommitConfig(configID)
    talentsFrame.ApplyButton:Click("LeftButton")

    return not hasError
end