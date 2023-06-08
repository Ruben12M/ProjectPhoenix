Config = {}

--#### GENERAL CONFIG ####
Config.QBCoreGetCoreObject = 'qb-core'  --- @param Modify it if you use an QBCore Custom.
Config.ExportMenu = 'qb-menu' --- @param Modify use 'qb-menu' or 'ox' to use ox_lib menus (in case of 'ox' uncomment the line 8 fxmanifest.lua )
Config.WeatherScript = 'cd_easytime' --- @param Choose between 'qb' or 'cd_easytime'
Config.ClothingScript = 'illenium-appearance' --- @param Choose between 'qb-clothing', 'fivem-appearance' or 'illenium-appearance'.

Config.ApartmentSystem = true --- @param Set to 'false' if you dont want to use apartments system.
Config.StashWeight = 150000
Config.StashSlots = 50

Config.DefaultSpawn = vector3(-1035.71, -2731.87, 12.86) --- @param Modify if you dont want to use apartment system, this will be the first spawn loc.

Config.FreeCharacters = 1
Config.PremiumSlots = { --- @param Set here the premium slots 
    { license = "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", slots = 2 },
}

--#### PED AND CAM COORDS ####
Config.PreviewCoords = vector4(-802.73, 341.02, 206.22, 195.4)
Config.PedCoords = vector4(-761.98, 318.37, 170.6, 356.56)  
Config.CamCoords = vector4(-761.97, 321.38, 170.6, 176.31)  

Config.DefaultClothes = { --- @param Set default clothes for non-created peds.
    [0] = {drawable = 0, texture = 0}, -- Face
    [1] = {drawable = 0, texture = 0}, -- Mask
    [2] = {drawable = 0, texture = 0}, -- Hair  
    [3] = {drawable = 0, texture = 0}, -- Torso
    [4] = {drawable = 1, texture = 0}, -- Leg
    [5] = {drawable = 0, texture = 0}, -- Parachute
    [6] = {drawable = 1, texture = 0}, -- Shoes
    [7] = {drawable = -1, texture = 0}, -- Accessory
    [8] = {drawable = 15, texture = 0}, -- Undershirt
    [9] = {drawable = 0, texture = 0}, -- Kevlar
    [10] = {drawable = 0, texture = 0}, -- Badge
    [11] = {drawable = 0, texture = 0}, -- Torso
}

--#### ANIMATIONS ####
Config.Animations = { --- @param Modify the animations ped does in the char selector scren.
    "WORLD_HUMAN_HANG_OUT_STREET", 
    "WORLD HUMAN STAND IMPATIENT", 
    "WORLD_HUMAN_STAND_MOBILE", 
    "WORLD_HUMAN_SMOKING_POT", 
    "WORLD_HUMAN_LEANING",  
    "WORLD_HUMAN_TOURIST_MAP", 
}

--#### APARTMENTS ####
Config.UsePhoneEmail = false --- @param Set to 'true' if you want to use phone emails instead normal notifications and config your phone on 'config_client.lua'
Config.PayToMove = false --- @param Set to 'true' if you have more then 1 apartment and you want to charge player for moving to other apartment
Config.ValueToMove = 50000
Config.EnableRent = true
Config.PriceRent = 1000
Config.IntervalRent = 500 -- 1000 = 1hour, 500 = 30minutes e.g....


Config.Apartments = {
    ["apartment1"] = {
        name = "apartment1", -- never change this name
        label = "Integrity Way", -- never change this name
        coords = vector4(269.73, -640.75, 42.02, 249.07),
        polyzoneBoxData = {
            heading = 250,
            minZ = 40,
            maxZ = 43.5,
            debug = false,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        }
    },
    
    ["apartment2"] = {
        name = "apartment2",
        label = "Morningwood Blvd",
        coords = vector4(-1288.52, -430.51, 35.15, 124.81),
        polyzoneBoxData = {
            heading = 124,
            minZ = 34.0,
            maxZ = 37.0,
            debug = false,
            length = 1,
            width = 3,
            distance = 2.0,
            created = false
        }
    },
    ["apartment3"] = { 
        name = "apartment3", 
        label = "South Rockford Drive",
        coords = vector4(-667.02, -1105.24, 14.63, 242.32),
        polyzoneBoxData = {
            heading = 245,
            minZ = 13.5,
            maxZ = 16.0,
            debug = false,
            length = 1,
            width = 3,
            distance = 2.0,
            created = false
        }
    },
}

--#### COMMANDS ####
Config.Commands = { 
    --STAFF 
    ["deletechar"] = { Command ="deletechar", Permission = "god"}, 
}

--#### NOTIFICATIONS ####
function ShowNotification(msg, type) 
    if type == 'inform' then 
		QBCore.Functions.Notify(msg, "primary")
    end
    if type == 'error' then 
        QBCore.Functions.Notify(msg, "error")
    end
    if type == 'success' then 
       QBCore.Functions.Notify(msg, "success")
    end
end

--## HUD ##--
Config.ToggleHud = false --- @param Set to 'true' to use the functions below if your hud support it hide and show hud.

function ToggleHud(toggle) 
    if toggle then
        TriggerEvent('hud:toogle', true)
    else
        TriggerEvent('hud:toogle', false)
    end
end
