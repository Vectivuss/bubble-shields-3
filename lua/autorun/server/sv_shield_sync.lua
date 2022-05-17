util.AddNetworkString( "vs.shield.sync" )

local function ShieldSystem_SyncData()
	local t = {}
	for k, v in pairs( vs.shield ) do
		t[k] = t[k] or {}
		t[k] = TypeID(v) != TYPE_FUNCTION and v or nil
	end
	return t
end
function ShieldSystem_Sync( p )
	if ( !IsValid( p ) ) then return end
	net.Start( "vs.shield.sync" )
		net.WriteTable( ShieldSystem_SyncData() )
	net.Send( p )
end
concommand.Add( "vs.shield.sync", function( p ) ShieldSystem_Sync( p ) end )

function ShieldSystem_SyncAll()
	for _, p in pairs( player.GetAll() ) do
        if !IsValid( p ) then continue end
		ShieldSystem_Sync( p )
	end
end
