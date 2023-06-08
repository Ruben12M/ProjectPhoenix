if Config.UseTarget ~= "ox_target" then
    return
end

function DropTarget(dropItem, index)
    local options = {
        {
            icon = 'fa-solid fa-backpack',
            label = 'Open Drop',
            distance = 2.5,
            onSelect = function()
                TriggerServerEvent("inventory:server:OpenInventory", "drop", index)
            end
        },
    }
    exports.ox_target:addLocalEntity(dropItem, options) 
end

Citizen.CreateThread(function()
    local options = {
        {
            icon = "fa-solid fa-cash-register",
            label = 'Open Vending',
            distance = 2.5,
            onSelect = function()
                exports['qs-inventory']:OpenVending()
            end
        },
    }
    exports.ox_target:addModel(Config.VendingObjects, options) 
end)

Citizen.CreateThread(function()
    local options = {
        {
            icon = "fa-solid fa-trash",
            label = 'Open Garbage',
            distance = 1.0,
            onSelect = function()
                ExecuteCommand('inventory')
            end
        },
    }
    exports.ox_target:addModel(Config.GarbageObjects, options) 
end)

Citizen.CreateThread(function()
    local options = {
        {
            event = "inventory:client:craftTarget",
            icon = "fas fa-tools",
            label = 'Open Crafting',
            distance = 2.5,
        },
    }
    exports.ox_target:addModel(Config.CraftingObject, options) 
end)