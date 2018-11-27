if CLIENT then
	CONSOLE = CONSOLE or {}
    COMMANDS = COMMANDS or {}

	local meta = FindMetaTable("Panel")

	-- local commands = {
	-- 	["time"] = true,
	-- 	["write%s+(.+)"] = true
	-- }

	function meta:ConsoleEntry(text, entity, specific)
		if !entity:GetUnlocked() then
			for k, v in pairs(COMMANDS) do
				if v.input == "login" then
					local exe = v:runcmd(text, self, entity)
					if exe then
						self:InsertColorChange( v.color.r or 255, v.color.g or 255, v.color.b or 255, v.color.a or 255)
						self:AppendText( exe .."\n" )
					end
					break
				end
			end
		else
			for k, v in pairs(COMMANDS) do
				if string.StartWith(text, v.input) then
					if v.whitelist then
						local exe = v:runcmd(text, self, entity)
						break
					else
						local exe = v:runcmd(text, self, entity)
						if exe then
							self:InsertColorChange( 225, 225, 225, 255 )
							self:AppendText( "C:\\" .. (entity:GetSysName() or "Main") .. "\\User\\".. entity:EntIndex() .. "@AES> " .. text .. "\n" )
							self:InsertColorChange( v.color.r or 255, v.color.g or 255, v.color.b or 255, v.color.a or 255)
							self:AppendText( exe .."\n" )
						end
						break
					end
				end
			end
		end
	end

	function meta:CreateConsole(main_frame, entity, specific)

		local selec = vgui.Create("DPanel", self)
		selec:SetPos(self:GetWide() + 30, 15)
		selec:Dock(FILL)
		selec:SetTall(selec:GetTall() - 30)
		selec:SetWide(selec:GetWide() - 45)
		selec:TDLib()
			:Background(Color(20,20,20,255))
			:Outline(Color(255, 255, 255, 255), 1)

		local richtext = vgui.Create( "RichText", selec )
		richtext:Dock( FILL )
		richtext:DockMargin(0,0,0,5)
		richtext.parent = main_frame:GetParent()
		function richtext:PerformLayout()
			self:SetFontInternal( "DebugFixed" )
		end
		
		local tx = vgui.Create( "DTextEntry", selec ) 
		tx:Dock(BOTTOM)
		tx:SetHistoryEnabled( true )
		tx:SetText( "" )
		tx:RequestFocus()
		tx.OnEnter = function( self )
			richtext:ConsoleEntry(self:GetValue(), entity, specific)
			self:SetText( "" )
			self:RequestFocus()
		end
		return richtext
	end
	
end	