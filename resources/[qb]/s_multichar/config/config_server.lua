RegisterNetEvent('s_multichar:server:deletestash', function(Apartment)
    MySQL.Async.execute('DELETE FROM s_stashes WHERE stash = ?', { Apartment }) 
end)
