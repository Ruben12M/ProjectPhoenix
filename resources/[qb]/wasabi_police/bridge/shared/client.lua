-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local timeouts = {}

SetTimeout = function(msec, cb)
    timeouts[#timeouts + 1] = {
        time = GetGameTimer() + msec,
        cb = cb
    }
    return #timeouts
end

ClearTimeout = function(i)
    timeouts[i] = nil
end

Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

AddRadialItems = function()
    if HasGroup(Config.policeJobs) then
        if Framework == 'qb' then
            if PlayerData.job.onduty then
                lib.addRadialItem({
                    {
                        id = 'pd_general',
                        label = 'Police',
                        icon = 'shield-halved',
                        menu = 'police_menu'
                    },
                })
            else
                lib.removeRadialItem('pd_general')
            end
        else
            lib.addRadialItem({
                {
                    id = 'pd_general',
                    label = 'Police',
                    icon = 'shield-halved',
                    menu = 'police_menu'
                },
            })
        end
    else
        lib.removeRadialItem('pd_general')
    end
end