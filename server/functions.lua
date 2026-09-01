--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##        ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##        ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######    ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##        ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##        ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    server/functions.lua
@author  Finn
@company FinnLocked
@date    01-09-2026
@license MIT

]]

ServerFunc = {}

local langFile = LoadResourceFile(GetCurrentResourceName(), "./locals/" .. Config.Local .. ".json")
local lang = json.decode(langFile)


ServerFunc.DebugLog = function(x, args)
    if Code.Debug[x] == nil then
        print("^5[SilentWatcher] ^3Code: DB0000 - Debug log was triggered without a message avalible.^0")
        return
    end
    if args and #args > 0 then
        print("^5[SilentWatcher] ^3Code: " .. x .. " - " .. Code.Debug[x]:format(table.unpack(args)) .. "^0")
        return
    end
    print("^5[SilentWatcher] ^3Code: " .. x .. " - " .. Code.Debug[x] .. "^0")
end


ServerFunc.ErrorLog = function(x, args)
    if Code.Error[x] == nil then
        print("^5[SilentWatcher] ^1Code: ER0000 - Error log was triggered without a message avalible.^0")
        return
    end
    if args and #args > 0 then
        print("^5[SilentWatcher] ^1Code: " .. x .. " - " .. Code.Error[x]:format(table.unpack(args)) .. "^0")
        return
    end
    print("^5[SilentWatcher] ^1Code: " .. x .. " - " .. Code.Error[x] .. "^0")
end


if lang == nil then
    ServerFunc.ErrorLog("ER0001")
    return StopResource(GetCurrentResourceName())
end


ServerFunc.Lang = function(x, y, args)
    if not lang[x] then
        ServerFunc.ErrorLog("ER0020", {x, Config.Local})
        return y
    end
    if lang[x][y] == nil then 
        ServerFunc.ErrorLog("ER0006", {y, Config.Local})
        return y
    end
    if args and #args > 0 then
        return lang[x][y]:format(table.unpack(args))
    end
    return lang[x][y]
end


function ConvertColor(channel)
    if Discord.Channels[channel] then
        local src = Discord.Channels[channel].Color
        if string.find(src,"#") then
            return tonumber(src:gsub("#",""),16)
        else
            return src
        end
    else
        ServerFunc.ErrorLog("ER0007", {channel})
        return 000000
    end
end


function FirstToUpper(str)
    return (str:gsub("^%l", string.upper))
end


function GetTitle(channel, icon)
    if icon then
        return icon .. " " .. FirstToUpper(channel)
    else
        return "❓ " .. FirstToUpper(channel)
    end
end


ServerFunc.ExtractIdentifiers = function(src)
    local identifiers = {}

    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        ServerFunc.ErrorLog("ER0021", {"ExtractIdentifiers"})
        return identifiers
    end

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam:") then
            identifiers["steam"] = id
        elseif string.find(id, "ip:") then
            identifiers["ip"] = id
        elseif string.find(id, "discord:") then
            identifiers["discord"] = id
        elseif string.find(id, "license:") then
            identifiers["license"] = id
        elseif string.find(id, "license2:") then
            identifiers["license2"] = id
        elseif string.find(id, "xbl:") then
            identifiers["xbl"] = id
        elseif string.find(id, "live:") then
            identifiers["live"] = id
        elseif string.find(id, "fivem:") then
            identifiers["fivem"] = id
        end
    end

    return identifiers
end


function GetPlayerLocation(src)
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        return "UNKNOWN"
    end

    local postalFile = LoadResourceFile(GetCurrentResourceName(), "./json/postals.json")
    local postal = json.decode(postalFile)

    if not postal then
        ServerFunc.ErrorLog("ER0018", {"postals.json", "decode failed or file empty"})
        return "UNKNOWN"
    end

    local nearest = nil

    local player = src
    local ped = GetPlayerPed(player)
    if not ped or ped == 0 then
        ServerFunc.ErrorLog("ER0013", {"ped for GetPlayerLocation"})
        return "UNKNOWN"
    end

    local playerCoords = GetEntityCoords(ped)
    local x, y = table.unpack(playerCoords)

    local ndm = -1
    local ni = -1
    for i, p in ipairs(postal) do
        local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
        if ndm == -1 or dm < ndm then
            ni = i
            ndm = dm
        end
    end

    local nearest = {}
    if ni ~= -1 then
        local nd = math.sqrt(ndm)
        nearest = {i = ni, d = nd}
    end
    local _nearest = postal[nearest.i].code
    return _nearest
end


function GetPlayerDetails(src, channel)
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        return "N/A"
    end

    local check = {"PlayerID", "SteamID", "SteamURL", "Postal", "DiscordID", "License", "License2", "IP", "PlayTime", "Ping", "Health", "Armor"}
    if not Discord.Channels[channel] then 
        ServerFunc.ErrorLog("ER0007", {channel})
        return "N/A" 
    end

    if Discord.Channels[channel].Details then
        Discord.Channels[channel].Details = {}
        for k,v in pairs(check) do
            Discord.Channels[channel].Details[v] = true
        end
    else
        for k,v in pairs(check) do
            if Discord.Channels[channel].Details[v] then
                Discord.Channels[channel].Details[v] = true
            end
        end
    end

    local ids = ServerFunc.ExtractIdentifiers(src)

    if Config.Details.Postal and Discord.Channels[channel].Details.Postal then
        postal = GetPlayerLocation(src)
        _postal = "\n> **Nearest Postal:** `".. postal .."`"
    else
        _postal = ""
    end

    if Config.Details.DiscordID and Discord.Channels[channel].Details.DiscordID then
        if ids.discord then
            _discordID ="\n> **Discord ID:** <@" ..ids.discord:gsub("discord:", "").."> (||"..ids.discord:gsub("discord:", "").."||)"
        else
            _discordID = "\n> **Discord ID:** N/A"
        end
    else
        _discordID = ""
    end

    if GetConvar("steam_webApiKey", "false") ~= "false" then
        if Config.Details.SteamID and Discord.Channels[channel].Details.SteamID then
            if ids.steam then
                _steamID ="\n> **Steam ID:** ||" ..ids.steam.."||"
            else
                _steamID = "\n> **Steam ID:** N/A"
                ServerFunc.ErrorLog("ER0023", {src, GetPlayerName(src) or "Unknown"})
            end
        else
            _steamID = ""
        end

        if Config.Details.SteamURL and Discord.Channels[channel].Details.SteamURL then
            if ids.steam then
                _steamURL ="\n> [Steam Profile Link](https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16)..")"
            else
                _steamURL = "\n> **Steam URL:** N/A"
                ServerFunc.ErrorLog("ER0023", {src, GetPlayerName(src) or "Unknown"})
            end
        else
            _steamURL = ""
        end
    else
        _steamID = ""
        _steamURL = ""
        ServerFunc.ErrorLog("ER0008")
    end

    if Config.Details.License and Discord.Channels[channel].Details.License then
        if ids.license then
            _license ="\n> **License:** ||" ..ids.license.. "||"
        else
            _license = "\n> **License:** N/A"
        end
    else
        _license = ""
    end

    if Config.Details.License2 and Discord.Channels[channel].Details.License2 then
        if ids.license2 then
            _license2 ="\n> **License2:** ||" ..ids.license2.. "||"
        else
            _license2 = "\n> **License2:** N/A"
        end
    else
        _license2 = ""
    end

    if Config.Details.IP and Discord.Channels[channel].Details.IP then
        if ids.ip then
            _ip = "\n> **IP:** ||" .. ids.ip:gsub("ip:", "") .. "||"
        else
            _ip = "\n> **IP:** N/A "
        end
    else
        _ip = ""
    end

    if Config.Details.PlayerID and Discord.Channels[channel].Details.PlayerID then
        if channel ~= "Join" then
            _playerID ="\n> **Player ID:** `" ..src.."`"
        else
            _playerID = "\n> **Player ID:** N/A"
        end
    else
        _playerID = ""
    end

    if Config.Details.Ping and Discord.Channels[channel].Details.Ping then
        _ping = "\n> **Ping:** `"..GetPlayerPing(src).."ms`"
    else
        _ping = ""
    end

    if Config.Details.Health or Config.Details.Armor then
        _hp = "\n"
        local playerPed = GetPlayerPed(src)
        if not playerPed or playerPed == 0 then
            ServerFunc.ErrorLog("ER0013", {"playerPed for Health/Armor"})
            _hp = ""
        else
            if Config.Details.Health and Discord.Channels[channel].Details.Health then
                local maxHealthRaw = GetEntityMaxHealth(playerPed)
                local healthRaw = GetEntityHealth(playerPed)
                local health = maxHealthRaw > 0 and math.floor((healthRaw / maxHealthRaw) * 100 + 0.5) or 0
                _hp = _hp.."> **Health:** ❤️: `"..health.."/100`"
            end
            if Config.Details.Armor and Discord.Channels[channel].Details.Armor then
                if Config.Details.Health then
                    _hp = _hp.." **|** "
                else 
                    _hp = _hp.."> "
                end
                local armour = GetPedArmour(playerPed)
                _hp = _hp.."**Armor:** 🛡️: `"..armour.."/100`"
            end
        end
    else
        _hp = ""
    end

    return _playerID.._postal.._hp.._discordID.._steamID.._steamURL.._license.._license2.._ip
end


function GetStatus(status, channel)
    if status == 404 or status == 401 then
        if Discord.Channels[channel] and Discord.Channels[channel].Webhook ~= "DISCORD_WEBHOOK" and Discord.Channels[channel].Webhook ~= "" then
            ServerFunc.ErrorLog("ER0009", {channel, status})
        else
            ServerFunc.ErrorLog("ER0017", {channel, "HTTP " .. tostring(status)})
        end
    end
end


local webhookQueue = {}
local flushTimers = {}


local function sendBatch(channel, batch)
    if not Discord.Channels[channel] then
        ServerFunc.ErrorLog("ER0007", {channel})
        return
    end

    local combined = {
        username = Config.BotDetails.Username,
        avatar_url = Config.BotDetails.Avatar,
        embeds = {}
    }

    for _, load in ipairs(batch) do
        local msg = load.messageToDeliver
        if msg.embeds and type(msg.embeds) == "table" then
            for _, e in ipairs(msg.embeds) do
                table.insert(combined.embeds, e)
            end
        else
            if #combined.embeds == 0 and msg.content then
                combined.content = msg.content
            end
        end
    end

    if #combined.embeds == 0 and not combined.content then
        return
    end

    local body, encodeErr = json.encode(combined)
    if not body then
        ServerFunc.ErrorLog("ER0019", {"webhook batch for channel " .. channel, encodeErr or "unknown"})
        return
    end

    PerformHttpRequest(Discord.Channels[channel].Webhook, function(err, text, headers)
        GetStatus(err, channel)
    end, "POST", body, {
        ["Content-Type"] = "application/json"
    })
end


local function flushChannel(channel)
    local queue = webhookQueue[channel]
    if not queue or #queue == 0 then
        flushTimers[channel] = nil
        return
    end

    local batch = {}
    for i = 1, math.min(10, #queue) do
        batch[i] = table.remove(queue, 1)
    end

    sendBatch(channel, batch)

    flushTimers[channel] = nil
    if #queue > 0 then
        ensureFlushTimer(channel)
    end
end


local function ensureFlushTimer(channel)
    if flushTimers[channel] then return end
    flushTimers[channel] = Citizen.SetTimeout(5000, function()
        flushChannel(channel)
    end)
end


SendWebhook = function(load)
    if not Discord.Channels[load.channel] then
        ServerFunc.ErrorLog("ER0007", {load.channel})
        return
    end

    if not webhookQueue[load.channel] then
        webhookQueue[load.channel] = {}
    end

    table.insert(webhookQueue[load.channel], load)

    if #webhookQueue[load.channel] >= 10 then
        if flushTimers[load.channel] then
            Citizen.ClearTimeout(flushTimers[load.channel])
            flushTimers[load.channel] = nil
        end
        flushChannel(load.channel)
        return
    end
    ensureFlushTimer(load.channel)
end


ServerFunc.CreateLog = function(args)
    if not args then
        ServerFunc.ErrorLog("ER0013", {"args in CreateLog"})
        return
    end

    if type(args) ~= "table" then
        ServerFunc.ErrorLog("ER0015", {"args in CreateLog", "table", type(args)})
        return
    end

    if Config.Debug then
        ServerFunc.DebugLog("DB0006", {
            args.Channel .. ", " .. (args.EmbedMessage or "") .. ", " .. tostring(args.PlayerID or "")
        })
    end

    if not args.Channel then
        ServerFunc.ErrorLog("ER0014", {"Channel", "CreateLog"})
        return
    end

    if Discord.Channels[args.Channel] == nil then
        ServerFunc.ErrorLog("ER0007", {args.Channel})
        return
    end

    if not args.EmbedMessage then
        ServerFunc.ErrorLog("ER0014", {"EmbedMessage", "CreateLog for channel " .. args.Channel})
    end

    if not Discord.Channels[args.Channel].Embed then
        local content = {
            username = Config.BotDetails.Username,
            content = args.EmbedMessage,
            avatar_url = Config.BotDetails.Avatar
        }
        SendWebhook({
            messageToDeliver = content,
            ip = args.ip,
            channel = args.Channel
        })
        return
    end

    local message = {
        username = Config.BotDetails.Username or "SilentWatcher",
        avatar_url = Config.BotDetails.Avatar or "https://finnlocked.com/assets/img/finnlocked.png",
        embeds = {{
            color = ConvertColor(args.Channel),
            author = {
                name = ("SilentWatcher | " .. Config.BotDetails.CommunityName) or "SilentWacther",
                icon_url = Config.BotDetails.CommunityIcon or "https://finnlocked.com/assets/img/finnlocked.png"
            },
            title = GetTitle(args.Channel, Discord.Channels[args.Channel].Icon),
            description = "```" .. args.EmbedMessage .. "```",
            footer = {
                text = Config.BotDetails.FooterText .. " • SilentWatcher by FinnLocked.com",
                icon_url = "https://finnlocked.com/assets/img/finnlocked.png"
            },
            fields = {}
        }}
    }

    if args.resource then
        message.embeds[1].description = message.embeds[1].description .. "\n`Export: " .. args.resource.."`"
    end

    if Discord.Channels[args.Channel].Screenshot then
        if GetResourceState(Config.Screencapture) ~= "started" then
            ServerFunc.ErrorLog("ER0004", {Config.Screencapture or "screencapture resource"})
            return
        end

        if args.PlayerID and GetPlayerName(args.PlayerID) then
            local PlayerDetails = GetPlayerDetails(args.PlayerID, args.Channel)
            table.insert(message.embeds[1].fields, {
                name = "Player Details: " .. GetPlayerName(args.PlayerID),
                value = PlayerDetails,
                inline = Discord.Channels[args.Channel].Inline
            })
        end

        if args.PlayerID_2 and GetPlayerName(args.PlayerID_2) then
            local PlayerDetails = GetPlayerDetails(args.PlayerID_2, args.Channel)
            table.insert(message.embeds[1].fields, {
                name = "Player Details: " .. GetPlayerName(args.PlayerID_2),
                value = PlayerDetails,
                inline = Discord.Channels[args.Channel].Inline
            })
        end

        if Discord.Channels[args.Channel].Timestamp then
            table.insert(message.embeds[1].fields, {
                name = "Timestamp:",
                value = "<t:" .. os.time() .. ":R>",
                inline = false
            })
        end

        if not Discord.Channels.Screenshot or not Discord.Channels.Screenshot.Webhook then
            ServerFunc.ErrorLog("ER0005")
            return
        end

        exports[Config.Screencapture]:remoteUpload(
            args.PlayerID,
            Discord.Channels.Screenshot.Webhook,
            {},
            function(resp)
                if resp and resp.attachments and resp.attachments[1] then
                    message.embeds[1].image = { url = resp.attachments[1].proxy_url }
                end
                SendWebhook({
                    messageToDeliver = message,
                    ip = args.ip,
                    channel = args.Channel
                })
            end,
            'blob'
        )
        return
    end


    if args.PlayerID and GetPlayerName(args.PlayerID) then
        local PlayerDetails = GetPlayerDetails(args.PlayerID, args.Channel)
        table.insert(message.embeds[1].fields, {
            name = "Player Details: " .. GetPlayerName(args.PlayerID),
            value = PlayerDetails,
            inline = Discord.Channels[args.Channel].Inline
        })
    end

    if args.PlayerID_2 and GetPlayerName(args.PlayerID_2) then
        local PlayerDetails = GetPlayerDetails(args.PlayerID_2, args.Channel)
        table.insert(message.embeds[1].fields, {
            name = "Player Details: " .. GetPlayerName(args.PlayerID_2),
            value = PlayerDetails,
            inline = Discord.Channels[args.Channel].Inline
        })
    end

    if Discord.Channels[args.Channel].Timestamp then
        table.insert(message.embeds[1].fields, {
            name = "Timestamp:",
            value = "<t:" .. os.time() .. ":R>",
            inline = false
        })
    end

    SendWebhook({
        messageToDeliver = message,
        ip = args.ip,
        channel = args.Channel
    })
end