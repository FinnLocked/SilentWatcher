--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##        ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##        ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######    ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##        ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##        ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    server/main.lua
@author  Finn
@company FinnLocked
@date    01-09-2026
@license MIT

]]

if Config == nil then
    ServerFunc.ErrorLog("ER0002")
    return StopResource(GetCurrentResourceName())
end


if Discord == nil then
    ServerFunc.ErrorLog("ER0003")
    return StopResource(GetCurrentResourceName())
end


if Config.Debug then
    RegisterNetEvent("FinnLocked:SilentWatcher:Debug")
    AddEventHandler("FinnLocked:SilentWatcher:Debug", ServerFunc.DebugLog)
    ServerFunc.DebugLog("DB0020")
end


RegisterNetEvent("FinnLocked:SilentWatcher:Error")
AddEventHandler("FinnLocked:SilentWatcher:Error", ServerFunc.ErrorLog)


RegisterNetEvent("FinnLocked:SilentWatcher:ClientExportLog")
AddEventHandler("FinnLocked:SilentWatcher:ClientExportLog", function(args)
    if not args then
        ServerFunc.ErrorLog("ER0013", {"args in ClientExportLog"})
        return
    end
    ServerFunc.CreateLog(args)
end)


exports("createLog", function(args)
    if not args then
        ServerFunc.ErrorLog("ER0013", {"args in createLog export"})
        return
    end
    if type(args) ~= "table" then
        ServerFunc.ErrorLog("ER0015", {"args in createLog export", "table", type(args)})
        return
    end
    args.resource = GetInvokingResource()
    ServerFunc.CreateLog(args)
end)


AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local src = source
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        ServerFunc.ErrorLog("ER0021", {"playerConnecting"})
        return
    end

    ServerFunc.CreateLog({
        EmbedMessage = ServerFunc.Lang("DefaultLogs", "PlayerConnecting", {GetPlayerName(src)}),
        PlayerID = src,
        Channel = "Connect"
    })
    if Config.Debug then
        ServerFunc.DebugLog("DB0003", {GetPlayerName(src)})
    end
end)


AddEventHandler("playerJoining", function(_source, oldID)
    local src = source
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        ServerFunc.ErrorLog("ER0021", {"playerJoining"})
        return
    end

    if Config.Debug then
        ServerFunc.DebugLog("DB0008", {GetPlayerName(src), src, oldID})
    end

    ServerFunc.CreateLog({
        Channel = "Join",
        EmbedMessage = ServerFunc.Lang("DefaultLogs", "PlayerJoining", {GetPlayerName(src)}),
        PlayerID = src
    })
    if Config.Debug then
        ServerFunc.DebugLog("DB0004", {GetPlayerName(src)})
    end


    if Config.NameChange.Status then
        local namesFile = LoadResourceFile(GetCurrentResourceName(), "./json/names.json")
        local names = json.decode(namesFile)

        if not names then
            ServerFunc.ErrorLog("ER0025")
            return
        end

        local steamid = ServerFunc.ExtractIdentifiers(src).steam
        if steamid then
            if names[steamid] ~= nil and names[steamid] ~= GetPlayerName(src) then
                if Config.Debug then
                    ServerFunc.DebugLog("DB0009", {steamid, names[steamid], GetPlayerName(src)})
                end

                for _, i in ipairs(GetPlayers()) do
                    if IsPlayerAceAllowed(i, Config.NameChange.AcePermission) then
                        TriggerClientEvent('chat:addMessage', i, {
                            template = '<div style="background-color: rgba(90, 90, 90, 0.9); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;"><b>{0}</b></div>',
                            args = { ServerFunc.Lang("Other", "NameChangeChat", {GetPlayerName(src), names[steamid]}) }
                        })
                    end
                end
                ServerFunc.CreateLog({
                    EmbedMessage = ServerFunc.Lang("Other", "NameChange", {GetPlayerName(src), {names[steamid]}}),
                    PlayerID = src,
                    Channel = "NameChange"
                })
            else
                if Config.Debug and names[steamid] then
                    ServerFunc.DebugLog("DB0010", {steamid, GetPlayerName(src)})
                end
            end
            names[steamid] = GetPlayerName(src)
            SaveResourceFile(GetCurrentResourceName(), "./json/names.json", json.encode(names), -1)
        else
            ServerFunc.ErrorLog("ER0023", {src, GetPlayerName(src)})

            if Config.ForceSteam then
                ServerFunc.CreateLog({
                    EmbedMessage = ServerFunc.Lang("Other", "ForceSteamLog", {GetPlayerName(src)}), 
                    PlayerID = src, 
                    Channel = 'NameChange'
                })
                DropPlayer(src, ServerFunc.Lang("Other", "ForceSteam") or "Please start steam and reconnect to the server.")
            else
                for _, i in ipairs(GetPlayers()) do
                    if IsPlayerAceAllowed(i, Config.NameChange.AcePermission) then
                        TriggerClientEvent('chat:addMessage', i, {
                            template = '<div style="background-color: rgba(90, 90, 90, 0.9); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;"><b>{0}</b></div>',
                            args = { ServerFunc.Lang("Other", "NoSteam", {GetPlayerName(src)}) }
                        })
                    end
                end
                ServerFunc.CreateLog({
                    EmbedMessage = ServerFunc.Lang("Other", "NoSteamLog", {GetPlayerName(src)}), 
                    PlayerID = src, 
                    Channel = 'NameChange'
                })
            end
        end
    end
end)


AddEventHandler("playerDropped", function(reason, resourceName, clientDropReason)
    local src = source
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        ServerFunc.ErrorLog("ER0021", {"playerDropped"})
        return
    end

    local DropReasons = {
        "Client-initiated disconnect",
        "Kicked by server.",
        "Lost connection. (More common as F8 disconnect)",
        "Error / crash on client side.",
        "Server shutdown / restart.",
        "Banned / rejected during connect.",
        "Duplicate connection",
        "Resource stop / unload causing disconnect."
    }

    local dropText = DropReasons[clientDropReason + 1]
    if not dropText then
        ServerFunc.ErrorLog("ER0026", {clientDropReason, #DropReasons - 1})
        dropText = "Unknown drop reason"
    end

    ServerFunc.CreateLog({
        EmbedMessage = ServerFunc.Lang("DefaultLogs", "PlayerDropped", {GetPlayerName(src), dropText}),
        PlayerID = src,
        Channel = "Leave"
    })
    if Config.Debug then
        ServerFunc.DebugLog("DB0005", {GetPlayerName(src)})
    end
end)


AddEventHandler("chatMessage", function(src, name, msg)
    if src == 0 then return end
    if msg:sub(1, 1) == "/" then return end

    if not src or not GetPlayerName(src) then
        ServerFunc.ErrorLog("ER0012", {tostring(src)})
        return
    end

    local pname = GetPlayerName(src) or "Unknown"
    if Config.Debug then
        ServerFunc.DebugLog("DB0011", {pname, src, msg})
    end

    ServerFunc.CreateLog({
        EmbedMessage = ServerFunc.Lang("DefaultLogs", "Chat", {pname, msg}),
        PlayerID = src,
        Channel = "Chat"
    })
end)


local explosionTypes = {"GRENADE", "GRENADELAUNCHER", "STICKYBOMB", "MOLOTOV", "ROCKET", "TANKSHELL", "HI_OCTANE", "CAR", "PLANE", "PETROL_PUMP", "BIKE", "DIR_STEAM", "DIR_FLAME", "DIR_GAS_CANISTER", "BOAT", "SHIP_DESTROY", "TRUCK", "BULLET", "SMOKEGRENADELAUNCHER", "SMOKEGRENADE", "BZGAS", "FLARE", "GAS_CANISTER", "EXTINGUISHER", "PROGRAMMABLEAR", "TRAIN", "BARREL", "PROPANE", "BLIMP", "DIR_FLAME_EXPLODE", "TANKER", "PLANE_ROCKET", "VEHICLE_BULLET", "GAS_TANK", "BIRD_CRAP", "RAILGUN", "BLIMP2", "FIREWORK", "SNOWBALL", "PROXMINE", "VALKYRIE_CANNON", "AIR_DEFENCE", "PIPEBOMB", "VEHICLEMINE", "EXPLOSIVEAMMO", "APCSHELL", "BOMB_CLUSTER", "BOMB_GAS", "BOMB_INCENDIARY", "BOMB_STANDARD", "TORPEDO", "TORPEDO_UNDERWATER", "BOMBUSHKA_CANNON", "BOMB_CLUSTER_SECONDARY", "HUNTER_BARRAGE", "HUNTER_CANNON", "ROGUE_CANNON", "MINE_UNDERWATER", "ORBITAL_CANNON", "BOMB_STANDARD_WIDE", "EXPLOSIVEAMMO_SHOTGUN", "OPPRESSOR2_CANNON", "MORTAR_KINETIC", "VEHICLEMINE_KINETIC", "VEHICLEMINE_EMP", "VEHICLEMINE_SPIKE", "VEHICLEMINE_SLICK", "VEHICLEMINE_TAR", "SCRIPT_DRONE", "RAYGUN", "BURIEDMINE", "SCRIPT_MISSIL"}
AddEventHandler("explosionEvent", function(_source, ev)
    local src = _source
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        ServerFunc.ErrorLog("ER0021", {"explosionEvent"})
        return
    end

    local pname = GetPlayerName(src) or "Unknown"

    if ev.explosionType < -1 or ev.explosionType > 77 then
        if Config.Debug then
            ServerFunc.DebugLog("DB0012", {"UNKNOWN", pname, src})
        end
        ev.explosionType = "UNKNOWN"
    else
        local typeName = explosionTypes[ev.explosionType + 1]
        if not typeName then
            ServerFunc.ErrorLog("ER0027", {ev.explosionType, 77})
            ev.explosionType = "UNKNOWN"
        else
            ev.explosionType = ServerExplosions.ExplosionNames[typeName] or typeName
        end
    end

    if Config.Debug then
        ServerFunc.DebugLog("DB0012", {ev.explosionType, pname, src})
    end

    ServerFunc.CreateLog({
        EmbedMessage = ServerFunc.Lang("DefaultLogs", "Explosions", {pname, ev.explosionType}),
        PlayerID = src,
        Channel = "Explosion"
    })
end)


RegisterServerEvent("FinnLocked:SilentWatcher:PlayerDied")
AddEventHandler("FinnLocked:SilentWatcher:PlayerDied", function(args)
    local src = source
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        ServerFunc.ErrorLog("ER0021", {"PlayerDied"})
        return
    end

    if not args then
        ServerFunc.ErrorLog("ER0013", {"args in PlayerDied"})
        return
    end

    if args.weapon == nil then 
        _Weapon = "" 
    else 
        _Weapon = "" .. args.weapon .. "" 
    end

    if args.type == 1 then
        if Config.Debug then
            ServerFunc.DebugLog("DB0013", {1, GetPlayerName(src), src})
        end

        ServerFunc.CreateLog({
            EmbedMessage = ServerFunc.Lang("DefaultLogs", "Death", {GetPlayerName(src), args.death_reason, _Weapon}),
            PlayerID = src,
            Channel = "Death"
        })
    elseif args.type == 2 then
        if Config.Debug then
            ServerFunc.DebugLog("DB0013", {2, GetPlayerName(src), src})
        end

        ServerFunc.CreateLog({
            EmbedMessage = ServerFunc.Lang("DefaultLogs", "Death2", {GetPlayerName(args.player_2_id), args.death_reason, GetPlayerName(src), _Weapon}),
            PlayerID = src,
            PlayerID_2 = args.player_2_id,
            Channel = "Death"
        })
    else
        ServerFunc.ErrorLog("ER0030", {tostring(args.type), src})
        if Config.Debug then
            ServerFunc.DebugLog("DB0013", {tostring(args.type), GetPlayerName(src), src})
        end

        ServerFunc.CreateLog({
            EmbedMessage = ServerFunc.Lang("DefaultLogs", "Death", {GetPlayerName(src), args.death_reason, _Weapon}),
            PlayerID = src,
            Channel = "Death"
        })
    end
end)


RegisterServerEvent("FinnLocked:SilentWatcher:PlayerShotWeapon")
AddEventHandler("FinnLocked:SilentWatcher:PlayerShotWeapon", function(weapon, count)
    local src = source
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        ServerFunc.ErrorLog("ER0021", {"PlayerShotWeapon"})
        return
    end

    if not weapon or not count then
        ServerFunc.ErrorLog("ER0028", {src})
        return
    end

    if Config.WeaponLog then
        if Config.Debug then
            ServerFunc.DebugLog("DB0014", {weapon, count, GetPlayerName(src), src})
        end

        ServerFunc.CreateLog({
            EmbedMessage = ServerFunc.Lang("DefaultLogs", "Shooting", {GetPlayerName(src), weapon, count}),
            PlayerID = src, 
            Channel = "Shooting"
        })
    end
end)


AddEventHandler("onResourceStop", function (resourceName)
    if Config.Debug then
        ServerFunc.DebugLog("DB0015", {"Stop", resourceName})
    end

    ServerFunc.CreateLog({
        EmbedMessage = ServerFunc.Lang("DefaultLogs", "ResourceStop", {resourceName}),
        Channel = "Resource"
    })
end)


AddEventHandler("onResourceStart", function (resourceName)
    Wait(100)
    if Config.Debug then
        ServerFunc.DebugLog("DB0015", {"Start", resourceName})
    end

    ServerFunc.CreateLog({
        EmbedMessage = ServerFunc.Lang("DefaultLogs", "ResourceStart", {resourceName}),
        Channel = "Resource"
    })
end)


AddEventHandler("onResourceListRefresh", function (resourceName)
    Wait(100)
    if Config.Debug then
        ServerFunc.DebugLog("DB0015", {"Refresh", resourceName or "global"})
    end

    ServerFunc.CreateLog({
        EmbedMessage = ServerFunc.Lang("DefaultLogs", "ResourceRefresh"),
        Channel = "Resource"
    })
end)


RegisterNetEvent("FinnLocked:SilentWatcher:ClientUpload")
AddEventHandler("FinnLocked:SilentWatcher:ClientUpload", function(args)
    local src = source
    if not src or src == 0 then
        ServerFunc.ErrorLog("ER0011")
        ServerFunc.ErrorLog("ER0021", {"ClientUpload"})
        return
    end

    if not args then
        ServerFunc.ErrorLog("ER0029", {src})
        return
    end

    if Config.Debug then
        ServerFunc.DebugLog("DB0016", {GetPlayerName(src), src})
    end

    ServerFunc.CreateLog(args)
end)