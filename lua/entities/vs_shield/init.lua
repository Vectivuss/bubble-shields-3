AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/hunter/misc/shell2x2.mdl" )
    self:SetNotSolid( true )
    self:DrawShadow( false )
end