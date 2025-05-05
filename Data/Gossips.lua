local addonName, LSU = ...

local Gossips = {
    [12] = { -- Kalimdor
        [206831] = { -- Portal to Wildheart Point
            {
                optionID = 39709
            }
        },
        [47923] = { -- Feronas Sindweller
            {
                optionID = 39076
            }
        },
        [47842] = { -- Archdruid Navarax
            {
                optionID = 39447
            }
        },
        [213620] = { -- Thrall
            {
                optionID = 123176
            }
        }
    },
    [13] = { -- Eastern Kingdoms
        [167032] = { -- Chromie
            {
                optionID = 51901,
                conditions = {
                    "!CT_EXPANSION;10"
                }
            }
        }
    },
    [572] = { -- Draenor
        [78556] = { -- Ariok
            {
                optionID = 43152
            }
        },
        [78568] = { -- Thaelin Darkanvil
            {
                optionID = 42452
            }
        },
        [79243] = { -- Baros Alexston
            {
                optionID = 43035
            }
        },
    },
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
        },
        [186224] = { -- Brena
            {
                optionID = 54825
            }
        },
        [187730] = { -- Akiun
            {
                optionID = 55220
            }
        },
        [190136] = { -- Tuskarr Fisherman
            {
                optionID = 55691
            }
        },
        [190142] = { -- Tuskarr Hunter
            {
                optionID = 55692
            }
        },
        [190143] = { -- Tuskarr Craftsman
            {
                optionID = 55693
            }
        },
        [190074] = { -- Festering Gnoll
            {
                optionID = 55694
            }
        },
        [196837] = { -- Instructional Crystal
            {
                optionID = 107039
            }
        },
        [377551] = { -- Rotting Root (North)
            {
                optionID = 55350
            }
        },
        [377555] = { -- Rotting Root (South)
            {
                optionID = 54967
            }
        },
        [377556] = { -- Rotting Root (West)
            {
                optionID = 54968
            }
        },
        [187873] = { -- Kalecgos
            {
                optionID = 55002
            }
        },
        [186448] = { -- Elder Poa
            {
                optionID = 55010
            },
            {
                optionID = 55011
            },
            {
                optionID = 55014
            },
            {
                optionID = 55017
            },
            {
                optionID = 55020
            },
            {
                optionID = 55022
            },
        },
        [186480] = { -- Brena
            {
                optionID = 55314
            }
        },
        [186280] = { -- Kalecgos
            {
                optionID = 54829
            }
        },
    }
}
LSU.Gossips = Gossips