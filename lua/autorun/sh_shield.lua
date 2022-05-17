vs = vs or {}
vs.shield = vs.shield or {}
pMeta = FindMetaTable( "Player" )

function pMeta:GetShields()
    return self:GetNWInt( "QShields", 0 )
end

function pMeta:HasShields()
    return self:GetShields() > 0 and true or false
end

function pMeta:HasActiveShield()
    return self:GetNWBool( "QShieldActive", false )
end

function GetMaxShields()
    local i = vs.shield
    return i.shield.max
end

function pMeta:HasMaxShields()
    local rank = vs.shield.ranks
    local maxRank = rank[ self:GetUserGroup() ] or GetMaxShields()
    return self:GetShields() >= maxRank and true or false
end

function pMeta:GetShieldCooldown()
    local i = self:GetNWInt( "QShieldCooldown", 0 )
    return math.Clamp( math.Round(i-CurTime()), 0, 999999 )
end

function pMeta:HasShieldCooldown()
    return self:GetShieldCooldown() > 0 and true or false
end