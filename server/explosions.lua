--[[

######## #### ##    ## ##    ## ##        #######   ######  ##    ## ######## ########  
##        ##  ###   ## ###   ## ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##        ##  ####  ## ####  ## ##       ##     ## ##       ##  ##   ##       ##     ## 
######    ##  ## ## ## ## ## ## ##       ##     ## ##       #####    ######   ##     ## 
##        ##  ##  #### ##  #### ##       ##     ## ##       ##  ##   ##       ##     ## 
##        ##  ##   ### ##   ### ##       ##     ## ##    ## ##   ##  ##       ##     ## 
##       #### ##    ## ##    ## ########  #######   ######  ##    ## ######## ########  

@file    server/explosions.lua
@author  Finn
@company FinnLocked
@date    01-09-2026
@license MIT

]]

ServerExplosions = {}

ServerExplosions.ExplosionNames = {
    ['GRENADE'] = 'Grenade',
    ['GRENADELAUNCHER'] = 'Grenade Launcher',
    ['STICKYBOMB'] = 'Sticky Bomb',
    ['MOLOTOV'] = 'Molotov',
    ['PROXMINE'] = 'Proximity Mine',
    ['PIPEBOMB'] = 'Pipe Bomb',
    ['SMOKEGRENADE'] = 'Smoke Grenade',
    ['SMOKEGRENADELAUNCHER'] = 'Smoke Grenade Launcher',
    ['BZGAS'] = 'BZ Gas',
    ['FLARE'] = 'Flare',
    ['EXTINGUISHER'] = 'Fire Extinguisher',
    ['SNOWBALL'] = 'Snowball',
    ['BIRD_CRAP'] = 'Bird Crap',
    ['ACID'] = 'Acid Package',
    ['C4'] = 'C4',
    ['FERTILIZER'] = 'Fertilizer Can',
    ['HAZARDCAN'] = 'Hazardous Jerry Can',

    ['ROCKET'] = 'Rocket',
    ['PLANE_ROCKET'] = 'Plane Rocket',
    ['TANKSHELL'] = 'Tank Shell',
    ['RAILGUN'] = 'Railgun',
    ['FIREWORK'] = 'Firework Launcher',
    ['VALKYRIE_CANNON'] = 'Valkyrie Cannon',
    ['AIR_DEFENCE'] = 'Air Defence Gun',
    ['APCSHELL'] = 'APC Shell',
    ['BOMBUSHKA_CANNON'] = 'Bombushka Cannon',
    ['HUNTER_CANNON'] = 'Hunter Cannon',
    ['HUNTER_BARRAGE'] = 'Hunter Barrage',
    ['ROGUE_CANNON'] = 'Rogue Cannon',
    ['OPPRESSOR2_CANNON'] = 'Oppressor Mk II Cannon',
    ['ORBITAL_CANNON'] = 'Orbital Cannon',
    ['TORPEDO'] = 'Torpedo',
    ['TORPEDO_UNDERWATER'] = 'Torpedo (Underwater)',
    ['MORTAR_KINETIC'] = 'Mortar (Kinetic)',
    ['SCRIPT_MISSIL'] = 'Script Missile',
    ['SCRIPT_DRONE'] = 'Script Drone',
	
    ['BOMB_STANDARD'] = 'Bomb',
    ['BOMB_STANDARD_WIDE'] = 'Bomb (Wide)',
    ['BOMB_CLUSTER'] = 'Cluster Bomb',
    ['BOMB_CLUSTER_SECONDARY'] = 'Cluster Bomb (Secondary)',
    ['BOMB_GAS'] = 'Gas Bomb',
    ['BOMB_INCENDIARY'] = 'Incendiary Bomb',
    ['MINE_UNDERWATER'] = 'Underwater Mine',
    ['BURIEDMINE'] = 'Buried Mine',
    ['VEHICLEMINE'] = 'Vehicle Mine',
    ['VEHICLEMINE_KINETIC'] = 'Vehicle Mine (Kinetic)',
    ['VEHICLEMINE_EMP'] = 'Vehicle Mine (EMP)',
    ['VEHICLEMINE_SPIKE'] = 'Vehicle Mine (Spike)',
    ['VEHICLEMINE_SLICK'] = 'Vehicle Mine (Slick)',
    ['VEHICLEMINE_TAR'] = 'Vehicle Mine (Tar)',

    ['BULLET'] = 'Exploding Bullet',
    ['VEHICLE_BULLET'] = 'Vehicle Bullet',
    ['EXPLOSIVEAMMO'] = 'Explosive Ammo',
    ['EXPLOSIVEAMMO_SHOTGUN'] = 'Explosive Shotgun Ammo',
    ['RAYGUN'] = 'Raygun',

    ['CAR'] = 'Vehicle (Car)',
    ['BIKE'] = 'Vehicle (Bike)',
    ['TRUCK'] = 'Vehicle (Truck)',
    ['TANKER'] = 'Vehicle (Tanker)',
    ['PLANE'] = 'Vehicle (Plane)',
    ['BOAT'] = 'Vehicle (Boat)',
    ['SHIP_DESTROY'] = 'Vehicle (Ship)',
    ['TRAIN'] = 'Vehicle (Train)',
    ['BLIMP'] = 'Blimp',
    ['BLIMP2'] = 'Blimp 2',

    ['HI_OCTANE'] = 'High Octane',
    ['PETROL_PUMP'] = 'Petrol Pump',
    ['GAS_CANISTER'] = 'Gas Canister',
    ['DIR_GAS_CANISTER'] = 'Gas Canister (Directional)',
    ['PROPANE'] = 'Propane Tank',
    ['BARREL'] = 'Barrel',
    ['GAS_TANK'] = 'Gas Tank',
    ['PROGRAMMABLEAR'] = 'Programmable AR',

    ['DIR_STEAM'] = 'Steam Vent',
    ['DIR_FLAME'] = 'Flame Vent',
    ['DIR_FLAME_EXPLODE'] = 'Flame Explosion (Directional)',
}