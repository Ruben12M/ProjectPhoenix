--[[  
    Vending machine configuration.
    Here you can choose all the Vending 
    machines and their items.
]]

Config.VendingObjects = {
    'prop_vend_soda_01',
    'prop_vend_soda_02',
    'prop_vend_water_01'
}

Config.VendingItem = {
    [1] = {
        name = 'tosti',
        price = 4,
        amount = 50,
        info = {},
        type = 'item',
        slot = 1,
    },
    [2] = {
        name = 'water_bottle',
        price = 4,
        amount = 50,
        info = {},
        type = 'item',
        slot = 2,
    },
}