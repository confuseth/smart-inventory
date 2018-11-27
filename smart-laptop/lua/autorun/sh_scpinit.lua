CONSOLE = CONSOLE or {}
COMMANDS = COMMANDS or {}

NETWORKS = NETWORKS or {}

function CONSOLE:addCommand(unique_name, t)
    local ta = table.Copy(t)
    COMMANDS[unique_name] = ta
end

if SERVER then
    local fol = "smart/"
    local files, folders = file.Find(fol .. "*", "LUA")
    for _, v in pairs(files) do
        if string.GetExtensionFromFilename(v) ~= "lua" then continue end
        include(fol .. v)
    end
    for _, folder in SortedPairs(folders, true) do
        for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
            AddCSLuaFile(fol .. folder .. "/" .. File)
            include(fol .. folder .. "/" .. File)
        end
        for _, File in SortedPairs(file.Find(fol .. folder .. "/sv_*.lua", "LUA"), true) do
            include(fol .. folder .. "/" .. File)
        end
        for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
            AddCSLuaFile(fol .. folder .. "/" .. File)
        end
    end
end

if CLIENT then
    local fol = "smart/"
    local files, folders = file.Find(fol .. "*", "LUA")
    for _, v in pairs(files) do
        if string.GetExtensionFromFilename(v) ~= "lua" then continue end
        include(fol .. v)
    end
    for _, folder in SortedPairs(folders, true) do
        for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
            AddCSLuaFile(fol .. folder .. "/" .. File)
            include(fol .. folder .. "/" .. File)
        end
        
        for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
            AddCSLuaFile(fol .. folder .. "/" .. File)
        end
    end
end