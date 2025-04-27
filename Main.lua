local addonName, LSU = ...
local eventFrame = CreateFrame("Frame")
local accountName = ""

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == addonName then
            if LSUDB == nil then
                LSUDB = {}
                LSUDB.AccountProperties = {}
            end
            if not LSUDB.AccountProperties.AccountName and not LSUDB.AccountProperties.DoNotNameAccount then
                StaticPopupDialogs["LSU_GetAccountName"] = {
                    text = "Hi! This account is new to me. What should I call you?",
                    button1 = SUBMIT,
                    button2 = CANCEL,
                    hasEditBox = 1,
                    OnShow = function(self, data)
                        self.editBox:SetMaxLetters(24)
                    end,
                    OnAccept = function(self, data)
                        accountName = self.editBox:GetText()
                        if accountName and accountName ~= "" then
                            LSUDB.AccountProperties.AccountName = accountName
                            StaticPopup_Hide("LSU_GetAccountName")
                            StaticPopupDialogs["LSU_AccountNameAccepted"] = {
                                text = string.format("Thank you! I shall now refer to you as %s.", accountName),
                                explicitAcknowledge = true,
                                OnAccept = function()
                                end,
                                OnCancel = function()
                                end,
                                timeout = 5,
                                preferredIndex = 3
                            }
                            StaticPopup_Show("LSU_AccountNameAccepted")
                        else
                            print("The account name can't be blank. If you don't wish to set an account name, please press Cancel.")
                        end
                    end,
                    OnCancel = function()
                        LSUDB.AccountProperties.DoNotNameAccount = true
                    end,
                    EditBoxOnEnterPressed = function(self, data)
                        accountName = self:GetParent().editBox:GetText()
                        if accountName and accountName ~= "" then
                            LSUDB.AccountProperties.AccountName = accountName
                            StaticPopup_Hide("LSU_GetAccountName")
                            StaticPopupDialogs["LSU_AccountNameAccepted"] = {
                                text = string.format("Thank you! I shall now refer to you as %s.", accountName),
                                explicitAcknowledge = true,
                                OnAccept = function()
                                end,
                                OnCancel = function()
                                end,
                                timeout = 5,
                                preferredIndex = 3
                            }
                            StaticPopup_Show("LSU_AccountNameAccepted")
                        end
                    end,
                    EditBoxOnTextChanged = StaticPopup_StandardNonEmptyTextHandler,
                    EditBoxOnEscapePressed = StaticPopup_StandardEditBoxOnEscapePressed,
                    hideOnEscape = 0,
                    timeout = 0,
                    exclusive = 1,
                    whileDead = 1,
                    explicitAcknowledge = true,
                    preferredIndex = 3
                }
                StaticPopup_Show("LSU_GetAccountName")
            end

            if LSUDB.AccountProperties.AccountName then
                local name = LSUDB.AccountProperties.AccountName
                local hour = tonumber(date("%H"))
                local greeting = ""
                if hour < 12 then
                    greeting = "Good morning, " .. name .. "!"
                elseif hour < 18 then
                    greeting = "Good afternoon, " .. name .. "!"
                else
                    greeting = "Good evening, " .. name .. "!"
                end

                StaticPopupDialogs["LSU_GreetPlayerByName"] = {
                    text = greeting .. " " .. CreateAtlasMarkup("delves-scenario-heart-icon", 18, 18),
                    explicitAcknowledge = true,
                    OnAccept = function()
                    end,
                    OnCancel = function()
                    end,
                    timeout = 10,
                    preferredIndex = 3
                }
                StaticPopup_Show("LSU_GreetPlayerByName")
            end
        end
    end
end)