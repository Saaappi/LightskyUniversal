local LSU = select(2, ...)
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
L.LABEL_NEWCHARACTER_BUTTON = "Configure New Character"

-- Fontstrings
L.FONTSTRING_GOSSIP_LINE_COUNT_TEXT = "|cffFFFFFF%s|r line(s)"

-- Popups
L.POPUP_NEWCHARACTER_TEXT = "Character configuration completed. Would you like to reload now?\n\n" ..
"|cffFF474CNOTE|r: This is recommended to guarantee the settings are saved server side."

-- Frame titles
L.TITLE_GOSSIPS = "Gossips"

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

LSU.L = L