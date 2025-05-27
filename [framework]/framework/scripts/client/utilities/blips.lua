Framework.Blips.locations = {
    --{title="Dynasty 8", colour=26, id=544, x=-693.67, y=276.48, z=82.69},
}

function Framework.Blips:RefreshBlips()
    for _, info in pairs(self.locations) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.5)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end

function Framework.Blips:DeleteBlips()
    for _, info in pairs(self.locations) do
      RemoveBlip(info.blip)
    end
end

Citizen.CreateThread(function()
    while true do
        Framework.Blips:RefreshBlips()
        Citizen.Wait(600000)
        Framework.Blips:DeleteBlips()
    end
end)

