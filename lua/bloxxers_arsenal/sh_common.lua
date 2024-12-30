
---------------------------------------------------------------------------------------------------
-- Custom Damage Types, set in SetDamageCustom and GetDamageCustom to indicate certain interactions
---------------------------------------------------------------------------------------------------

-- If this flag is not set, no Bloxxer's Arsenal interactions will occur (something else is using custom damage types)
-- I'm pretty sure literally nobody uses this feature, but in case of conflict this can be modified
BLOXXERS_ARSENAL.CDMG_ACTIVE = 32768

-- This damage is capable of reflecting projectiles (e.g. Sword hitting Superball)
BLOXXERS_ARSENAL.CDMG_REFLECT = 1

-- This damage cannot hurt its attacker, and will instead launch them (e.g. Timebomb/Rocket explosions)
BLOXXERS_ARSENAL.CDMG_BLASTJUMP = 2


BLOXXERS_ARSENAL.LHIKBones = {
    "ValveBiped.Bip01_L_UpperArm",
    "ValveBiped.Bip01_L_Forearm",
    "ValveBiped.Bip01_L_Wrist",
    "ValveBiped.Bip01_L_Ulna",
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Bip01_L_Finger4",
    "ValveBiped.Bip01_L_Finger41",
    "ValveBiped.Bip01_L_Finger42",
    "ValveBiped.Bip01_L_Finger3",
    "ValveBiped.Bip01_L_Finger31",
    "ValveBiped.Bip01_L_Finger32",
    "ValveBiped.Bip01_L_Finger2",
    "ValveBiped.Bip01_L_Finger21",
    "ValveBiped.Bip01_L_Finger22",
    "ValveBiped.Bip01_L_Finger1",
    "ValveBiped.Bip01_L_Finger11",
    "ValveBiped.Bip01_L_Finger12",
    "ValveBiped.Bip01_L_Finger0",
    "ValveBiped.Bip01_L_Finger01",
    "ValveBiped.Bip01_L_Finger02"
}