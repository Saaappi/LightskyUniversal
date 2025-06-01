local eventFrame = CreateFrame("Frame")

local function BuyService()
    local reservePercent = 0.33
    local money = GetMoney()
    local reserve = money * reservePercent

    local numServices = GetNumTrainerServices()
    for index = 1, numServices do
        local cost = GetTrainerServiceCost(index)
        if (money - cost) >= reserve then
            BuyTrainerService(index)
            money = money - cost
        end
    end
end

eventFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
eventFrame:RegisterEvent("TRAINER_UPDATE")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
        local type = ...
        if type == 7 then
            BuyService()
        end
    elseif event == "TRAINER_UPDATE" then
        C_Timer.After(.25, BuyService)
    end
end)