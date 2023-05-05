local PlayerJob = {}
local onDuty = false
local debuginfo = false

local function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

local function TakeOutVehicle(vehicleInfo)
    local coords = FAFConfig.Locations["vehicle"].loc
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        SetVehicleNumberPlateText(veh, "FAF" .. tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        exports['ps-fuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 48, 0, true)
        SetVehicleModColor_1(veh, 3, 0, 0)
        SetVehicleModColor_2(veh, 3, 0, 0)
        QBCore.Shared.SetDefaultVehicleExtras(veh, FAFConfig.VehicleSettings[vehicleInfo].extras)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, vehicleInfo, coords, true)
end

 function MenuGarage()
    local vehicleMenu = {
        {
            header = "FAF Garage",
            isMenuHeader = true
        }
    }

    local authorizedVehicles = FAFConfig.AuthorizedVehicles[QBCore.Functions.GetPlayerData().job.grade.level]
    for veh, label in pairs(authorizedVehicles) do
        vehicleMenu[#vehicleMenu + 1] = {
            header = label,
            txt = "",
            params = {
                event = "fafTaxi:client:TakeOutVehicle",
                args = {
                    vehicle = veh
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu + 1] = {
        header = "Close Menu",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

RegisterNetEvent('fafTaxi:client:TakeOutVehicle', function(data)
    local vehicle = data.vehicle
    TakeOutVehicle(vehicle)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if PlayerJob.name == 'faf' then
        onDuty = PlayerJob.onduty
        if PlayerJob.onduty then
            TriggerServerEvent("fafTaxi:server:AddDriver", PlayerJob.name)
        else
            TriggerServerEvent("fafTaxi:server:RemoveDriver", PlayerJob.name)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    local ped = PlayerPedId()
    local player = PlayerId()

    CreateThread(function()
        Wait(1000)
        QBCore.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
            onDuty = PlayerData.job.onduty
            if PlayerJob.name == 'faf' and onDuty then
                TriggerServerEvent("fafTaxi:server:AddDriver", PlayerJob.name)
            end
        end)
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if PlayerJob.name == 'faf' and onDuty then
        TriggerServerEvent("fafTaxi:server:RemoveDriver", PlayerJob.name)
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    if PlayerJob.name == 'faf' and duty ~= onDuty then
        if duty then
            TriggerServerEvent("fafTaxi:server:AddDriver", PlayerJob.name)
        else
            TriggerServerEvent("fafTaxi:server:RemoveDriver", PlayerJob.name)
        end
    end

    onDuty = duty
end)

RegisterNetEvent('fafTaxi:stash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash",
        "fafTaxistash_" .. QBCore.Functions.GetPlayerData().citizenid)
    TriggerEvent("inventory:client:SetCurrentStash", "fafTaxistash_" .. QBCore.Functions.GetPlayerData().citizenid)
end)

RegisterNetEvent('fafTaxi:armory', function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "fafTaxi", FAFConfig.Items)
end)

RegisterNetEvent('DriverToggle:Duty', function()
    onDuty = not onDuty
    TriggerServerEvent("QBCore:ToggleDuty")
    TriggerServerEvent("fafTaxi:server:UpdateBlips")
end)

RegisterNetEvent('fafMenu:client:Menu', function()
    MenuGarage()
end)
-- CreateThread(function()
--     local model = `U_M_M_Vince`
--     RequestModel(model)
--     while not HasModelLoaded(model) do
--       Wait(0)
--     end
--     local entity = CreatePed(0, model, vector3(1137.26, -784.83, 56.6), 356.76, true, false)
--     FreezeEntityPosition(entity, true)
--     SetBlockingOfNonTemporaryEvents(entity, true)
--     SetEntityInvincible(entity, true)
--     exports['qb-target']:AddTargetEntity(entity, { 
--       options = { 
--         {
--           num = 1,
--           type = "client",
--           event = "DriverToggle:Duty",
--           icon = 'fas fa-example',
--           label = 'Toggle Duty',
--           job = 'faf', 
--         },
--         {
--             num = 2,
--             type = "client",
--             event = "fafTaxi:stash",
--             icon = 'fas fa-example',
--             label = 'Stash',
--             job = 'faf', 
--         },
--         {
--             num = 3,
--             type = "client",
--             event = "fafTaxi:armory",
--             icon = 'fas fa-example',
--             label = 'Armory',
--             job = 'faf', 
--             },
--         {
--             num = 4,
--             type = "client",
--             action = function()
--             MenuGarage();
--         end,
--             icon = 'fas fa-example',
--             label = 'Grab Vehicle',
--             job = 'faf', 
--         },
--         {
--             num = 5,
--             type = "client",
--             event = "qb-bossmenu:client:OpenMenu",
--             icon = 'fas fa-example',
--             label = 'Boss Menu',
--             job = 'faf', 
--         },
--       },
--       distance = 2.5,
--     })
--   end)


exports['qb-target']:AddBoxZone("faftaxi", vector3(1138.2, -786.51, 57.6), 0.6, 1.6, {
    name="faftaxi",
    heading = 0,
  --debugPoly = true,
    minZ = 56.6,
    maxZ = 58.0
  

}, {
    options = {
        {
            num = 1,
            type = "client",
            event = "DriverToggle:Duty",
            icon = 'fas fa-example',
            label = 'Toggle Duty',
            job = 'faf', 
          },
          {
              num = 2,
              type = "client",
              event = "fafTaxi:stash",
              icon = 'fas fa-example',
              label = 'Stash',
              job = 'faf',
          },
          {
              num = 3,
              type = "client",
              event = "fafTaxi:armory",
              icon = 'fas fa-example',
              label = 'Armory',
              job = 'faf',
              },
          {
              num = 4,
              type = "client",
              event = "fafTaxi:client:TakeOutVehicle",
              icon = 'fas fa-example',
              label = 'Grab Vehicle',
              job = 'faf', 
          },
          {
              num = 5,
              type = "client",
              event = "qb-bossmenu:client:OpenMenu",
              icon = 'fas fa-example',
              label = 'Boss Menu',
              job = 'faf', 
          },
    },
    distance = 2
})

