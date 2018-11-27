AddCSLuaFile()

net.Receive("calcViewRack", function()
	local ent = net.ReadEntity()
	
	hook.Add( "HUDShouldDraw", "HideHUD", function(name)
		return false
	end)

	local lerp_port = 0

	hook.Add( "CalcView", "calcRackSpec", function( ply, pos, angles, fov )
		--lerp_port = Lerp(0.06, lerp_port, 20)
		local ang = ent:GetAngles()
		ang:RotateAroundAxis(ent:GetAngles():Up(), -90)
		ang:RotateAroundAxis(ent:GetAngles():Forward(), 20 )

		local view = {}
		view.origin = ent:GetPos() - ent:GetAngles():Right() * 6 + ent:GetAngles():Up() * 10
		view.angles = ang
		view.fov = fov
		view.drawviewer = true
		return view
	end)
	ent:OpenLaptop()
end)
