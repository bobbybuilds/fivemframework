Framework.Utility = {
    NoClip = false,
    Speed = 1.0,
    Test = 'Lets Test',
    timeFrozen = false,
    weatherFrozen = false,
    currentHour = 12,
    currentWeather = "CLEAR",
    SuperMan = false
}

RegisterCommand("ped", function(args)
    Framework.Utility:PedChange(args)
end, false)

RegisterCommand("time", function(_, args)
    local hour = tonumber(args[1])
    Framework.Utility:ChangeTime(hour)
end, false)

RegisterCommand("noclip", function()
    Framework.Utility:ToggleNoClip()
end, false)


RegisterCommand("weather", function(_, args)
    local weather = string.upper(args[1] or "")
    Framework.Utility:ChangeWeather(weather)
end, false)

RegisterCommand("freezeweather", function()
    Framework.Utility.weatherFrozen = true
    Framework:Notification("~y~Weather frozen")
end, false)

RegisterCommand("unfreezeweather", function()
    Framework.Utility.weatherFrozen = false
    Framework:Notification("~y~Weather unfrozen")
end, false)

RegisterCommand("freezetime", function()
    Framework.Utility.timeFrozen = true
    Framework:Notification("~y~Time frozen")
end, false)

RegisterCommand("unfreezetime", function()
    Framework.Utility.timeFrozen = false
    Framework:Notification("~y~Time unfrozen")
end, false)



local displayText = ""
local showPersistentText = false

function ShowPersistentGtaText(msg)
    displayText = msg
    showPersistentText = true
end

function HidePersistentGtaText()
    showPersistentText = false
end


CreateThread(function()
    ShowPersistentGtaText("Framework Roleplay - Alpha 0.0.2")
    while true do
        Wait(1)
        if showPersistentText and displayText ~= "" then
            SetTextFont(8) -- GTA style
            SetTextScale(0.5, 0.5)
            SetTextColour(255, 255, 255, 150) -- 51 alpha = 20% opacity
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(2, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(displayText:upper())
            DrawText(0.00, 0.00) -- far top-left corner
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if Framework.Utility.timeFrozen then
            NetworkOverrideClockTime(Framework.Utility.currentHour, 0, 0)
        end
        if Framework.Utility.weatherFrozen then
            SetWeatherTypeNowPersist(Framework.Utility.currentWeather)
            SetWeatherTypeNow(Framework.Utility.currentWeather)
            SetOverrideWeather(Framework.Utility.currentWeather)
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        Wait(1)
        if IsControlJustReleased(0, 289) then
            Framework.Utility:ToggleNoClip()
        end
        if Framework.Utility.NoClip then
            Framework.Utility:NoClipping()
        end
    end
end)

function Framework.Utility:SuperMan()
    while Framework.SuperMan do
        Citizen.Wait(500)
        local player = PlayerId()
        local ped = PlayerPedId()
        
        SetEntityInvincible(ped, true)
        SetPedCanRagdoll(ped, false)
        ClearEntityLastDamageEntity(ped)
        ResetPedRagdollTimer(ped)
        SetEntityHealth(ped, 200)
        SetPedArmour(ped, 100)
        
        RestorePlayerStamina(player, 1.0)
        SetRunSprintMultiplierForPlayer(player, 1.49)
        SetSwimMultiplierForPlayer(player, 1.49)
        SetSuperJumpThisFrame(player)
        SetPedMoveRateOverride(player, 10.0)
        SetPedCanRagdoll(ped, false)
        SetPedDiesWhenInjured(ped, false)
        
        SetPedCanBeKnockedOffVehicle(ped, 1)
        
        local currentHealth = GetEntityHealth(ped)
        if currentHealth < 200 then
            StartScreenEffect("PPFilterDamage", 0, false)
            Citizen.SetTimeout(300, function()
                StopScreenEffect("PPFilterDamage")
            end)
        end
    end
end


function Framework.Utility:ChangeWeather(weather)
    if weather ~= "" then
        SetWeatherTypeNowPersist(weather)
        SetWeatherTypeNow(weather)
        SetOverrideWeather(weather)
        Framework.Utility.currentWeather = weather
        Framework:Notification("~y~Weather set to " .. weather)
    else
        Framework:Notification("~r~Wrong type of weather")
    end
end

function Framework.Utility:ChangeTime(hour)
    if hour and hour >= 0 and hour <= 23 then
        Framework.Utility.currentHour = hour
        NetworkOverrideClockTime(Framework.Utility.currentHour, 0, 0)
        Framework:Notification("~y~Time set to " .. hour .. ":00")
    else
        Framework:Notification("~r~Usage: /time [0-23]")
    end
end

function Framework.Utility:PedChange(model)
    if #model < 1 then        return
    end
    self.modelName = model[1]

    RequestModel(self.modelName)
    while not HasModelLoaded(self.modelName) do
        Wait(100)
    end

    if IsModelInCdimage(self.modelName) and IsModelValid(self.modelName) then
        SetPlayerModel(PlayerId(), self.modelName)
        SetModelAsNoLongerNeeded(self.modelName)
    end
end

function Framework.Utility:ToggleNoClip()
    if self.NoClip then
        local ped = PlayerPedId()
        SetEntityVisible(ped, true, false)
        SetEntityInvincible(ped, false)
        FreezeEntityPosition(ped, false)
        self.NoClip = false
    else
        self.NoClip = true
    end
end

function Framework.Utility:NoClipping()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local camRot = GetGameplayCamRot(0)
    local pitch = math.rad(camRot.x)
    local yaw = math.rad(camRot.z)

    local forward = vector3(
        -math.sin(yaw) * math.cos(pitch),
        math.cos(yaw) * math.cos(pitch),
        math.sin(pitch)
    )

    local right = vector3(
        math.cos(yaw),
        math.sin(yaw),
        0.0
    )

    SetEntityVisible(ped, false, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)

    if IsControlPressed(0, 21) then -- SHIFT
        self.Speed = 5.0
    elseif IsControlPressed(0, 36) then -- CTRL
        self.Speed = 0.5
    else
        self.Speed = 1.0
    end


    if IsControlPressed(0, 32) then -- W
        pos = pos + forward * self.Speed
    end
    if IsControlPressed(0, 33) then -- S
        pos = pos - forward * self.Speed
    end
    if IsControlPressed(0, 34) then -- A
        pos = pos - right * self.Speed
    end
    if IsControlPressed(0, 35) then -- D
        pos = pos + right * self.Speed
    end
    if IsControlPressed(0, 44) then -- Q
        pos = pos - vector3(0, 0, self.Speed)
    end
    if IsControlPressed(0, 38) then -- E
        pos = pos + vector3(0, 0, self.Speed)
    end

    SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, true, true, true)
end


Framework.Player = {}

function Framework.Player:Ped()
    return PlayerPedId()
end

function Framework.Player:Position()
    return GetEntityCoords(PlayerPedId())
end

function Framework.Utility:LoadModel(model)
    local hash = type(model) == "string" and GetHashKey(model) or model
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end
    return hash
end

function Framework.Utility:LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
end






RegisterCommand("car", function(_, args)
    local modelName = args[1]
    if not modelName then
        print("Usage: /car [model]")
        return
    end

    local model = GetHashKey(modelName)

    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do
        Wait(10)
    end

    if not HasModelLoaded(model) then
        print("Model load failed: " .. modelName)
        return
    end

    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local veh = CreateVehicle(model, pos.x, pos.y, pos.z + 1.0, heading, true, false)
    SetPedIntoVehicle(playerPed, veh, -1)
    SetEntityAsNoLongerNeeded(veh)
    SetModelAsNoLongerNeeded(model)

    print("Spawned vehicle: " .. modelName)
end, false)

RegisterCommand("cardel", function(_, args)
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local radius = tonumber(args[1]) or 3.0

    local vehToDelete = GetVehiclePedIsIn(playerPed, false)
    if vehToDelete ~= 0 then
        DeleteEntity(vehToDelete)
        print("Deleted vehicle you're in.")
        return
    end

    local vehicles = GetGamePool("CVehicle")
    local deletedCount = 0
    for _, veh in pairs(vehicles) do
        if #(GetEntityCoords(veh) - pos) < radius then
            DeleteEntity(veh)
            deletedCount = deletedCount + 1
        end
    end

    if deletedCount > 0 then
        print("Deleted " .. deletedCount .. " vehicle(s) within " .. radius .. " meters.")
    else
        print("No vehicles found nearby.")
    end
end, false)

RegisterCommand("tp", function(_, args)
    local targetId = tonumber(args[1])
    if not targetId then
        Framework:Notification("Usage: /tp [~y~playerID~s~]")
        return
    end

    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if not DoesEntityExist(targetPed) then
        Framework:Notification("~r~Player ID ~y~" .. targetId .. " ~r~not found.")
        return
    end

    local targetCoords = GetEntityCoords(targetPed)
    local ped = PlayerPedId()

    SetEntityCoords(ped, targetCoords.x, targetCoords.y, targetCoords.z + 1.0, false, false, false, true)
    Framework:Notification("Teleported to player ~y~" .. targetId)
end, false)

RegisterCommand("tpwp", function()
    local waypointBlip = GetFirstBlipInfoId(8) 
    if not DoesBlipExist(waypointBlip) then
        Framework:Notification("~o~No waypoint set.")
        return
    end

    local coords = GetBlipInfoIdCoord(waypointBlip)
    local ped = Framework.Player.ped

    local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, 1000.0, 0)
    if foundGround then
        SetEntityCoords(ped, coords.x, coords.y, groundZ + 1.0, false, false, false, true)
        Framework:Notification("Teleported to ~y~waypoint~s~.")
    else
        SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
        Framework:Notification("Teleported to ~y~waypoint~s~ (~o~no ground found~s~).")
    end
end, false)

RegisterCommand("id", function()
    local id = GetPlayerServerId(PlayerId())
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("ID: ~y~" .. id)
    EndTextCommandThefeedPostTicker(false, false)
end, false)


RegisterNetEvent('Framework:Notification')
AddEventHandler('Framework:Notification', function(text)
    Framework:Notification(text)
end)

RMenu.Add('tools', 'ped_selector', RageUI.CreateMenu("Ped Selector", "~y~Select a ped model"))

local pedList = {
    "a_m_m_business_01",
    "a_f_m_bevhills_01",
    "s_m_y_cop_01",
    "s_m_m_security_01",
    "u_m_m_jesus_01",
    "csb_popov",
    "ig_bankman",
    "a_m_m_skater_01",
    "ig_claypain"
}

local selectedIndex = 1

function SetPedModel(modelName)
    local model = GetHashKey(modelName)

    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do
        Wait(10)
    end

    if not HasModelLoaded(model) then
        print("Failed to load ped model: " .. modelName)
        return
    end

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    print("Changed ped to: " .. modelName)
end

RegisterCommand("ped", function(_, args)
    local model = args[1]

    if model then
        SetPedModel(model)
    else
        OpenPedMenu()
    end
end)

function OpenPedMenu()
    local IsOpen = true
    local initOpen = true

    Citizen.CreateThread(function()
        while IsOpen do
            IsOpen = false

            if initOpen then
                initOpen = false
                RageUI.Visible(RMenu:Get('tools', 'ped_selector'), true)
            end

            RageUI.IsVisible(RMenu:Get('tools', 'ped_selector'), true, false, true, function()
                IsOpen = true

                RageUI.List("Ped Models", pedList, selectedIndex, "Pick a model to change your ped", {}, true, function(Hovered, Active, Selected, Index)
                    selectedIndex = Index

                    if Selected then
                        SetPedModel(pedList[selectedIndex])
                        RageUI.CloseAll()
                    end
                end)
            end)

            Wait(1)
        end
    end)
end



local lastHealth = 200

RegisterCommand('superman', function()
    if Framework.SuperMan then
        Framework.SuperMan = false
        Framework:Notification('You are no longer ~g~Superman')
    else
        Framework.SuperMan = true
        Framework:Notification('You are ~g~Superman')
    end

end)

RegisterNetEvent("GiveWeapon:ApplyWeapon")
AddEventHandler("GiveWeapon:ApplyWeapon", function(weaponName, ammo)
    local weapon = GetHashKey(weaponName)

    if not IsWeaponValid(weapon) then
        print("Invalid weapon: " .. weaponName)
        return
    end

    GiveWeaponToPed(PlayerPedId(), weapon, ammo or 0, false, true)
    print("Received weapon: " .. weaponName .. " with ammo: " .. ammo)
end)

local spawnedPed = nil
local shooting = false

RegisterCommand("spawnshooter", function()
    if spawnedPed then
        DeleteEntity(spawnedPed)
        spawnedPed = nil
        shooting = false
        return
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local model = `s_m_y_swat_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    spawnedPed = CreatePed(4, model, coords.x + 2.0, coords.y + 2.0, coords.z, heading, true, false)
    GiveWeaponToPed(spawnedPed, `WEAPON_ASSAULTRIFLE`, 9999, false, true)
    SetPedAccuracy(spawnedPed, 100)
    SetPedCombatAttributes(spawnedPed, 46, true)
    SetPedFleeAttributes(spawnedPed, 0, false)
    SetPedCanRagdoll(spawnedPed, false)
    SetEntityInvincible(spawnedPed, true)

    shooting = true

    Citizen.CreateThread(function()
        while shooting and DoesEntityExist(spawnedPed) do
            local base = GetEntityCoords(spawnedPed)
            local offsetX = math.random(-10, 10)
            local offsetY = math.random(-10, 10)
            local offsetZ = math.random(0, 3)

            local target = vector3(base.x + offsetX, base.y + offsetY, base.z + offsetZ)
            TaskShootAtCoord(spawnedPed, target.x, target.y, target.z, 2000, `FIRING_PATTERN_FULL_AUTO`)
            Wait(2500)
        end
    end)
end, false)

local isSpawnMenuOpen = false

RegisterCommand("tp", function()
    isSpawnMenuOpen = false
    OpenSpawnMenu()
end)

local spawnLocations = {
    {title = "Dynasty 8", x = -693.67, y = 276.48, z = 82.69},
    {title = "Luxury Autos", x = -807.61, y = -229.01, z = 37.06},
    {title = "Pacific Bank", x = 247.1, y = 216.42, z = 106.28},
    {title = "MRPD", x = 426.55, y = -980.94, z = 30.69},
    {title = "DMV", x = 1093.19, y = -366.71, z = 66.98},
    {title = "MPHouse1", x = 972.36, y = -608.0695, z = -82.07},
    {title = "Diving Job", x = 1186.2363, y = -1394.9562, z = 35.148},
    {title = "DW Customs", x = -205.6758, y = -1306.6063, z = 31.3110},
    {title = "Gym", x = -1203.6095, y = -1568.5759, z = 4.6080},
    {title = "Track", x = -1699.2960, y = 140.4074, z = 64.3716}
    
}

RMenu.Add('spawn', 'selector', RageUI.CreateMenu("Teleport Menu", "~y~Where ya wanna go"))

function OpenSpawnMenu()
    if isSpawnMenuOpen then return end
    isSpawnMenuOpen = true

    RageUI.Visible(RMenu:Get('spawn', 'selector'), true)

    Citizen.CreateThread(function()
        while isSpawnMenuOpen do
            Citizen.Wait(0)
            RageUI.IsVisible(RMenu:Get('spawn', 'selector'), true, false, true, function()

                for i = 1, #spawnLocations do
                    local loc = spawnLocations[i]

                    RageUI.ButtonWithStyle(loc.title, "Teleport to " .. loc.title, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            DoScreenFadeOut(500)
                            Wait(500)
                            SetEntityCoords(PlayerPedId(), loc.x, loc.y, loc.z)
                            SetEntityHeading(PlayerPedId(), 0.0)
                            DoScreenFadeIn(500)
                            RageUI.CloseAll()
                            isSpawnMenuOpen = false
                        end
                    end)
                end
            end)
        end
    end)
end

RegisterCommand('skin', function()
    RandomSkin()
end)

AddEventHandler("playerSpawned", function()
    Wait(1000)
    RandomSkin()
end)

function RandomSkin()
    local ped = PlayerPedId()

    local model = GetHashKey("mp_m_freemode_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    ped = PlayerPedId()

    local whiteFaces = {0, 1, 4, 6, 7, 9, 12, 16, 17, 18}
    local blackFaces = {2, 5, 8, 10, 13, 20, 21, 42, 43, 44}
    local latinoFaces = {3, 14, 15, 19, 22, 23, 24, 25}
    local mixedFaces = {26, 27, 28, 29, 30, 31, 32, 33}
    local allFaces = {whiteFaces, blackFaces, latinoFaces, mixedFaces}

    local racePool = allFaces[math.random(1, #allFaces)]
    local shapeFirst = racePool[math.random(#racePool)]
    local shapeSecond = racePool[math.random(#racePool)]
    local skinFirst = racePool[math.random(#racePool)]
    local skinSecond = racePool[math.random(#racePool)]

    local shapeMix = math.random(40, 100) / 100.0
    local skinMix = math.random(40, 100) / 100.0

    SetPedHeadBlendData(ped, shapeFirst, shapeSecond, 0, skinFirst, skinSecond, 0, shapeMix, skinMix, 0.0, false)

    for i = 0, 19 do
        SetPedFaceFeature(ped, i, math.random(-30, 30) / 100.0)
    end

    for i = 0, 12 do
        SetPedHeadOverlay(ped, i, math.random(0, 5), 0.6)
    end

    local hairStyle = math.random(0, 36)
    SetPedComponentVariation(ped, 2, hairStyle, 0, 2)

    local hairColor = math.random(0, 63)
    local hairHighlight = math.random(0, 63)
    SetPedHairColor(ped, hairColor, hairHighlight)

    SetPedComponentVariation(ped, 6, 1, 0, 2)

    Framework:Notification('You look... ~y~beautiful')
end

RegisterCommand("coords", function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local x = coords.x
    local y = coords.y
    local z = coords.z
    local h = heading

    print(string.format("vector3(%.4f, %.4f, %.4f)", x, y, z))
    print(string.format("vector4(%.4f, %.4f, %.4f, %.4f)", x, y, z, h))
    print(string.format("x = %.4f, y = %.4f, z = %.4f", x, y, z))
    print(string.format("x = %.4f, y = %.4f, z = %.4f, h = %.4f", x, y, z, h))

    Framework:Notification('~y~Heres your coordinates my ~g~darling')
end, false)

local activeMonkeys = {}
local targetPlayer = nil
local monkeyModel = `a_c_chimp`
local doubling = false

RegisterCommand("wild", function(source, args, rawCommand)
    local serverId = tonumber(args[1])
    if not serverId then
        print("Usage: /wild [playerServerId]")
        return
    end

    local localId = GetPlayerFromServerId(serverId)
    if not localId or localId == -1 then
        print("Invalid player ID.")
        return
    end

    local targetPed = GetPlayerPed(localId)
    if not DoesEntityExist(targetPed) then
        print("Target ped doesn't exist.")
        return
    end

    targetPlayer = targetPed
    activeMonkeys = {}
    doubling = true

    RequestModel(monkeyModel)
    while not HasModelLoaded(monkeyModel) do Wait(50) end

    local coords = GetEntityCoords(targetPed)
    local firstMonkey = CreatePed(28, monkeyModel, coords.x + 1.0, coords.y, coords.z, 0.0, true, true)
    SetEntityAsMissionEntity(firstMonkey, true, true)
    table.insert(activeMonkeys, firstMonkey)

    FollowTarget(firstMonkey, targetPlayer)
    print("Spawning first monkey...")

    StartDoubling()
end)

function FollowTarget(monkey, target)
    TaskFollowToOffsetOfEntity(monkey, target, 0.0, 0.0, 0.0, 2.0, -1, 2.0, true)
end

function StartDoubling()
    Citizen.CreateThread(function()
        while doubling do
            Wait(10000)

            print("Doubling attempt... total monkeys:", #activeMonkeys)

            if #activeMonkeys > 100 then
                doubling = false
                print("Too many monkeys. Begin attack!")
                AttackTarget()
                break
            end

            local newMonkeys = {}

            for _, monkey in ipairs(activeMonkeys) do
                if DoesEntityExist(monkey) then
                    RequestModel(monkeyModel)
                    while not HasModelLoaded(monkeyModel) do Wait(10) end

                    local dict = "scr_rcbarry2"
                    local fx = "scr_clown_appears"
                    RequestNamedPtfxAsset(dict)
                    while not HasNamedPtfxAssetLoaded(dict) do Wait(10) end
                    UseParticleFxAssetNextCall(dict)
                    local fxHandle = StartParticleFxLoopedOnEntity(fx, monkey, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)

                    Wait(500)

                    local coords = GetEntityCoords(monkey)
                    local clone = CreatePed(28, monkeyModel, coords.x + math.random(-2,2), coords.y + math.random(-2,2), coords.z, 0.0, true, true)

                    if DoesEntityExist(clone) then
                        SetEntityAsMissionEntity(clone, true, true)
                        FollowTarget(clone, targetPlayer)
                        table.insert(newMonkeys, clone)
                        print("Monkey cloned.")
                    end

                    StopParticleFxLooped(fxHandle, 0)
                end
            end

            for _, m in ipairs(newMonkeys) do
                table.insert(activeMonkeys, m)
            end
        end
    end)
end


function AttackTarget()
    local player = targetPlayer
    if not DoesEntityExist(player) then return end

    local monkeyGroup = GetHashKey("MONKEYS")
    AddRelationshipGroup("MONKEYS")

    SetRelationshipBetweenGroups(5, monkeyGroup, GetPedRelationshipGroupHash(player))
    SetRelationshipBetweenGroups(5, GetPedRelationshipGroupHash(player), monkeyGroup)

    for _, monkey in pairs(activeMonkeys) do
        if DoesEntityExist(monkey) then
            ClearPedTasksImmediately(monkey)

            SetPedRelationshipGroupHash(monkey, monkeyGroup)
            SetPedCombatAttributes(monkey, 5, true)
            SetPedCombatAttributes(monkey, 46, true) 
            SetPedCombatAttributes(monkey, 1424, true)
            SetPedFleeAttributes(monkey, 0, 0) 
            SetPedCanRagdoll(monkey, true)
            SetBlockingOfNonTemporaryEvents(monkey, true)
            SetPedAsEnemy(monkey, true)
            GiveWeaponToPed(monkey, `WEAPON_UNARMED`, 1, false, true)
            TaskCombatPed(monkey, player, 0, 16)
        end
    end
end

local cultModels = {
    `a_m_o_acult_01`,
    `a_m_o_acult_02`,
    `a_m_y_acult_01`,
    `a_f_m_fatcult_01`,
    `a_m_m_acult_01`
}

local cultists = {}
local cultTarget = nil
local cultActive = false

RegisterCommand("cult", function(source, args, raw)
    local serverId = tonumber(args[1])
    if not serverId then
        print("Usage: /cult [playerId]")
        return
    end

    local localId = GetPlayerFromServerId(serverId)
    if not localId or localId == -1 then
        print("Invalid player ID.")
        return
    end

    local targetPed = GetPlayerPed(localId)
    if not DoesEntityExist(targetPed) then
        print("Target player ped not found.")
        return
    end

    cultTarget = targetPed
    cultists = {}
    cultActive = true

    local model = GetRandomCultModel()
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    local coords = GetEntityCoords(cultTarget)
    local cultist = CreatePed(26, model, coords.x + 1.0, coords.y, coords.z, 0.0, true, true)
    SetEntityAsMissionEntity(cultist, true, true)
    table.insert(cultists, cultist)
    FollowTarget(cultist, cultTarget)

    StartCultDoubling()
end)

function GetRandomCultModel()
    return cultModels[math.random(1, #cultModels)]
end

function FollowTarget(ped, target)
    TaskFollowToOffsetOfEntity(ped, target, 0.0, 0.0, 0.0, 2.0, -1, 2.0, true)
end

function StartCultDoubling()
    Citizen.CreateThread(function()
        while cultActive do
            Wait(10000)

            print("Doubling cult... total:", #cultists)

            if #cultists > 100 then
                cultActive = false
                print("Too many cultists! Begin attack!")
                CultAttackTarget()
                break
            end

            local newOnes = {}

            for _, ped in ipairs(cultists) do
                if DoesEntityExist(ped) then

                    local dict = "scr_rcbarry2"
                    local fx = "scr_clown_appears"
                    RequestNamedPtfxAsset(dict)
                    while not HasNamedPtfxAssetLoaded(dict) do Wait(10) end
                    UseParticleFxAssetNextCall(dict)
                    local fxHandle = StartParticleFxLoopedOnEntity(fx, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)

                    Wait(500)

                    local model = GetRandomCultModel()
                    RequestModel(model)
                    while not HasModelLoaded(model) do Wait(10) end

                    local coords = GetEntityCoords(ped)
                    local clone = CreatePed(26, model, coords.x + math.random(-2,2), coords.y + math.random(-2,2), coords.z, 0.0, true, true)

                    if DoesEntityExist(clone) then
                        SetEntityAsMissionEntity(clone, true, true)
                        FollowTarget(clone, cultTarget)
                        table.insert(newOnes, clone)
                        print("Cultist cloned.")
                    end

                    StopParticleFxLooped(fxHandle, 0)
                end
            end

            for _, p in ipairs(newOnes) do
                table.insert(cultists, p)
            end
        end
    end)
end

function CultAttackTarget()
    local player = cultTarget
    if not DoesEntityExist(player) then return end

    local cultGroup = GetHashKey("CULTISTS")
    AddRelationshipGroup("CULTISTS")

    SetRelationshipBetweenGroups(5, cultGroup, GetPedRelationshipGroupHash(player))
    SetRelationshipBetweenGroups(5, GetPedRelationshipGroupHash(player), cultGroup)

    for _, ped in pairs(cultists) do
        if DoesEntityExist(ped) then
            ClearPedTasksImmediately(ped)

            SetPedRelationshipGroupHash(ped, cultGroup)
            SetPedCombatAttributes(ped, 5, true)
            SetPedCombatAttributes(ped, 46, true)
            SetPedCombatAttributes(ped, 1424, true)
            SetPedFleeAttributes(ped, 0, 0)
            SetPedCanRagdoll(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedAsEnemy(ped, true)
            GiveWeaponToPed(ped, `WEAPON_UNARMED`, 1, false, true)
            TaskCombatPed(ped, player, 0, 16)
        end
    end
end

RegisterCommand("spinner", function()
    Framework:Spinner("Loading...", 5000)
end)


RegisterCommand("nativebar", function()
    Citizen.CreateThread(function()
        local duration = 5000
        local startTime = GetGameTimer()
        while GetGameTimer() - startTime < duration do
            local progress = (GetGameTimer() - startTime) / duration

            DrawRect(0.5, 0.9, 0.4, 0.03, 0, 0, 0, 200)
            DrawRect(0.3 + (0.2 * progress), 0.9, 0.4 * progress, 0.03, 255, 255, 255, 255)

            Wait(0)
        end
    end)
end)

RegisterCommand("scaleformbar", function()
    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    while not HasScaleformMovieLoaded(scaleform) do Wait(0) end

    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_MIDSIZED_MESSAGE")
    PushScaleformMovieMethodParameterString("HACKING")
    PushScaleformMovieMethodParameterString("50% Complete")
    EndScaleformMovieMethod()

    local endTime = GetGameTimer() + 5000
    while GetGameTimer() < endTime do
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        Wait(0)
    end
end)

RegisterCommand("helpbar", function()
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName("~b~Progress:~s~ [====          ]")
    EndTextCommandDisplayHelp(0, false, true, 5000)
end)

RegisterCommand("nativeprogress", function()
    local duration = 5000 
    local startTime = GetGameTimer()
    local endTime = startTime + duration

    Citizen.CreateThread(function()
        while GetGameTimer() < endTime do
            local now = GetGameTimer()
            local progress = (now - startTime) / duration
            local barWidth = 0.3
            local barHeight = 0.03
            local x = 0.5
            local y = 0.9


            DrawRect(x, y, barWidth, barHeight, 0, 0, 0, 180)
            DrawRect(x - barWidth / 2 + (barWidth * progress) / 2, y, barWidth * progress, barHeight, 255, 255, 255, 255)

            Wait(0)
        end
    end)
end)






































