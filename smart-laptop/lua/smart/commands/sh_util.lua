
local help = {}
help.input = "help"
help.color = Color(255,255,255,255)
help.description = "Display a list of commands that can be accessed by the user."

function help:runcmd(text, panel, entity)
	local cmd = string.match(text, "help%s+(%d+)") or ""
	cmd = string.Trim(cmd)
	local t = ""
	local n = 1
	local list = {}


	if cmd then

		panel:InsertColorChange( 255,155,15,255)
		panel:AppendText( "HELP: Here is an array of availible console commands:\n" )

	else

		panel:InsertColorChange( 255,155,15,255)
		panel:AppendText( "HELP: Showing availible console commands (Page 1 out of " .. n .. ") :\n" )
	end
	
	for k, v in pairs(COMMANDS) do

		if #k > 7 then
			t = t .. k .. "\t(" .. v.description .. ")" .. "\n"
		else
			t = t .. k .. "\t\t(" .. v.description .. ")" .. "\n"
		end
	end

	return t
end

CONSOLE:addCommand( "help" , help )

local name = {}
name.input = "name"
name.color = Color(255,55,55,255)
name.description = "Change the server's system name. Usage: name + 'string'."

function name:runcmd(text, panel, entity)
	local cmd = string.match(text, "name%s+(.+)") or ""
	cmd = string.Trim(cmd)
	local oldsysname = entity:GetSysName()
	entity:SetSysName(cmd)
	return oldsysname .. ": changed system name to: " .. cmd
end

CONSOLE:addCommand( "name" , name )

local clear = {}
clear.input = "clear"
clear.color = Color(255,55,55,255)
clear.description = "Clears the console entirely."

function clear:runcmd(text, panel, entity)
	panel:SetText("")
	return nil
end

CONSOLE:addCommand( "clear" , clear )

local shutdown = {}
shutdown.input = "shutdown"
shutdown.color = Color(255,55,55,255)
--shutdown.whitelist = { "control" }
shutdown.description = "Shutdowns the server."

function shutdown:runcmd(text, pnl, entity)
	hook.Remove("CalcView", "calcRackSpec")
	hook.Remove( "HUDShouldDraw", "HideHUD")
	hook.Remove( "Tick", "CheckPlayerEscapeLaptop")
	local pass = true
	entity.panels.frame:Close()
	if entity:GetPassword() then
		entity:SetUnlocked(false)
		pass = false
	end
	net.Start("scp_laptop_shutdown")
	net.WriteEntity(entity)
	net.WriteBool(pass)
	net.SendToServer()
	return nil
end

CONSOLE:addCommand( "shutdown" , shutdown )


local time = {}
time.input = "time"
time.color = Color(200,200,255,255)
--time.whitelist = { "control" , "external"}
time.description = "Display the current time and date in the console."
function time:runcmd(text)
	return os.date()
end

CONSOLE:addCommand( "time" , time )

local list = {}
list.input = "list"
list.color = Color(200,200,200,255)
list.description = "Lists contents of internal arrays. Usage: list + 'file'."
function list:runcmd(text, panel, entity)
	self.color = Color(255,30,30,255)
	local output = "ERROR: Incorrect usage of command. Usage: list + 'string'."
	local cmd = string.match(text, "list%s+(%w+)") or ""
	cmd = string.Trim(cmd)
	
	local temp = ""
	local iter = 0
	
	if (cmd == "file" or cmd == "files" ) and entity.files then
		for k, file_table in pairs(entity.files) do
			if (iter > 2) then
				iter = 1
				temp = temp .."\n\t" ..file_table.name
			else
				temp = temp .."\t" ..file_table.name
				iter = iter + 1
			end 
		end
		output = "Here is a list of all files:\n" ..temp
	-- elseif (cmd == "network" or cmd == "networks" ) and NETWORKS then
	-- 	for k, v in pairs(NETWORKS) do
	-- 		if (iter > 2) then
	-- 			iter = 1
	-- 			temp = temp .."\n\t" ..v.name
	-- 		else
	-- 			temp = temp .."\t" ..v.name
	-- 			iter = iter + 1
	-- 		end 
	-- 	end
	-- 	output = "Here is a list of all networks:\n" ..temp
	end


	return output
end
CONSOLE:addCommand( "list" , list )