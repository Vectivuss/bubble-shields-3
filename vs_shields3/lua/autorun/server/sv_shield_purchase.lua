local function ShieldSystem_Purchase( p, k )
    local shieldData = vs.shield
    if !shieldData then return end
    if !k then return end
    if k > GetMaxShields() then return end

    local npc_vendor = false
    for _, e in pairs( ents.FindByClass( "vs_shield_npc" ) ) do
        if ( p:GetPos():Distance( e:GetPos() ) < 140 ) then
            npc_vendor = true 
            break
        end
    end
    if !npc_vendor then return end

    local price = shieldData.shield.price * k
    local canAfford = p:canAfford( price )

    do // How many shield(s) player can purchase.
        local Hascooldown = p:HasShieldCooldown()
        local cooldown = p:GetShieldCooldown()
        local cur = p:GetShields()
        local max = GetMaxShields()
        local hasMax = p:HasMaxShields()
        local rank = shieldData.ranks

        if p:HasShieldCooldown() then
            DarkRP.notify( p, 1, 4, "You're currently on cooldown: " .. cooldown )
            return
        end

        if hasMax then
            DarkRP.notify( p, 0, 4, "You've got max shields!" )
            return 
        end

        local maxRank = rank[ p:GetUserGroup() ] or GetMaxShields()
        if k + cur > maxRank then
            local overAmount = ( cur + k ) - maxRank
            k = k - overAmount
            ShieldSystem_Purchase( p, k )
            return
        end
    end

    do // Price Checks & cooldowns
        if !canAfford then
            DarkRP.notify( p, 1, 4, "You're unable to afford this!" )
            return
        end

        DarkRP.notify( p, 3, 3, "You purcahsed " .. k .. " shield(s) for " .. DarkRP.formatMoney( price ) )

        p:addMoney( -price )
        p:AddShields( k )
        if shieldData.OnGive then shieldData.OnGive( p ) end
    end
end

concommand.Add( "vs.shield.purchase", function( p, _, t )
    local k = tonumber( t[1] or 0 )
    ShieldSystem_Purchase( p, k )
end )