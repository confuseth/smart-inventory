include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

net.Receive("scp_removeEntVGUI",function()
	local ent = net.ReadEntity()
	ent.panels.frame:Hide()
	hook.Remove("CalcView", "calcRackSpec")
	hook.Remove( "HUDShouldDraw", "HideHUD")
	hook.Remove( "Tick", "CheckPlayerEscapeLaptop")
	ent.panels.frame:Hide()
end)


function ENT:ReceiveMessages(origin, msg, color)
	if self.console then
		self.console:InsertColorChange( color.r or 255, color.b or 200, color.g or 200, color.a or 255 )
		self.console:AppendText( "* C:\\" .. (origin:GetSysName() or "Main") .. "\\User\\".. origin:EntIndex() .. "@AES \"" .. msg .. "\"\n" )
	end
end


function ENT:OpenLaptop()

	local entity = self
	entity.panels = entity.panels or {}

	if IsValid(entity.panels.frame) then
		entity.panels.frame:Show()
		hook.Add( "Tick", "CheckPlayerEscapeLaptop", function()
            if ( input.IsKeyDown( KEY_ESCAPE ) ) then
                if IsValid(entity.panels.frame) then
					hook.Remove("CalcView", "calcRackSpec")
					hook.Remove( "HUDShouldDraw", "HideHUD")
					hook.Remove( "Tick", "CheckPlayerEscapeLaptop")
					net.Start("stop_calcViewRack")
					net.WriteEntity(entity)
					net.SendToServer()
					entity.panels.frame:Hide()
                    gui.HideGameUI()
                end
            end
        end )
	else
		entity.panels.frame = vgui.Create("DFrame")
		entity.panels.frame:SetSize(ScrW(),ScrH())
		entity.panels.frame:Center()
		entity.panels.frame:MakePopup()
		entity.panels.frame:SetKeyboardInputEnabled(true)
		entity.panels.frame:SetTitle("")
		entity.panels.frame:SetDraggable(false)
		entity.panels.frame:ShowCloseButton(false)
		entity.panels.frame.OnClose = function()
			hook.Remove("CalcView", "calcRackSpec")
			hook.Remove( "HUDShouldDraw", "HideHUD")
			hook.Remove( "Tick", "CheckPlayerEscapeLaptop")
			net.Start("stop_calcViewRack")
			net.WriteEntity(entity)
			net.SendToServer()
		end
		entity.panels.frame.Paint = function()
		end

		hook.Add( "Tick", "CheckPlayerEscapeLaptop", function()
            if ( input.IsKeyDown( KEY_ESCAPE ) ) then
                if IsValid(entity.panels.frame) then
					hook.Remove("CalcView", "calcRackSpec")
					hook.Remove( "HUDShouldDraw", "HideHUD")
					hook.Remove( "Tick", "CheckPlayerEscapeLaptop")
					net.Start("stop_calcViewRack")
					net.WriteEntity(entity)
					net.SendToServer()
					entity.panels.frame:Hide()
                    gui.HideGameUI()
                end
            end
        end )

		local top = vgui.Create("DPanel", entity.panels.frame)
		top:SetSize(entity.panels.frame:GetWide()/1.5, entity.panels.frame:GetTall()/1.5)
		top:SetPos(entity.panels.frame:GetWide()/6.5, entity.panels.frame:GetTall()/10.5)
		top:TDLib()
			:Background(Color(20,20,20,255))
			:Outline(Color(255, 255, 255, 255), 3)

		local drive = {}
		drive.f = vgui.Create("DPanel", top)
		drive.f:SetPos(15,15)
		drive.f:DivWide(4)
		drive.f:DivTall(1)
		drive.f:SetTall(drive.f:GetTall() - 30)
		drive.f:TDLib()
			:Background(Color(20,20,20,255))
			:Outline(Color(255, 255, 255, 255), 1)

		local drive = {}
		drive.f = vgui.Create("DPanel", top)
		drive.f:SetPos(15,15)
		drive.f:DivWide(4)
		drive.f:DivTall(1)
		drive.f:SetTall(drive.f:GetTall() - 30)
		drive.f:TDLib()
			:Background(Color(20,20,20,255))
			:Outline(Color(255, 255, 255, 255), 1)

		drive.c = vgui.Create("DPanel", top)
		drive.c:Dock(FILL)
		drive.c:TDLib()
			:Background(Color(20,20,20,255))
			:Outline(Color(255, 255, 255, 255), 1)

		entity.console = drive.c:CreateConsole(entity.panels.frame, entity, "external") -- create console area

		local name_slot = vgui.Create("DPanel", drive.f )
		name_slot:SetPos(0,0)
		name_slot:DivWide(1)
		name_slot:SetTall(25)
		name_slot:TDLib()
			:Background(Color(20,20,20,255))
			:Outline(Color(255, 255, 255, 255), 1)
			:Text("EXTERNAL DRIVES", "DebugFixed", Color(255, 255, 255), TEXT_ALIGN_CENTER)
			
		-- if entity:GetExtDrive() then
			
		-- 	drive.unamed = vgui.Create("DButton", drive.f )
		-- 	drive.unamed:SetWide(drive.f:GetWide() - 12)
		-- 	drive.unamed:SetPos(6, name_slot:GetTall() + 6)
		-- 	drive.unamed:SetContentAlignment(4)
		-- 	drive.unamed:SetTall(25)

		-- 	function drive.unamed:DoClick()
		-- 		for k, v in pairs(drive) do
		-- 			v.selected = false
		-- 		end
		-- 		entity.selected = true
		-- 		console:InsertColorChange( 255, 155, 155, 255)
		-- 		--print(ITEMS[entity:GetExternal()])
		-- 		if ITEMS[entity:GetExternal()].Drive == "0:" then
		-- 			console:AppendText( ITEMS[entity:GetExternal()].Drive ..  " Unassigned External Drive; Set a name with 'ext_set'.\n" )
		-- 		else
		-- 			console:AppendText( ITEMS[entity:GetExternal()].Drive ..  " Assigned External Drive; Use 'ext_help' for help.\n" )
		-- 		end
		-- 	end
		-- 	drive.unamed.Paint = function(s,w,h)
		-- 		if s.selected then
		-- 			surface.SetDrawColor(Color(255,255,255, 10))
		-- 			surface.DrawRect(0, 0, w, h)
		-- 		end
		-- 	end
		-- 	drive.unamed:TDLib()
		-- 		:Outline(Color(255,255,255), 1)
		-- 		:FadeHover(Color(255,255,255,10))
		-- 		:Text(spacer .. ITEMS[entity:GetExternal()].Drive .. " EXTERNAL-DRIVE", "DebugFixed", Color(255, 255, 255), TEXT_ALIGN_LEFT, 10)
		-- end
	end
end



--[[-------------------------------------------------------------------------
drive.unamed.Paint = function(s,w,h)
			s.len = 0
			surface.SetDrawColor(Color(255,255,255))
			for i = 0, s:GetWide(), s:GetWide()/16 do
				surface.DrawRect(s.len + i, 0 , s:GetWide()/(16*4), 1)
				surface.DrawRect( s:GetWide() - i - s:GetWide()/(16*4), 0, s:GetWide()/(16*4) + 1, 1)
			end
			for i = 0, s:GetWide(), s:GetWide()/16 do
				surface.DrawRect(s.len + i, s:GetTall() - 1, s:GetWide()/(16*4), 1)
				surface.DrawRect( s:GetWide() - i - s:GetWide()/(16*4), s:GetTall() - 1, s:GetWide()/(16*4) + 1, 1)
			end
			surface.DrawRect(s:GetWide() - 1, 0, 1, s:GetTall())
			surface.DrawRect(0, 0, 1, s:GetTall())
			if s.selected then
				surface.SetDrawColor(Color(255,255,255, 10))
				surface.DrawRect(0, 0, w, h)
			end
		end
---------------------------------------------------------------------------]]