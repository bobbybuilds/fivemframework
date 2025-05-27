Framework = {}
Framework.Menus = {}
Framework.Player = {}
Framework.Blips = {}
Framework.Blips.locations = {
    --{title="Dynasty 8", colour=26, id=544, x=-693.67, y=276.48, z=82.69},
}


-- One main loop for player stuff, instead of using like GetEntityCoords or PlayerPedId 1000 different times in different scripts
Citizen.CreateThread(function()
    while true do
        Framework.Player.ped = PlayerPedId()
        Framework.Player.Pos = GetEntityCoords(Framework.Player.ped)
        Framework.Player.Heading = GetEntityHeading(Framework.Player.ped)
        Framework.Player.Health = GetEntityHealth(Framework.Player.ped)
        Framework.Player.Vehicle = GetVehiclePedIsIn(Framework.Player.ped, false)
        if Framework.Player.Vehicle == 0 then -- More optimized than IsPedSittingInAnyVehicle() because we're already getting the vehicle entity
            Framework.Player.InVehicle = false
        else
            Framework.Player.InVehicle = true
        end
        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    while true do
        if GetPlayerWantedLevel(Framework.Player.ped) > 0 then
            ClearPlayerWantedLevel(Framework.Player.ped)
        end
        Citizen.Wait(500)
    end
end)

function Framework:Notification(text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(false, false)
end

function Framework:HelpNotification(text)
    AddTextEntry("FrameworkHelp", text)
    BeginTextCommandDisplayHelp("FrameworkHelp")
    EndTextCommandDisplayHelp(0, false, true, 1)
end

function Framework:GetDistance(coords1, coords2)
    return #(coords1 - coords2)
end

function Framework:LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
end

function Framework:LoadModel(model)
    local hash = type(model) == "string" and GetHashKey(model) or model
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end
    return hash
end

function Framework:SyncDoors(doorHash, coords, locked)
    local doorId = doorHash .. "_" .. math.floor(coords.x) .. "_" .. math.floor(coords.y)

    AddDoorToSystem(doorId, doorHash, coords, false, false)
    DoorSystemSetDoorState(doorId, locked and 1 or 0, true, true)
end

function Framework:Spinner(label, time)
    BeginTextCommandBusyspinnerOn("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandBusyspinnerOn(4)

    Citizen.Wait(time)
    BusyspinnerOff()
end

AddEventHandler('Framework:LicenseSync', function(source, identifier)
    Framework.Player.Id = source
    Framework.Player.Identifier = identifier
end)

AddEventHandler('Framework:LicenseSync', function(source, identifier)
    Framework.Player.Id = source
    Framework.Player.Identifier = identifier
end)

