local addonName, LSU = ...
local L = {}

L.TALENT_IMPORTER_BUTTON_TOOLTIP = "Click to open the talent importer utility."
L.APPLY_TALENTS_BUTTON_TOOLTIP = "Click to apply talents for your class and specialization."
L.TEXT_BAD_LOADOUT = "This is a bad loadout! Try importing a new one."
L.TEXT_CONFIG_IS_NIL = "configID is nil!"
L.TEXT_TREEID_IS_NIL = "treeID is nil!"
L.CONTAINERS_BUTTON_TOOLTIP = "Click to open container items from your inventory."
L.LABEL_TALENT_IMPORTER = "Talent Importer"
L.LABEL_TALENT_IMPORTER_BUTTON_BACK = "Back"
L.NEW_CHARACTER_BUTTON_TOOLTIP = "Click to configure new character settings for"
L.SELL_JUNK_TOOLTIP = "|cffFFFFFFThis item is junk!|r"
L.SELL_JUNK_BUTTON_TOOLTIP = "Click to sell \"junk\" items from your inventory."
L.TEXT_CONFIGURATION_COMPLETE = "Configuration completed. Would you like to reload now?"
L.TALENT_IMPORTER_BUTTON_BACK_TOOLTIP = "Return to class selection."
L.TRANSMOG_BUTTON_TOOLTIP = "Click to learn transmogrification appearances from the inventory."
L.TEXT_BUTTON_CREATION_FAILED = "Button failed to create"
L.TEXT_CHARACTER_VARIABLE_NIL = "The {character} variable is nil. Please reload."
L.TEXT_COULD_NOT_RETRIEVE_NPC_INFO = "Could not retrieve NPC information."
L.TEXT_NO_GOSSIP_OPTIONS_AVAILABLE = "No gossip options available."
L.TEXT_LAST_UPDATED = "Last Updated"
L.TEXT_LOW_INVENTORY_SPACE = "Inventory space is 5% or less. Summoning a vendor mount..."
L.TEXT_RARE_SPOTTED = "has been spotted"

-- Button labels
L.LABEL_ACCEPT_QUESTS                   = "Accept Quests"
L.LABEL_ALWAYS_COMPARE_ITEMS            = "Always Compare Items"
L.LABEL_ALWAYS_SHOW_ACTION_BARS         = "Always Show Action Bars"
L.LABEL_ARACHNOPHOBIA_MODE              = "Arachnophobia Mode"
L.LABEL_AUTO_DISMOUNT_FLYING            = "Auto Dismount Flying"
L.LABEL_AUTO_INTERACT                   = "Auto Interact"
L.LABEL_AUTO_LOOT                       = "Auto Loot"
L.LABEL_AUTO_PUSH_SPELLS_TO_ACTION_BAR  = "Auto Push Spells To Action Bar"
L.LABEL_AUTO_REPAIR                     = "Auto Repair"
L.LABEL_AUTO_TRAIN                      = "Auto Train"
L.LABEL_BUY_QUEST_ITEMS                 = "Buy Quest Items"
L.LABEL_CHAT_ICONS                      = "Chat Icons"
L.LABEL_CHROMIE_TIME                    = "Chromie Time"
L.LABEL_CLEAR_ALL_TRACKING              = "Clear All Tracking"
L.LABEL_COMPLETE_QUESTS                 = "Complete Quests"
L.LABEL_COOLDOWN_VIEWER                 = "Cooldown Viewer"
L.LABEL_DEPOSIT_KEEP_AMOUNT             = "Deposit Keep Amount"
L.LABEL_DISABLE_FOOTSTEP_SOUNDS         = "Disable Footstep Sounds"
L.LABEL_DISABLE_SKYRIDING_FULL_SCREEN   = "Disable Skyriding Full Screen Effects"
L.LABEL_DISABLE_SKYRIDING_VELOCITY_VFX  = "Disable Skyriding Velocity VFX"
L.LABEL_DISABLE_USER_ADDONS_BY_DEFAULT  = "Disable User Addons By Default"
L.LABEL_DISCORD                         = "Discord"
L.LABEL_DONATE                          = "Donate"
L.LABEL_EDIT_MODE_LAYOUT                = "Edit Mode Layout"
L.LABEL_ENABLE_FLOATING_COMBAT_TEXT     = "Enable Floating Combat Text"
L.LABEL_GOSSIP                          = "Gossip"
L.LABEL_ITEM_LEVEL                      = "Item Level"
L.LABEL_LOOT_UNDER_MOUSE                = "Loot Under Mouse"
L.LABEL_MOUNT_JOURNAL_SHOW_PLAYER       = "Mount Journal Show Player"
L.LABEL_NEW_CHARACTER                   = "New Character"
L.LABEL_NEWCHARACTER_BUTTON             = "Configure New Character"
L.LABEL_OCCLUDED_SILHOUETTE_PLAYER      = "Occluded Silhouette Player"
L.LABEL_OPEN_GOSSIPS                    = "Open Gossips"
L.LABEL_PLAYER_TALENTS                  = "Player Talents"
L.LABEL_POPUP_CTRLC_COPY                = "Use Ctrl+C to copy the link below."
L.LABEL_ENABLE_PROFANITY_FILTER         = "Profanity Filter"
L.LABEL_PVP_FRAMES_DISPLAY_CLASS_COLOR  = "PvP Frames Display Class Color"
L.LABEL_QUEST_REWARDS                   = "Quest Rewards"
L.LABEL_QUEST_TEXT_CONTRAST             = "Quest Text Contrast"
L.LABEL_RAID_FRAMES_DISPLAY_CLASS_COLOR = "Raid Frames Display Class Color"
L.LABEL_RARES                           = "Rares"
L.LABEL_READY_CHECKS                    = "Ready Checks"
L.LABEL_REPLACE_MY_PLAYER_PORTRAIT      = "Replace My Player Portrait"
L.LABEL_REPLACE_OTHER_PLAYER_PORTRAITS  = "Replace Other Player Portraits"
L.LABEL_ROLE_CHECKS                     = "Role Checks"
L.LABEL_SELL_PRICE                      = "Sell Price"
L.LABEL_SHOW_SCRIPT_ERRORS              = "Show Script Errors"
L.LABEL_SHOW_TARGET_OF_TARGET           = "Show Target of Target"
L.LABEL_SHOW_TUTORIALS                  = "Show Tutorials"
L.LABEL_SKIP_CINEMATICS                 = "Skip Cinematics"
L.LABEL_SOFT_TARGET_ENEMY               = "Soft Target Enemy"
L.LABEL_SPELLBOOK_HIDE_PASSIVES         = "Spellbook Hide Passives"

L.HEADER_CHROMIE_TIME_MODULE            = "Chromie Time Module"
L.HEADER_GENERAL_MODULES                = "General Modules"
L.HEADER_GOSSIP_MODULE                  = "Gossip Module"
L.HEADER_NEW_CHARACTER_MODULE           = "New Character Module"

-- Fontstrings
L.FONTSTRING_GOSSIP_LINE_COUNT_TEXT = "|cffFFFFFF%s|r line(s)"

-- Popups
L.POPUP_NEWCHARACTER_TEXT = "Character configuration completed. Would you like to reload now?\n\n" ..
"|cffFF474CNOTE|r: This is recommended to guarantee the settings are saved server side."

L.SLASH_CMD_LSU = "/lsu"

-- Frame titles
L.TITLE_ADDON = C_AddOns.GetAddOnMetadata(addonName, "Title")
L.TITLE_GOSSIPS = "Gossips"
L.TITLE_SETTINGS = "Settings"

-- Tooltips
L.TOOLTIP_GOSSIPS_OPEN_BUTTON = "Click to open the Gossips utility."
L.TOOLTIP_GOSSIPS_SEARCHBOX = "Enter a search query here to filter the above edit box, making it significantly easier to locate what you're looking for.\n\n" ..
"|cffFF474CNOTE|r: Your search query can be no more than 30 characters."
L.TOOLTIP_GOSSIPS_SUBMIT_BUTTON = "Submit the contents of the edit box for processing. If valid, the addon will add them to your Gossips table and automate their selection going forward.\n\n" ..
"If you submit gossips that are available in the active Gossip Frame, then they will be selected without the need to close and reopen the frame."
L.TOOLTIP_GOSSIPS_HELP_BUTTON = "|cffFF474CThere is a rough cap on the number of gossips you can store. The exact number will depend on the format of your gossips, but the range is anywhere from 250-275,000.|r\n\n" ..
"Entering data requires the ID of the NPC/GameObject, the ID of the desired gossip option, and optionally a list of conditions.\n\n" ..
"The |cff00CCFF<ID>|r for the NPC or GameObject can be found at the top of the GossipFrame when interacting with the target. It prefixes the name within [].\n\n" ..
"The |cff00CCFF<GossipOptionID>|r can be found before the text of the option within []. It's the number in the |cffBA45A0mulberry|r color.\n\n" ..
"Conditions are slightly more complicated and can be daisy chained together. Condition types are case sensitive and should always be CAPITALIZED! Condition types and their values should always be separated by a semicolon. Supported conditions and how to format them can be seen below:\n\n" ..
"Supported Conditions:\n" ..
"- |cff00CCFF!CT_EXPANSION|r: Used to determine whether the player is not in the given Chromie Time expansion.\n" ..
"- |cff00CCFFQUEST_ACTIVE|r: Used to determine if a player is actively on a quest.\n" ..
"- |cff00CCFFOBJECTIVE_INCOMPLETE|r: Used to determine if a given objective is incomplete on an active quest.\n\n" ..
"Format Examples:\n" ..
"- |cff00CCFF!CT_EXPANSION;10|r: Checks to see if the player is not in the Legion expansion for Chromie Time.\n" ..
"- |cff00CCFFQUEST_ACTIVE;12345|r: Checks to see if the player is on the quest with an ID of 12345.\n" ..
"- |cff00CCFFOBJECTIVE_COMPLETE;12345;1|r: Checks to see if the first objective is complete for the quest with an ID of 12345.\n" ..
"- |cff00CCFFOBJECTIVE_INCOMPLETE;12345;1|r: Checks to see if the first objective is incomplete for the quest with an ID of 12345.\n\n" ..
"Daisy chaining conditions together is easily done by separating them with a comma:\n" ..
"- |cff00CCFF!CT_EXPANSION;10,QUEST_ACTIVE;12345|r: First, the addon will check if the player is not in Legion Chromie Time, and then check if they're on the quest with an ID of 12345.\n\n" ..
"If any condition fails its check, then the gossip will not be selected. Nothing is returned in chat when a condition fails, so if something isn't working as it should, double check your conditions! :D"
L.TOOLTIP_ACCEPT_QUESTS = "Streamline your gameplay by automatically accepting most available quests from NPCs."
L.TOOLTIP_AUTO_REPAIR = "Keep your gear in top shape by auto-repairing at vendors, as long as the repair cost is under 33% of your current gold."
L.TOOLTIP_AUTO_TRAIN = "Effortlessly learn new skills by automatically training all available spells at trainers—limited to affordable costs (up to 33% of your gold)."
L.TOOLTIP_BUY_QUEST_ITEMS = "Never forget a quest item again! Purchases required quest items from vendors automatically."
L.TOOLTIP_CHROMIE_TIME = "Automatically choose and activate your preferred Chromie Time expansion when interacting with them."
L.TOOLTIP_COMPLETE_QUESTS = "Finish quests with automatic turn-ins and selecting rewards."
L.TOOLTIP_GOSSIP = "Interact with supported NPCs efficiently by instantly selecting gossip options."
L.TOOLTIP_NEW_CHARACTER = "Configure and manage special settings for new characters with a dedicated module toggle."
L.TOOLTIP_PLAYER_TALENTS = "Quickly learn new talents at the click of a button!"
L.TOOLTIP_QUEST_REWARDS = "Automatically selects the best quest reward—prioritizing item level, sell price, or choosing randomly if needed."
L.TOOLTIP_RARES = "Control rare spawn notifications—toggle announcements for rare NPCs on or off."
L.TOOLTIP_SKIP_CINEMATICS = "Enjoy uninterrupted gameplay by skipping in-game cinematics and movies automatically."
L.TOOLTIP_ALWAYS_COMPARE_ITEMS = "Force displays the comparison tooltip when you hover over other items, allowing you to easily compare attributes and stats."
L.TOOLTIP_ALWAYS_SHOW_ACTION_BARS = "Keeps action bars visible at all times."
L.TOOLTIP_ARACHNOPHOBIA_MODE = "Replaces arachnid creature models with crabs to provide a more comfortable experience for players with arachnophobia."
L.TOOLTIP_AUTO_DISMOUNT_FLYING = "If enabled, automatically dismounts your character when casting spells or abilities while flying."
L.TOOLTIP_AUTO_INTERACT = "Automatically moves your character into range when interacting with NPCs or objects."
L.TOOLTIP_AUTO_LOOT_DEFAULT = "Automatically collects loot from defeated enemies or opened containers."
L.TOOLTIP_AUTO_PUSH_SPELLS_TO_ACTION_BAR = "Automatically adds newly learned spells to your action bar when you level up."
L.TOOLTIP_CLEAR_ALL_TRACKING = "Automatically removes all active tracking options from the minimap."
L.TOOLTIP_COOLDOWN_VIEWER = "Displays a visual tracker on your screen for ability cooldowns."
L.TOOLTIP_DISABLE_SKYRIDING_FULL_SCREEN_EFFECT = "Disables full screen visual effects while skyriding for a clearer view and reduced visual distractions."
L.TOOLTIP_DISABLE_SKYRIDING_VFX = "Disables velocity visual effects while skyriding to reduce motion sickness and provide a more comfortable experience."
L.TOOLTIP_DISABLE_USER_ADDONS_BY_DEFAULT = "Prevents newly installed addons from being enabled automatically."
L.TOOLTIP_ENABLE_FLOATING_COMBAT_TEXT = "Enables or disables floating combat text for damage, healing, and other events during combat."
L.TOOLTIP_DISABLE_FOOTSTEP_SOUNDS = "Enables or disables footstep sounds."
L.TOOLTIP_LOOT_UNDER_MOUSE = "Displays the loot window beneath your mouse cursor."
L.TOOLTIP_MOUNT_JOURNAL_SHOWS_PLAYER = "Automatically displays your character model riding mounts in the Mount Journal preview."
L.TOOLTIP_OCCLUDED_SILHOUETTE_PLAYER = "Displays your character's silhouette when view is blocked by objects, such as trees, for improved tracking."
L.TOOLTIP_ENABLE_PROFANITY_FILTER = "Enables the in-game profanity filter to block offensive language in chat."
L.TOOLTIP_PVP_FRAMES_DISPLAY_CLASS_COLOR = "Displays player class colors on PvP frames for easier identification of opponents and teammates."
L.TOOLTIP_QUEST_TEXT_CONTRAST = "Enable to enhance the contrast of the quest giver interface for improved readability and accessibility."
L.TOOLTIP_RAID_FRAMES_DISPLAY_CLASS_COLOR = "Displays player class colors on raid frames for easier identification of group members."
L.TOOLTIP_REPLACE_MY_PLAYER_PORTRAIT = "Replaces your character's portrait with your class icon."
L.TOOLTIP_REPLACE_OTHER_PLAYER_PORTRAITS = "Replaces the portraits of other players with their class icon."
L.TOOLTIP_SHOW_SCRIPT_ERRORS = "Displays Lua script errors as they occur to help identify and troubleshoot addon or interface issues."
L.TOOLTIP_SHOW_TARGET_OF_TARGET = "Shows the target of your current target for improved situational awareness."
L.TOOLTIP_SHOW_TUTORIALS = "Displays tutorial popups to guide you through gameplay and features."
L.TOOLTIP_SOFT_TARGET_ENEMY = "Highlights or selects enemies you're looking at without requiring a hard target, enabling quick interaction or awareness."
L.TOOLTIP_SPELLBOOK_HIDE_PASSIVES = "Hides passive spells in your spellbook for a clearer view of active abilities."

LSU.L = L