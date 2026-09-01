--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##        ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##        ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######    ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##        ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##        ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    fxmanifest.lua
@author  Finn
@company FinnLocked
@date    30-08-2026
@license MIT

]]

name 'SilentWatcher'
description 'Server Logger to Discord using webhooks and smart batching. More info can be found at https://finnlocked.com/'
author 'FinnLocked'
version '1.0.0'
repository 'https://github.com/FinnLocked/SilentWatcher'
url 'https://finnlocked.com/'

server_scripts {
    'config/codes.lua',
    'config/config.lua',
    'config/webhooks.lua',
    'server/explosions.lua',
    'server/functions.lua',
    'server/main.lua'
}

client_scripts {
    'config/codes.lua',
    'config/config.lua',
    'client/clienttables.lua',
    'client/functions.lua',
    'client/main.lua'
}

files {
    'json/*.json',
    'locals/*.json'
}

lua54 'yes'
games { 'gta5' }
fx_version 'cerulean'