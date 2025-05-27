RegisterCommand("giveweapon", function(source, args)
    local targetId = tonumber(args[1])
    local weapon = args[2]
    local ammo = tonumber(args[3]) or 0

    if not targetId or not weapon then
        print("Usage: /giveweapon [playerID] [weapon_name] [ammo]")
        return
    end

    weapon = string.upper(weapon)
    if not weapon:find("WEAPON_") then
        weapon = "WEAPON_" .. weapon
    end

    TriggerClientEvent("GiveWeapon:ApplyWeapon", targetId, weapon, ammo)
    print("Gave " .. weapon .. " (" .. ammo .. " ammo) to player " .. targetId)
end, false)
