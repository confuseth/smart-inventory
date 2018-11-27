util.AddNetworkString("calcViewRack")
util.AddNetworkString("stop_calcViewRack")

util.AddNetworkString("scp_laptop_shutdown")
util.AddNetworkString("scp_entitysetunlocked")
util.AddNetworkString("scp_entitysetpassword")
util.AddNetworkString("scp_removeEntVGUI")

util.AddNetworkString("broadcast_consolemsg")
util.AddNetworkString("receive_consolemsg")

net.Receive("stop_calcViewRack", function(len, ply)
	local ent = net.ReadEntity()
	ent:SetCurrentUser(nil)
end) 

hook.Add("PlayerDeath", "_CloseOnDeath", function(ply)
	for k, v in pairs(ents.FindByClass("smart_laptop")) do
		if v:GetCurrentUser() then
			if v:GetCurrentUser() == ply then
				net.Start("scp_removeEntVGUI")
				net.WriteEntity(v)
				net.Send(ply)
				v:SetCurrentUser(nil)
			end
		end
	end	
end)

net.Receive("scp_entitysetunlocked", function(len, ply)
	local ent = net.ReadEntity()
	local bol = net.ReadBool()
	ent:SetUnlocked(bol)
end)