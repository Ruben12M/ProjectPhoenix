-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['es_extended']:getSharedObject()
Framework = 'esx'

GetPlayer = function(source)
    return ESX.GetPlayerFromId(source)
end

GetPlayers = function()
    return ESX.GetExtendedPlayers()
end

KickPlayer = function(source, reason)
    local player = GetPlayer(source)
    return player.kick(reason)
end

HasGroup = function(source, filter)
    local player = GetPlayer(source)
    if not player then return false, false end
    local type = type(filter)

    if type == 'string' then
        if player.job.name == filter then
            return player.job.name, player.job.grade
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            local grade = filter[player.job.name]

            if grade and grade <= player.job.grade then
                return player.job.name, player.job.grade
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                if player.job.name == filter[i] then
                    return player.job.name, player.job.grade
                end
            end
        end
    end
end

GetIdentifier = function(source)
    local player = GetPlayer(source)
    return player.identifier
end

GetName = function(source)
    local player = GetPlayer(source)
    return player.getName()
end

GetPlayerIdentity = function(source)
    local player = GetPlayer(source)
    local licenseFound
    local data = {
        name = player.getName(),
        job = player.job.label,
        position = player.job.grade_label,
        dob = player.get('dateofbirth') or false,
    }
    if player.get('sex') == 'm' then data.sex = 'Male' else data.sex = 'Female' end
    if GetResourceState('esx_status') == 'started' then
        TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)
            if status then
                data.drunk = math.floor(status.percent)
            end
        end)
    end
    if GetResourceState('esx_license') == 'started' then
        TriggerEvent('esx_license:getLicenses', source, function(licenses)
            licenseFound = true
            data.licenses = licenses
        end)
    end
    while not licenseFound do Wait() end
    return data
end

GetJobLabel = function(source)
    local player = GetPlayer(source)
    return player.job.label
end

RegisterUsableItem = function(item, cb)
    ESX.RegisterUsableItem(item, cb)
end

HasItem = function(source, item)
    local player = GetPlayer(source)
    local item = player.getInventoryItem(item)
    if item ~= nil then
        return item.count
    else
        return 0
    end
end

AddItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    return player.addInventoryItem(item, count, metadata, slot)
end

AddWeapon = function(source, weapon, ammo)
    local player = GetPlayer(source)
    player.addWeapon(data.itemId, ammo)
end

RemoveItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    player.removeInventoryItem(item, count, metadata, slot)
end

AddMoney = function(source, type, amount)
    if type == 'cash' then type = 'money' end
    local player = GetPlayer(source)
    player.addAccountMoney(type, amount)
end

RemoveMoney = function(source, type, amount)
    if type == 'cash' then type = 'money' end
    local player = GetPlayer(source)
    player.removeAccountMoney(type, amount)
end

GetPlayerAccountFunds = function(source, type)
    if type == 'cash' then type = 'money' end
    local player = GetPlayer(source)
    return player.getAccount(type).money
end

GrantLicense = function(source, license)
    local player = GetPlayer(source)
    if not player then return end
    TriggerEvent('esx_license:addLicense', source, license)
end

RevokeLicense = function(source, target, license)
    local player = GetPlayer(source)
    local authorized = false
    for i=1, #Config.policeJobs do
        if player.job.name == Config.policeJobs[i] then
            authorized = true
            break
        end
    end
    if authorized then
        local targetPlayer = GetPlayer(target)
        if not targetPlayer then return end
        TriggerEvent('esx_license:removeLicense', target, license)
    else
        print('[wasabi_police]: Player: '..source..' attempted to revoke a license without an active police job!')
    end
end

GetVehicleOwner = function(plate)
    local owner
    MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local identifier = result[1].owner
            MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            }, function(result2)
                if result2[1] then
                    owner = result2[1].firstname..' '..result2[1].lastname
                else
                    owner = false
                end
            end)
        else
            owner = false
        end
    end)
    while owner == nil do
        Wait()
    end
    return owner
end

ToggleDuty = function(source, job, grade)
    local player = GetPlayer(source)
    if job:sub(0, 3) == 'off' then
        local onDuty = string.gsub(job, 'off', '')
        player.setJob(onDuty, grade)
        TriggerClientEvent('wasabi_police:notify', source, Strings.on_duty, Strings.on_duty_desc, 'success')
    else
        player.setJob(('off%s'):format(job), tonumber(grade))
        TriggerClientEvent('wasabi_police:notify', source, Strings.off_duty, Strings.off_duty_desc, 'error')
    end
end

CreateThread(function()
    while ESX == nil do Wait() end
    for i=1, #Config.policeJobs do
        TriggerEvent('esx_society:registerSociety', Config.policeJobs[i], Config.policeJobs[i], 'society_'..Config.policeJobs[i], 'society_'..Config.policeJobs[i], 'society_'..Config.policeJobs[i], {type = 'public'})
    end
end) 
