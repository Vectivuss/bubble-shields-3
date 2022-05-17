if !CLIENT then return end

for i=12, 45 do // Not as expensive as people think
	surface.CreateFont( "ui."..i, { font = "Arial", size = i }) 
	surface.CreateFont( "uib."..i, { font = "Arial", size = i, weight = 1024 })
end

local shieldData = {}
timer.Simple( 0, function() RunConsoleCommand( "vs.shield.sync" ) end )
net.Receive( "vs.shield.sync", function() shieldData = net.ReadTable() end )

concommand.Add( "shield.ui", function( p )
    if !IsValid( p ) then return end
    local w, h = ScrW(), ScrH()

    local DFrame = vgui.Create( "DFrame" )
    DFrame:SetTitle( "" )
    DFrame:DockPadding( 0, 0, 0, 0 )
    DFrame:MakePopup()
    DFrame:SetSize( 0, 0 )
    DFrame:SizeTo( w*.4, h*.41, .15, 0, 1 )
    DFrame.Close = function( s )
		s:AlphaTo( 0, .1, .1, function() s:Remove() end )
	end
    DFrame.Think = function( s )
        if input.IsKeyDown( KEY_TAB ) then s:Close() end
        DFrame:Center()
    end
    DFrame.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 44, 53 ) )
    end
    DFrame:ShowCloseButton( false )

    local DPanel = vgui.Create( "DPanel", DFrame )
    DPanel:Dock( TOP )
    DPanel:SetTall( h*.04 )
    DPanel.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 33, 36, 44 ) )
        surface.SetDrawColor( 22, 24, 30 )
        surface.DrawTexturedRect( 0, h*.99, w, h*.06 )
        draw.SimpleText( "Bubble Shields", "ui.25", w*.01, h*.19, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end

    local DButton = vgui.Create( "DButton", DPanel )
    DButton:Dock( RIGHT )
    DButton:SetWide( w*.02 )
    DButton:SetText( "" )
    DButton.Paint = function( s, w, h )
        if s:IsHovered() then
            draw.SimpleText( "X", "uib.25", w/2, h/2, Color( 255, 50, 90 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        else
            draw.SimpleText( "X", "uib.25", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end
    DButton.DoClick = function()
        DFrame:Close()
    end

    local DPanel = vgui.Create( "DPanel", DFrame )
    DPanel:Dock( LEFT )
    DPanel:SetWide( w*.07 )
    DPanel.Paint = function( s, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 32, 37, 45 ) )
        surface.SetDrawColor( 29, 32, 39 )
        surface.DrawTexturedRect( w*.99, 0, h*.005, h )
    end

	// Master Panel // 
    local Populate = vgui.Create( "DPanel", DFrame )
    Populate:Dock( FILL )
    Populate.Paint = nil
	local function loadPanel( func )
		Populate:AlphaTo( 0, .1, 0, function()
			Populate:Clear()
			func( Populate )
			Populate:AlphaTo( 255, .01, .05 )
		end )
	end
	Populate.Paint = nil
	// Master Panel // 

    local function DScrollPanelCreate( panel )
        local DScrollPanel = vgui.Create( "DScrollPanel", panel )
        DScrollPanel:Dock( FILL )
        DScrollPanel:DockMargin( 0, 0, -w*.005, 0)
        local sbar = DScrollPanel:GetVBar()
		local bb = 0
		sbar.btnUp.Paint = function( _, w, h ) bb = h end
		sbar.Paint = function( _, w, h )
			draw.RoundedBox( 16, w / 4 - w / 4, bb, w / 4, h - bb * 2, Color( 0, 0, 0, 128 ) )
		end sbar.btnDown.Paint = nil
		sbar.btnGrip.Paint = function( s, w, h )
			if s:IsHovered() then
				draw.RoundedBox( 16, w / 4 - w / 4, 0, w / 4, h, Color( 71, 86, 126 ) )
			else
				draw.RoundedBox( 16, w / 4 - w / 4, 0, w / 4, h, Color( 71, 86, 126, 155 ) )
			end
		end
        return DScrollPanel
    end

    local function ShieldSystem_Shields()
        local DScrollPanel = DScrollPanelCreate( Populate )

        for i=1, shieldData.shield.max do
            local price = ( i * shieldData.shield.price )

            local DPanel = vgui.Create( "DPanel", DScrollPanel )
            DPanel:Dock( TOP )
            DPanel:DockMargin( 0, 0, 0, h*.005 )
            DPanel:SetTall( h*.045 )
            DPanel:SetText( "" )
            DPanel.Paint = function( s, w, h )
                if s:IsHovered() then
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 88 ) )
                else
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 66 ) )
                end
                draw.SimpleText( "Shield " .. i, "uib.20", w*.015, h*.3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
            end

            local DButton = vgui.Create( "DButton", DPanel )
            DButton:Dock( RIGHT )
            DButton:SetWide( w*.07 )
            DButton:SetText( "" )
            DButton.Paint = function( s, w, h )
                if s:IsHovered() then
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 166 ) )
                    draw.SimpleText( DarkRP.formatMoney( price ), "ui.22", w*.45, h*.5, Color( 52, 235, 71, 213 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                else    
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 66 ) )
                    draw.SimpleText( DarkRP.formatMoney( price ), "ui.22", w*.45, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                end
            end
            DButton.DoClick = function()
                surface.PlaySound( "ui/buttonclick.wav" )
                RunConsoleCommand( "vs.shield.purchase", i )
            end
        end
    end

    local tabs = {
        { text = "Shields", color = Color( 240, 50, 80 ), func = ShieldSystem_Shields },
    }

    loadPanel( ShieldSystem_Shields )

    local _selectedTab = ""
    for k, v in pairs( tabs ) do
        local name = ( v.text or "" )
        local price = ( v.price or 0 )
        local color = ( v.color or color_white )

        local Item = {}
        Item[k] = vgui.Create( "DButton", DPanel )
        Item[k]:Dock( TOP )
        Item[k]:DockMargin( 0, h*.002, 0, h*.005 )
        Item[k]:SetTall( h*.035 )
        Item[k]:SetText( "" )
        Item[k].barStatus = 0
        Item[k].Selected = false
        Item[k].Paint = function( s, w, h )
            if ( s:IsHovered() ) then
                s.barStatus = math.Clamp( s.barStatus + 5 * FrameTime(), 0, 1 )
            else
                s.barStatus = math.Clamp( s.barStatus - 5 * FrameTime(), 0, 1 )
            end
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 128 ) )

            surface.SetDrawColor( color )
            surface.DrawRect( 0, 0, w*s.barStatus, h )

            draw.SimpleText( name, "uib.18", w*.49, h*.19, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
        end
        Item[k].DoClick = function( s )
			if !v.func then return end
			_selectedTab = k
			loadPanel( v.func )
        end
    end
end )

// Shield HUD // 
hook.Add( "HUDPaint", "ShieldSystem.ShieldCount", function()
	local p, w, h = LocalPlayer(), ScrW(), ScrH()
	if !p:HasShields() then return end
	local x, y = w*.436, h*.941
	local W, H = w*.12, h*.05
	draw.RoundedBox( 16, x, y, W, H, Color( 0, 0, 0, 220 ) )
	draw.SimpleText( "Active Shields: " .. p:GetShields(), "ui.30", (x)+w*.008, (y)+h*.011, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end )
// Shield HUD // 