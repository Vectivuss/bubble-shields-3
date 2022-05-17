if ( !istable( ULib ) ) then return end

local CATEGORY_NAME = "Bubble Shields"

/*
	Set Player Shield(s)
*/
function ulx.setshields( calling_ply, target_plys, amount )
	for i=1, #target_plys do
		local v = target_plys[ i ]
		v:SetShields( amount )
	end
	ulx.fancyLogAdmin( calling_ply, "#A set #T shield(s) to #i", target_plys, amount )
end

local setshields = ulx.command( CATEGORY_NAME, "ulx setshields", ulx.setshields, "!setshields" )
setshields:addParam{ type=ULib.cmds.PlayersArg }
setshields:addParam{ type=ULib.cmds.NumArg, min=0, max=50, hint="Give target(s) shields amount", ULib.cmds.round }
setshields:defaultAccess( ULib.ACCESS_ADMIN )
setshields:help( "Set target(s) an amount of shields" )


/*
	Add Player Shield(s)
*/
function ulx.giveshields( calling_ply, target_plys, amount )
	for i=1, #target_plys do
		local v = target_plys[ i ]
		v:AddShields( amount )
	end
	ulx.fancyLogAdmin( calling_ply, "#A gave #T #i shield(s).", target_plys, amount )
end

local giveshields = ulx.command( CATEGORY_NAME, "ulx giveshields", ulx.giveshields, "!giveshields" )
giveshields:addParam{ type=ULib.cmds.PlayersArg }
giveshields:addParam{ type=ULib.cmds.NumArg, min=0, max=50, hint="Give target(s) shields amount", ULib.cmds.round }
giveshields:defaultAccess( ULib.ACCESS_ADMIN )
giveshields:help( "Give target(s) an amount of shields" )


/*
	Get Player Shield(s)
*/
function ulx.getshields( calling_ply, target_plys )
	local affected_plys = {}
	for i=1, #target_plys do
		local v = target_plys[ i ]
		if ulx.getExclusive( v, calling_ply ) then
			ULib.tsayError( calling_ply, ulx.getExclusive( v, calling_ply ), true )
		elseif not v:Alive() then
			ULib.tsayError( calling_ply, v:Nick() .. " is currently dead!", true )
		else
			ulx.fancyLogAdmin( calling_ply, "#T has " .. v:GetShields() .. " shield(s)", target_plys )
			table.insert( affected_plys, v )
		end
	end
end
local getshields = ulx.command( CATEGORY_NAME, "ulx getshields", ulx.getshields, "!getshields" )
getshields:addParam{ type=ULib.cmds.PlayersArg }
getshields:defaultAccess( ULib.ACCESS_ADMIN )
getshields:help( "Checks target(s) how many shields they have" )
