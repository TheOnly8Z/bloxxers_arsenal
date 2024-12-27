SWEP.PrintName = "Bloxxer's Arsenal Base Throwing"
SWEP.Base = "blox_base"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = false

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_superball.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

DEFINE_BASECLASS(SWEP.Base)

SWEP.ThrowEntity = "sent_ball"
SWEP.ThrowForce = 500
SWEP.ThrowCooldown = 1
SWEP.ThrowDelay = 0.1
SWEP.ThrowOriginOffset = Vector(8, 8, 8)

SWEP.DrawSound = Sound("BloxxersArsenal.Sword.Draw")
SWEP.ThrowSound = Sound("BloxxersArsenal.Sword.Slash")

SWEP.HoldType = "melee"

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextIdle")
    self:NetworkVar("Float", 1, "NextThrowRelease")
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)

    local anim = "throw"

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    self:UpdateNextIdle()

    self:SetNextPrimaryFire(CurTime() + self.ThrowCooldown)
    self:SetNextSecondaryFire(CurTime() + self.ThrowCooldown)

    self:SetNextThrowRelease(CurTime() + self.ThrowDelay)

end

function SWEP:SecondaryAttack()
end

function SWEP:ThrowProjectile()
    if CLIENT then return end
    local owner = self:GetOwner()
    local proj = ents.Create(self.ThrowEntity)
    if not IsValid(proj) then return end

    local origin = owner:GetShootPos()
    if self.ThrowOriginOffset then
        local ang = owner:GetAimVector():Angle()
        origin:Add(ang:Right() * self.ThrowOriginOffset.x)
        origin:Add(ang:Forward() * self.ThrowOriginOffset.y)
        origin:Add(ang:Up() * self.ThrowOriginOffset.z)
    end

    proj:SetPos(origin)
    proj:SetOwner(owner)
    proj:Spawn()
    proj:GetPhysicsObject():SetVelocity(owner:GetAimVector() * self.ThrowForce)
end


function SWEP:Think()
    BaseClass.Think(self)

    local curtime = CurTime()

    local releasetime = self:GetNextThrowRelease()
    if releasetime > 0 and curtime > releasetime then
        self:ThrowProjectile()
        self:SetNextThrowRelease(0)
    end
end

function SWEP:Holster()
    BaseClass.Deploy(self)

    self:SetNextThrowRelease(0)
    return true
end


AddCSLuaFile()
local searchdir = "weapons/blox_base_throw"

local function autoinclude(dir)
    local files, dirs = file.Find(searchdir .. "/*.lua", "LUA")

    for _, filename in pairs(files) do
        if filename == "shared.lua" then continue end
        local luatype = string.sub(filename, 1, 2)

        if luatype == "sv" then
            if SERVER then
                include(dir .. "/" .. filename)
            end
        elseif luatype == "cl" then
            AddCSLuaFile(dir .. "/" .. filename)

            if CLIENT then
                include(dir .. "/" .. filename)
            end
        else
            AddCSLuaFile(dir .. "/" .. filename)
            include(dir .. "/" .. filename)
        end
    end

    for _, path in pairs(dirs) do
        autoinclude(dir .. "/" .. path)
    end
end

autoinclude(searchdir)