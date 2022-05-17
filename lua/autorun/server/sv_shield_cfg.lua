timer.Simple( 0, function() ShieldSystem_SyncAll() end ) -- IGNORE

//////////////////////////////////////////////////////////////////////////////////

/////////////////////////////// Vectivus´s Shields V3 /////////////////////////////

// Developed by Vectivus:
// http://steamcommunity.com/profiles/76561198371018204

// Wish to contact me:
// vectivus099@gmail.com

//////////////////////////////////////////////////////////////////////////////////

vs.shield = {

    shield = {  // Configuration for shield

        // Max amount of shield(s) the player can hold
        max = 4,

        // Price for each shield
        price = 10000,

        // how long each shield lasts before breaking
        delay = 2,

        // Notify the attacker on how many shield(s) the victim has left
        notifications = true,


        // Each shield breaking applies a cooldown on when the player can buy more.
        // E.g if the cooldown was 5s and the player lost two shields the cooldown will be 10s
        cooldown = 20, // Don't want to use? set to 0

    },


    bubble = { // Configuration for bubble ENT

        // Damage matterial
        material = "Models/effects/comball_tape",

        // This will allow the player to hold crouch and show the shield until they stop
        crouchEnable = true,

        // Shield material shown while the player holds crouch
        crouchMaterial = "models/props_combine/tprings_globe",

    },

    ranks = { // Configuration for UserGroups
        // Allows certain ranks to purchase more or less than default. Ranks not added will use default max

        [ "superadmin" ] = 12,
        [ "admin" ] = 6,

    },

    // Weapons that can break more than 1 shield(s)
    // "kill" will damage the player through shield(s). 
    // "all" will break ALL player shield(s)
    weapons = {
        [ "weapon_rpg" ] = "kill",
        [ "weapon_smg1" ] = "all",
        [ "weapon_pistol" ] = 2,
    },


    /*  [ DEVELOPER FUNCTIONALITY ]

        OnGive = function( p ) // Player
            // Code
        end,

        OnRemove = function( p, t ) // Player, CTakeDamageInfo ( falldamage doesn't count )
            // Code
        end,

        OnThink = function( p ) // Player
            // Code
        end,
    */

}