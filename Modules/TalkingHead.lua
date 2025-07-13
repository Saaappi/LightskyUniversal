local addonTable = select(2, ...)

hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
    if not LSUDB.Settings["MuteTalkingHead.Enabled"] then return end

    self:Reset()
    self:CloseImmediately()
end)