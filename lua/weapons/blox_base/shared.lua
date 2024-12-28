SWEP.PrintName = "Bloxxer's Arsenal Base"
SWEP.Category = "Bloxxer's Arsenal"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

SWEP.PogoLimit = 6
SWEP.PogoCounter = 0
SWEP.PogoMaxVelocity = 200
SWEP.PogoMinVelocity = -400

SWEP.DrawAmmo = false

SWEP.DrawSound = ""

SWEP.HoldType = "pistol"

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextIdle")
end

function SWEP:UpdateNextIdle()
    local vm = self:GetOwner():GetViewModel()
    self:SetNextIdle(CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate())
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
    self:SetHoldType(self.HoldType)
    local speed = 1
    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("draw"))
    vm:SetPlaybackRate(speed)
    -- self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / speed)
    -- self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() / speed)
    self:UpdateNextIdle()
    self:SetNextPrimaryFire(CurTime())
    self:SetNextSecondaryFire(CurTime())
    if IsFirstTimePredicted() then
        self:EmitSound(self.DrawSound)
    end

    return true
end

--local cvar = GetConVar("sv_defaultdeployspeed")
function SWEP:Holster()
    --local vm = self:GetOwner():GetViewModel()
    --vm:SetPlaybackRate(cvar:GetFloat()) -- If we holster to a HL2 weapon, this is required to give it the proper deploy speed
    return true
end

function SWEP:Think()
    if IsValid(self:GetOwner()) and self:GetOwner():OnGround() then
        self.PogoCounter = 0
    end
end

local upvector = Vector(0, 0, 1)
function SWEP:AllowPogo()
    if not IsValid(self:GetOwner()) or not self:GetOwner():IsPlayer() then return false end
    local vz = self:GetOwner():GetVelocity().z

    return self.PogoCounter < self.PogoLimit
            and self:GetOwner():GetAimVector():Dot(upvector) <= -0.707
            and not self:GetOwner():OnGround() and vz >= self.PogoMinVelocity and vz <= self.PogoMaxVelocity
end

AddCSLuaFile()
local searchdir = "weapons/blox_base"

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