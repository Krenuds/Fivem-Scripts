local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('BeanMachine:server:TryMakeItem', function(item, success)
    local Player = QBCore.Functions.GetPlayer(source)
    for ingredient, info in pairs (Config.Recipes[item].ingredients) do
        Player.Functions.RemoveItem(info.name, info.amount)
    end 
    if success then Player.Functions.AddItem(item, 1) end
    
end)

QBCore.Functions.CreateCallback('BeanMachine:server:CreateItem', function(source, cb, foodItem)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        for item, requiredItem in pairs(Config.Recipes[foodItem].ingredients) do
           local ingredientCount = exports.ox_inventory:Search(source, 'count', requiredItem.name)
           if ingredientCount < requiredItem.amount then
                cb(false)
                return
           end
        end 
        cb(true)
    end
end)