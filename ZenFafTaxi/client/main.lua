QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for _, station in pairs(FAFConfig.Locations["stations"]) do
        print "adding blip"
        local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
        SetBlipSprite(blip, 198)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 60)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(station.label)
        EndTextCommandSetBlipName(blip)
    end
end)



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
        --   {
        --       num = 2,
        --       type = "client",
        --       event = "fafTaxi:stash",
        --       icon = 'fas fa-example',
        --       label = 'Stash',
        --       job = 'faf',
        --   },
        --   {
        --       num = 3,
        --       type = "client",
        --       event = "fafTaxi:armory",
        --       icon = 'fas fa-example',
        --       label = 'Armory',
        --       job = 'faf',
        --       },
          {
              num = 4,
              type = "client",
              action = function()
              MenuGarage();
          end,
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
    distance = 1
})
