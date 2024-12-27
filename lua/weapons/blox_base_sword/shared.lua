SWEP.PrintName = "BLOXXERS' Arsenal Sword Base"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = false

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_sword.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

SWEP.DrawAmmo = false

sound.Add({
    name = "BloxxersArsenal.Sword.Slash",
    sound = "bloxxers_arsenal/sword/slash.wav",
    level = 70,
    channel = CHAN_WEAPON,
})
sound.Add({
    name = "BloxxersArsenal.Sword.Lunge",
    sound = "bloxxers_arsenal/sword/lunge.wav",
    level = 70,
    channel = CHAN_WEAPON,
})
sound.Add({
    name = "BloxxersArsenal.Sword.Draw",
    sound = "bloxxers_arsenal/sword/draw.wav",
    level = 70,
    channel = CHAN_WEAPON,
})
sound.Add({
    name = "BloxxersArsenal.Sword.Pogo",
    sound = "weapons/knife/knife_hitwall1.wav",
    level = 70,
    channel = CHAN_ITEM,
})
sound.Add({
    name = "BloxxersArsenal.Sword.PogoEnd",
    sound = "physics/plastic/plastic_box_impact_hard1.wav",
    level = 70,
    channel = CHAN_ITEM,
})

SWEP.DrawSound = Sound("BloxxersArsenal.Sword.Draw")
SWEP.SlashSound = Sound("BloxxersArsenal.Sword.Slash")
SWEP.LungeSound = Sound("BloxxersArsenal.Sword.Lunge")
SWEP.PogoSound = Sound("BloxxersArsenal.Sword.Pogo")
SWEP.PogoEndSound = Sound("BloxxersArsenal.Sword.PogoEnd")

SWEP.HitDistance = 96
SWEP.HitDistanceLunge = 128

SWEP.HitMaxTargets = 0
SWEP.HitDelay = 0.1
SWEP.HitLingerTime = 0.08
SWEP.HitLingerTimeLunge = 0.02
SWEP.HitForceScale = 100
SWEP.SwingCooldown = 0.3
SWEP.SwingCooldownLunge = 0.75

SWEP.ComboCount = 2
SWEP.ComboResetTime = 0.3

SWEP.PogoLimit = 6
SWEP.PogoForce = 250
SWEP.PogoForceLunge = 500

SWEP.PogoCounter = 0
SWEP.HitCounter = 0

SWEP.HitSizeMin = {
    Min = Vector(-0.5, -0.5, -0.5),
    Max = Vector(0.5, 0.5, 0.5)
}

SWEP.HitSize = {
    Min = Vector(-64, -64, -8),
    Max = Vector(64, 64, 8)
}

SWEP.HitSizeLunge = {
    Min = Vector(-10, -10, -8),
    Max = Vector(10, 10, 8)
}

SWEP.HitDamage = 30
SWEP.ComboDamage = 60

SWEP.HitEntities = {}

local upvector = Vector(0, 0, 1)

function SWEP:Initialize()
    self:SetHoldType("knife")
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextMeleeAttack")
    self:NetworkVar("Float", 1, "NextIdle")
    self:NetworkVar("Float", 2, "NextMeleeAttackEnd")
    self:NetworkVar("Int", 2, "Combo")
end

function SWEP:UpdateNextIdle()
    local vm = self:GetOwner():GetViewModel()
    self:SetNextIdle(CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate())
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)

    local anim = "slash1"
    if self:GetCombo() == 1 then
        anim = "slash2"
    elseif self:GetCombo() == 2 then
        anim = "lunge"
    end

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    self:UpdateNextIdle()
    self:SetNextMeleeAttack(CurTime() + self.HitDelay)

    if IsFirstTimePredicted() then
        self.HitEntities = {self:GetOwner()}
        self.HitCounter = 0
    end

    if anim == "lunge" then
        self:EmitSound(self.LungeSound)
        self:SetNextPrimaryFire(CurTime() + self.SwingCooldownLunge)
        self:SetNextSecondaryFire(CurTime() + self.SwingCooldownLunge)
        self:SetNextMeleeAttackEnd(CurTime() + self.HitDelay + self.HitLingerTime)
    else
        self:EmitSound(self.SlashSound)
        self:SetNextPrimaryFire(CurTime() + self.SwingCooldown)
        self:SetNextSecondaryFire(CurTime() + self.SwingCooldown)
        self:SetNextMeleeAttackEnd(CurTime() + self.HitDelay + self.HitLingerTime)
    end
end

function SWEP:SecondaryAttack()
end

local phys_pushscale = GetConVar("phys_pushscale")

function SWEP:DealDamage(initial)
    local owner = self:GetOwner()
    local anim = self:GetSequenceName(owner:GetViewModel():GetSequence())

    owner:LagCompensation(true)

    local dist = anim == "lunge" and self.HitDistanceLunge or self.HitDistance
    local hull = anim == "lunge" and self.HitSizeLunge or self.HitSize

    -- Initial hit is also a hull trace so it does not trigger hitgroup multipliers
    local tr = util.TraceHull({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * dist,
        mins = self.HitSizeMin.Min,
        maxs = self.HitSizeMin.Max,
        filter = self.HitEntities,
        mask = MASK_SHOT_HULL
    })

    if not IsValid(tr.Entity) then
        tr = util.TraceHull({
            start = owner:GetShootPos(),
            endpos = owner:GetShootPos() + owner:GetAimVector() * dist,
            filter = self.HitEntities,
            mins = hull.Min,
            maxs = hull.Max,
            mask = MASK_SHOT_HULL
        })
    end

    -- We need the second part for single player because SWEP:Think is ran shared in SP
    -- if tr.Hit and not (game.SinglePlayer() and CLIENT) then
    --     self:EmitSound(self.PogoSound)
    -- end

    local scale = phys_pushscale:GetFloat()

    if SERVER and IsValid(tr.Entity) and tr.Entity:Health() > 0 and (self.HitMaxTargets == 0 or self.HitCounter < self.HitMaxTargets) then
        local dmginfo = DamageInfo()
        local attacker = owner

        if not IsValid(attacker) then
            attacker = self
        end

        dmginfo:SetAttacker(attacker)
        dmginfo:SetInflictor(self)
        if (tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot()) then
            dmginfo:SetDamageType(DMG_SLASH) -- this seems to significantly amplify push force on props
        end
        local dmg = self.HitDamage

        if anim == "slash2" then
            dmginfo:SetDamageForce(owner:GetRight() * 9000 * scale + owner:GetForward() * 9000 * scale) -- Yes we need those specific numbers
        elseif anim == "slash1" then
            dmginfo:SetDamageForce(owner:GetRight() * -9000 * scale + owner:GetForward() * 9000 * scale)
        elseif anim == "lunge" then
            dmginfo:SetDamageForce(owner:GetUp() * 9000 * scale + owner:GetForward() * 12000 * scale)
            dmg = self.ComboDamage
        end

        dmginfo:SetDamage(istable(dmg) and math.random(dmg[1], dmg[2]) or dmg)
        SuppressHostEvents(NULL) -- Let the breakable gibs spawn in multiplayer on client
        -- tr.Entity:TakeDamageInfo(dmginfo)
        tr.Entity:DispatchTraceAttack(dmginfo, tr, owner:GetAimVector())
        SuppressHostEvents(owner)
        hit = true

        self.HitCounter = self.HitCounter + 1
        if self.HitMaxTargets > 0 and self.HitCounter >= self.HitMaxTargets then
            self:SetNextMeleeAttackEnd(0)
        end

    elseif tr.HitWorld and initial then
        if IsFirstTimePredicted() and tr.HitNormal:Dot(upvector) >= 0 and self:AllowPogo() then
            self.PogoCounter = self.PogoCounter + 1
            if SERVER then
                self:GetOwner():SetVelocity(Vector(0, 0, self:GetOwner():GetVelocity().z * -1 + (anim == "lunge" and self.PogoForceLunge or self.PogoForce)))
            end
            if not (game.SinglePlayer() and CLIENT) then
                if self.PogoCounter >= self.PogoLimit then
                    self:EmitSound(self.PogoEndSound)
                else
                    self:EmitSound(self.PogoSound)
                end
            end
        end
    end

    if IsValid(tr.Entity) then
        local phys = tr.Entity:GetPhysicsObject()

        if IsValid(phys) then
            phys:ApplyForceOffset(owner:GetAimVector() * self.HitForceScale * phys:GetMass() * scale, tr.HitPos)
        end
    end

    if initial and SERVER then
        if anim ~= "lunge" then
            self:SetCombo(self:GetCombo() + 1)
        else
            self:SetCombo(0)
        end
    end

    owner:LagCompensation(false)

    if SERVER and IsValid(tr.Entity) then
        table.insert(self.HitEntities, tr.Entity)
    end
end

--local sv_deployspeed = GetConVar("sv_defaultdeployspeed")

function SWEP:Deploy()
    local speed = 1 --sv_deployspeed:GetFloat()
    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("draw"))
    vm:SetPlaybackRate(speed)
    self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / speed)
    self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() / speed)
    self:UpdateNextIdle()

    if IsFirstTimePredicted() then
        self:EmitSound(self.DrawSound)
    end

    if SERVER then
        self:SetCombo(0)
    end

    return true
end

function SWEP:Holster()
    self:SetNextMeleeAttack(0)

    return true
end

function SWEP:Think()
    local curtime = CurTime()

    if IsValid(self:GetOwner()) and self:GetOwner():OnGround() then
        self.PogoCounter = 0
    end

    --[[
    if idletime > 0 and curtime > idletime then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0" .. math.random(1, 2)))
        self:UpdateNextIdle()
    end
    ]]

    local meleetime = self:GetNextMeleeAttack()
    local meleeendtime = self:GetNextMeleeAttackEnd()
    if meleetime > 0 and curtime > meleetime then
        self:DealDamage(true)
        self:SetNextMeleeAttack(0)
    elseif meleeendtime > 0 and curtime <= meleeendtime then
        self:DealDamage(false)
    end

    if SERVER and curtime > self:GetNextPrimaryFire() + self.ComboResetTime then
        self:SetCombo(0)
    end
end

function SWEP:AllowPogo()
    if not IsValid(self:GetOwner()) or not self:GetOwner():IsPlayer() then return false end
    local vz = self:GetOwner():GetVelocity().z

    return self.PogoCounter < self.PogoLimit
            and self:GetOwner():GetAimVector():Dot(upvector) <= -0.707
            and not self:GetOwner():OnGround() and vz >= -400 and vz <= 200
end

AddCSLuaFile()
local searchdir = "weapons/blox_base_sword"

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