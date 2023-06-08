-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

--Customize notifications
RegisterNetEvent('wasabi_police:notify', function(title, desc, style)
    lib.notify({
        title = title,
        description = desc,
        duration = 3500,
        type = style
    })
end)

ShowTextUI = function(msg)
    lib.showTextUI(msg) -- Replace this with your custom text UI function/event?
end

HideTextUI = function()
    lib.hideTextUI() -- Replace this with your custom text UI function/event?
end

--Custom Car lock
addCarKeys = function(plate, model)
    if Framework == 'qb' then
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
    else
        exports.wasabi_carlock:GiveKeys(plate) -- Leave like this if using wasabi_carlock
    end
end

--Send to jail
RegisterNetEvent('wasabi_police:sendToJail', function()
    if not HasGroup(Config.policeJobs) then return end
    local target, time

    if Config.Jail.input then
        local coords = GetEntityCoords(cache.ped)
        local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
        if not player then
            TriggerEvent('wasabi_police:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
        else
            local input = lib.inputDialog(Strings.minutes_dialog, {Strings.minutes_dialog_field})
            if not input then return end
            local quantity = math.floor(tonumber(input[1]))
            if quantity < 1 then
                TriggerEvent('wasabi_police:notify', Strings.invalid_amount, Strings.invalid_amount_desc, 'error')
            else
                target, time = GetPlayerServerId(player), quantity
            end
        end
    end

    if Config.Jail.jail == 'rcore' then
        ExecuteCommand('jail '..target..' jailed '..time..' Sentenced')
    elseif Config.Jail.jail == 'tk_jail' then
        if Framework == 'esx' then
            exports.esx_tk_jail:jail(target, time)
        elseif Framework == 'qb' then
            exports.qb_tk_jail:jail(target, time)
        end
    elseif Config.Jail.jail == 'hd_jail' then
        TriggerServerEvent('HD_Jail:sendToJail', target, 'Prison', time, 'Sentenced', 'Police')
    elseif Config.Jail.jail == 'myPrison' then
        ExecuteCommand('jail')
    elseif Config.Jail.jail == 'qalle-jail' then
        TriggerServerEvent('esx-qalle-jail:jailPlayer', target, time, 'Sentenced')
    elseif Config.Jail.jail == 'plouffe' then
        exports.plouffe_jail:Set(target, time)
    elseif Config.Jail.jail == 'mx' then
        TriggerServerEvent('mx_jail:jailPlayer', target, time, target)
        TriggerServerEvent('mx_jail:setTime', target, time)
    elseif Config.Jail.jail == 'custom' then

    end
end)

--Impound Vehicle
impoundSuccessful = function(vehicle)
    if not DoesEntityExist(vehicle) then return end
    SetEntityAsMissionEntity(vehicle, false, false)
    if Config.AdvancedParking then
        exports['AdvancedParking']:DeleteVehicleOnServer(vehicle, nil, nil)
    else
        DeleteVehicle(vehicle)
    end
    if not DoesEntityExist(vehicle) then
        TriggerEvent('wasabi_police:notify', Strings.success, Strings.car_impounded_desc, 'success')
    end
end

--Death check
deathCheck = function(serverId)
    serverId = serverId or GetPlayerServerId(PlayerId())
    local ped = GetPlayerPed(GetPlayerFromServerId(serverId)) or PlayerPedId()
    return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsEntityPlayingAnim(ped, 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 3)
end

--Search player
searchPlayer = function(player)
    if Config.inventory == 'ox' then
        exports.ox_inventory:openNearbyInventory()
    elseif Config.inventory == 'qs' or Config.inventory == 'qb' then
        TriggerServerEvent('inventory:server:OpenInventory', 'otherplayer', GetPlayerServerId(player))
    elseif Config.inventory == 'mf' then
        local identifier = GetIdentifier(player)
        exports['mf-inventory']:openOtherInventory(identifier)
    elseif Config.inventory == 'cheeza' then
        TriggerEvent('inventory:openPlayerInventory', GetPlayerServerId(player), true)
    elseif Config.inventory == 'custom' then
        -- INSERT CUSTOM SEARCH PLAYER FOR YOUR INVENTORY
    end
end

exports('searchPlayer', searchPlayer)

OnCuffTimerStart = function()
    if Config.inventory == 'qs' then
        exports['qs-inventory']:setInventoryDisabled(true)
    end
end

OnCuffTimerEnd = function()
    if Config.inventory == 'qs' then
        exports['qs-inventory']:setInventoryDisabled(false)
    end
end

-- Customize target
AddEventHandler('wasabi_police:addTarget', function(d)
    if d.targetType == 'AddBoxZone' then
        exports.qtarget:AddBoxZone(d.identifier, d.coords, d.width, d.length, {
            name=d.identifier,
            heading=d.heading,
            debugPoly=false,
            minZ=d.minZ,
            maxZ=d.maxZ,
            useZ = true,
        }, {
            options = d.options,
            job = (d.job or false),
            distance = d.distance,
        })
    elseif d.targetType == 'Player' then
        exports.qtarget:Player({
            options = d.options,
            job = (d.job or false),
            distance = d.distance,
        })
    elseif d.targetType == 'Vehicle' then
        exports.qtarget:Vehicle({
            options = d.options,
            job = (d.job or false),
            distance = d.distance
        })
    elseif d.targetType == 'Model' then
        exports.qtarget:AddTargetModel(d.models, {
            options = d.options,
            job = (d.job or false),
            distance = d.distance,
        })
    end
end)

--Change clothes(Cloakroom)
AddEventHandler('wasabi_police:changeClothes', function(data) 
    if Config.skinScript == 'custom' then
        -- Place custom code here?
    else
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if data == 'civ_wear' then
                if Config.skinScript == 'appearance' then
                        skin.sex = nil
                        exports['fivem-appearance']:setPlayerAppearance(skin)
                else
                TriggerEvent('skinchanger:loadClothes', skin)
                end
            elseif skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, data.male)
            elseif skin.sex == 1 then
                TriggerEvent('skinchanger:loadClothes', skin, data.female)
            end
        end)
    end
end)

-- Billing event
AddEventHandler('wasabi_police:finePlayer', function()
    if not HasGroup(Config.policeJobs) then return end
    local hasJob, _grade = HasGroup(Config.policeJobs)
    local coords = GetEntityCoords(cache.ped)
    local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
    if not player then
        TriggerEvent('wasabi_police:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
    else
        local job, _grade = HasGroup(Config.policeJobs)
        local jobLabel = lib.callback.await('wasabi_police:getJobLabel', 100)
        local targetId = GetPlayerServerId(player)
        local input = lib.inputDialog('Invoice Amount', {'Amount', 'Reason'})
        if not input then return end
        local amount = math.floor(tonumber(input[1]))
        local reason = tostring(input[2]) or jobLabel
        if amount < 1 then
            TriggerEvent('wasabi_police:notify', Strings.invalid_entry, Strings.invalid_entry_desc, 'error')
        elseif Config.billingSystem == 'okok' then
            TriggerServerEvent('okokBilling:CreateCustomInvoice', targetId, amount, reason, 'Police Billing', 'society_'..job, jobLabel)
        elseif Config.billingSystem == 'esx' then
            TriggerServerEvent('esx_billing:sendBill', targetId, 'society_'..job, reason, amount)
        elseif Config.billingSystem == 'qb' then
            TriggerServerEvent('wasabi_police:qbBill', targetId, amount, hasJob)
            local gender = Strings.mr
            if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
                gender = Strings.mrs
            end
            local charinfo = QBCore.Functions.GetPlayerData().charinfo
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = jobLabel,
                subject = Strings.debt_collection,
                message = (Strings.db_email):format(gender, charinfo.lastname, amount),
                button = {}
            })
        else
            -- Custom here?
        end
    end
end)

-- Job menu
openJobMenu = function()
    if not HasGroup(Config.policeJobs) then return end
    if not IsOnDuty() then return end
    local job, grade = HasGroup(Config.policeJobs)
    local jobLabel = Strings.police
    local Options = {}
    if Config.searchPlayers then
        Options[#Options + 1] = {
            title = Strings.search_player,
            description = Strings.search_player_desc,
            icon = 'magnifying-glass',
            arrow = false,
            event = 'wasabi_police:searchPlayer',
        }
    end
    Options[#Options + 1] = {
        title = Strings.check_id,
        description = Strings.check_id_desc,
        icon = 'id-card',
        arrow = true,
        event = 'wasabi_police:checkId',
    }
    if Config?.GrantWeaponLicenses?.enabled and tonumber(grade or 0) >= Config.GrantWeaponLicenses.minGrade then
        Options[#Options + 1] = {
            title = Strings.grant_license,
            description = Strings.grant_license_desc,
            icon = 'id-card',
            arrow = true,
            event = 'wasabi_police:grantLicense',
        }
    end
    if Config.Jail.enabled then
        Options[#Options + 1] = {
            title = Strings.jail_player,
            description = Strings.jail_player_desc,
            icon = 'lock',
            arrow = false,
            event = 'wasabi_police:sendToJail',
        }
    end
    Options[#Options + 1] = {
        title = Strings.handcuff_soft_player,
        description = Strings.handcuff_soft_player_desc,
        icon = 'hands-bound',
        arrow = false,
        args = { type = 'soft' },
        event = 'wasabi_police:handcuffPlayer',
    }
    Options[#Options + 1] = {
        title = Strings.handcuff_hard_player,
        description = Strings.handcuff_hard_player_desc,
        icon = 'hands-bound',
        arrow = false,
        args = { type = 'hard' },
        event = 'wasabi_police:handcuffPlayer',
    }
    Options[#Options + 1] = {
        title = Strings.escort_player,
        description = Strings.escort_player_desc,
        icon = 'hand-holding-hand',
        arrow = false,
        event = 'wasabi_police:escortPlayer',
    }
    if Config.GSR.enabled then
        Options[#Options + 1] = {
            title = Strings.gsr_test,
            description = Strings.gsr_test_desc,
            icon = 'gun',
            arrow = false,
            event = 'wasabi_police:gsrTest',
        }
    end
    Options[#Options + 1] = {
        title = Strings.put_in_vehicle,
        description = Strings.put_in_vehicle_desc,
        icon = 'arrow-right-to-bracket',
        arrow = false,
        event = 'wasabi_police:inVehiclePlayer',
    }
    Options[#Options + 1] = {
        title = Strings.take_out_vehicle,
        description = Strings.take_out_vehicle_desc,
        icon = 'arrow-right-from-bracket',
        arrow = false,
        event = 'wasabi_police:outVehiclePlayer',
    }
    Options[#Options + 1] = {
        title = Strings.vehicle_interactions,
        description = Strings.vehicle_interactions_desc,
        icon = 'car',
        arrow = true,
        event = 'wasabi_police:vehicleInteractions',
    }
    Options[#Options + 1] = {
        title = Strings.place_object,
        description = Strings.place_object_desc,
        icon = 'box',
        arrow = true,
        event = 'wasabi_police:placeObjects',
    }
    if Config.billingSystem then
        Options[#Options + 1] = {
            title = Strings.fines,
            description = Strings.fines_desc,
            icon = 'file-invoice',
            arrow = false,
            event = 'wasabi_police:finePlayer',
        }
    end
    if Config.MobileMenu.enabled then
		OpenMobileMenu('pd_job_menu', jobLabel, Options)
	else
        lib.registerContext({
            id = 'pd_job_menu',
            title = jobLabel,
            options = Options
        })
        lib.showContext('pd_job_menu')
    end
end
