local QBCore = exports['qb-core']:GetCoreObject()
local huntStarted = false
local path = GetResourcePath(GetCurrentResourceName())
for k,v in pairs (Config.Clues) do
    if v.configItem then
        exports['qb-core']:AddItem(v.configItem.name, v.configItem)
        QBCore.Functions.CreateUseableItem(v.configItem.name, function(source, item)
            TriggerClientEvent('scav:revealClue', source, v)
        end)
        
    end
end

RegisterServerEvent('scav:server:getItem')
AddEventHandler('scav:server:getItem', function(_item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = _item
    Player.Functions.AddItem(item, 1)
end)