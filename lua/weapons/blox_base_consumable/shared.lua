AddCSLuaFile()

SWEP.PrintName = "Bloxxer's Arsenal Base Consumable"
SWEP.Base = "blox_base"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = false

SWEP.Author = "8Z"
SWEP.Instructions = "Left Click: Consume"

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_bloxy_cola.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

DEFINE_BASECLASS(SWEP.Base)

sound.Add({
    name = "BloxxersArsenal.BloxyCola.Draw",
    sound = "bloxxers_arsenal/drink/SodaCanOpening.wav",
    level = 70,
    channel = CHAN_ITEM,
})
sound.Add({
    name = "BloxxersArsenal.BloxyCola.Use",
    sound = "bloxxers_arsenal/drink/SlurpingSodaAhhhh.wav",
    level = 70,
    channel = CHAN_ITEM,
})

SWEP.DrawSound = Sound("BloxxersArsenal.BloxyCola.Draw")
SWEP.UseSound = Sound("BloxxersArsenal.BloxyCola.Use")

SWEP.ConsumeMinClip = -1
SWEP.ConsumeDelay = 0.5
SWEP.UseDelay = 3

SWEP.OffhandShowCooldown = false
function SWEP:GetHUDCooldownFraction(wep)
    return math.max(0, wep:GetNextOffhandEnd() - CurTime()) / self.UseDelay
end

SWEP.HoldType = "slam"

SWEP.OffhandUsable = true
function SWEP:OffhandAttack(wep)
    wep:SetNextOffhandEnd(CurTime() + self.UseDelay)
    self:SetNextPrimaryFire(CurTime() + self.UseDelay)
    self:SetNextConsumableEffect(CurTime() + self.ConsumeDelay)
    if IsFirstTimePredicted() then
        wep:DoLHIKAnimation(self.ViewModel, "offhand")
        self:EmitSound(self.UseSound)
    end
end

function SWEP:OffhandThink(wep)
    local curtime = CurTime()

    local effecttime = self:GetNextConsumableEffect()
    if effecttime > 0 and curtime > effecttime then
        self:ConsumeEffect()
        self:SetNextConsumableEffect(0)
    end
end

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 2, "NextConsumableEffect")
end

function SWEP:PrimaryAttack()
    if self.ConsumeMinClip > 0 and self:Clip1() < self.ConsumeMinClip then return end
    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)

    local anim = "consume"

    local vm = owner:GetViewModel()
    vm:SetPlaybackRate(1)
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    self:UpdateNextIdle()

    self:EmitSound(self.UseSound)
    self:SetNextPrimaryFire(CurTime() + self.UseDelay)
    self:SetNextConsumableEffect(CurTime() + self.ConsumeDelay)
end

function SWEP:SecondaryAttack()
end

function SWEP:ConsumeEffect()
    local owner = self:GetOwner()
    if owner:Health() < owner:GetMaxHealth() then
        owner:SetHealth(math.min(owner:Health() + 5, owner:GetMaxHealth()))
    end
end

function SWEP:Holster()
    if self:GetNextConsumableEffect() > CurTime() then return false end
    BaseClass.Holster(self)
    self:SetNextConsumableEffect(0)
    return true
end

function SWEP:Think()
    BaseClass.Think(self)

    local curtime = CurTime()

    local effecttime = self:GetNextConsumableEffect()
    if effecttime > 0 and curtime > effecttime then
        self:ConsumeEffect()
        self:SetNextConsumableEffect(0)
    end
end