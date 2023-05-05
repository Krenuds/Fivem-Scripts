local QBCore = exports['qb-core']:GetCoreObject()
local objects = {}
local itemsLoaded = false
local soundIsPlaying = false
local soundRepeatInterval = 8000
local broadcastFrequency = 144.0
local PlayerID =  GetPlayerServerId(PlayerId())
local function GetAClue (clue)
    QBCore.Functions.Notify("You found a clue!", 'success', 4000)
    TriggerServerEvent('scav:server:getItem', clue)
end

--Challenges
local function FindAClue(clue)
    local name = clue.configItem.name
    if clue.challenge then
        local challengeName = clue.challenge

        --Circle Challenge
        if challengeName == 'circle' then
            exports['ps-ui']:Circle(function(success)
                if success then
                    GetAClue(name)
                else
                    QBCore.Functions.Notify('Could Not Open', 'error', 5000)
                end
            end, 8, 8) 

        --Circle 2 Challenge
        elseif challengeName == 'circle2' then
            local haskeys = QBCore.Functions.HasItem('setofkeys', 1)

            if haskeys then
                exports['ps-ui']:Circle(function(success)
                    if success then
                        GetAClue(name)
                    else
                        QBCore.Functions.Notify('Could Not Open', 'error', 5000)
                    end
                end, 8, 8) 
            else
                QBCore.Functions.Notify('You need a set of keys to unlock this box.', 'error', 5000)
            end

        --Thermite Challenge
        elseif challengeName == 'thermite' then
            exports['ps-ui']:Thermite(function(success)
                if success then
                    GetAClue(name)
                else
                    QBCore.Functions.Notify('Could Not Open', 'error', 5000)
                end
             end, 20, 5, 5) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks

        --Password 1 Challenge
        elseif challengeName == 'password1' then
            local password = "3209"

            local input = exports ['ps-ui']:Input({
                title = "Locked",
                inputs = {
                    {
                        type = "password",
                        placeholder = "####"
                    }
                }
            })

            if input[1]:lower() == password:lower() then
                GetAClue(name)
            else 
                QBCore.Functions.Notify('Wrong Combination', 'error', 5000)
            end 

        --Password 2 Challenge
        elseif challengeName == 'password2' then
            local password = "ForgetMeNot"

            local input = exports ['ps-ui']:Input({
             title = "I have a blue eye, but I can't see. I have a round face, but expressionless it be. I hold your memories, but I'm not your brain.",
             inputs = {
                    {
                        type = "password",
                        placeholder = "What am I?"
                    }
                }
            })
            -- Remove spaces from the input string using string.gsub
            local inputWithoutSpaces = string.gsub(input[1], "%s", "")
    
            if inputWithoutSpaces:lower() == password:lower() then
                GetAClue(name)
            else 
                QBCore.Functions.Notify('Wrong Password', 'error', 5000)
            end 
    end
        else 
            GetAClue(name)
        end 
end


local function CreateItems (configItems)
    for k, v in pairs(configItems) do
        local model = GetHashKey(v.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end
        local obj = CreateObject(model, v.location.x, v.location.y, v.location.z, false, true, true)
        SetEntityHeading(obj, v.location.w)
        FreezeEntityPosition(obj, true)
        SetEntityInvincible(obj, true)
        SetEntityAsMissionEntity(obj, true, true)
        configItems[k].obj = obj

        local options = {
            {
                name = k,
                onSelect = function ()
                    FindAClue(v)
                end,
                icon = v.icon,
                label = v.description,
            }
        }
        exports.ox_target:addLocalEntity(obj, options)
    end
    itemsLoaded = true
end

local function DeleteItems (configItems)
    for k, v in pairs(configItems) do
        if v.obj then
            DeleteObject(v.obj)
            v.obj = nil
        end
    end
    itemsLoaded = false
end

AddEventHandler('onResourceStart', function (resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    CreateItems(Config.Clues)
end)

AddEventHandler('onResourceStop', function (resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    DeleteItems(Config.Clues)
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function (source)
    if itemsLoaded then return end
    print('scav:Client:OnPlayerLoaded')
     CreateItems(Config.Clues)
end)

RegisterNetEvent ('scav:revealClue', function(clue)
    local name = clue.configItem.name
    local image = tostring(LoadResourceFile(GetCurrentResourceName(), 'images/'..name..'.txt'))
    exports['ps-ui']:ShowImage(image)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local currentChannel = Player(PlayerID).state['radioChannel']

        if currentChannel == broadcastFrequency and not soundIsPlaying  then
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "morse", 0.4)
            soundIsPlaying = true
        elseif currentChannel ~= broadcastFrequency and soundIsPlaying then
            TriggerServerEvent('InteractSound_SV:StopOnSource')
            soundIsPlaying = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if soundIsPlaying then
            Citizen.Wait(soundRepeatInterval)
            soundIsPlaying = false 
        end 
    end
end)
