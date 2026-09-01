--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##        ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##        ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######    ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##        ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##        ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    config/webhooks.lua
@author  Finn
@company FinnLocked
@date    01-09-2026
@license MIT

]]

Discord = {}
Discord.Channels = {
    Screenshot = {
        Webhook = "DISCORD_WEBHOOK"
    },
    Chat = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "💬",
        Color = "#A1A1A1",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        },
        Screenshot = true
    },
    Connect = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "📥",
        Color = "#3AF241",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        }
    },
    Join = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "📥",
        Color = "#3AF241",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        }
    },
    Leave = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "📤",
        Color = "#F23A3A",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        }
    },
    Death = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "☠️",
        Color = "#000000",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        },
        Screenshot = true
    },
    Shooting = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "🔫",
        Color = "#2E66F2",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        },
        Screenshot = true
    },
    Resource = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "📁",
        Color = "#EBEE3F",
        Embed = true,
        Inline = true,
        Timestamp = true
    },
    Explosion = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "💣",
        Color = "#03FC98",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        },
        Screenshot = true
    },
    NameChange = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "⚠️",
        Color = "#03FC98",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        }
    },
    ExampleExportChannel = {
        Webhook = "DISCORD_WEBHOOK",
        Icon = "🆕",
        Color = "#008080",
        Embed = true,
        Inline = true,
        Timestamp = true,
        Details = {
            PlayerID = true,
            SteamID = true,
            SteamURL = true,
            Postal = true,
            DiscordID = true,
            License = true,
            License2 = true,
            IP = true,
            Ping = true,
            Health = true,
            Armor = true
        },
        Screenshot = true
    }
}