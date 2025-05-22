local LSU = select(2, ...)

LSU.Enum = {
    Cinematics = {},
    Containers = {},
    Gossips = {
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
            },
            [4311] = { -- Holgar Stormaxe
                {
                    optionID = 47485
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
            },
            [107934] = { -- Recruiter Lee
                {
                    optionID = 47484,
                    conditions = {
                        "QUEST_ACTIVE;42782"
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
        [619] = { -- Broken Isles
            [91462] = { -- Malfurion Stormrage
                {
                    optionID = 44675
                }
            },
            [108642] = { -- Keeper Remulos
                {
                    optionID = 45772
                }
            }
        },
        [875] = { -- Zandalar
            [135440] = { -- Princess Talanji
                {
                    optionID = 47851
                }
            }
        },
        [1550] = { -- Shadowlands
            [159650] = { -- Elena
                {
                    optionID = 49559
                },
            },
            [159652] = { -- Florin
                {
                    optionID = 49558
                }
            },
            [159651] = { -- Dumitra
                {
                    optionID = 49557
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
    },
    Junk = {
        13444,  -- Major Mana Potion
        13446,  -- Major Healing Potion
        22829,  -- Super Healing Potion
        22832,  -- Super Mana Potion
        27854,  -- Smoked Talbuk Venison
        27855,  -- Mag'har Grainbread
        27860,  -- Purified Draenic Water
        28399,  -- Filtered Draenic Water
        29449,  -- Bladespire Bagel
        29451,  -- Clefthoof Ribs
        30810,  -- Sunfury Signet
        32902,  -- Bottled Nethergon Energy
        32905,  -- Bottled Nethergon Vapor
        33447,  -- Runic Healing Potion
        33457,  -- Scroll of Agility VI
        33459,  -- Scroll of Protection VI
        37091,  -- Scroll of Intellect VII
        37093,  -- Scroll of Stamina VII
        43463,  -- Scroll of Agility VII
        43465,  -- Scroll of Strength VII
        43467,  -- Scroll of Protection VII
    },
    Quests = {}
}