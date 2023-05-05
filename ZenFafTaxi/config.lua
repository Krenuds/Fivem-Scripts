FAFConfig = {}

FAFConfig.Locations = { 
    ["stations"] = {
        [1] = {label = "Fast As Fuck Taxi", coords = vector4(1144.27, -776.37, 57.6, 346.29)}
    }, 
    ["npc"] = {
        loc = vector3(1137.26, -784.83, 57.6),
    },
    ["vehicle"] = {
        loc = vector4(1139.08, -780.34, 57.6, 359.88),
    },
}
FAFConfig.VehicleSettings = {
    ["cheburek"] = { --- Model name
        ["extras"] = {
            ["1"] = true, -- on/off
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
            ["6"] = true,
            ["7"] = true,
            ["8"] = true,
            ["9"] = true,
            ["10"] = true,
            ["11"] = true,
            ["12"] = true,
            ["13"] = true,
        },
		["livery"] = 0,
    },
    ["stretch"] = {
        ["extras"] = {
            ["1"] = true,
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
            ["6"] = true,
            ["7"] = true,
            ["8"] = true,
            ["9"] = true,
            ["10"] = true,
            ["11"] = true,
            ["12"] = true,
            ["13"] = true,
        },
		["livery"] = 1,
    }
}
FAFConfig.AuthorizedVehicles = {
	[0] = {
		["cheburek"] = "Rune Cheburek",
	},
	[1] = {
		["cheburek"] = "Rune Cheburek",
	},
	[2] = {
		["cheburek"] = "Rune Cheburek",
        ["stretch"] = "The Stretch",
	},
	[3] = {
		["cheburek"] = "Rune Cheburek",
        ["superd"] = "Super Deluxe",
        ["stretch"] = "The Stretch",
	},
	[4] = {
		["cheburek"] = "Rune Cheburek",
        ["superd"] = "Super Deluxe",
        ["stretch"] = "The Stretch",
	}
}

FAFConfig.Items = { 
    label = "Fast As Fuck General Store",
    slots = 30,
    items = {
        [1] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "jerry_can",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "cleaningkit",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "repairkit",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
    }
}

