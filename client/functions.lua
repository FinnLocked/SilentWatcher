--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##        ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##        ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######    ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##        ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##        ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    client/functions.lua
@author  Finn
@company FinnLocked
@date    01-09-2026
@license MIT

]]

ClientFunc = {}


ClientFunc.ErrorLog = function(x, args)
    if not Code or not Code.Error[x] then
        print("^5[SilentWatcher] ^1Code: ER0000 - Error log was triggered without a message avalible.^0")
        return
    end
    TriggerServerEvent("FinnLocked:SilentWatcher:Error", x, args)
end


ClientFunc.DebugLog = function(x, args)
    if not Code or not Code.Debug[x] then
        print("^5[SilentWatcher] ^3Code: DB0000 - Debug log was triggered without a message avalible.^0")
        return
    end
    TriggerServerEvent("FinnLocked:SilentWatcher:Debug", x, args)
end


local langFile = LoadResourceFile(GetCurrentResourceName(), "locals/" .. Config.Local .. ".json")
local lang = json.decode(langFile)


if not lang then
    ClientFunc.ErrorLog("ER0001")
    ClientFunc.ErrorLog("ER0016", {"language table"})
end


ClientFunc.Lang = function(x, y, args)
    if not lang then
        ClientFunc.ErrorLog("ER0020", {x, Config.Local})
        return y
    end

    if not lang[x] then
        ClientFunc.ErrorLog("ER0020", {x, Config.Local})
        return y
    end

    if lang[x][y] == nil then
        ClientFunc.ErrorLog("ER0010", {y, Config.Local})
        return y
    end

    if args and #args > 0 then
        return lang[x][y]:format(table.unpack(args))
    end
    return lang[x][y]
end


ClientFunc.DeathCause = function(ped)
    if not ped or ped == 0 then
        ped = PlayerPedId()
    end

    if not ped or ped == 0 then
        ClientFunc.ErrorLog("ER0013", {"ped in DeathCause"})
        return nil, nil, nil
    end

    if not IsEntityDead(ped) then
        return nil, nil, nil
    end

    local hash = GetPedCauseOfDeath(ped)
    local info = ClientTables.deatCause[hash]

    local category, weaponName
    if info then
        category = info[1]
        weaponName = info[2]
    end

    if not weaponName then
        weaponName = ClientTables.WeaponNames[tostring(hash)] or "Unknown"
    end

    return hash, category, weaponName
end