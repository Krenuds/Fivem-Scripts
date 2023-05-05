local currentVendors = {}

RegisterNetEvent('ZenFoodCart:server:CreateNewVendor', function(workTruck)
    currentVendors[source] = workTruck
end)

RegisterNetEvent('ZenFoodCart:server:RemoveVendor', function()
    currentVendors[source] = nil
end)

RegisterNetEvent('ZenFoodCart:server:ExchangeListForProduce', function()
    local  Player = QBCore.Functions.GetPlayer(source) 
    local  src = source
    Player.Functions.AddItem('food_cart_ingredients', 10)
    Player.Functions.RemoveItem('food_cart_list', 1)

    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["trash_newspaper" ], 'remove', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["cornucopia" ], 'add', 10)
    -- TriggerClientEvent('QBCore:Notify', source, "You made the dough", "success", 4000)
end)

RegisterNetEvent('ZenFoodCart:server:GiveIngredientList', function()
    local  Player = QBCore.Functions.GetPlayer(source) 
    local  src = source
    Player.Functions.AddItem('food_cart_list', 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["trash_newspaper" ], 'add', 1)

end)

QBCore.Functions.CreateCallback('ZenFoodCart:server:CheckInvForList', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local HasItem = exports.ox_inventory:Search(source, 'count', 'food_cart_list')
        if HasItem > 0 then
            cb(true)
        else
            cb(false)
        end
    end
end)

QBCore.Functions.CreateCallback('ZenFoodCart:server:CheckInvForIngredients', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        cb(exports.ox_inventory:Search(source, 'count', 'food_cart_ingredients'))
    end
end)