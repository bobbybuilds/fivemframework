local firstSpawn = true

RegisterNetEvent('Framework:Notify')
AddEventHandler('Framework:Notify', function(text)
    Framework:Notification(text)
end)

AddEventHandler('playerSpawned', function()
    if firstSpawn then
        firstSpawn = false
        Citizen.Wait(5000)
        ShutdownLoadingScreen()
    end
end)