local Player = FindMetaTable("Player")

BLOXXERS_ARSENAL.IN_CONTEXT = IN_RUN
BLOXXERS_ARSENAL.IN_OFFHAND = {
    [0] = IN_WEAPON1,
    [1] = IN_WEAPON2,
    [2] = IN_BULLRUSH,
}

BLOXXERS_ARSENAL.MAX_OFFHAND_BINDS = 3

-- Last slot is reserved for spacebar related tools
BLOXXERS_ARSENAL.MAX_OFFHAND_SLOTS = 4

function Player:Blox_GetOffhandClass(slot)
    if not slot or slot < 0 or slot >= BLOXXERS_ARSENAL.MAX_OFFHAND_SLOTS then return end
    local s = self:GetNW2String("Blox_Offhand_" .. slot)
    if s == "" then return nil end
    return s
end

function Player:Blox_GetOffhandWeapon(slot)
    local class = self:Blox_GetOffhandClass(slot)
    if class then
        return self:GetWeapon(class)
    end
end

function Player:Blox_SetOffhandClass(slot, class)
    if not slot or slot < 0 or slot >= BLOXXERS_ARSENAL.MAX_OFFHAND_SLOTS then return end
    for i = 0, BLOXXERS_ARSENAL.MAX_OFFHAND_SLOTS - 1 do
        if self:Blox_GetOffhandClass(i) == class then
            self:SetNW2String("Blox_Offhand_" .. i, nil)
        end
    end
    self:SetNW2String("Blox_Offhand_" .. slot, class)
end

function Player:Blox_SetOffhandWeapon(slot, wep)
    if not IsValid(wep) or not wep.BloxxersArsenal or not wep.OffhandUsable then return end
    self:Blox_SetOffhandClass(slot, wep:GetClass())
end


hook.Add("KeyPress", "bloxxers_arsenal", function(ply, key)
    local activewep = ply:GetActiveWeapon()
    if not IsValid(activewep) or not activewep.BloxxersArsenal then return end
    if IsValid(activewep:GetActiveOffhand()) then
        local offhandwep = activewep:GetActiveOffhand()
    else
        for i = 0, BLOXXERS_ARSENAL.MAX_OFFHAND_BINDS - 1 do
            if key == BLOXXERS_ARSENAL.IN_OFFHAND[i] then
                if ply:KeyDown(BLOXXERS_ARSENAL.IN_CONTEXT) and activewep.OffhandUsable then
                    ply:Blox_SetOffhandWeapon(i, activewep)
                else
                    local offhandwep = ply:Blox_GetOffhandWeapon(i)
                    if IsValid(offhandwep) and offhandwep ~= activewep
                            and activewep.FreeOffhand and activewep:OffhandReady()
                            and offhandwep:CanOffhandAttack() then
                        activewep:SetActiveOffhand(offhandwep)
                        offhandwep:OffhandAttack(activewep)
                    end
                end
                break
            end
        end
    end
end)

if CLIENT then
    BLOXXERS_ARSENAL.Icons = {}

    local SS = ScreenScale

    surface.CreateFont("Blox_Bind", {
        font = "Arial",
        size = SS(12),
        weight = 800,
    })

    local bind0 = CreateClientConVar("blox_offhand_bind_1", KEY_R, true, true, "Bind used for the 1st offhand slot (KEY enum)")
    local bind1 = CreateClientConVar("blox_offhand_bind_2", KEY_F, true, true, "Bind used for the 2nd offhand slot (KEY enum)")
    local bind2 = CreateClientConVar("blox_offhand_bind_3", KEY_B, true, true, "Bind used for the 3rd offhand slot (KEY enum)")
    BLOXXERS_ARSENAL.OFFHAND_CVAR = {
        [0] = bind0,
        [1] = bind1,
        [2] = bind2,
    }

    hook.Add("PlayerBindPress", "bloxxers_arsenal", function(ply, bind, pressed, code)
        local activewep = LocalPlayer():GetActiveWeapon()
        if not IsValid(activewep) or not activewep.BloxxersArsenal then return end
        if bind == "+menu_context" then
            BLOXXERS_ARSENAL.CONTEXT_MENU_PRESSED = pressed
            return true
        end
        for i = 0, BLOXXERS_ARSENAL.MAX_OFFHAND_BINDS - 1 do
            if input.LookupKeyBinding(BLOXXERS_ARSENAL.OFFHAND_CVAR[i]:GetInt()) == bind then
                return true
            end
        end
    end)

    hook.Add("CreateMove", "bloxxers_arsenal", function(cmd)
        local activewep = LocalPlayer():GetActiveWeapon()
        if not IsValid(activewep) or not activewep.BloxxersArsenal then return end

        if BLOXXERS_ARSENAL.CONTEXT_MENU_PRESSED then
            cmd:AddKey(BLOXXERS_ARSENAL.IN_CONTEXT)
        end

        for i = 0, BLOXXERS_ARSENAL.MAX_OFFHAND_BINDS - 1 do
            if input.IsKeyDown(BLOXXERS_ARSENAL.OFFHAND_CVAR[i]:GetInt()) then
                cmd:AddKey(BLOXXERS_ARSENAL.IN_OFFHAND[i])
            end
        end
    end)
end