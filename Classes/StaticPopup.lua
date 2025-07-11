local addonName, addonTable = ...

function addonTable.NewStaticPopup(key, text, opts)
    opts = opts or {}
    StaticPopupDialogs[key] = {
        text = text,
        button1 = opts.button1Text or YES,
        button2 = opts.button2Text,
        hasEditBox = opts.hasEditBox,
        OnShow = opts.onShow,
        OnAccept = opts.onAccept,
        OnCancel = function() end,
        timeout = 0,
        hideOnEscape = 1,
        preferredIndex = 3
    }
end