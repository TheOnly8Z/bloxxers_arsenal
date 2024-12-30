AddCSLuaFile()

BLOXXERS_ARSENAL = {}

for _, v in pairs(file.Find("bloxxers_arsenal/*", "LUA")) do
    if string.Left(v, 3) == "sh_" then
        include("bloxxers_arsenal/" .. v)
        AddCSLuaFile("bloxxers_arsenal/" .. v)
    elseif string.Left(v, 3) == "sv_" then
        if SERVER then
            include("bloxxers_arsenal/" .. v)
        end
    elseif string.Left(v, 3) == "cl_" then
        AddCSLuaFile("bloxxers_arsenal/" .. v)
        if CLIENT then
            include("bloxxers_arsenal/" .. v)
        end
    end
end