local QBCore = exports['qb-core']:GetCoreObject()
local DriverCount = 0
local Drivers = {}

-- Business app?
RegisterNetEvent('fafTaxi:server:AddDriver', function(job)
	if job == 'fafTaxi' then
		local src = source
		DriverCount = DriverCount + 1
		TriggerClientEvent("fafTaxi:client:SetDriverCount", -1, DriverCount)
		Drivers[src] = true
	end
end)

RegisterNetEvent('fafTaxi:server:RemoveDriver', function(job)
	if job == 'fafTaxi' then
		local src = source
		DriverCount = DriverCount - 1
		TriggerClientEvent("fafTaxi:client:SetDriverCount", -1, DriverCount)
		Drivers[src] = nil
	end
end)

QBCore.Functions.CreateCallback('fafTaxi:GetDrivers', function(_, cb)
	local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v.PlayerData.Job.name == 'faf' and v.PlayerData.job.onduty then
			amount = amount + 1
		end
	end
	cb(amount)
end)

exports('GetDriverCount', function() return DriverCount end)
