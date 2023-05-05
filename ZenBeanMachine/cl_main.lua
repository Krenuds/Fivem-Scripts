local QBCore = exports['qb-core']:GetCoreObject()
local vein = exports.vein
local PlayerJob = {}

local function CreateItem(item) 
    exports['ps-ui']:Circle(function(success)
        if success then
            TriggerServerEvent('BeanMachine:server:TryMakeItem', item, true)
        else
            TriggerServerEvent('BeanMachine:server:TryMakeItem', item, false)
            lib.notify({
                title = 'Burned!',
                description = 'Try Again!',
                type = 'error'
            })           
        end
    end, 2, 15)
end

local function BuildContextOptions (_type) 
    local _options = {}
    for item, details in pairs(Config.Recipes) do 
        if details.type == _type then
            local ingredients = ''
            for ingredient, info in pairs(details.ingredients) do
                ingredients = ingredients .. info.name .. ": " .. info.amount .. " "
            end
            table.insert(_options, {
                title = details.name, 
                description = ingredients,  
                onSelect = function ()
                    QBCore.Functions.TriggerCallback('BeanMachine:server:CreateItem', function(result)
                        if result then CreateItem(item) else
                            lib.notify({
                                title = 'Ingredients Missing',
                                description = 'You are short on ingredients!',
                                type = 'error'
                            })
                        end
                    end, item)
                end,
            })
        end
    end
    return _options
end

local drinkItemOptions = BuildContextOptions("drink")
local foodItemOptions = BuildContextOptions("food")

lib.registerContext({
    id = 'theDrinkMachine',
    title = 'Brew Delicious Coffee',
    options = drinkItemOptions,
})

lib.registerContext({
    id = 'theFoodMachine',
    title = 'Donuts and Pastries',
    options = foodItemOptions,
})

local function AddBlip()
    local loc = Config.blipLocation
    local blip = AddBlipForCoord(loc.x, loc.y, loc.z)
    SetBlipSprite (blip, 93)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bean Machine")
    EndTextCommandSetBlipName(blip)
end

local IsEmployee = function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == 'beanmachine' then
        return true
    else
        return false
    end
end

local function CreateZones()

    --SHOP
    exports.ox_target:addBoxZone({
        name = "sink",
        coords = vec3(124.4, -1039.53, 28.7),
        size = vec3(2.5, 6, 1.0),
        rotation = 340.0,   
        distance = 1,
        job = "beanmachine",
        options = {
            {
                canInteract = IsEmployee,
                name = 'ingredients',
                icon = 'fa-solid fa-jar-wheat',
                label = 'Ingredients Cabinet',
                event = 'BeanMachine:client:OpenShop',
            }
        }
        
    })
    
    --DRINK MACHINE
    exports.ox_target:addBoxZone({
        name = "coffeeMachine",
        coords = vec3(122.85, -1041.64, 29.5),
        size = vec3(0.45, 0.7, 0.5),
        rotation = 339.0,
        distance = 1,
        options = {
            {
                canInteract = IsEmployee,
                name = 'makeCoffee',
                type = 'client',
                icon = 'fa-solid fa-mug-hot',
                label = 'Make Bevereges',
                onSelect = function ()
                    lib.showContext('theDrinkMachine')
                end
            }
        }
    })

    --DRINK MACHINE
    exports.ox_target:addBoxZone({
        name = "coffeeMachine2",
        coords = vec3(124.6, -1036.9, 29.5),
        size = vec3(0.45, 0.7, 0.5),
        rotation = 339.0,
        distance = 1,  
        options = {
            {
                canInteract = IsEmployee,
                name = 'makeCoffee',
                icon = 'fa-solid fa-mug-hot',
                label = 'Make Bevereges',
                onSelect = function ()
                    lib.showContext('theDrinkMachine')
                end
            }
        }
    })

    --FOOD MACHINE
    exports.ox_target:addBoxZone({
        name = "donutCabinet",
        coords = vec3(121.42, -1038.42, 29.45),
        size = vec3(0.6, 1.45, 0.50000000000001),
        rotation = 340.0,
        distance = 1,     
        options = {
            {
                canInteract = IsEmployee,
                name = 'donutsCabinet',
                icon = 'fa-solid fa-circle-dot',
                label = 'Make Pastries',
                onSelect = function ()
                    lib.showContext('theFoodMachine')
                end
            }
        }
    })

    --FOOD TRAY
    exports.ox_target:addBoxZone({
        name = "beanMachineTray1",
        coords = vec3(120.57, -1040.74, 29.25),
        size = vec3(0.5, 0.6, 0.1),
        rotation = 340.75,
        distance = 2,
        options = {
            {
                name = 'tray1',
                icon = 'fa-solid fa-circle-dot',
                label = 'Counter',
                event = 'BeanMachine:client:tray',
            }
        }
    })

    --FOOD TRAY
    exports.ox_target:addBoxZone({
        name = "beanMachinetray2",
        coords = vec3(121.81, -1037.1, 29.25),
        size = vec3(0.5, 0.6, 0.1),
        rotation = 340.75,
        distance = 2,
        options = {
            {
                name = 'tray2',
                icon = 'fa-solid fa-circle-dot',
                label = 'Counter',
                event = 'BeanMachine:client:tray',
            }
        }
    })

    --STASH
    exports.ox_target:addBoxZone({
        name = "storageCabinet",
        coords = vec3(121.71, -1038.53, 28.85),
        size = vec3(0.6, 3.3, 0.65000000000001),
        rotation = 340.0,
        distance = 1,
        options = {
            {
                canInteract = IsEmployee,
                name = 'storage',
                icon = 'fa-solid fa-cube',
                label = 'Storage Cabinet',
                event = 'BeanMachine:client:stash',
            }
        }
    })
end

RegisterNetEvent('BeanMachine:client:stash', function()
     exports.ox_inventory:openInventory('stash', 'beanmachine')
end)
RegisterNetEvent('BeanMachine:client:tray', function()
    exports.ox_inventory:openInventory('stash', 'beanmachinecounter')
end)

RegisterNetEvent('BeanMachine:client:OpenShop', function()
    exports.ox_inventory:openInventory('shop', {type = 'beanMachine', slots = 8})
end)


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData) 
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo end)

CreateThread(function()
    AddBlip()
    CreateZones()
end)