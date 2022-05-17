function pMeta:SetShields( a )
    self:SetNWInt( "QShields", a )
end

function pMeta:AddShields( a )
    self:SetShields( self:GetShields() + a )
end

function pMeta:SetActiveShield( a )
    if !isbool( a ) then return end
    self:SetNWBool( "QShieldActive", a )
end

function pMeta:SetShieldCooldown( a )
    self:SetNWInt( "QShieldCooldown", CurTime() + a )
end

function pMeta:AddShieldCooldown( a )
    self:SetShieldCooldown( self:GetShieldCooldown() + a )
end

hook.Add( "PlayerSpawn", "ShieldSystem.Spawn", function( p )
    p:SetShields( 0 )
    p:SetShieldCooldown( 0 )
    p:SetActiveShield( false )
end )

function _ShieldSystem_ShieldProp( p, m ) // player, material
    if !IsValid( p ) then return end
    if IsValid( p.bubbleShield ) then return end
    p.bubbleShield = ents.Create( "vs_shield" )
    p.bubbleShield:SetMaterial( m or "" )
    p.bubbleShield:SetPos( p:WorldSpaceCenter() )
    p.bubbleShield:SetParent( p, 1 )
    p.bubbleShield:Spawn()
end

hook.Add( "EntityTakeDamage", "ShieldSystem.TakeDamage", function( e, t )
    local shieldData = vs.shield
    if !shieldData then return end
    local p = e:IsPlayer() and e
    local att = t:GetAttacker()
    local fall = t:IsFallDamage()
    if !p then return end
    if !p:HasShields() then return end
    local weapon = shieldData.weapons[ att:GetActiveWeapon():GetClass() ]
    if weapon == "kill" then return end
    t:SetDamage( 0 )
    p:AddShieldCooldown( shieldData.shield.cooldown )

    if !fall then
        if shieldData.OnRemove then shieldData.OnRemove( p, t ) end
    end
end )

hook.Add( "PostEntityTakeDamage", "ShieldSystem.PostDamage", function( e, t )
    local shieldData = vs.shield
    if !shieldData then return end
    local p = e:IsPlayer() and e
    local att = t:GetAttacker()
    local inf = t:GetInflictor()
    local fall = t:IsFallDamage()
    if !p then return end
    if !att then return end
    if !p:HasShields() then return end
    local weapon = shieldData.weapons[ att:GetActiveWeapon():GetClass() ]
    if weapon == "kill" then return end

    if !p:HasActiveShield() then
        p:SetActiveShield( true )

        _ShieldSystem_ShieldProp( p, shieldData.bubble.material )

        if weapon == "all" then
            p:AddShields( -p:GetShields() )
        elseif weapon then
            p:AddShields( -weapon )
        else
            p:AddShields( -1 )
        end

        if p:GetShields() < 0 then p:SetShields( 0 ) end // This wont happen but just in case

        if ( shieldData.shield.notifications and att:IsPlayer() ) then 
            DarkRP.notify( att, 0, 2, p:Name() .. " has " .. p:GetShields() .. " shield(s) left!" )
        end

        timer.Simple( shieldData.shield.delay, function()
            p:SetActiveShield( false )
            local hasShield = IsValid( p.bubbleShield )
            if hasShield then p.bubbleShield:Remove() end
            sound.Play( "Breakable.Glass", p:GetPos(), 128, 128 )
        end )
    end
end )

hook.Add( "Think", "ShieldSystem.Think", function()
    local shieldData = vs.shield
    if !shieldData then return end
    if !shieldData.bubble.crouchEnable then return end
    for _, p in pairs( player.GetAll() ) do
        if !IsValid( p ) then continue end
        if p:GetMoveType() == MOVETYPE_NOCLIP then continue end
        if !p:HasShields() then continue end
        if !p:Alive() then continue end
        if p:HasActiveShield() then continue end

        local hasShield = IsValid( p.bubbleShield )
        if !p:Crouching() and hasShield then p.bubbleShield:Remove() end
        if hasShield then continue end
        if p:Crouching() then _ShieldSystem_ShieldProp( p, shieldData.bubble.crouchMaterial ) end
    end
end )

hook.Add( "Think", "ShieldSystem.OnThink", function()
    local shieldData = vs.shield
    if !shieldData then return end
    for _, p in pairs( player.GetAll() ) do
        if !IsValid( p ) then continue end
        if !p:HasShields() then continue end
        if shieldData.OnThink then shieldData.OnThink( p ) end
    end
end )

hook.Add( "PlayerDeath", "ShieldSystem.Death", function( p )
    local hasShield = IsValid( p.bubbleShield )
    if hasShield then p.bubbleShield:Remove() end
end )