local password = {}
password.input = "password"
password.color = Color(50,255,50,255)
--password.whitelist = {"control" , "external", "multiple"}
password.description = "Create a password. Usage: password + 'string'."
function password:runcmd(text, panel, entity)
	local cmd = string.match(text, "password%s+(%w+)") or ""
	cmd = string.Trim(cmd)

	if cmd then
		net.Start("scp_entitysetpassword")
		net.WriteEntity(entity)
		net.WriteString(cmd)
		net.SendToServer()
		output = entity:GetSysName() .. ": Password has been set."
	end

	return output
end

CONSOLE:addCommand( "password" , password )

local login = {}
login.input = "login"
login.color = Color(50,255,50,255)
--login.whitelist = {"control" , "external", "multiple"}
login.description = "Login into the device. Usage: login + 'string'."
function login:runcmd(text, panel, entity)
	local cmd = string.match(text, "login%s+(%w+)") or ""
	cmd = string.Trim(cmd)
	local output = "ERROR: Incorrect password."
	if cmd then
		if entity:GetPassword() == cmd and !entity:GetUnlocked() then
			self.color = Color(50,255,50,255)
			output = entity:GetSysName() .. ": Access granted."
			net.Start("scp_entitysetunlocked")
			net.WriteEntity(entity)
			net.WriteBool(true)
			net.SendToServer()
		elseif entity:GetUnlocked() and string.match(entity:GetPassword(), "(.+)") then
			self.color = Color(50,255,50,255)
			output = entity:GetSysName() .. ": You are already logged in."
		elseif entity:GetUnlocked() and string.match(entity:GetPassword(), "") then
			self.color = Color(255,20,20)
			output = "ERROR: No password found! Try creating a password first."
		else
			self.color = Color(255,20,20)
		end
	end

	return output
end

CONSOLE:addCommand( "login" , login )