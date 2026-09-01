--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##        ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##        ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######    ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##        ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##        ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    config/codes.lua
@author  Finn
@company FinnLocked
@date    01-09-2026
@license MIT

]]

Code = {}

Code.Error = {
    ER0001 = "Could not load language file. Make sure you didn't make a type.",
    ER0002 = "Could not load config file. Make sure you didn't make a typo.",
    ER0003 = "Could not load webhooks file. Make sure you didn't make a typo.",
    ER0004 = "Could not find %s. Please make sure it is running.",
    ER0005 = "Webhook for the screenshots needs to be defined in the config/webhooks.lua file.",
    ER0006 = "Language setting not found for %s. Please make sure it exists in your locals/%s.lua",
    ER0007 = "No webhook channel found in config/webhooks.lua for channel %s",
    ER0008 = "You need to set a steam api key in your server.cfg for the steam identifiers to work!.",
    ER0009 = "Possible invalid webhook for %s webhook. Status code: %s",
    ER0010 = "Language setting not found for %s. Please make sure it exists in your locals/%s.lua - Client Side",
    ER0011 = "No player ID (source) provided. Expected a valid player server ID.",
    ER0012 = "Invalid player ID: %s. Player does not exist or has disconnected.",
    ER0013 = "Function called with nil arguments: %s",
    ER0014 = "Missing required argument '%s' in event/data for %s.",
    ER0015 = "Unexpected data type for '%s': expected %s, got %s.",
    ER0016 = "Config value '%s' is missing or nil.",
    ER0017 = "Webhook payload for '%s' failed to send: %s",
    ER0018 = "Failed to decode JSON for '%s'. Error: %s",
    ER0019 = "Failed to encode JSON for '%s'. Error: %s",
    ER0020 = "Attempted to use nil language table for '%s' in locals/%s.lua",
    ER0021 = "Event '%s' triggered from client with invalid or missing source.",
    ER0022 = "Resource '%s' tried to call createLog but provided invalid data: %s",
    ER0023 = "Steam identifier missing for player %s (name: %s).",
    ER0024 = "Discord identifier missing for player %s (name: %s).",
    ER0025 = "Name change detection failed: names.json could not be loaded or parsed.",
    ER0026 = "Drop reason index out of range: %s (max %s).",
    ER0027 = "Explosion type index out of range: %s (max %s).",
    ER0028 = "Weapon log event received with nil weapon or count from player %s.",
    ER0029 = "Client upload event received with nil or invalid args from player %s.",
    ER0030 = "Unhandled event type in PlayerDied: type=%s from player %s.",
    ER0031 = "Failed to load ClientTables: %s.",
    ER0032 = "Weapon hash %s not found in ClientTables.WeaponNames.",
    ER0033 = "Death cause hash %s not found in ClientTables.deatCause.",
    ER0034 = "Screenshot upload failed: %s.",
    ER0035 = "Invalid or missing URL for screenshot upload.",
}

Code.Debug = {
    DB0001 = "Export Triggered from %s started",
    DB0002 = "Export Triggered from %s success",
    DB0003 = "playerConnecting Triggered by %s",
    DB0004 = "playerJoined Triggered by %s",
    DB0005 = "PlayerDropped Triggered by %s",
    DB0006 = "New Create Log incomming with details: %s",
    DB0007 = "playerConnecting deferred for %s (src: %s)",
    DB0008 = "playerJoining processed for %s (src: %s, oldID: %s)",
    DB0009 = "Name change detected for SteamID %s: '%s' -> '%s'",
    DB0010 = "No name change for SteamID %s (same name: '%s')",
    DB0011 = "Chat message logged from %s (src: %s): '%s'",
    DB0012 = "Explosion event logged: type=%s by %s (src: %s)",
    DB0013 = "PlayerDied event processed: type=%s, victim=%s (src: %s)",
    DB0014 = "Weapon shot event logged: %s x%s by %s (src: %s)",
    DB0015 = "Resource event logged: %s for resource '%s'",
    DB0016 = "ClientUpload event received from %s (src: %s)",
    DB0017 = "createLog called via export from resource '%s'",
    DB0018 = "Validation passed for player %s (src: %s)",
    DB0019 = "Validation failed for player %s (src: %s): %s",
    DB0020 = "Config.Debug enabled - verbose logging active",
    DB0021 = "DeathCause resolved: hash=%s, category=%s, weapon=%s (ped: %s)",
    DB0022 = "Weapon hash %s resolved to name '%s' for shooting event.",
    DB0023 = "Screenshot upload requested for URL: %s",
    DB0024 = "Screenshot upload response processed: hasAttachment=%s, url=%s",
    DB0025 = "ClientTables loaded successfully.",
}