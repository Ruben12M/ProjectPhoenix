if Config.VehicleKeys.ENABLE then

    RegisterServerEvent('cd_garage:LoadCachedkeys')
    AddEventHandler('cd_garage:LoadCachedkeys', function()
        local _source = source
        local identifier = GetIdentifier(_source)
        local temp_table = {}

        local Result = DatabaseQuery('SELECT plate FROM '..FW.vehicle_table..' WHERE '..FW.vehicle_identifier..'="'..identifier..'"')
        if Result and Result[1] then
            for c, d in pairs(Result) do
                table.insert(temp_table, {plate = d.plate})
            end
        end
        for c, d in pairs(KeyCacheTable) do
            if identifier == d.reciever_identifier then
                if CheckDuplicateKeys(d.plate, temp_table) then
                    table.insert(temp_table, {plate = d.plate})
                end
            end
        end
        TriggerClientEvent('cd_garage:AddKeys_playerload', _source, temp_table)
    end)

    function CheckDuplicateKeys(plate, data_table)
        for c, d in pairs(data_table) do
            if d.plate == plate then
                return false
            end
        end
        return true
    end

    RegisterServerEvent('cd_garage:GiveKeys')
    AddEventHandler('cd_garage:GiveKeys', function(action, plate, target)
        local _source = source
        local owner_identifier = GetIdentifier(_source)
        local reciever_identifier = GetIdentifier(target)
        if CharacterNames[target] == nil then
            CharacterNames[target] = GetCharacterName(target)
        end

        if action == 'save' then
            if CheckVehicleOwner(_source, plate) then
                DatabaseQuery('INSERT INTO cd_garage_keys (plate, owner_identifier, reciever_identifier, char_name) VALUES (@plate, @owner_identifier, @reciever_identifier, @char_name)', {['@plate'] = plate, ['@owner_identifier'] = owner_identifier, ['@reciever_identifier'] = reciever_identifier, ['@char_name'] = CharacterNames[target]})
                Notif(_source, 2, 'gave_keys_saved', CharacterNames[target], plate)
                Notif(target, 2, 'recieve_keys_saved', plate)
            else
                Notif(_source, 3, 'dont_own_vehicle')
                return
            end
        elseif action == 'temp' then
            Notif(_source, 2, 'gave_keys_temp', CharacterNames[target], plate)
            Notif(target, 2, 'recieve_keys_temp', plate)
        end
        table.insert(KeyCacheTable, {plate = plate, char_name = CharacterNames[target], owner_identifier = owner_identifier, reciever_identifier = reciever_identifier})
        TriggerClientEvent('cd_garage:AddKeys', target, plate)
    end)

    RegisterServerEvent('cd_garage:JobVehicleCacheKeys')
    AddEventHandler('cd_garage:JobVehicleCacheKeys', function(plate)
        local _source = source
        local identifier = GetIdentifier(_source)
        table.insert(KeyCacheTable, {plate = plate, owner_identifier = identifier, reciever_identifier = identifier})
    end)

    RegisterServerEvent('cd_garage:ShowKeys')
    AddEventHandler('cd_garage:ShowKeys', function()
        local _source = source
        local identifier = GetIdentifier(_source)
        local self = {}
        local Result = DatabaseQuery('SELECT * FROM cd_garage_keys WHERE owner_identifier="'..identifier..'"')
        if Result and Result[1] then
            for c, d in pairs(Result) do
                d.saved = true
                table.insert(self, d)
            end
        end
        for c, d in pairs(KeyCacheTable) do
            if d.owner_identifier == identifier then
                d.saved = false
                if CheckDuplicateKeys(d.plate, self) then
                    table.insert(self, d)
                end
            end
        end
        TriggerClientEvent('cd_garage:ShowKeys', _source, self)
    end)

    RegisterServerEvent('cd_garage:RemoveKeys')
    AddEventHandler('cd_garage:RemoveKeys', function(data)
        for c, d in pairs(KeyCacheTable) do
            if d.plate == data.plate and d.reciever_identifier == data.reciever_identifier then
                table.remove(KeyCacheTable, c)
                if data.saved then
                    DatabaseQuery('DELETE FROM cd_garage_keys WHERE plate="'..data.plate..'" and reciever_identifier="'..data.reciever_identifier..'"')
                end
                break
            end
        end
        local target_source = GetPlayerFromIdentifier(data.reciever_identifier)
        if target_source then
            TriggerClientEvent('cd_garage:RemoveKeys', target_source, data.plate)
        end
    end)

    RegisterServerEvent('cd_garage:SyncVehicleLock')
    AddEventHandler('cd_garage:SyncVehicleLock', function(netid, lock_state, players)
        if players then
            for c, d in pairs(players) do
                TriggerClientEvent('cd_garage:SyncVehicleLock', d, netid, lock_state)
            end
        end
        local vehicle = NetworkGetEntityFromNetworkId(netid)
        SetVehicleDoorsLocked(vehicle, lock_state)
    end)

    RegisterServerEvent('cd_garage:SaveAllVehicleDamage')
    AddEventHandler('cd_garage:SaveAllVehicleDamage', function(data)
        for c, d in pairs(data) do
            DatabaseQuery('UPDATE '..FW.vehicle_table..' SET '..FW.vehicle_props..'=@props WHERE plate=@plate', {['@props'] = json.encode(d), ['@plate'] = d.plate})
        end
    end)

end
