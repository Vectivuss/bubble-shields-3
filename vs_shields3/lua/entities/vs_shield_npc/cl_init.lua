include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	if LocalPlayer():GetPos():Distance( self:GetPos() ) > 180 then return end

	local Pos = self:GetPos() + self:GetUp() * 85
	Pos = Pos + self:GetUp() * math.abs( math.sin( CurTime() ) * 1.2 )
	local Ang = Angle( 0, LocalPlayer():EyeAngles().y - 90, 90 )
	cam.Start3D2D( Pos, Ang, 0.1 )
		draw.RoundedBox( 22, -125, 30, 250, 60, Color( 0, 0, 0, 200 ) )
		draw.SimpleTextOutlined( "Bubble Shields", "ui.33", 0, 58, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color( 87, 39, 210, 25 ) )
		draw.NoTexture()
	cam.End3D2D()
end