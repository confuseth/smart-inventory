AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
 
include('shared.lua')
 
-- sound.Add( {
-- 	name = "washer_sound",
-- 	volume = 0.2,
-- 	sound = "ambient/water/water_run1.wav"
-- } )

sound.Add( {
	name = "machine_sound",
	volume = 0.2,
	sound = "ambient/machines/machine3.wav"
} )

function ENT:Initialize()
	self:SetModel( "models/props_computers/laptop.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 	self:SetUseType( SIMPLE_USE )
 	--self:SetDevice("")
 	self:SetPassword("")
 	self:SetSysName("Main")
 	self:SetMaterial("models/props_computers/server_rack/console_on")
 	self:SetShutdown(false)
 	self:SetUnlocked(true)
 	self:SetBeingHacked(false)
 	self.rackHP = 100
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(true);
	end
	self.emittingsound = CreateSound(self, "machine_sound")
	self.emittingsound:Play()
	self:SetTrigger(true)
end

function ENT:Use( activator, caller )
	if !IsValid(self:GetCurrentUser()) and !self:GetShutdown() and !self.blocked and !self:GetBeingHacked() then
		self:SetCurrentUser(caller)
		net.Start("calcViewRack")
		net.WriteEntity(self)
		net.Send(caller)
	else
		self.blocked = true
		self.emittingsound:Play()
		timer.Simple(2, function()
			if IsValid(self) then
				self:SetMaterial("models/props_computers/server_rack/console_on")
				self:SetShutdown(false)
				self.blocked = false
			end
		end)
	end
end

-- local delay = 4
-- function ENT:Think()
-- 	if self:GetBroken() then
-- 		if CurTime() < delay then return end
-- 		local p = self:GetPos()
-- 		local ef = EffectData()
-- 		ef:SetOrigin( p + self:GetAngles():Up() * math.random(15, 60)  )
-- 		ef:SetMagnitude(math.random(3, 4))
-- 		util.Effect( "ElectricSpark", ef )
-- 		delay = CurTime() + math.random(1, 3)
-- 	end
-- end

net.Receive("scp_laptop_shutdown", function(len, ply)
	local ent = net.ReadEntity()
	local bol = net.ReadBool()
	
	ent:SetUnlocked(bol)

	ent:SetMaterial("models/props_computers/server_rack/console")
	ent:SetShutdown(true)
	ent.emittingsound:Stop()
end)

net.Receive("scp_entitysetpassword", function(len, ply)
	local ent = net.ReadEntity()
	local str = net.ReadString()
	
	ent:SetPassword(str)
end)

-- function ENT:OnTakeDamage(dmg)
-- 	if self:GetBroken() then return end
-- 	if ( self.rackHP - dmg:GetDamage() ) <= 0 then
-- 		self:SetBroken(true)
--    		self.emittingsound:Stop()
-- 	else
-- 		self.rackHP = self.rackHP - dmg:GetDamage()
-- 	end
-- end

function ENT:OnRemove()
	if self.emittingsound then
   		self.emittingsound:Stop()
   	end
end;
