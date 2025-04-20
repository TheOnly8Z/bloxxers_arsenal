AddCSLuaFile()

SWEP.PrintName = "Cheezburger"
SWEP.Base = "blox_base_consumable"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Description = "u can haz cheezburger!"
SWEP.Instructions = "Left Click: Consume \nRight Click: Drop"
SWEP.Tips = [[- The Cheezburger will fully restore your </color><color=120,255,120>health</color><color=150,150,150,255> plus </color><color=120,255,120>overheal</color><color=150,150,150,255> when consumed. It can also be dropped on the ground for allies to pick up, though they will not benefit from overheal.
]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_cheezburger.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 80
SWEP.UseHands = true

SWEP.Slot = 5

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100

SWEP.AmmoRegen = true
SWEP.AmmoRegenInterval = 1
SWEP.AmmoRegenAmount = 1

SWEP.ConsumeMinClip = 100
SWEP.ConsumeDelay = 1 -- synced to the animation
SWEP.UseDelay = 4

SWEP.OffhandShowCooldown = true
SWEP.OffhandShowClip = true
function SWEP:GetHUDCooldownFraction(wep)
    return 1 - math.Clamp(self:Clip1() / self:GetMaxClip1(), 0, 1)
end
function SWEP:GetHUDClip(wep)
    return math.Round(self:Clip1() / self:GetMaxClip1() * 100) .. "%"
end

function SWEP:ConsumeEffect()
    self:SetClip1(0)
    local owner = self:GetOwner()
    if owner:Health() < (owner:GetMaxHealth() + 1) then
        owner:SetHealth(owner:GetMaxHealth() + 25)
    end
end

function SWEP:PrimaryAttack()
    if self.ConsumeMinClip > 0 and self:Clip1() < self.ConsumeMinClip then return end
    local owner = self:GetOwner()
	if owner:Health() >= owner:GetMaxHealth() then return end
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

sound.Add({
    name = "BloxxersArsenal.Burger.CanIHaz",
    sound = "bloxxers_arsenal/cheezburger/canihaz.wav",
    level = 70,
    channel = CHAN_WEAPON,
})

sound.Add({
    name = "BloxxersArsenal.Burger.Mmm",
    sound = "bloxxers_arsenal/cheezburger/mmm.wav",
    level = 70,
    channel = CHAN_WEAPON,
})

SWEP.UseSound = Sound("BloxxersArsenal.Burger.Mmm")
SWEP.DrawSound = Sound("BloxxersArsenal.Burger.CanIHaz")