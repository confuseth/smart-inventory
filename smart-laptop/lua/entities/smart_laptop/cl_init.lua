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

		drive.c = vgui.Create("DPanel", top)
		drive.c:Dock(FILL)
		drive.c:TDLib()
			:Background(Color(20,20,20,255))
			:Outline(Color(255, 255, 255, 255), 1)

		entity.console = drive.c:CreateConsole(entity.panels.frame, entity, "external") -- create console area

	end
end