--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##       ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######   ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##       ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##       ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##      #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    config/config.lua
@author  Finn
@company FinnLocked
@date    01-09-2026
@license MIT

]]

Config = {}

Config.Local = "en"         -- Language code used for any translated strings in this resource.
Config.Debug = false        -- Leave false on production servers to reduce console noise.
Config.ForceSteam = false   -- When true, players without a valid Steam identifier are kicked / not allowed to join.

Config.NameChange = {
    Status = true,                          -- Enable/disable real-time name change tracking and notifications.
    AcePermission = "FinnLocked.NameChange" -- ACE permission required to see name-change logs in server chat.
}

Config.Screencapture = "screencapture" -- Resource name that provides screenshot functionality. Must match the actual resource name on your server. (https://github.com/itschip/screencapture)

Config.Details = {
    Postal = true,      -- Show player's nearest postal.
    PlayerID = true,    -- Show the server-assigned player ID (source).
    SteamID = true,     -- Show the player's Steam ID.
    SteamURL = true,    -- Show a clickable Steam profile URL.
    DiscordID = true,   -- Show the player's Discord ID if linked.
    License = true,     -- Show the primary Rockstar license identifier.
    License2 = true,    -- Show the secondary license identifier (if present).
    IP = false,         -- Show the player's IP address (be mindful of privacy laws (false by default)).
    Ping = true,        -- Show current player ping/latency.
    Health = true,      -- Show current health value.
    Armor = true        -- Show current armor value.
}


Config.BotDetails = {
    Username = "SilentWatcher",                                         -- Name shown as the sender in Discord.
    Avatar = "https://finnlocked.com/assets/img/finnlocked.png",        -- Profile picture URL for the bot.
    FooterText = "SilentWatcher",                                       -- Text shown in the embed footer.
    CommunityName = "FinnLocked",                                       -- Name of your community/server shown in embeds.
    CommunityIcon = "https://finnlocked.com/assets/img/finnlocked.png"  -- Icon shown next to community name.
}

Config.WeaponLog = true -- When true, weapon usage (shots) is logged by this resource.

Config.WeaponsNotLogged = { -- List of weapon hashes/names that should NOT be logged. (Useful to ignore spammy or irrelevant weapons (toys, utility items, etc.)).
    "WEAPON_SNOWBALL",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PETROLCAN"
}