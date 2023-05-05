local bossNPC = nil
local clockedIn = false
local blip = nil
local workTruck = nil
local foodCart = nil
local foodCartAttachedToTruck = nil
local ingredientsCount = 0
local currentWorkArea = nil

local function DetachCartFromTruck() 
    while not workTruck and not foodCart do 
        Wait(10)
    end
    local cartBackCoords = GetOffsetFromEntityInWorldCoords(workTruck, 0.0, -5.0, 0.0)
    DetachEntity(foodCart, true, true)
    SetEntityCoords(foodCart, cartBackCoords)
    PlaceObjectOnGroundProperly(foodCart)
    
    foodCartAttachedToTruck = false
end

local function AttachCartToTruck() 
    while not workTruck do 
        Wait(10)
    end
    AttachEntityToEntity(foodCart, workTruck, GetEntityBoneIndexByName(workTruck, "misc_a"), 0.0, -1.8, 0.0, 0.0, 0.0, 90.0, true, true, false, true, 1, true) 
    if foodCartAttachedToTruck == nil then 
        exports['qb-target']:AddTargetEntity(workTruck, {
            options = {
                {
                    num = 1,
                    type = "client",
                    icon = 'fas fa-example',
                    label = 'Unload Cart',
                    canInteract = function()
                        return foodCartAttachedToTruck == true
                    end,
                    action = function()
                        DetachCartFromTruck()
                    end,    
                },
                {
                    num = 2,
                    type = "client",
                    icon = 'fas fa-example',
                    label = 'Load Cart',
                    canInteract = function()
                        return foodCartAttachedToTruck == false
                    end,
                    action = function()
                        AttachCartToTruck()
                    end,    
                },
            },
            distance = 2.5,
        })
    end
    foodCartAttachedToTruck = true
end

local function SpawnFoodTruck() 
    local loc = vector4(-585.02, -902.68, 25.68, 83.31)
    local workTruckHash = GetHashKey("bison") 
    while not HasModelLoaded(workTruckHash) do 
        Wait(10)
        RequestModel(workTruckHash)
    end
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        workTruck = NetToVeh(netId)
        SetVehicleNumberPlateText(workTruck, "FOOD-" .. tostring(math.random(10, 99)))
        SetEntityHeading(workTruck, loc.w)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(workTruck))
        SetVehicleEngineOn(workTruck, true, true)
        SetVehicleDoorOpen(workTruck, 5, false, false)
    end, workTruckHash, loc, false)

end

local function CreateFoodCart() 
    local loc = vector4(-575.35, -897.47, 25.7, 307.04)
    local foodCartHash = GetHashKey("prop_hotdogstand_01") 
    while not HasModelLoaded(foodCartHash) do 
        Wait(10)
        RequestModel(foodCartHash)
    end
    foodCart = CreateObject(foodCartHash, loc.x, loc.y, loc.z, true, true, true)
end

local function StartIngredientsRun ()
    QBCore.Functions.TriggerCallback('ZenFoodCart:server:CheckInvForList', function(hasList)
        if not hasList then
            TriggerServerEvent('ZenFoodCart:server:GiveIngredientList')
        end
    end)
    SetNewWaypoint(Config.Locations.ingredientStore)
    local alert = lib.alertDialog({
        header = 'You are running low on ingredients!',
        content = 'Head down to the produce vendor  \n And Stock up',
        centered = true,
    })
end 

local function StartJob()
    lib.notify({
        id = 'StartWork',
        title = 'Time to get to work!',
        duration = '500',
        description = 'The people are waiting',
        position = 'top-right',
        style = {
            backgroundColor = '#141517',
            color = '#909296'
        },
        icon = 'fa-solid fa-utensils',
        iconColor = '#9eecff'
    })
    while clockedIn and ingredientsCount > 0 do 
        Wait(10)
        if currentWorkArea == nil and clockedIn then
            currentWorkArea = Config.WorkAreas[math.random(#Config.WorkAreas)]
            SetNewWaypoint(currentWorkArea)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            currentWorkArea = AddBlipForRadius(currentWorkArea.x, currentWorkArea.y, currentWorkArea.z, 100.0)
            SetBlipSprite(currentWorkArea, 9)
            SetBlipColour(currentWorkArea, 1)
            SetBlipAlpha(currentWorkArea, 90)
            SetBlipAsShortRange(currentWorkArea, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("Hungry Customers")
            EndTextCommandSetBlipName(currentWorkArea) 
        end
    end
end

local function SignIn()
    TriggerServerEvent('ZenFoodCart:server:CreateNewVendor', workTruck)
    SpawnFoodTruck()
    CreateFoodCart()
    AttachCartToTruck()

    if (workTruck and foodCart and foodCartAttachedToTruck) then
        QBCore.Functions.TriggerCallback('ZenFoodCart:server:CheckInvForIngredients', function(ingredients)
            ingredientsCount = ingredients
            if ingredients >= 10 then
                StartJob()
            else 
                StartIngredientsRun()
            end
        end)
    end
end

local function SignOut()
    clockedIn = false
    DeleteVehicle(workTruck)
    DeleteObject(foodCart)
    TriggerServerEvent('ZenFoodCart:server:RemoveVendor')
    foodCartAttachedToTruck = nil
    workTruck = nil
    RemoveBlip(currentWorkArea)
    currentWorkArea = nil
end

local function IngredientsTransaction()
    TriggerServerEvent('ZenFoodCart:server:ExchangeListForProduce')
    QBCore.Functions.TriggerCallback('ZenFoodCart:server:CheckInvForIngredients', function(ingredients)
        ingredientsCount += ingredients
        StartJob()
    end)
end

local function CreateJobNPCs()
    local bossLoc = vector4(-584.88, -896.98, 24.95, 175.77)
    local npcHashKey = GetHashKey('a_m_m_afriamer_01')
    RequestModel(npcHashKey)
    while not HasModelLoaded(npcHashKey) do
      Wait(1)
    end
    bossNPC = CreatePed(0, npcHashKey, bossLoc.x, bossLoc.y, bossLoc.z, bossLoc.w, false, false)
    FreezeEntityPosition(bossNPC, true)
    SetEntityInvincible(bossNPC, true)
    SetBlockingOfNonTemporaryEvents(bossNPC, true)
    TaskStartScenarioInPlace(bossNPC, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    exports['qb-target']:AddTargetEntity(bossNPC, {
        options = {
            {
                num = 1,
                type = "client",
                icon = 'fas fa-example',
                label = 'Clock In',
                item = 'WEAPON_KATANA',
                canInteract = function() return clockedIn == false end,
                action = function()
                    clockedIn = true 
                    SignIn()
                end,    
            },
            {
                num = 2,
                type = "client",
                icon = 'fas fa-example',
                label = 'Clock Out',
                canInteract = function () return clockedIn == true end,
                action = function()
                    clockedIn = false 
                    SignOut()
                end,
                
            },
        },
        distance = 2.5,
    })
    local vendorLoc = vector4(-1271.47, -1418.66, 3.37, 39.79)
    local npcHashKey = GetHashKey('U_M_O_FinGuru_01')
    RequestModel(npcHashKey)
    while not HasModelLoaded(npcHashKey) do
      Wait(1)
    end
    vendorNPC = CreatePed(0, npcHashKey, vendorLoc.x, vendorLoc.y, vendorLoc.z, vendorLoc.w, false, false)
    FreezeEntityPosition(vendorNPC, true)
    SetEntityInvincible(vendorNPC, true)
    SetBlockingOfNonTemporaryEvents(vendorNPC, true)
    TaskStartScenarioInPlace(vendorNPC, 'WORLD_HUMAN_AA_COFFEE', 0, true)
    exports['qb-target']:AddTargetEntity(vendorNPC, {
        options = {
            {
                num = 1,
                type = "client",
                icon = 'fas fa-example',
                label = 'Buy Food Cart Ingredients',
                item = 'food_cart_list',
                action = function()
                    IngredientsTransaction()
                end, 
            },
        },
        distance = 2.5,
    })
end

local function CreateBlip()
    loc = vector3(-584.98, -898.64, 25.7)
    blip = AddBlipForCoord(loc.x, loc.y, loc.z)
    SetBlipSprite(blip, 616)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 10)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Food Truck Driver")
    EndTextCommandSetBlipName(blip)
end

--START RESOURCE
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    CreateJobNPCs()
    CreateBlip()
  end)
  
--STOP RESOURCE
  AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if bossNPC ~= nil then
      DeleteEntity(bossNPC)
      RemoveBlip(blip)
    end
    if vendorNPC ~= nil then
        DeleteEntity(vendorNPC)
      end
  end)

  RegisterNetEvent('dispatch:clNotify')
  AddEventHandler('dispatch:clNotify', function(sNotificationData, sNotificationId)
    if clockedIn then
        loc = sNotificationData.origin
        QBCore.Functions.Notify("Delivery Incoming", 'success')
        blip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetNewWaypoint(loc.x, loc.y)
        lib.notify({
            title = 'Crime Alert',
            description = json.encode(sNotificationData),
            type = 'success'
        })
        CreateThread(function()
            Wait(20000)
            RemoveBlip(blip)
        end)
    end
end)
