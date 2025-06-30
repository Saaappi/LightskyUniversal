local addonName, LSU = ...
local Locales = {
    enUS = {},
    enGB = {},
    deDE = {},
    esES = {},
    esMX = {},
    frFR = {},
    itIT = {},
    koKR = {},
    ptBR = {},
    ruRU = {},
    zhCN = {},
    zhTW = {}
}

LIGHTSKYUNIVERSAL_LOCALES = Locales

local L = Locales.enUS

L["SLASH_COMMAND1"] = "/lightskyuniversal"
L["SLASH_COMMAND2"] = "/lsu"

-- Headers (Settings)
L["GENERAL_MODULES"] = "General Modules"
L["GOSSIP_MODULE"] = "Gossip Module"
L["CHROMIE_TIME_MODULE"] = "Chromie Time Module"
L["NEW_CHARACTER_MODULE"] = "New Character Module"

-- Error Messages
L["ADDON_NOT_FOUND"] = "%s not found! Are you sure it's loaded?"

-- Text Output (Chat)
L["HAS_BEEN_SPOTTED"] = "has been spotted"
L["WAY"] = "way"

-- Popups
L["JOINED_GROUP"] = "You've joined or are joining a group while Auto Share Quests is enabled.\n\n" ..
"Would you like to disable this feature now? (No reload necessary!)"
L["NEW_CHARACTER_TEXT"] = "Character configuration completed for |c%s%s|r. Would you like to reload now?\n\n" ..
"|cffFF474CNOTE|r: This is recommended to guarantee the settings are saved server side."
L["NEW_CHARACTER_WIPED"] = "The unique identifier for this character has been wiped. Would you like to reload now?"
L["USE_CTRLC_TO_COPY_THE_LINK_BELOW"] = "Use Ctrl+C to copy the link below."

-- Button Labels & Tooltips
L["DISCORD"] = "Discord"
L["DONATE"] = "Donate"
L["IMPORT"] = "Import"
L["IMPORT_TOOLTIP"] = "Quickly import gossips in the Player Gossips table from the HelpMePlay addon.\n\n" ..
"|cffFF474CNOTE:|r This will WIPE the gossips from HelpMePlay. This action is irreversible!"
L["NEW_CHARACTER_BUTTON_TOOLTIP"] = "Click to configure new character settings for |c%s%s|r."

L["AUTO_SHARE_QUESTS"] = "Auto Share Quests"
L["AUTO_SHARE_QUESTS_TOOLTIP"] = "Automatically share quests with your party when you accept them."

L["ACCEPT_QUESTS"] = "Accept Quests"
L["ACCEPT_QUESTS_TOOLTIP"] = "Streamline your gameplay by automatically accepting most available quests from NPCs."

L["ALWAYS_COMPARE_ITEMS"] = "Always Compare Items"
L["ALWAYS_COMPARE_ITEMS_TOOLTIP"] = "Force displays the comparison tooltip when you hover over other items, allowing you to easily compare attributes and stats."

L["ALWAYS_SHOW_ACTION_BARS"] = "Always Show Action Bars"
L["ALWAYS_SHOW_ACTION_BARS_TOOLTIP"] = "Keeps action bars visible at all times."

L["ARACHNOPHOBIA_MODE"] = "Arachnophobia Mode"
L["ARACHNOPHOBIA_MODE_TOOLTIP"] = "Replaces arachnid creature models with crabs to provide a more comfortable experience for players with arachnophobia."

L["ASSISTED_COMBAT_HIGHLIGHT"] = "Assisted Combat Highlight"
L["ASSISTED_COMBAT_HIGHLIGHT_TOOLTIP"] = "Guides your rotation by highlighting the optimal next ability to use."

L["AUTO_DISMOUNT_FLYING"] = "Auto Dismount Flying"
L["AUTO_DISMOUNT_FLYING_TOOLTIP"] = "If enabled, automatically dismounts your character when casting spells or abilities while flying."

L["AUTO_INTERACT"] = "Auto Interact"
L["AUTO_INTERACT_TOOLTIP"] = "Automatically moves your character into range when interacting with NPCs or objects."

L["AUTO_LOOT"] = "Auto Loot"
L["AUTO_LOOT_TOOLTIP"] = "Automatically collects loot from defeated enemies or opened containers."

L["AUTO_PUSH_SPELLS_TO_ACTION_BAR"] = "Auto Push Spells To Action Bar"
L["AUTO_PUSH_SPELLS_TO_ACTION_BAR_TOOLIP"] = "Automatically adds newly learned spells to your action bar when you level up."

L["AUTO_REPAIR"] = "Auto Repair"
L["AUTO_REPAIR_TOOLTIP"] = "Keep your gear in top shape by auto-repairing at vendors, as long as the repair cost is under 33% of your current gold."

L["AUTO_TRAIN"] = "Auto Train"
L["AUTO_TRAIN_TOOLTIP"] = "Effortlessly learn new skills by automatically training all available spells at trainers—limited to affordable costs (up to 33% of your gold)."

L["BUY_QUEST_ITEMS"] = "Buy Quest Items"
L["BUY_QUEST_ITEMS_TOOLTIP"] = "Never forget a quest item again! Purchases required quest items from vendors automatically."

L["CHROMIE_TIME"] = "Chromie Time"
L["CHROMIE_TIME_TOOLTIP"] = "Automatically choose and activate your preferred Chromie Time expansion when interacting with them."

L["CLEAR_ALL_TRACKING"] = "Clear All Tracking"
L["CLEAR_ALL_TRACKING_TOOLTIP"] = "Automatically removes all active tracking options from the minimap."

L["COMPLETE_QUESTS"] = "Complete Quests"
L["COMPLETE_QUESTS_TOOLTIP"] = "Finish quests with automatic turn-ins and selecting rewards."

L["CONFIGURE_NEW_CHARACTER"] = "Configure New Character"
L["CONFIGURE_NEW_CHARACTER_TOOLTIP"] = "Quickly configure new characters with a click of a button! Check this box, then opt into any settings under the New Character section below."

L["COOLDOWN_VIEWER"] = "Cooldown Viewer"
L["COOLDOWN_VIEWER_TOOLTIP"] = "Displays a visual tracker on your screen for ability cooldowns."

L["DISABLE_FOOTSTEP_SOUNDS"] = "Disable Footstep Sounds"
L["DISABLE_FOOTSTEP_SOUNDS_TOOLTIP"] = "Enables or disables footstep sounds."

L["DISABLE_SKYRIDING_FULL_SCREEN_EFFECTS"] = "Disable Skyriding Full Screen Effects"
L["DISABLE_SKYRIDING_FULL_SCREEN_EFFECTS_TOOLTIP"] = "Disables full screen visual effects while skyriding for a clearer view and reduced visual distractions."

L["DISABLE_SKYRIDING_VELOCITY_VFX"] = "Disable Skyriding Velocity VFX"
L["DISABLE_SKYRIDING_VELOCITY_VFX_TOOLTIP"] = "Disables velocity visual effects while skyriding to reduce motion sickness and provide a more comfortable experience."

L["DISABLE_USER_ADDONS_BY_DEFAULT"] = "Disable User Addons By Default"
L["DISABLE_USER_ADDONS_BY_DEFAULT_TOOLTIP"] = "Prevents newly installed addons from being enabled automatically."

L["EDIT_MODE_LAYOUT"] = "Edit Mode Layout"
L["EDIT_MODE_LAYOUT_TOOLTIP"] = "Choose and apply your preferred Edit Mode layout."

L["ENABLE_FLOATING_COMBAT_TEXT"] = "Enable Floating Combat Text"
L["ENABLE_FLOATING_COMBAT_TEXT_TOOLTIP"] = "Enables or disables floating combat text for damage, healing, and other events during combat."

L["GOSSIP"] = "Gossip"
L["GOSSIP_TOOLTIP"] = "Interact with supported NPCs efficiently by instantly selecting gossip options."

L["LOOT_UNDER_MOUSE"] = "Loot Under Mouse"
L["LOOT_UNDER_MOUSE_TOOLTIP"] = "Displays the loot window beneath your mouse cursor."

L["MOUNT_JOURNAL_SHOW_PLAYER"] = "Mount Journal Show Player"
L["MOUNT_JOURNAL_SHOW_PLAYER_TOOLTIP"] = "Automatically displays your character model riding mounts in the Mount Journal preview."

L["NEW_CHARACTER"] = "New Character"
L["NEW_CHARACTER_TOOLTIP"] = "Tired of configuring specific settings for every new character? Toggle this feature and opt into settings under the New Character Module section below."

L["OCCLUDED_SILHOUETTE_PLAYER"] = "Occluded Silhouette Player"
L["OCCLUDED_SILHOUETTE_PLAYER_TOOLTIP"] = "Displays your character's silhouette when view is blocked by objects, such as trees, for improved tracking."

L["OPEN_GOSSIPS"] = "Open Gossips"

L["PLAYER_TALENTS"] = "Player Talents"
L["PLAYER_TALENTS_TOOLTIP"] = "Quickly learn new talents at the click of a button!"

L["PROFANITY_FILTER"] = "Profanity Filter"
L["PROFANITY_FILTER_TOOLTIP"] = "Enables the in-game profanity filter to block offensive language in chat."

L["PVP_FRAMES_DISPLAY_CLASS_COLOR"] = "PvP Frames Display Class Color"
L["PVP_FRAMES_DISPLAY_CLASS_COLOR_TOOLTIP"] = "Displays player class colors on PvP frames for easier identification of opponents and teammates."

L["QUEST_REWARDS"] = "Quest Rewards"
L["QUEST_REWARDS_TOOLTIP"] = "Automatically selects the best quest reward—prioritizing item level, sell price, or choosing randomly if needed."

L["QUEST_TEXT_CONTRAST"] = "Quest Text Contrast"
L["QUEST_TEXT_CONTRAST_TOOLTIP"] = "Enable to enhance the contrast of the quest giver interface for improved readability and accessibility."

L["RAID_FRAMES_DISPLAY_CLASS_COLOR"] = "Raid Frames Display Class Color"
L["RAID_FRAMES_DISPLAY_CLASS_COLOR_TOOLTIP"] = "Displays player class colors on raid frames for easier identification of group members."

L["RARES"] = "Rares"
L["RARES_TOOLTIP"] = "Control rare spawn notifications—toggle announcements for rare NPCs on or off."

L["REPLACE_MY_PLAYER_PORTRAIT"] = "Replace My Player Portrait"
L["REPLACE_MY_PLAYER_PORTRAIT_TOOLTIP"] = "Replaces your character's portrait with your class icon."

L["REPLACE_OTHER_PLAYER_PORTRAITS"] = "Replace Other Player Portraits"
L["REPLACE_OTHER_PLAYER_PORTRAITS_TOOLTIP"] = "Replaces the portraits of other players with their class icon."

L["SHOW_SCRIPT_ERRORS"] = "Show Script Errors"
L["SHOW_SCRIPT_ERRORS_TOOLTIP"] = "Displays Lua script errors as they occur to help identify and troubleshoot addon or interface issues."

L["SHOW_TARGET_OF_TARGET"] = "Show Target of Target"
L["SHOW_TARGET_OF_TARGET_TOOLTIP"] = "Shows the target of your current target for improved situational awareness."

L["SHOW_TUTORIALS"] = "Show Tutorials"
L["SHOW_TUTORIALS_TOOLTIP"] = "Displays tutorial popups to guide you through gameplay and features."

L["SKIP_CINEMATICS"] = "Skip Cinematics"
L["SKIP_CINEMATICS_TOOLTIP"] = "Enjoy uninterrupted gameplay by skipping in-game cinematics and movies automatically."

L["SOFT_TARGET_ENEMY"] = "Soft Target Enemy"
L["SOFT_TARGET_ENEMY_TOOLTIP"] = "Highlights or selects enemies you're looking at without requiring a hard target, enabling quick interaction or awareness."

L["SPELLBOOK_HIDE_PASSIVES"] = "Spellbook Hide Passives"
L["SPELLBOOK_HIDE_PASSIVES_TOOLTIP"] = "Hides passive spells in your spellbook for a clearer view of active abilities."

L["WARBAND_MAP"] = "Warband Map"
L["WARBAND_MAP_TOOLTIP"] = "Allows you to quickly cast |cnIQ3:|Hitem:212174::::::::71:104:::::::::|h[The Warband Map to Everywhere All At Once]|h|r spell, quickly revealing the map for every zone you've explored with your warband."

L["WIPE_CHARACTER"] = "Wipe Character"
L["WIPE_CHARACTER_TOOLTIP"] = "Removes the current character from the list of known characters. Doing this will allow you to rerun the New Character configuration for the current character."