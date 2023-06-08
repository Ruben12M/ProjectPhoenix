-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
-- Customize the way it pulls user identification info?
lib.callback.register('wasabi_police:checkPlayerId', function(source, target)
    local data = GetPlayerIdentity(target)
    return data
end)

--Death check
deathCheck = function(serverId)
    serverId = serverId or GetPlayerServerId(PlayerId())
    local ped = GetPlayerPed(GetPlayerFromServerId(serverId)) or PlayerPedId()
    return Player(serverId).state.dead or false
end