AddCSLuaFile()

BLOXXERS_ARSENAL = {}

---------------------------------------------------------------------------------------------------
-- Custom Damage Types, set in SetDamageCustom and GetDamageCustom to indicate certain interactions
---------------------------------------------------------------------------------------------------

-- If this flag is not set, no Bloxxer's Arsenal interactions will occur (something else is using custom damage types)
-- I'm pretty sure literally nobody uses this feature, but in case of conflict this can be modified
BLOXXERS_ARSENAL.CDMG_ACTIVE = 32768

-- This damage is capable of reflecting projectiles (e.g. Sword hitting Superball)
BLOXXERS_ARSENAL.CDMG_REFLECT = 1