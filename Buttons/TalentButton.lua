local addonName, LSU = ...
local applyTalentsButton

-- Last Updated: 11.1.5
local talents = {
    {   -- Warrior (Fury)
        [72] = "CgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0YgZZmZYsMmZmFmZmxMYYmttZGzM2GmxYGzMjFbzwMjBAAACDsBLLGNmBwsAjF"
    },
    {   -- Paladin (Protection)
        [66] = "CIEAAAAAAAAAAAAAAAAAAAAAAsNzMDz2YhZMzM2mZmZmxYYAAAGAAAAAAASmZYYmhxMmt2AgxAGAD2GAAgZm2mlZbGAgNDMAMzwwYA"
    },
    {   -- Hunter (Marksmanship)
        [254] = "C4PAAAAAAAAAAAAAAAAAAAAAAwADsMGNWGAzG2AAAAAAAAAAAAAAYGzYGzMDzoZGjhZGGDzsMG2GjZxsMMjZmZWmZGGzMz2yYw2A"
    },
    {   -- Rogue (Subtlety)
        [261] = "CUQAAAAAAAAAAAAAAAAAAAAAAAAM2mBAAAAAgZbMWmGzYmxMGjZYmZmhxsNLGjttZmxMzMGMWmlBAAAgZwAYMbGGYgZhFaxGM"
    },
    {   -- Priest (Shadow)
        [258] = "CIQAAAAAAAAAAAAAAAAAAAAAAMgZGAAAAAAAAAAAAMmZxMmhtZbmZmZmtxMLDmNmZmZMbMLYwMmFz2UzMAMAmZzywsZAIjxCAA"
    },
    {   -- Death Knight (Unholy)
        [252] = "CwPAAAAAAAAAAAAAAAAAAAAAAAgZGzMjZYYGmZmpZMjZGzYAAAAAAAAAMMzYGjZmZAAbgZxYmZmxMzA2MLGGYgZhhGLYAmBA"
    },
    {   -- Shaman (Enhancement)
        [263] = "CcQAAAAAAAAAAAAAAAAAAAAAAMzMzCYmx2MzMzMzyMjtxAAAAAAAAAAAwiZMsBbwMM0gFAMLTmBzyiZmZYmZmZBLmZCWGLjZGAgBA"
    },
    {   -- Mage (Arcane)
        [62] = "C4DAAAAAAAAAAAAAAAAAAAAAAMjhxsgZmZMLmBjZMmmHYMDAAAAAADAYmZaZ2WmBAwGAAAAAALAsMGmZWmlhZwMjZmZmZmxMGD"
    },
    {   -- Warlock (Destruction)
        [267] = "CsQAAAAAAAAAAAAAAAAAAAAAAAmZmZmZEzihxsZmZYWmNjZmxsY2YbxMDAAAAMzMsNzsMjFYgZxoxMAmNshBAAAAAAwYmxsAA"
    },
    {   -- Monk (Brewmaster)
        [268] = "CwQAAAAAAAAAAAAAAAAAAAAAAAAAAAzMGzgxyMz2YmZAAAAAAAYZBEzMwMMYGsMzMDzyYmx2sMTLbWsNmxMbAAwGAAAwsNbNzMzCzwG"
    },
    {   -- Druid (Guardian)
        [104] = "CgGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzYMzMzyMMmZMGLMMzsYZALGGNRzMzyMbzMzyYGAAAAAAwwMDYZbmNMmlBwEAAAwGMAsZmhB"
    },
    {   -- Demon Hunter (Vengeance)
        [581] = "CUkAAAAAAAAAAAAAAAAAAAAAAAAGjZmZMmZkZmxMDzMLjBjtZMjZMzwY2mZmtZmhZwAAAAAsMLmxwsx0AzMwG"
    },
    {   -- Evoker (Devastation)
        [1467] = "CsbBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAmZmBzsZGmBMYMTzYmJz2YZYmZmZMz2MgZMzGzMbzMDMwYwCsMGN2GAzAwGG"
    }
}

EventRegistry:RegisterCallback("PlayerSpellsFrame.TalentTab.Show", function()
    local parentFrame = PlayerSpellsFrame
    local talentsFrame = parentFrame.TalentsTab or PlayerSpellsFrame.TalentsFrame
    if not applyTalentsButton then
        local button = {
            type = "BasicButton",
            name = "LSUApplyTalentsButton",
            width = 120,
            height = 25,
            text = "Apply Talents",
            point = "LEFT",
            parent = talentsFrame.SearchBox
        }
        applyTalentsButton = LSU.CreateButton(button)
    end
    applyTalentsButton:ClearAllPoints()
    applyTalentsButton:SetPoint("LEFT", applyTalentsButton:GetParent(), "RIGHT", 2.5, 0)
    applyTalentsButton:Show()

    applyTalentsButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(LSU.Locale.BUTTON_DESCRIPTION_APPLYTALENTS, 1, 1, 1, 1, true)
    end)

    applyTalentsButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local version = C_Traits.GetLoadoutSerializationVersion and C_Traits.GetLoadoutSerializationVersion() or 1
    local function GetValidationError(treeID, importStream, isTryRead)
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
    local function GetNodes(specID, configID, treeID)
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
    local function GetNodeOrder(specID, configID, treeID)
        if nodeOrderList[specID] then
            return nodeOrderList[specID]
        end

        local order = {}
        for i, nodeID in ipairs(GetNodes(specID, configID, treeID)) do
            order[nodeID] = i
        end

        nodeOrderList[specID] = order
        return order
    end

    local function ConvertToImportLoadoutEntryInfo(specID, configID, treeID, loadoutContent)
        local loadoutEntryInfo = talentsFrame:ConvertToImportLoadoutEntryInfo(configID, treeID, loadoutContent)
        local nodeOrder = GetNodeOrder(specID, configID, treeID)

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
    local function GetLoadoutEntryInfo(importText, configID)
        local loadoutEntryInfo = loadoutEntryInfoCache[importText]
        if loadoutEntryInfo then
            return loadoutEntryInfo
        end

        local specID = PlayerUtil.GetCurrentSpecID()
        local treeID = C_ClassTalents.GetTraitTreeForSpec(specID)
        if not treeID then
            LSU.PrintError("treeID is nil!")
        end

        local importStream = ExportUtil.MakeImportDataStream(importText)
        if not importStream or not importStream.currentRemainingValue then
            return false
        end

        local errorMessage = GetValidationError(treeID, importStream)
        if errorMessage then
            return false
        end

        --[[if C_ClassTalents.GetStarterBuildActive() then
            local eventName = "TRAIT_CONFIG_UPDATED";
            starterBuildDeactiveFrame:RegisterEvent(eventName);
            starterBuildDeactiveFrame:SetScript(
                "OnEvent",
                function(_, event, ...)
                    if event == eventName and (...) == configID then
                        starterBuildDeactiveFrame:UnregisterAllEvents();
                        Addon:ImportTextAsync(importText);
                    end
                end
            );

            C_ClassTalents.SetStarterBuildActive(false);
            return false;
        end]]

        local success, loadoutContent = pcall(talentsFrame.ReadLoadoutContent, talentsFrame, importStream, treeID)
        if not success then
            return false
        end

        loadoutEntryInfo = ConvertToImportLoadoutEntryInfo(specID, configID, treeID, loadoutContent)
        if not loadoutEntryInfo then
            return false
        end

        loadoutEntryInfoCache[importText] = loadoutEntryInfo
        return loadoutEntryInfo
    end

    local function ResetTree()
        local configID = C_ClassTalents.GetActiveConfigID()
        if not configID then
            LSU.PrintError("configID is nil!")
            return false
        end

        local specID = PlayerUtil.GetCurrentSpecID()
        local treeID = C_ClassTalents.GetTraitTreeForSpec(specID)
        if not treeID then
            LSU.PrintError("treeID is nil!")
            return false
        end

        C_Traits.ResetTree(configID, treeID)
        return true
    end

    local function ImportText(importText)
        local configID = C_ClassTalents.GetActiveConfigID()
        if not configID then
            LSU.PrintError("configID is nil!")
            return
        end

        local loadoutEntryInfo = GetLoadoutEntryInfo(importText, configID)
        if not loadoutEntryInfo then
            return
        end

        local hasError = false

        if not ResetTree() then
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
                        LSU.PrintError("This is a bad loadout! Try importing a new one.")
                        DevTools_Dump(entry)
                        break
                    elseif errorRank and entry.ranksPurchased > 1 then
                        --LSU.PrintWarning(string.format("Cannot learn %s (%d)", name, errorRank))
                    else
                        --LSU.PrintWarning(string.format("Cannot learn %s", name))
                    end
                end
            end
        end

        C_Traits.CommitConfig(configID)
        talentsFrame.ApplyButton:Click("LeftButton")

        return not hasError
    end

    applyTalentsButton:SetScript("OnClick", function()
        C_Timer.After(0, function()
            if talents[LSU.Character.ClassID] then
                local class = talents[LSU.Character.ClassID]
                if class[LSU.Character.SpecID] then
                    ImportText(class[LSU.Character.SpecID])
                end
            end
        end)
    end)
end)

EventRegistry:RegisterCallback("PlayerSpellsFrame.TalentTab.Hide", function()
    applyTalentsButton:Hide()
end)