Framework.Jobs.Postal = {
	Destinations = {
		[1] = {x = 993.43 , y = -435.78 , z = 62.90},
		[2] = {x = 962.23 , y = -501.71 , z = 60.60},
		[3] = {x = 848.74 , y = -566.43 , z = 56.80},
		[4] = {x = 873.72 , y = -598.91 , z = 57.30},
		[5] = {x = 976.78 , y = -617.92 , z = 58.84},
		[6] = {x = 962.03 , y = -660.24 , z = 56.60},
		[7] = {x = 983.74 , y = -708.37 , z = 56.60},
		[8] = {x = 1351.81 , y = -557.10 , z = 74.30},
		[9] = {x = 1385.57 , y = -578.70 , z = 73.40},
		[10] = {x = 481.05 , y = -1777.05 , z = 27.60},
		[11] = {x = 91.26 , y = -1964.30 , z = 19.80},
		[12] = {x = 42.68 , y = -1919.71 , z = 21.66},
		[13] = {x = -25.05 , y = -1847.62 , z = 24.40},
		[14] = {x = -950.47 , y = -1090.66 , z = 1.20},
		[15] = {x = -1043.84 , y = -1140.54 , z = 1.20},
		[16] = {x = -1102.22 , y = -1055.32 , z = 1.20},
		[17] = {x = -1040.41 , y = -1020.46 , z = 1.20},
		[18] = {x = -1174.60 , y = -946.51 , z = 2.20},
		[19] = {x = -1934.30 , y = 184.15 , z = 83.60},
		[20] = {x = -1955.52 , y = 214.66 , z = 85.10},
		[21] = {x = -1992.7 , y = 293.87 , z = 90.80},
		[22] = {x = -2001.84 , y = 367.69 , z = 93.50},
		[23] = {x = -1940.61 , y = 355.12 , z = 92.10},
		[24] = {x = -1953.85 , y = 447.37 , z = 100},
		[25] = {x = -1941.84 , y = 550.09 , z = 113.80},
		[26] = {x = -1985.28 , y = 603.43 , z = 117.20},
		[27] = {x = -1802.67 , y = 457.71 , z = 127.30},
		[28] = {x = -1452,18 , y = 533.98 , z = 118.30},
		[29] = {x = -1322.91 , y = 450.97 , z = 98.70},
		[30] = {x = -1238.55 , y = 485.34 , z = 92.20},
		[31] = {x = -1164.5 , y = 477.03 , z = 84.95},
		[32] = {x = -1113.47 , y = 477.93 , z = 81.20},
		[33] = {x = -845.8 , y = 458.44 , z = 86.70},
		[34] = {x = -805.49 , y = 426.46 , z = 90.60},
		[35] = {x = -373.43 , y = 349.19 , z = 108.30},
		[36] = {x = -261.05 , y = 396.75 , z = 109.05},
		[37] = {x = -201.33 , y = 409.82 , z = 109.60},
		[38] = {x = -352.96 , y = 476.25 , z = 111.90},
		[39] = {x = -472.82 , y = 354.26 , z = 102.85},
		[40] = {x = -526.71 , y = 415.71 , z = 92.60},
	},
	Active = false,
	TotalStops = 40,
	Vehicles = {
		"Boxville1",
		"Boxville2",
		"Boxville3",
		"Pony1",
		"Pony2"
	}
}

jobActive = false
totalCurrentStops = 0
initalTextSent = false
distance = 0
totalDistance = 0
doneCheck = false

local destination = {

}
totalStopSelection = 40



function Framework.Jobs.Postal:GenerateMenu()
    _menuPool = NativeUI.CreatePool()
    CokRon = NativeUI.CreateMenu("GoPostal", "~b~Deliver GoPostal Packages")
    _menuPool:Add(CokRon)

    bool = false
    function FirstItem(CokRon)
        local click = NativeUI.CreateItem("Your Job Rank: ~g~" ..currentRank.. " ", "Progress to next level:~g~ " ..currentProgress.. " / " ..totalProgress.. " ")
        CokRon:AddItem(click)
    end

	vehicles = {
		"Boxville1",
		"Boxville2",
		"Boxville3",
		"Pony1",
		"Pony2",
	}

    function SecondItem(CokRon)
        local vehicleList = NativeUI.CreateListItem("Select Your Delivery Vehicle", vehicles, 1)
        CokRon:AddItem(vehicleList)
        CokRon.OnListSelect = function(sender,item,index)
            if item == vehicleList then

				ESX.TriggerServerCallback('Cok_Postal:server:checkBankAccount', function(cb)
					if cb then
						hasEnough = true
					else
						hasEnough = true
					end
				end)

				ESX.TriggerServerCallback('Cok_Postal:CheckLevel', function(level, progress, pay)
					currentRank = level
				end)
				
				Citizen.Wait(500)

				if hasEnough == true then 
					selectedVehicle = item:IndexToItem(index)

					if selectedVehicle == 'Boxville1' then
						startJobAfterChecks()
					elseif selectedVehicle == 'Boxville2' then
						if currentRank >= 2 then
							startJobAfterChecks()
						else
							ESX.ShowNotification('~y~You are not a high enough rank to use this vehicle')
							_menuPool:CloseAllMenus()
						end
					elseif selectedVehicle == 'Boxville3' then
						if currentRank >= 3 then
							startJobAfterChecks()
						else
							ESX.ShowNotification('~y~You are not a high enough rank to use this vehicle')
							_menuPool:CloseAllMenus()
						end
					elseif selectedVehicle == 'Pony1' then
						if currentRank >= 4 then
							startJobAfterChecks()
						else
							ESX.ShowNotification('~y~You are not a high enough rank to use this vehicle')
							_menuPool:CloseAllMenus()
						end
					elseif selectedVehicle == 'Pony2' then
						if currentRank >= 5 then
							startJobAfterChecks()
						else
							ESX.ShowNotification('~y~You are not a high enough rank to use this vehicle')
							_menuPool:CloseAllMenus()
						end
					end
				else
					_menuPool:CloseAllMenus()
					ESX.ShowNotification('~y~You do not have enough to afford the security deposit')
				end
            end
        end 
    end

	function ThirdItem(CokRon)
        local click = NativeUI.CreateItem("Rank 2:~b~ Boxville Rank 2", "Unlock this vehicle by completing jobs")
        CokRon:AddItem(click)
    end

	function FourthItem(CokRon)
        local click = NativeUI.CreateItem("Rank 3:~b~ Boxville Rank 3", "Unlock this vehicle by completing jobs")
        CokRon:AddItem(click)
    end

	function FifthItem(CokRon)
        local click = NativeUI.CreateItem("Rank 4:~b~ Pony Van", "Unlock this vehicle by completing jobs")
        CokRon:AddItem(click)
    end

	function SixthItem(CokRon)
        local click = NativeUI.CreateItem("Rank 5:~b~ Pony Van 2", "Unlock this vehicle by completing jobs")
        CokRon:AddItem(click)
    end

    FirstItem(CokRon)
    SecondItem(CokRon)
	ThirdItem(CokRon)
	FourthItem(CokRon)
	FifthItem(CokRon)
	SixthItem(CokRon)
    _menuPool:RefreshIndex()
	_menuPool:ProcessMenus()
end

function GenerateJobActiveMenu()

    _menuPool = NativeUI.CreatePool()
    CokRonActive = NativeUI.CreateMenu("GoPostal", "~b~Finish The current Job")
    _menuPool:Add(CokRonActive)

    bool = false
    function FirstItem(CokRonActive)
        local click = NativeUI.CreateItem("Finish the Job", "Finishing the Job will cancel your progress")
        CokRonActive:AddItem(click)
        CokRonActive.OnItemSelect = function(sender,item,index)
            if item == click then 

				local distance = GetDistanceBetweenCoords(GetEntityCoords(CurrentVehicle),Config.StartJobLocation.x,Config.StartJobLocation.y,Config.StartJobLocation.z, true)

				if distance < 20 then
					TriggerServerEvent('Cok_Postal:returnDeposit')
					ESX.ShowNotification('~y~You returned your vehicle and recieved the ~g~$500~y~ security deposit back')
				else
					ESX.ShowNotification('~y~You failed to return the vehicle and lost the security deposit')
				end

				isToDepot = false
				TriggerServerEvent('Cok_Postal:FinishJob', totalCurrentStops, totalDistance)
				PlaySound(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", false, 0, true)

				initalTextSent = false
				isOnRoute = false
				--isToDepot = false
				jobActive = false
				px = 0
				py = 0
				pz = 0
				totalDistance = 0
				RemoveBlip(returnBlip)
				RemoveBlip(destBlip)
				SetBlipRoute(returnBlip,  false) -- waypoint to blip
				SetBlipRoute(destBlip,  false) -- waypoint to blip


                if CurrentVehicle ~= nil then
                    DeleteEntity(CurrentVehicle)
                end

                jobActive = false


                _menuPool:CloseAllMenus()
				GenerateMenu(CokRon)
				TriggerEvent('Cok_Postal:updateMenus')
				_menuPool:ProcessMenus()
            end
        end        
    end

    FirstItem(CokRonActive)
    _menuPool:RefreshIndex()
end

-- Generate Menu first time

--GenerateMenu(CokRon)
GenerateJobActiveMenu(CokRonActive)

function startJobAfterChecks()
	--local selectedVehicle = item:IndexToItem(index)
	--ESX.ShowNotification(selectedVehicle)
	totalCurrentStops = 0
	distance = 0

	SpawnDeliveryVehicle(selectedVehicle)

	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)



	TriggerServerEvent('Cok_Postal:removeSecurityDeposit')
	ESX.ShowNotification('~g~$' ..Config.vehicleSecurityDeposit.. '~y~ has been withdrawn from your bank account as a vehicle deposit')


	jobActive = true
	isOnRoute = true
	destinationNumber = math.random(1, totalStopSelection)
	px = destination[destinationNumber].x
	py = destination[destinationNumber].y
	pz = destination[destinationNumber].z
	distance = round(GetDistanceBetweenCoords(Config.StartJobLocation.x, Config.StartJobLocation.y, Config.StartJobLocation.z, px,py,pz))
	DrawBlip(destination,destinationNumber)

	jobActive = true
	_menuPool:CloseAllMenus()


end

------------------------------------------------------------------ Change Clothes ------------------------------------------------------------------




------------------------------------------------------------------ Spawn Vehicle ------------------------------------------------------------------

function SpawnDeliveryVehicle(vehicleType)
	
	local Rnd           = GetRandomFromRange(1, #Config.ParkingSpawns)
	local SpawnLocation = Config.ParkingSpawns[Rnd]

	if vehicleType == 'Boxville1' then
		local ModelHash = GetHashKey('boxville2')
		WaitModelLoad(ModelHash)
		CurrentVehicle = CreateVehicle(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, SpawnLocation.h, true, true)
		exports['cokKeys']:SetVehicleLocked(CurrentVehicle, 0)
		totalRankStops = 14
	end
	
	if vehicleType == 'Boxville2' then
		local ModelHash = GetHashKey('boxville2')
		WaitModelLoad(ModelHash)
		CurrentVehicle = CreateVehicle(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, SpawnLocation.h, true, true)
		exports['cokKeys']:SetVehicleLocked(CurrentVehicle, 0)
		--SetVehicleExtra(CurrentVehicle, 2, false)
		totalRankStops = 14
	end

	if vehicleType == 'Boxville3' then
		local ModelHash = GetHashKey('boxville2')
		WaitModelLoad(ModelHash)
		CurrentVehicle = CreateVehicle(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, SpawnLocation.h, true, true)
		exports['cokKeys']:SetVehicleLocked(CurrentVehicle, 0)
		--SetVehicleExtra(CurrentVehicle, 2, false)
		totalRankStops = 19
	end

	if vehicleType == 'Pony1' then
		local ModelHash = GetHashKey('pony')
		WaitModelLoad(ModelHash)
		CurrentVehicle = CreateVehicle(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, SpawnLocation.h, true, true)
		exports['cokKeys']:SetVehicleLocked(CurrentVehicle, 0)
		--SetVehicleExtra(CurrentVehicle, 2, false)
		SetVehicleLivery(CurrentVehicle, 1)
		totalRankStops = 19
	end

	if vehicleType == 'Pony2' then
		local ModelHash = GetHashKey('pony')
		WaitModelLoad(ModelHash)
		CurrentVehicle = CreateVehicle(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, SpawnLocation.h, true, true)
		exports['cokKeys']:SetVehicleLocked(CurrentVehicle, 0)
		--SetVehicleExtra(CurrentVehicle, 2, false)
		SetVehicleLivery(CurrentVehicle, 1)
		totalRankStops = 19
	end
	
	--DecorSetInt(CurrentVehicle, "Delivery.Rental", Config.DecorCode)
	SetVehicleOnGroundProperly(CurrentVehicle)

end 


------------------------------------------------------- Routes --------------------------------------------------------

function DrawBlip(destination,base)
	destBlip = AddBlipForCoord(destination[destinationNumber].x,destination[destinationNumber].y, destination[destinationNumber].z)
	SetBlipSprite(destBlip, 1)
	SetBlipColour(destBlip, 3)
	--SetNewWaypoint(destination[destinationNumber].x,destination[destinationNumber].y)
	SetBlipRoute(destBlip,  true) -- waypoint to blip
	SetBlipRouteColour(destBlip, 3)
end

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if jobActive == true then
			if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) == false then
				vehicleBlip = AddBlipForCoord(GetEntityCoords(CurrentVehicle).x,GetEntityCoords(CurrentVehicle).y,GetEntityCoords(CurrentVehicle).z)
				SetBlipSprite(vehicleBlip, 225)
				SetBlipColour(destBlip, 38)
				Citizen.Wait(200)
			else 
				RemoveBlip(vehicleBlip)
		else
			RemoveBlip(vehicleBlip)
		end
	end
end)]]



------------------------------------------------------- Route Function --------------------------------------------------------


Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(0)
		if isOnRoute == true then
			destinate = destination[destinationNumber].name
			--drawTxt("Get in your vehicle and drive to "..destinate .." and deliver the packages",4, 1, 0.45, 0.92, 0.70,255,255,255,255)
			DrawMarker(1,destination[destinationNumber].x,destination[destinationNumber].y,destination[destinationNumber].z, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 0.5,0,255,17, 200, 0, 0, 0, 0)
			if initalTextSent == false then
				ESX.ShowNotification('~b~Drive to the destination and deliver the packages')
				initalTextSent = true
			end
			if GetDistanceBetweenCoords(px,py,pz, GetEntityCoords(GetPlayerPed(-1),true)) < 2 then
				--drawTxt("PRESS E TO DELIVER THE Packages",2, 1, 0.45, 0.03, 0.80,255,255,51,255)
				speed = GetEntitySpeed(CurrentVehicle)
				if speed < 2 then
					showHelpText('Press ~input_pickup~ to deliver the package')
					if IsControlJustPressed(1,38) then
						if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
							if GetVehiclePedIsIn(PlayerPedId(),  true)  == CurrentVehicle then
								totalCurrentStops = totalCurrentStops + 1
								FreezeEntityPosition(CurrentVehicle, true)
								Citizen.Wait(4000)
								FreezeEntityPosition(CurrentVehicle, false)
								if totalCurrentStops <= totalRankStops then
									--totalCurrentStops = totalCurrentStops + 1
									RemoveBlip(destBlip)
									notifyRankStops = totalRankStops + 1
									ESX.ShowNotification('~y~Stops Complete: ~g~' ..totalCurrentStops..' / ' ..notifyRankStops.. ' ')
									isOnRoute = false
									Citizen.Wait(500)
									destinationNumber = math.random(1, totalStopSelection)
									px = destination[destinationNumber].x
									py = destination[destinationNumber].y
									pz = destination[destinationNumber].z
									distance = round(GetDistanceBetweenCoords(Config.StartJobLocation.x, Config.StartJobLocation.y, Config.StartJobLocation.z, px,py,pz))
									totalDistance = totalDistance + distance
									DrawBlip(destination,destinationNumber)
									PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
									--ESX.ShowNotification('~b~Drive to ~g~' ..destinate..'~b~ and deliver the package')
									ESX.ShowNotification('~b~Drive to the destination and deliver the packages')
									isOnRoute = true
								else
									RemoveBlip(destBlip)
									isOnRoute = false
									isToDepot = true
									ESX.ShowNotification('~y~You have completed all deliveries.~n~Return to GoPostal to collect your payment.')
									PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
									returnBlip = AddBlipForCoord(Config.StartJobLocation.x, Config.StartJobLocation.y)
									SetBlipRoute(returnBlip,  true) -- waypoint to blip
									SetBlipRouteColour(returnBlip, 5)
								end
							else
								ESX.ShowNotification('~y~You must use the vehicle provided')
							end
						else
							ESX.ShowNotification('~y~You need to be in your work vehicle')
						end
					end
				end
			end
			if IsEntityDead(GetPlayerPed(-1)) then
				jobActive = false
				base = 0
				RemoveBlip(returnBlip)
				RemoveBlip(destBlip)
				isOnRoute = false
				isToDepot = false
				px = 0
				py = 0
				pz = 0
			end
		end
	end
end)

Citizen.CreateThread(function()
	if Config.useESX then
		RegisterNetEvent('esx:playerLoaded')
		AddEventHandler('esx:playerLoaded', function(xPlayer)
			ESX.TriggerServerCallback('Cok_Postal:CheckLevel', function(level, progress, pay)
				currentRank = level
				currentProgress = progress
			end)
		
			Citizen.Wait(500)
		
			if currentRank == 1 then
				totalProgress = 75
			elseif currentRank == 2 then
				totalProgress = 150
			elseif currentRank == 3 then
				totalProgress = 250
			elseif currentRank == 4 then 
				totalProgress = 500
			elseif currentRank == 5 then
				totalProgress = 'Completed Rankings'
			end	
		end)
	else
		Citizen.Wait(0)
	end
end)

--[[Citizen.CreateThread(function()

	ESX.TriggerServerCallback('Cok_Postal:CheckLevel', function(level, progress, pay)
		currentRank = level
		currentProgress = progress
	end)

	Citizen.Wait(500)

	if currentRank == 1 then
		totalProgress = 80
	elseif currentRank == 2 then
		totalProgress = 200
	elseif currentRank == 3 then
		totalProgress = 300
	elseif currentRank == 4 then 
		totalProgress = 500
	elseif currentRank == 5 then
		totalProgress = 'Completed Rankings'
	end	

	_menuPool:ProcessMenus()
	--GenerateMenu(CokRon)
end)]]

RegisterNetEvent('Cok_Postal:updateMenus')
AddEventHandler('Cok_Postal:updateMenus', function()

	ESX.TriggerServerCallback('Cok_Postal:CheckLevel', function(level, progress, pay)
		currentRank = level
		currentProgress = progress
	end)

	Citizen.Wait(600)

	if currentRank == 1 then
		totalProgress = 75
	elseif currentRank == 2 then
		totalProgress = 150
	elseif currentRank == 3 then
		totalProgress = 250
	elseif currentRank == 4 then 
		totalProgress = 500
	elseif currentRank == 5 then
		totalProgress = 'Completed Rankings'
	end	

	_menuPool:ProcessMenus()
	--GenerateMenu(CokRon)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local start = Config.StartJobLocation
		local distance = #(GetEntityCoords(PlayerPedId()) - start)
	
		if distance < 2.0 then
			_menuPool:ProcessMenus()
			showHelpText('Press ~input_pickup~ to open the ~y~GoPostal~w~ Job Menu')
			if IsControlJustPressed(1, 38) and jobActive == false then
				TriggerEvent('Cok_Postal:updateMenus')
				Citizen.Wait(800)
				GenerateMenu(CokRon)
				CokRon:Visible(not CokRon:Visible())
			elseif IsControlJustPressed(1, 38) and jobActive == true then
				GenerateJobActiveMenu(CokRonActive)
				CokRonActive:Visible(not CokRonActive:Visible())
			end
		end
	end

end)



function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end

function showHelpText(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function GetRandomFromRange(a, b)
	return GetRandomIntInRange(a, b)
end

function WaitModelLoad(name)
	RequestModel(name)
	while not HasModelLoaded(name) do
		Wait(0)
	end
end

function ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end