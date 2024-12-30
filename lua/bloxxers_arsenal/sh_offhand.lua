local Player = FindMetaTable("Player")

-- Slot 0: Reload
-- Slot 1: Flashlight
-- Slot 2: Suitzoom
-- Slot 3: 
BLOXXERS_ARSENAL.MAX_OFFHAND_SLOTS = 4

function Player:Blox_GetOffhandClass(slot)
    if not slot or slot < 0 or slot >= BLOXXERS_ARSENAL.MAX_OFFHAND_SLOTS then return end

    return self:GetNW2String("Blox_Offhand_" .. slot)
end

function Player:Blox_GetOffhandWeapon(slot)
    local class = self:Blox_GetOffhandClass(slot)
    if class then
        return self:GetWeapon(class)
    end
end