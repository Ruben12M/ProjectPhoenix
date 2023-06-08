if Config.UseTarget ~= "qb-target" then
    return
end

function DropTarget(dropItem, index)
    exports['qb-target']:AddTargetEntity(dropItem, {
        options = {
            {
                icon = 'fas fa-backpack',
                label = 'Open Drop',
                action = function()
                    TriggerServerEvent("inventory:server:OpenInventory", "drop", index)
                end,
            }
        },
        distance = 2.5,
    })
end

Citizen.CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.VendingObjects, {
        options = {
            {
                icon = "fa-solid fa-cash-register",
                label = 'Open Vending',
                action = function()
                    exports['qs-inventory']:OpenVending()
                end
            },
        },
        distance = 2.5
    })
end)

Citizen.CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.GarbageObjects, {
        options = {
            {
                icon = "fa-solid fa-trash",
                label = 'Open Garbage',
                action = function()
                    ExecuteCommand('inventory')
                end
            },
        },
        distance = 1.0
    })
end)

Citizen.CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.CraftingObject, {
        options = {
            {
                event = "inventory:client:craftTarget",
                icon = "fas fa-tools",
                label = 'Open Crafting',
            },
        },
        distance = 2.5,
    })
end)