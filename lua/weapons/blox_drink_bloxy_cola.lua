AddCSLuaFile()

SWEP.PrintName = "Bloxy Cola"
SWEP.Base = "blox_base_consumable"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Description = "Warning: Bloxy Cola may be habit-forming."
SWEP.Tips = [[- Bloxy Cola gives you </color><color=255,120,120>lifesteal</color><color=150,150,150,255> on all your Bloxxers gear, making it an excellent self-sustaining consumable.

- While this gear is on cooldown, you will only receive a bit of health on drinking.
]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_bloxy_cola.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 80
SWEP.UseHands = true

SWEP.Slot = 5

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100

SWEP.AmmoRegen = true
SWEP.AmmoRegenInterval = 0.5
SWEP.AmmoRegenAmount = 1

SWEP.ConsumeMinClip = 10
SWEP.ConsumeDelay = 2 -- synced to the gulp sound
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
    if owner:Health() < owner:GetMaxHealth() then
        owner:SetHealth(math.min(owner:Health() + 5, owner:GetMaxHealth()))
    end
end