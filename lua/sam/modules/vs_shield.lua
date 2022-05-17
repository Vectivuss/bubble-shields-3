if SAM_LOADED then return end
local sam, command, language = sam, sam.command, sam.language

command.set_category( "Bubble Shields" )

/*
	Set Player Shield(s)
*/
command.new( "setshields" )
	:SetPermission( "setshields", "admin" )
	:AddArg( "player" )
	:AddArg( "number", { hint = "amount", min = 1, max = 50, round = true, optional = true, default = 1 } )
	:Help( "This will set the targets shield(s)" )
	
	:OnExecute(function(ply, targets, amount)
		for i = 1, #targets do
			targets[i]:SetShields( amount )
		end
		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} set {T} shield(s) to {V}", {
			A = ply, T = targets, V = amount
		})
	end)
:End()

/*
	Add Player Shields(s)
*/
command.new( "giveshields" )
	:SetPermission( "giveshields", "admin" )
	:AddArg( "player" )
	:AddArg( "number", { hint = "amount", min = 1, max = 50, round = true, optional = true, default = 1 } )
	:Help( "This will add shield(s) to target" )
	
	:OnExecute(function(ply, targets, amount)
		for i = 1, #targets do
			targets[i]:AddShields( amount )
		end
		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} gave {T} {V} shield(s).", {
			A = ply, T = targets, V = amount
		})
	end)
:End()

/*
	Get Player Shield(s)
*/
command.new( "getshields" )
	:SetPermission( "getshields", "admin" )
	:AddArg( "player" )
	:Help( "This will tell you the players shield amount" )
	
	:OnExecute(function(ply, targets, amount)
		for i = 1, #targets do
			amount = targets[i]:GetShields()
		end
		sam.player.send_message(nil, "{T} has {V} shield(s).", {
			A = ply, T = targets, V = amount
		})
	end)
:End()