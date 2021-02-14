﻿AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
require("caf_util")
DEFINE_BASECLASS("base_sb_environment")

function ENT:Initialize()
	BaseClass.Initialize(self)

	self.sbenvironment.temperature2 = 0
	self.sbenvironment.sunburn = false
	self.sbenvironment.unstable = false

	self:DrawShadow(false)

	if CAF then
		self.caf = self.caf or {}
		self.caf.custom = self.caf.custom or {}
		self.caf.custom.canreceivedamage = false
		self.caf.custom.canreceiveheatdamage = false
	end
end

function ENT:SBEnvPhysics(ent)
	ent:SetCollisionBounds(self.mins, self.maxs)
	ent:PhysicsInitBox(self.mins, self.maxs)
	ent:SetNotSolid(true)
end

function ENT:GetSunburn()
	return self.sbenvironment.sunburn
end

function ENT:GetUnstable()
	return self.sbenvironment.unstable
end

function ENT:SetFlags(flags)
	if not flags or type(flags) ~= "number" then return end
	self.sbenvironment.unstable = caf_util.isBitSet(flags, 1)
	self.sbenvironment.sunburn = caf_util.isBitSet(flags, 2)
end

function ENT:Unstable()

end

function ENT:GetPriority()
	return 1
end

function ENT:CreateEnvironment(ent, mins, maxs, gravity, atmosphere, pressure, temperature, temperature2, o2, co2, n, h, flags, name)
	--needs a parent!
	if not ent then
		self:Remove()
	end

	self:SetParent(ent)
	self:SetFlags(flags)

	self.mins = mins
	self.maxs = maxs

	--set temperature2 if given
	if temperature2 and type(temperature2) == "number" then
		self.sbenvironment.temperature2 = temperature2
	end

	BaseClass.CreateEnvironment(self, gravity, atmosphere, pressure, temperature, o2, co2, n, h, name)
end

function ENT:UpdateEnvironment(radius, gravity, atmosphere, pressure, temperature, o2, co2, n, h, temperature2, flags)
	self:SetFlags(flags)

	if radius and type(radius) == "number" then
		self:UpdateSize(self.sbenvironment.size, radius)
	end

	--set temperature2 if given
	if temperature2 and type(temperature2) == "number" then
		self.sbenvironment.temperature2 = temperature2
	end

	BaseClass.UpdateEnvironment(self, gravity, atmosphere, pressure, temperature, o2, co2, n, h)
end

function ENT:IsPlanet()
	return true
end

function ENT:CanTool()
	return false
end

function ENT:GravGunPunt()
	return false
end

function ENT:GravGunPickupAllowed()
	return false
end

function ENT:Think()
	self:Unstable()
	self:NextThink(CurTime() + 1)

	return true
end

function ENT:PosInEnvironment(pos, other)
	if other and other == self then return other end

	local min = self.mins + self:GetPos()
	local max = self.maxs + self:GetPos()

	if (pos.x < max.x and pos.x > min.x) and (pos.y < max.y and pos.y > min.y) and (pos.z < max.z and pos.z > min.z) then
		if other then
			if other:GetPriority() < self:GetPriority() then
				return self
			elseif other:GetPriority() == self:GetPriority() then
				if self:GetSize() > other:GetSize() then return other end
			else
				return other
			end
		end

		return self
	end

	return other
end