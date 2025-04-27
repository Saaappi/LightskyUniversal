local addonName, LSU = ...

local Gossips = {
    [1978] = { -- Dragon Isles
        [186187] = { -- Kalecgos
            {
                optionID = 54821
            }
        },
        [190229] = { -- Korrikunit the Whalebringer
            {
                optionID = 55417
            }
        },
        [190226] = { -- Jokomuupat
            {
                optionID = 55418
            }
        },
        [190225] = { -- Babunituk
            {
                optionID = 55419
            }
        },
        [376767] = { -- Lingering Image (Mosaic)
            {
                optionID = 54980
            }
        },
        [376971] = { -- Lingering Image (Tower)
            {
                optionID = 55182
            }
        },
        [376972] = { -- Lingering Image (Workshop)
            {
                optionID = 55183
            }
        },
        [376974] = { -- Lingering Image (Pavilion)
            {
                optionID = 55184
            }
        },
        [183543] = { -- Noriko the All-Remembering
            {
                optionID = 54965,
                conditions = {
                    "OBJECTIVE_INCOMPLETE;66503;1"
                }
            }
        }
    }
}
LSU.Gossips = Gossips