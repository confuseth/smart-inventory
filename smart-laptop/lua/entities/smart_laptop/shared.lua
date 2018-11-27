ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Laptop"
ENT.Author			= "confuseth"

ENT.Spawnable		= true
ENT.AdminOnly		= false

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "CurrentUser" )
	self:NetworkVar( "Bool", 0, "Broken" )
	self:NetworkVar( "Bool", 1, "Shutdown" )
	self:NetworkVar( "Bool", 2, "BeingHacked" )
	self:NetworkVar( "Bool", 3, "Hacked" )
	self:NetworkVar( "Bool", 4, "Unlocked" )
	self:NetworkVar( "String", 0, "Password" )
	self:NetworkVar( "String", 1, "SysName" )
end
