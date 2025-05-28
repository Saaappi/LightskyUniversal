local LSU = select(2, ...)

LSU.Enum.PlayerTalents = {}
LSU.Enum.PlayerTalents.ClassButtons = {
    {
        ["id"] = 1,
        ["atlas"] = "classicon-deathknight",
        ["classID"] = 6,
        ["className"] = "Death Knight",
        ["classColor"] = C_ClassColor.GetClassColor("DEATHKNIGHT"),
    },
    {
        ["id"] = 2,
        ["atlas"] = "classicon-demonhunter",
        ["classID"] = 12,
        ["className"] = "Demon Hunter",
        ["classColor"] = C_ClassColor.GetClassColor("DEMONHUNTER"),
    },
    {
        ["id"] = 3,
        ["atlas"] = "classicon-druid",
        ["classID"] = 11,
        ["className"] = "Druid",
        ["classColor"] = C_ClassColor.GetClassColor("DRUID"),
    },
    {
        ["id"] = 4,
        ["atlas"] = "classicon-evoker",
        ["classID"] = 13,
        ["className"] = "Evoker",
        ["classColor"] = C_ClassColor.GetClassColor("EVOKER"),
    },
    {
        ["id"] = 5,
        ["atlas"] = "classicon-hunter",
        ["classID"] = 3,
        ["className"] = "Hunter",
        ["classColor"] = C_ClassColor.GetClassColor("HUNTER"),
    },
    {
        ["id"] = 6,
        ["atlas"] = "classicon-mage",
        ["classID"] = 8,
        ["className"] = "Mage",
        ["classColor"] = C_ClassColor.GetClassColor("MAGE"),
    },
    {
        ["id"] = 7,
        ["atlas"] = "classicon-monk",
        ["classID"] = 10,
        ["className"] = "Monk",
        ["classColor"] = C_ClassColor.GetClassColor("MONK"),
    },
    {
        ["id"] = 8,
        ["atlas"] = "classicon-paladin",
        ["classID"] = 2,
        ["className"] = "Paladin",
        ["classColor"] = C_ClassColor.GetClassColor("PALADIN"),
    },
    {
        ["id"] = 9,
        ["atlas"] = "classicon-priest",
        ["classID"] = 5,
        ["className"] = "Priest",
        ["classColor"] = C_ClassColor.GetClassColor("PRIEST"),
    },
    {
        ["id"] = 10,
        ["atlas"] = "classicon-rogue",
        ["classID"] = 4,
        ["className"] = "Rogue",
        ["classColor"] = C_ClassColor.GetClassColor("ROGUE"),
    },
    {
        ["id"] = 11,
        ["atlas"] = "classicon-shaman",
        ["classID"] = 7,
        ["className"] = "Shaman",
        ["classColor"] = C_ClassColor.GetClassColor("SHAMAN"),
    },
    {
        ["id"] = 12,
        ["atlas"] = "classicon-warlock",
        ["classID"] = 9,
        ["className"] = "Warlock",
        ["classColor"] = C_ClassColor.GetClassColor("WARLOCK"),
    },
    {
        ["id"] = 13,
        ["atlas"] = "classicon-warrior",
        ["classID"] = 1,
        ["className"] = "Warrior",
        ["classColor"] = C_ClassColor.GetClassColor("WARRIOR"),
    },
}

LSU.Enum.PlayerTalents.SpecEditBoxes = {
    { -- Death Knight
        {
            ["id"] = 250,
            ["name"] = "Blood",
        },
        {
            ["id"] = 251,
            ["name"] = "Frost",
        },
        {
            ["id"] = 252,
            ["name"] = "Unholy",
        }
    },
    { -- Demon Hunter
        {
            ["id"] = 577,
            ["name"] = "Havoc",
        },
        {
            ["id"] = 581,
            ["name"] = "Vengeance",
        }
    },
    { -- Druid
        {
            ["id"] = 102,
            ["name"] = "Balance",
        },
        {
            ["id"] = 103,
            ["name"] = "Feral",
        },
        {
            ["id"] = 104,
            ["name"] = "Guardian",
        },
        {
            ["id"] = 105,
            ["name"] = "Restoration",
        },
    },
    { -- Evoker
        {
            ["id"] = 1473,
            ["name"] = "Augmentation",
        },
        {
            ["id"] = 1467,
            ["name"] = "Devastation",
        },
        {
            ["id"] = 1468,
            ["name"] = "Preservation",
        },
    },
    { -- Hunter
        {
            ["id"] = 253,
            ["name"] = "Beast Mastery",
        },
        {
            ["id"] = 254,
            ["name"] = "Marksmanship",
        },
        {
            ["id"] = 255,
            ["name"] = "Survival",
        },
    },
    { -- Mage
        {
            ["id"] = 62,
            ["name"] = "Arcane",
        },
        {
            ["id"] = 63,
            ["name"] = "Fire",
        },
        {
            ["id"] = 64,
            ["name"] = "Frost",
        },
    },
    { -- Monk
        {
            ["id"] = 268,
            ["name"] = "Brewmaster",
        },
        {
            ["id"] = 270,
            ["name"] = "Mistweaver",
        },
        {
            ["id"] = 269,
            ["name"] = "Windwalker",
        },
    },
    { -- Paladin
        {
            ["id"] = 65,
            ["name"] = "Holy",
        },
        {
            ["id"] = 66,
            ["name"] = "Protection",
        },
        {
            ["id"] = 70,
            ["name"] = "Retribution",
        },
    },
    { -- Priest
        {
            ["id"] = 256,
            ["name"] = "Discipline",
        },
        {
            ["id"] = 257,
            ["name"] = "Holy",
        },
        {
            ["id"] = 258,
            ["name"] = "Shadow",
        },
    },
    { -- Rogue
        {
            ["id"] = 259,
            ["name"] = "Assassination",
        },
        {
            ["id"] = 260,
            ["name"] = "Outlaw",
        },
        {
            ["id"] = 261,
            ["name"] = "Subtlety",
        },
    },
    { -- Shaman
        {
            ["id"] = 262,
            ["name"] = "Elemental",
        },
        {
            ["id"] = 263,
            ["name"] = "Enhancement",
        },
        {
            ["id"] = 264,
            ["name"] = "Restoration",
        },
    },
    { -- Warlock
        {
            ["id"] = 265,
            ["name"] = "Affliction",
        },
        {
            ["id"] = 266,
            ["name"] = "Demonology",
        },
        {
            ["id"] = 267,
            ["name"] = "Destruction",
        },
    },
    { -- Warrior
        {
            ["id"] = 71,
            ["name"] = "Arms",
        },
        {
            ["id"] = 72,
            ["name"] = "Fury",
        },
        {
            ["id"] = 73,
            ["name"] = "Protection",
        },
    },
}