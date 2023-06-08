if Config.UseTarget ~= "ox_target" then
    return
end

function createPeds()
    if pedSpawned then return end

    for k, v in pairs(Config.Locations) do
        local current = type(v['ped']) == 'number' and v['ped'] or joaat(v['ped'])

        RequestModel(current)
        while not HasModelLoaded(current) do
            Wait(0)
        end

        ShopPed[k] = CreatePed(0, current, v['coords'].x, v['coords'].y, v['coords'].z - 1, v['coords'].w, false, false)
        TaskStartScenarioInPlace(ShopPed[k], v['scenario'], 0, true)
        FreezeEntityPosition(ShopPed[k], true)
        SetEntityInvincible(ShopPed[k], true)
        SetBlockingOfNonTemporaryEvents(ShopPed[k], true)

        if Config.UseTarget then
            local options = {
                {
                    label = v['targetLabel'],
                    icon = v['targetIcon'],
                    item = v['item'],
                    job = v.requiredJob,
                    gang = v.requiredGang,
                    distance = 2.0,
                    onSelect = function()
                        exports['qs-shops']:openShop(k, Config.Locations[k])
                    end
                },
            }
            exports.ox_target:addLocalEntity(ShopPed[k], options) 
        end
    end
    pedSpawned = true
end