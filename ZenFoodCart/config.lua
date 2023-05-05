QBCore = exports['qb-core']:GetCoreObject()
Config = {}

Config.Locations = {
    ingredientStore = vector3(-1273.28, -1417.14, 4.37) 
}

Config.WorkAreas = {
    vector3(-1354.16, -1114.37, 4.07), --Mirror Restaraunt
    vector3(407.69, -983.6, 29.27),  --Mission Row
    vector3(278.44, -584.68, 43.3), --Pillbox
    vector3(-512.78, -258.34, 35.56), --City Hall
    vector3(-1656.06, -1026.76, 13.02), --Del Perro Pier
    vector3(379.62, -1270.13, 32.33), --Blaze It
    vector3(-365.96, -121.0, 38.72), --Rising Sun
    vector3(808.58, -816.03, 26.19), --Ottos
}
Config.MealTypes = {
    ['Burgers'] = {
        ingredients = {
            ['Bun'] = 1,
            ['Meat'] = 1,
            ['Lettuce'] = 1,
            ['Tomato'] = 1,
            ['Cheese'] = 1,
        },
    },
    
    ['Fish'] = {
        ingredients = {
            ['Bun'] = 1,
            ['Fish'] = 1,
            ['Lettuce'] = 1,
            ['Tomato'] = 1,
            ['Cheese'] = 1,
        },
    },
    ['hotdogs'] = {
        ingredients = {
            ['Bun'] = 1,
            ['Sausage'] = 1,
            ['Lettuce'] = 1,
            ['Tomato'] = 1,
            ['Cheese'] = 1,
        },
    }
 }