local eventHandler = CreateFrame("Frame")
local transactionInProgress = false

local function GetTransactionAmount()
    local keepAmount = LSUDB.Settings["WarbankDepositInCopper"] or 0
    local netAmount = GetMoney() - keepAmount
    return (netAmount ~= 0) and netAmount or nil
end

local function ManageGuildBankFunds(isDeposit, amount)
    C_Timer.After(0.15, function()
        if isDeposit then
            C_Bank.DepositMoney(2, amount)
        else
            C_Bank.WithdrawMoney(2, amount)
        end
    end)
end

local function IsBankOpenEvent(event, interactionType)
    return event == "BANKFRAME_OPENED"
        or (event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW"
            and interactionType == Enum.PlayerInteractionType.Banker)
end

local function OnEvent(_, event, interactionType)
    local settings = LSUDB.Settings
    local keepAmount = settings and settings["WarbankDepositInCopper"] or 0
    if keepAmount == 0 then return end

    if not IsBankOpenEvent(event, interactionType) then return end
    if not C_Bank.CanDepositMoney(2) then return end

    if transactionInProgress then return end
    transactionInProgress = true
    C_Timer.After(0.5, function() transactionInProgress = false end)

    local transactionAmount = GetTransactionAmount()
    if not transactionAmount then return end

    if transactionAmount > 0 then
        ManageGuildBankFunds(true, transactionAmount)
    else
        ManageGuildBankFunds(false, -transactionAmount)
    end
end

eventHandler:RegisterEvent("BANKFRAME_OPENED")
eventHandler:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
eventHandler:SetScript("OnEvent", OnEvent)