-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if GetResourceState('qb-core') ~= 'started' then return end
QBCore = exports['qb-core']:GetCoreObject()
Framework = 'qb'

GetPlayer = function(source)
    return QBCore.Functions.GetPlayer(source)
end

GetPlayers = function()
    return QBCore.Functions.GetPlayers()
end

KickPlayer = function(source, reason)
    QBCore.Functions.Kick(source, reason, true, true)
end

HasGroup = function(source, filter)
    local groups = { 'job', 'gang' }
    local player = GetPlayer(source)
    if not player then return false, false end
    local type = type(filter)

    if type == 'string' then
        for i = 1, #groups do
            local data = player.PlayerData[groups[i]]

            if data.name == filter then
                return data.name, data.grade.level
            end
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            for i = 1, #groups do
                local data = player.PlayerData[groups[i]]
                local grade = filter[data.name]

                if grade and grade <= data.grade.level then
                    return data.name, data.grade.level
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local group = filter[i]

                for j = 1, #groups do
                    local data = player.PlayerData[groups[j]]

                    if data.name == group then
                        return data.name, data.grade.level
                    end
                end
            end
        end
    end
end

GetIdentifier = function(source)
    local player = QBCore.Functions.GetPlayer(source)
    return player.PlayerData.citizenid
end

GetName = function(source)
    local player = QBCore.Functions.GetPlayer(source)
    return player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
end

GetPlayerIdentity = function(source)
    local player = GetPlayer(source)
    local data = {
        name = player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname,
        job = player.PlayerData.job.label,
        position = player.PlayerData.job.grade.name,
        dob = player.PlayerData.charinfo.birthdate,
        licenses = {}
    }
    if player.PlayerData.charinfo.gender == 1 then
        data.sex = Strings.female
    else
        data.sex = Strings.male
    end
    if player.PlayerData.metadata['licences'] then
        for k,v in pairs(player.PlayerData.metadata['licences']) do
            if v then
                data.licenses[#data.licenses + 1] = {
                    type = k
                }
            end
        end
    end
    return data
end

GetJobLabel = function(source)
    local player = GetPlayer(source)
    return player.PlayerData.job.label
end

RegisterUsableItem = function(item, cb)
    QBCore.Functions.CreateUseableItem(item, cb)
end

HasItem = function(source, item)
    local player = GetPlayer(source)
    local item = player.Functions.GetItemByName(item)
    if GetResourceState('ox_inventory') == 'started' then
        return item?.count or 0
    else
        return item?.amount or 0
    end
end

AddItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    return player.Functions.AddItem(item, count, slot, metadata)
end

AddWeapon = function(source, weapon, ammo)
    local player = GetPlayer(source)
    return player.Functions.AddItem(weapon, 1, nil, nil)
end

RemoveItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    player.Functions.RemoveItem(item, count, slot, metadata)
end

AddMoney = function(source, type, amount)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    player.Functions.AddMoney(type, amount)
end

RemoveMoney = function(source, type, amount)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    player.Functions.RemoveMoney(type, amount)
end

GetPlayerAccountFunds = function(source, type)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    return player.PlayerData.money[type]
end

GrantLicense = function(source, license)
    local player = GetPlayer(source)
    if not player then return end
    local licenses = player.PlayerData.metadata['licences']
    if licenses?[license] then return false end
    if not licenses then licenses = {} end
    licenses[license] = true
    player.Functions.SetMetaData('licences', licenses)
    TriggerClientEvent('wasabi_notify', source, Strings.weapon_license, Strings.weapon_license_desc, 'success')
    return true
end

RevokeLicense = function(source, target, license)
    local player = GetPlayer(source)
    local authorized = false
    for i=1, #Config.policeJobs do
        if player.PlayerData.job.name == Config.policeJobs[i] then
            authorized = true
            break
        end
    end
    if authorized then
        local targetPlayer = GetPlayer(target)
        if not targetPlayer then return end
        local licenses = targetPlayer.PlayerData.metadata['licences']
        if not licenses[license] then
            print('[wasabi_police]: Player: '..source..' attempted to revoke license: '..license..' from target id: '..target..' but it was already non existent')
            return
        end
        licenses[license] = false
        targetPlayer.Functions.SetMetaData('licences', licenses)
    else
        print('[wasabi_police]: Player: '..source..' attempted to revoke a license without an active police job!')
    end
end

GetVehicleOwner = function(plate)
    local owner
    MySQL.Async.fetchAll('SELECT citizenid FROM player_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local identifier = result[1].citizenid
            MySQL.Async.fetchAll('SELECT charinfo FROM players WHERE citizenid = @identifier', {
                ['@identifier'] = identifier
            }, function(result2)
                if result2[1] then
                    local charData = json.decode(result2[1].charinfo)
                    owner = charData.firstname..' '..charData.lastname
                else
                    owner = false
                end
            end)
        else
            owner = false
        end
    end)
    while owner == nil do Wait() end
    return owner
end

ToggleDuty = function(source, _job, _grade)
    local player = GetPlayer(source)
    if player.PlayerData.job.onduty then
        player.Functions.SetJobDuty(false)
        TriggerClientEvent('wasabi_police:notify', source, Strings.off_duty, Strings.off_duty_desc, 'error')
    else
        player.Functions.SetJobDuty(true)
        TriggerClientEvent('wasabi_police:notify', source, Strings.on_duty, Strings.on_duty_desc, 'success')
    end
end

lib.callback.register('wasabi_police:isPlayerDead', function(source, id)
    local player = GetPlayer(id)
    if not player then return end
    return player.PlayerData.metadata['isdead']
end)
