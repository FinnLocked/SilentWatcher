--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##        ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##        ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######    ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##        ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##        ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    client/main.lua
@author  Finn
@company FinnLocked
@date    01-09-2026
@license MIT

]]

exports("createLog", function(args)
    if not args then
        if ClientFunc and ClientFunc.ErrorLog then
            ClientFunc.ErrorLog("ER0013", {"args in client createLog export"})
        else
            print("^5[SilentWatcher] ^1Code: ER0013 - Function called with nil arguments: args in client createLog export^0")
        end
        return
    end

    if type(args) ~= "table" then
        if ClientFunc and ClientFunc.ErrorLog then
            ClientFunc.ErrorLog("ER0015", {"args in client createLog export", "table", type(args)})
        else
            print("^5[SilentWatcher] ^1Code: ER0015 - Unexpected data type for 'args': expected table, got " .. type(args) .. "^0")
        end
        return
    end

    if Config and Config.Debug and ClientFunc and ClientFunc.DebugLog then
        ClientFunc.DebugLog("DB0017", {GetInvokingResource() or "unknown"})
    end

    args.resource = GetInvokingResource()
    TriggerServerEvent("FinnLocked:SilentWatcher:ClientExportLog", args)
end)


RegisterNetEvent('FinnLocked:SilentWatcher:CreateScreenshot')
AddEventHandler('FinnLocked:SilentWatcher:CreateScreenshot', function(args)
    if not args then
        if ClientFunc and ClientFunc.ErrorLog then
            ClientFunc.ErrorLog("ER0013", {"args in CreateScreenshot"})
        else
            print("^5[SilentWatcher] ^1Code: ER0013 - Function called with nil arguments: args in CreateScreenshot^0")
        end
        return
    end

    if args.url ~= "" and args.url ~= nil and args.url ~= 'DISCORD_WEBHOOK' then
        exports['screenshot-basic']:requestScreenshotUpload(args.url, 'files[]', function(data)
            local resp = json.decode(data)
            if not resp then
                if ClientFunc and ClientFunc.ErrorLog then
                    ClientFunc.ErrorLog("ER0018", {"screenshot-basic response", "decode failed"})
                else
                    print("^5[SilentWatcher] ^1Code: ER0018 - Failed to decode JSON for 'screenshot-basic response'. Error: decode failed^0")
                end
                return
            end

            if resp.attachments then
                args.responseUrl = resp.attachments[1].url
                args.hasScreenshot = true
                TriggerServerEvent('FinnLocked:SilentWatcher:ClientUpload', args)
            else
                if ClientFunc and ClientFunc.ErrorLog then
                    ClientFunc.ErrorLog("ER0017", {"screenshot upload", "no attachments in response"})
                else
                    print("^5[SilentWatcher] ^1Code: ER0017 - Webhook payload for 'screenshot upload' failed to send: no attachments in response^0")
                end
            end
        end)
    end
end)


local function GetKillerPlayerId(ped)
    if not ped or ped == 0 then
        if ClientFunc and ClientFunc.ErrorLog then
            ClientFunc.ErrorLog("ER0013", {"ped in GetKillerPlayerId"})
        else
            print("^5[SilentWatcher] ^1Code: ER0013 - Function called with nil arguments: ped in GetKillerPlayerId^0")
        end
        return nil
    end

    local killer = GetPedSourceOfDeath(ped)
    if not killer or killer == 0 then
        return nil
    end

    if IsEntityAPed(killer) and IsPedAPlayer(killer) then
        return NetworkGetPlayerIndexFromPed(killer)
    end

    if IsEntityAVehicle(killer) then
        local driver = GetPedInVehicleSeat(killer, -1)
        if driver and driver ~= 0 and IsEntityAPed(driver) and IsPedAPlayer(driver) then
            return NetworkGetPlayerIndexFromPed(driver)
        end
    end

    return nil
end


local function GetDeathReasonFromCategory(category, killerId)
    if killerId == PlayerId() then
        return ClientFunc.Lang("DeathReasons", "Suicide")
    end

    if killerId == nil then
        return ClientFunc.Lang("DeathReasons", "Died")
    end

    if not category then
        return ClientFunc.Lang("DeathReasons", "Killed")
    end

    local map = {
        ["Beaten"] = ClientFunc.Lang("DeathReasons", "Murdered"),
        ["Torched"] = ClientFunc.Lang("DeathReasons", "Torched"),
        ["Stabbed"] = ClientFunc.Lang("DeathReasons", "Knifed"),
        ["Pistolled"] = ClientFunc.Lang("DeathReasons", "Pistoled"),
        ["Riddled"] = ClientFunc.Lang("DeathReasons", "Riddled"),
        ["Rifled"] = ClientFunc.Lang("DeathReasons", "Rifled"),
        ["Machine Gunned"] = ClientFunc.Lang("DeathReasons", "MachineGunned"),
        ["Pulverized"] = ClientFunc.Lang("DeathReasons", "Pulverized"),
        ["Sniped"] = ClientFunc.Lang("DeathReasons", "Sniped"),
        ["Obliterated"] = ClientFunc.Lang("DeathReasons", "Obliterated"),
        ["Shredded"] = ClientFunc.Lang("DeathReasons", "Shredded"),
        ["Bombed"] = ClientFunc.Lang("DeathReasons", "Bombed"),
        ["Mowed Over"] = ClientFunc.Lang("DeathReasons", "MowedOver"),
        ["Flattened"] = ClientFunc.Lang("DeathReasons", "Flattened"),
        ["Fell from a high place"] = ClientFunc.Lang("DeathReasons", "Died"),
    }

    return map[category] or ClientFunc.Lang("DeathReasons", "Killed")
end


CreateThread(function()
    while true do
        Wait(500)

        local ped = PlayerPedId()
        if not IsEntityDead(ped) then
            goto continue
        end

        local deathHash, deathCategory, weaponName = ClientFunc.DeathCause(ped)
        local killerId = GetKillerPlayerId(ped)

        local deathReason = GetDeathReasonFromCategory(deathCategory, killerId)

        local payload
        if deathReason == ClientFunc.Lang("DeathReasons", "Suicide") or deathReason == ClientFunc.Lang("DeathReasons", "Died") then
            payload = {
                type = 1,
                player_id = GetPlayerServerId(PlayerId()),
                death_reason = deathReason,
                weapon = weaponName
            }

            if Config and Config.Debug and ClientFunc and ClientFunc.DebugLog then
                ClientFunc.DebugLog("DB0013", {1, "self", PlayerId()})
            end
        else
            if not killerId then
                payload = {
                    type = 1,
                    player_id = GetPlayerServerId(PlayerId()),
                    death_reason = deathReason or ClientFunc.Lang("DeathReasons", "Died"),
                    weapon = weaponName
                }

                if ClientFunc and ClientFunc.ErrorLog then
                    ClientFunc.ErrorLog("ER0030", {"2 (no killerId)", PlayerId()})
                end
            else
                payload = {
                    type = 2,
                    player_id = GetPlayerServerId(PlayerId()),
                    player_2_id = GetPlayerServerId(killerId),
                    death_reason = deathReason,
                    weapon = weaponName
                }

                if Config and Config.Debug and ClientFunc and ClientFunc.DebugLog then
                    ClientFunc.DebugLog("DB0013", {2, "other", PlayerId()})
                end
            end
        end

        TriggerServerEvent("FinnLocked:SilentWatcher:PlayerDied", payload)

        while IsEntityDead(PlayerPedId()) do
            Wait(1000)
        end
        ::continue::
    end
end)


local function IsWeaponLogged(weaponHash)
    local name = ClientTables.WeaponNames[tostring(weaponHash)]
    if not name then
        return false, "Undefined"
    end

    for _, v in pairs(Config.WeaponsNotLogged) do
        if weaponHash == GetHashKey(v) then
            return false, name
        end
    end

    return true, name
end


CreateThread(function()
    local fireWeapon = nil
    local timeout = 0
    local fireCount = 0

    while true do
        Wait(0)

        local ped = GetPlayerPed(PlayerId())
        local nowShooting = IsPedShooting(ped)
        local selectedWeapon = GetSelectedPedWeapon(ped)

        if nowShooting then
            fireWeapon = selectedWeapon
            fireCount = fireCount + 1
            timeout = 500
        elseif not nowShooting and fireCount ~= 0 and timeout ~= 0 then
            if timeout ~= 0 then
                timeout = timeout - 1
            end

            if fireWeapon ~= selectedWeapon then
                timeout = 0
            end

            if fireCount ~= 0 and timeout == 0 then
                local logged, name = true, "Undefined"

                if not ClientTables.WeaponNames[tostring(fireWeapon)] then
                    logged = false
                    name = ClientFunc.Lang("WeaponFired", "Undefined") or "Undefined"

                    if Config and Config.Debug and ClientFunc and ClientFunc.DebugLog then
                        ClientFunc.DebugLog("DB0014", {name, fireCount, "local", PlayerId()})
                    end

                    TriggerServerEvent("FinnLocked:SilentWatcher:PlayerShotWeapon", name, fireCount)
                else
                    logged, name = IsWeaponLogged(fireWeapon)
                    if logged then
                        if Config and Config.Debug and ClientFunc and ClientFunc.DebugLog then
                            ClientFunc.DebugLog("DB0014", {name, fireCount, "local", PlayerId()})
                        end

                        TriggerServerEvent("FinnLocked:SilentWatcher:PlayerShotWeapon", name, fireCount)
                    else
                        name = ClientFunc.Lang("WeaponFired", "Undefined") or "Undefined"

                        if Config and Config.Debug and ClientFunc and ClientFunc.DebugLog then
                            ClientFunc.DebugLog("DB0014", {name, fireCount, "local", PlayerId()})
                        end

                        TriggerServerEvent("FinnLocked:SilentWatcher:PlayerShotWeapon", name, fireCount)
                    end
                end

                fireCount = 0
                timeout = 0
                fireWeapon = nil
            end
        end
    end
end)